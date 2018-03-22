//
//  RSOSAuthManager.m
//  Emergency Reference Application
//
//  Created by Chris Lin on 11/30/17.
//  Copyright © 2017 RapidSOS. All rights reserved.
//

#import "RSOSAuthManager.h"
#import "RSOSUtils.h"
#import "RSOSCredentialStorage.h"
#import "RSOSLocalStorageManager.h"

#import "AFNetworking.h"

NSString * const RSOSDataAPIHostProduction = @"https://api.rapidsos.com";
NSString * const RSOSDataAPIHostStaging = @"https://api-staging.rapidsos.com";
NSString * const RSOSDataAPIHostSandbox = @"https://api-sandbox.rapidsos.com";

NSString * const RSOSClientAccessTokenStorageKey = @"ClientAccessToken";
NSString * const RSOSUserAccessTokenStorageKey = @"UserAccessToken";


@implementation RSOSAuthManager

+ (instancetype) sharedInstance{
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (id) init{
    if (self = [super init]){
        [self initializeManager];
    }
    return self;
}

- (void) initializeManager {
    
    self.baseURL = @"https://api-sandbox.rapidsos.com";
    
    self.clientID = @"";
    self.clientSecret = @"";

    // load stored auth token if it exists
    [self loadStoredClientToken];
    
    [self loadStoredUserToken];
    
    if(self.modelUserToken != nil) {
        
        // load stored user credentials from keychain
        NSDictionary *storedCredentials = [RSOSCredentialStorage loadStoredCredentials];
        
        if(storedCredentials != nil) {
            
            self.modelUserToken.username = storedCredentials[@"username"];
            self.modelUserToken.password = storedCredentials[@"password"];
        }
    }
}

#pragma mark - Utils

- (NSString *)getClientAuthorizationToken {
    if (self.modelClientToken == nil) return @"";
    return [self.modelClientToken getAuthorizationToken];
}

- (NSString *)getUserAuthorizationToken {
    if (self.modelUserToken == nil) return @"";
    return [self.modelUserToken getAuthorizationToken];
}

- (void)storeClientToken {
    [RSOSLocalStorageManager saveObject:[self.modelClientToken serializeToDictionary] key:RSOSClientAccessTokenStorageKey];
}

- (void)loadStoredClientToken {
    NSDictionary *authTokenDict = [RSOSLocalStorageManager loadObjectForKey:RSOSClientAccessTokenStorageKey];
    self.modelClientToken = [[RSOSAccessTokenDataModel alloc] initWithDictionary:authTokenDict];
}

- (void)storeUserToken {
    [RSOSLocalStorageManager saveObject:[self.modelUserToken serializeToDictionary] key:RSOSUserAccessTokenStorageKey];
}

- (void)loadStoredUserToken {
    NSDictionary *authTokenDict = [RSOSLocalStorageManager loadObjectForKey:RSOSUserAccessTokenStorageKey];
    self.modelUserToken = [[RSOSUserAccessTokenDataModel alloc] initWithDictionary:authTokenDict];
}

- (void)clearUserCredentials {
    
    [self.modelUserToken initialize];
    
    [RSOSLocalStorageManager removeObjectForKey:RSOSUserAccessTokenStorageKey];
    
    // delete stored credentials from the keychain
    [RSOSCredentialStorage deleteStoredCredentials];
}

#pragma mark - Requests for Access Tokens

- (void)requestClientAccessTokenWithCallback:(void (^)(RSOSResponseStatusDataModel *status))callback {
    
    // access token URL
    NSString *urlString = [NSString stringWithFormat:@"%@/oauth/token", self.baseURL];
    
    // session manager
    AFHTTPSessionManager *managerAFSession = [AFHTTPSessionManager manager];
    managerAFSession.requestSerializer = [AFHTTPRequestSerializer serializer];
    managerAFSession.responseSerializer = [AFJSONResponseSerializer serializer];
    
    // Add Header
    [managerAFSession.requestSerializer setValue:@"application/x-www-form-urlencoded"
                              forHTTPHeaderField:@"Content-Type"];
    
    // parameters
    NSDictionary *params = @{@"grant_type": @"client_credentials",
                             @"client_id":self.clientID,
                             @"client_secret":self.clientSecret
                             };
    
    [managerAFSession POST:urlString parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        RSOSResponseStatusDataModel *response = [[RSOSResponseStatusDataModel alloc] initWithTask:task response:responseObject error:nil];
        
        if ([response isSuccess] == YES) {
            
            // store client token
            
            self.modelClientToken = [[RSOSAccessTokenDataModel alloc] initWithDictionary:responseObject];
            [self storeClientToken];
        }
        
        if (callback) {
            callback(response);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        RSOSResponseStatusDataModel *response = [[RSOSResponseStatusDataModel alloc] initWithTask:task response:nil error:error];
        
        if (callback) {
            callback(response);
        }
    }];
}

- (void)requestUserAccessTokenWithUsername:(NSString *)username password:(NSString *)password callback:(void (^)(RSOSResponseStatusDataModel *status))callback {
    
    if(username.length == 0 ||
       password.length == 0) {
        
        RSOSResponseStatusDataModel *response = [[RSOSResponseStatusDataModel alloc] init];
        response.status = RSOSHTTPResponseCodeUnauthorized;
        
        if(callback) {
            callback(response);
        }
        
        return;
    }
    
    // access token URL
    NSString *urlString = [NSString stringWithFormat:@"%@/oauth/token", self.baseURL];
    
    // Session manager
    AFHTTPSessionManager *managerAFSession = [AFHTTPSessionManager manager];
    managerAFSession.requestSerializer = [AFHTTPRequestSerializer serializer];
    managerAFSession.responseSerializer = [AFJSONResponseSerializer serializer];
    
    // Add Header
    [managerAFSession.requestSerializer setValue:@"application/x-www-form-urlencoded; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    
    // request parameters
    NSDictionary *params = @{@"grant_type": @"password",
                             @"client_id": self.clientID,
                             @"client_secret": self.clientSecret,
                             @"username": username,
                             @"password": password,
                             };
    
    [managerAFSession POST:urlString parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        RSOSResponseStatusDataModel *response = [[RSOSResponseStatusDataModel alloc] initWithTask:task response:responseObject error:nil];
        
        if ([response isSuccess] == YES) {
            
            // store client token
            
            self.modelUserToken = [[RSOSUserAccessTokenDataModel alloc] initWithDictionary:responseObject];
            
            self.modelUserToken.username = username;
            self.modelUserToken.password = password;
            
            [self storeUserToken];
            
            // store user credentials in the keychain
            
            NSDictionary *credentials = @{
                                          @"username":username,
                                          @"password":password
                                          };
            
            
            [RSOSCredentialStorage storeCredentials:credentials];
        }
        
        if (callback) {
            callback(response);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        RSOSResponseStatusDataModel *response = [[RSOSResponseStatusDataModel alloc] initWithTask:task response:nil error:error];
        
        if (callback) {
            callback(response);
        }
    }];
}

#pragma mark - Refresh tokens

- (void)refreshClientAccessTokenIfNeededWithCallback:(void (^)(RSOSResponseStatusDataModel *status))callback {
    
    if (self.modelClientToken == nil || [self.modelClientToken isTokenExpired] == YES) {
        
        // expired or missing client token -- request a new client token
        [self requestClientAccessTokenWithCallback:callback];
    }
    else {
        
        // valid client token -- execute callback block with successful status
        RSOSResponseStatusDataModel *responseStatus = [[RSOSResponseStatusDataModel alloc] init];
        responseStatus.status = RSOSHTTPResponseCodeOK;
        
        if (callback) {
            callback(responseStatus);
        }
    }
}

- (void)refreshUserAccessTokenIfNeededWithCallback:(void (^)(RSOSResponseStatusDataModel *status))callback {
    
    // refresh authenticated user token
    
    if (self.modelUserToken == nil || [self.modelUserToken isTokenExpired] == YES) {
        
        // expired or missing user token
        
        [self requestUserAccessTokenWithUsername:self.modelUserToken.username password:self.modelUserToken.password callback:^(RSOSResponseStatusDataModel * _Nonnull responseStatus) {
            
            // if response code indicates invalid credentials, remove stored credentials
            if(responseStatus.status == RSOSHTTPResponseCodeUnauthorized) {
                
                [self clearUserCredentials];
            }
            
            if(callback) {
                callback(responseStatus);
            }
            
        }];
    }
    else {
        
        // valid client token -- execute callback block with successful status
        
        RSOSResponseStatusDataModel *responseStatus = [[RSOSResponseStatusDataModel alloc] init];
        responseStatus.status = RSOSHTTPResponseCodeOK;
        
        if (callback) {
            callback(responseStatus);
        }
    }
}

#pragma mark - User Login Helper Methods

- (void)requestRegisterWithUsername:(NSString *)username
                           password:(NSString *)password
                              email:(NSString *)email
                           callback:(void (^)(RSOSResponseStatusDataModel *status))callback {
    
    RSOSAuthManager *authManager = [RSOSAuthManager sharedInstance];
    
    // ensure valid access token
    
    [authManager refreshClientAccessTokenIfNeededWithCallback:^(RSOSResponseStatusDataModel *status) {
        
        if ([status isSuccess] == YES) {
            
            // register user request URL
            NSString *urlString = [NSString stringWithFormat:@"%@/v1/rain/user", self.baseURL];
            
            // session manager
            AFHTTPSessionManager *managerAFSession = [AFHTTPSessionManager manager];
            managerAFSession.requestSerializer = [AFJSONRequestSerializer serializer];
            managerAFSession.responseSerializer = [AFJSONResponseSerializer serializer];
            
            // add authentication header
            [managerAFSession.requestSerializer setValue:[[RSOSAuthManager sharedInstance] getClientAuthorizationToken] forHTTPHeaderField:@"Authorization"];
            
            // parameters
            NSDictionary *params = @{@"username": username,
                                     @"password": password,
                                     @"email": email,
                                     };
            
            [managerAFSession POST:urlString parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                [self requestLoginWithUsername:username
                                      password:password
                                      callback:^(RSOSResponseStatusDataModel *status) {
                                          if(callback) {
                                              callback(status);
                                          }
                                      }];
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
                RSOSResponseStatusDataModel *status = [[RSOSResponseStatusDataModel alloc] initWithTask:task response:nil error:error];
                
                if (callback) {
                    callback(status);
                }
            }];
        }
        else {
            
            // access token request failed
            if (callback) {
                callback(status);
            }
        }
    }];
}

- (void)requestLoginWithUsername:(NSString *)username
                        password:(NSString *)password
                        callback:(void (^)(RSOSResponseStatusDataModel *status))callback {
    
    [[RSOSAuthManager sharedInstance] requestUserAccessTokenWithUsername:username password:password callback:callback];
}

- (void)requestPinWithPhoneNumber:(NSString *)phoneNumber
                         callback:(void (^)(RSOSResponseStatusDataModel *status))callback {
    
    phoneNumber = [RSOSUtilsString normalizePhoneNumber:phoneNumber prefix:@""];
    
    // ensure valid user access token
    
    [[RSOSAuthManager sharedInstance] refreshUserAccessTokenIfNeededWithCallback:^(RSOSResponseStatusDataModel *status) {
        
        if ([status isSuccess] == YES) {
            
            // pin request URL
            NSString *urlString = [NSString stringWithFormat:@"%@/v1/rain/caller-ids", self.baseURL];
            
            // session manager
            AFHTTPSessionManager *managerAFSession = [AFHTTPSessionManager manager];
            managerAFSession.requestSerializer = [AFJSONRequestSerializer serializer];
            managerAFSession.responseSerializer = [AFJSONResponseSerializer serializer];
            
            // Add Header
            [managerAFSession.requestSerializer setValue:[RSOSAuthManager sharedInstance].getUserAuthorizationToken forHTTPHeaderField:@"Authorization"];
            
            NSDictionary *params = @{@"caller_id": phoneNumber};
            
            [managerAFSession POST:urlString parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                RSOSResponseStatusDataModel *status = [[RSOSResponseStatusDataModel alloc] initWithTask:task response:responseObject error:nil];
                
                if (callback) {
                    callback(status);
                }
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
                RSOSResponseStatusDataModel *status = [[RSOSResponseStatusDataModel alloc] initWithTask:task response:nil error:error];
                
                if (callback) {
                    callback(status);
                }
            }];
        }
        else {
            if (callback) {
                callback(status);
            }
        }
    }];
}

- (void)requestValidatePin:(NSString *)pin forPhoneNumber:(NSString *)phoneNumber callback:(void (^)(RSOSResponseStatusDataModel *status))callback {
    
    // ensure valid user access token
    
    [[RSOSAuthManager sharedInstance] refreshUserAccessTokenIfNeededWithCallback:^(RSOSResponseStatusDataModel *status) {
        
        // validate pin request URL
        NSString *urlString = [NSString stringWithFormat:@"%@/v1/rain/caller-ids", self.baseURL];
        
        // session manager
        AFHTTPSessionManager *managerAFSession = [AFHTTPSessionManager manager];
        managerAFSession.requestSerializer = [AFJSONRequestSerializer serializer];
        managerAFSession.responseSerializer = [AFJSONResponseSerializer serializer];
        
        // Add Header
        [managerAFSession.requestSerializer setValue:[RSOSAuthManager sharedInstance].getUserAuthorizationToken forHTTPHeaderField:@"Authorization"];
        
        // parameters
        NSDictionary *params = @{@"caller_id": phoneNumber,
                                 @"validation_code": pin,
                                 };
        
        [managerAFSession PATCH:urlString parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            RSOSResponseStatusDataModel *status = [[RSOSResponseStatusDataModel alloc] initWithTask:task response:responseObject error:nil];
            
            if (callback) {
                callback(status);
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            RSOSResponseStatusDataModel *status = [[RSOSResponseStatusDataModel alloc] initWithTask:task response:nil error:error];
            
            if (callback) {
                callback(status);
            }
            
        }];
    }];
}

@end
