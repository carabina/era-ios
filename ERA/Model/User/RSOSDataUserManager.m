//
//  RSOSDataUserManager.m
//  Emergency Reference Application
//
//  Created by Chris Lin on 11/30/17.
//  Copyright © 2017 RapidSOS. All rights reserved.
//

#import "RSOSDataUserManager.h"
#import "RSOSAuthManager.h"
#import "RSOSUtils.h"
#import "RSOSLocalStorageManager.h"
#import "RSOSLocationManager.h"
#import "RSOSCallFlowAPIManager.h"
#import "RSOSFailSafeManager.h"
#import "RSOSAppManager.h"
#import "RSOSDataFileUploadAWSSignature.h"

#import "RSOSUtils.h"
#import "AppConstants.h"
#import <AFNetworking.h>
#import <AFImageDownloader.h>

@implementation RSOSDataUserManager

+ (instancetype)sharedInstance {
    
    static dispatch_once_t once;
    static id sharedInstance;
    
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

- (id)init {
    
    if (self = [super init]) {
        [self initializeManager];
    }
    
    return self;
}

- (void)initializeManager {
    
    self.modelProfile = [[RSOSDataUserProfile alloc] init];
    self.savedLocations = [NSMutableArray array];
    
    // Device
    self.phoneNumber = @"";
    self.isPhoneVerified = NO;
}

- (void)setDeviceInfoWithDictionary:(NSDictionary *)dict {
    
    self.phoneNumber = [RSOSUtilsString refineNSString:[dict objectForKey:@"phone_number"]];
    self.isPhoneVerified = [RSOSUtilsString refineBool:[dict objectForKey:@"phone_verified"] defaultValue:NO];
    
}

- (NSDictionary *)serializeDeviceInfoToDictionary {
    
    return @{@"phone_number": self.phoneNumber,
             @"phone_verified": @(self.isPhoneVerified)
             };
    
}

#pragma mark - Utils

- (BOOL) isLoggedIn {
    
    RSOSUserAccessTokenDataModel *accessToken = [RSOSAuthManager sharedInstance].modelUserToken;
    
    return (accessToken.username.length > 0 &&
            accessToken.password.length > 0 &&
            self.phoneNumber.length > 0 &&
            self.isPhoneVerified == YES);
    
}

- (void)logoutUser {
    
    [[RSOSAuthManager sharedInstance] description];
    [self clearDeviceInfoFromLocalstorage];
    [self clearProfileInfoFromLocalstorage];
    
    [[RSOSAuthManager sharedInstance] clearUserCredentials];
    
    [self initializeManager];
    
}

#pragma mark - Localstorage

- (void)saveDeviceInfoToLocalStorage {
    
    [RSOSLocalStorageManager saveObject:@{@"device": [self serializeDeviceInfoToDictionary]}
                                    key:@"DEVICEINFO"];
}

- (void)loadDeviceInfoFromLocalstorage {
    
    NSDictionary *dict = [RSOSLocalStorageManager loadObjectForKey:@"DEVICEINFO"];
    
    if (dict != nil && [dict isKindOfClass:[NSDictionary class]] == YES) {
        
        NSDictionary *dictAccount = [dict objectForKey:@"device"];
        [self setDeviceInfoWithDictionary:dictAccount];
    }
}

- (void)clearDeviceInfoFromLocalstorage {
    [RSOSLocalStorageManager removeObjectForKey:@"DEVICEINFO"];
}

- (void)saveProfileInfoToLocalstorage {
    [RSOSLocalStorageManager saveObject:[self.modelProfile serializeToDictionary] key:@"PROFILE"];
    
    [RSOSLocalStorageManager saveObject:[self serializeSavedLocationsToDictionaries] key:@"SAVED_LOCATIONS"];
    
}

- (void)loadProfileInfoFromLocalstorage {
    
    @try {
        NSDictionary *dict = [RSOSLocalStorageManager loadObjectForKey:@"PROFILE"];
        
        if (dict != nil && [dict isKindOfClass:[NSDictionary class]] == YES) {
            [self.modelProfile setWithDictionary:dict];
        }
        
        NSMutableArray *storedSavedLocations = [NSMutableArray array];
        NSArray *locationDicts = [RSOSLocalStorageManager loadObjectForKey:@"SAVED_LOCATIONS"];
        for(NSDictionary *locationDict in locationDicts) {
            [storedSavedLocations addObject:[[RSOSDataSavedLocation alloc] initWithDictionary:locationDict]];
        }
        
        self.savedLocations = storedSavedLocations;
        
    }
    @catch(NSException *e) {
        NSLog(@"failed to load stored data: %@", e.description);
    }
    
}

- (void)clearProfileInfoFromLocalstorage {
    [RSOSLocalStorageManager removeObjectForKey:@"PROFILE"];
}


#pragma mark - Authentication

- (void)requestRegisterWithUsername:(NSString *)username
                            password:(NSString *)password
                               email:(NSString *)email
                            callback:(void (^)(RSOSResponseStatusDataModel *status))callback {
    
    RSOSAuthManager *authManager = [RSOSAuthManager sharedInstance];
    
    // ensure valid access token
    
    [authManager refreshClientAccessTokenIfNeededWithCallback:^(RSOSResponseStatusDataModel *status) {
        
        if ([status isSuccess] == YES) {
            
            // register user request URL
            NSString *urlString = [NSString stringWithFormat:@"%@/v1/rain/user", RSOS_BASE_URL];
            
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
            
            NSLog(@"Network Request =>\nPOST: %@", urlString);
            
            [managerAFSession POST:urlString parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                NSLog(@"Request Succeeded =>\nPOST: %@", urlString);
                
                /**
                 * Now log in as the user we have just created
                 * This will fetch a user access token giving read/write access
                 * to the new user's RapidSOS Emergency Data, and
                 * store the new user's credentials in the keychain
                 * (see RSOSAuthManager.m)
                 */
                
                [self requestLoginWithUsername:username
                                      password:password
                                      callback:^(RSOSResponseStatusDataModel *status) {
                                          if(callback) {
                                              callback(status);
                                          }
                                      }];
                
                
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
                RSOSResponseStatusDataModel *status = [[RSOSResponseStatusDataModel alloc] initWithTask:task response:nil error:error];
                NSLog(@"Request Failed =>\nRequest: %@\nResponse: %@", urlString, status);
                
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
            NSString *urlString = [NSString stringWithFormat:@"%@/v1/rain/caller-ids", RSOS_BASE_URL];
            
            // session manager
            AFHTTPSessionManager *managerAFSession = [AFHTTPSessionManager manager];
            managerAFSession.requestSerializer = [AFJSONRequestSerializer serializer];
            managerAFSession.responseSerializer = [AFJSONResponseSerializer serializer];
            
            // Add Header
            [managerAFSession.requestSerializer setValue:[RSOSAuthManager sharedInstance].getUserAuthorizationToken forHTTPHeaderField:@"Authorization"];
            
            NSDictionary *params = @{@"caller_id": phoneNumber};
            
            NSLog(@"Network Request =>\nPOST: %@\nParams: %@\n", urlString, params);
            
            [managerAFSession POST:urlString parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                NSLog(@"Request Succeeded=>\nPOST: %@", urlString);
                
                RSOSResponseStatusDataModel *status = [[RSOSResponseStatusDataModel alloc] initWithTask:task response:responseObject error:nil];
                
                self.phoneNumber = phoneNumber;
                
                if (callback) {
                    callback(status);
                }
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
                RSOSResponseStatusDataModel *status = [[RSOSResponseStatusDataModel alloc] initWithTask:task response:nil error:error];
                NSLog(@"Request Failed=>\nPOST: %@\nResponse: %@", urlString, status);
                
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

- (void)requestValidatePin:(NSString *)pin callback:(void (^)(RSOSResponseStatusDataModel *status))callback {
    
    // ensure valid user access token
    
    [[RSOSAuthManager sharedInstance] refreshUserAccessTokenIfNeededWithCallback:^(RSOSResponseStatusDataModel *status) {
        
        // validate pin request URL
        NSString *urlString = [NSString stringWithFormat:@"%@/v1/rain/caller-ids", RSOS_BASE_URL];
        
        // session manager
        AFHTTPSessionManager *managerAFSession = [AFHTTPSessionManager manager];
        managerAFSession.requestSerializer = [AFJSONRequestSerializer serializer];
        managerAFSession.responseSerializer = [AFJSONResponseSerializer serializer];
        
        // Add Header
        [managerAFSession.requestSerializer setValue:[RSOSAuthManager sharedInstance].getUserAuthorizationToken forHTTPHeaderField:@"Authorization"];
        
        // parameters
        NSDictionary *params = @{@"caller_id": self.phoneNumber,
                                 @"validation_code": pin,
                                 };

        NSLog(@"Network Request =>\nPATCH: %@\nParams: %@", urlString, params);
        
        [managerAFSession PATCH:urlString parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSLog(@"Request Succeeded=>\nPOST: %@", urlString);
            RSOSResponseStatusDataModel *status = [[RSOSResponseStatusDataModel alloc] initWithTask:task response:responseObject error:nil];
            
            // store verified device
            if ([status isSuccess] == YES) {
                self.isPhoneVerified = YES;
                [self saveDeviceInfoToLocalStorage];
                
                /**
                 * Register user device token for validated phone number
                 */
                
                [[RSOSAppManager sharedInstance] registerDeviceTokenForPhoneNumberIfPossible];
            }
            
            if (callback) {
                callback(status);
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            RSOSResponseStatusDataModel *status = [[RSOSResponseStatusDataModel alloc] initWithTask:task response:nil error:error];
            NSLog(@"Request Failed=>\nPOST: %@\nResponse: %@", urlString, status);
            
            if (callback) {
                callback(status);
            }
            
        }];
    }];
}

- (void)requestPasswordResetWithEmail:(NSString *)email
                              callback:(void (^)(RSOSResponseStatusDataModel *status))callback {
    RSOSAuthManager *authManager = [RSOSAuthManager sharedInstance];
    
    // ensure valid access token
    
    [authManager refreshClientAccessTokenIfNeededWithCallback:^(RSOSResponseStatusDataModel *status) {
        
        if ([status isSuccess] == YES) {
            
            // reset password request URL
            NSString *urlString = [NSString stringWithFormat:@"%@/v1/rain/password-reset", RSOS_BASE_URL];
            
            // session manager
            AFHTTPSessionManager *managerAFSession = [AFHTTPSessionManager manager];
            managerAFSession.requestSerializer = [AFJSONRequestSerializer serializer];
            managerAFSession.responseSerializer = [AFJSONResponseSerializer serializer];
            
            // Add Header
            [managerAFSession.requestSerializer setValue:[[RSOSAuthManager sharedInstance] getClientAuthorizationToken] forHTTPHeaderField:@"Authorization"];
            
            // parameters
            NSDictionary *params = @{@"email": email};
            
            NSLog(@"Network Request =>\nPOST: %@\nParams: %@\n", urlString, params);
            
            [managerAFSession POST:urlString parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                NSLog(@"Request Succeeded=>\nPOST: %@", urlString);
                RSOSResponseStatusDataModel *status = [[RSOSResponseStatusDataModel alloc] initWithTask:task response:responseObject error:nil];
                
                if (callback) {
                    callback(status);
                }
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
                RSOSResponseStatusDataModel *status = [[RSOSResponseStatusDataModel alloc] initWithTask:task response:nil error:error];
                NSLog(@"Request Failed=>\nPOST: %@\nResponse: %@", urlString, status);
                
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


#pragma mark - User Profile

- (void)requestProfileWithCallback:(void (^)(RSOSResponseStatusDataModel *status))callback {
    
    [[RSOSAuthManager sharedInstance] refreshUserAccessTokenIfNeededWithCallback:^(RSOSResponseStatusDataModel *status) {
        
        if ([status isSuccess] == YES) {
            
            // profile info request URL
            NSString *urlString = [NSString stringWithFormat:@"%@/v1/rain/personal-info", RSOS_BASE_URL];
            
            // session manager
            AFHTTPSessionManager *managerAFSession = [AFHTTPSessionManager manager];
            managerAFSession.requestSerializer = [AFJSONRequestSerializer serializer];
            managerAFSession.responseSerializer = [AFJSONResponseSerializer serializer];
            
            // Add Header
            [managerAFSession.requestSerializer setValue:[RSOSAuthManager sharedInstance].getUserAuthorizationToken forHTTPHeaderField:@"Authorization"];
            
            NSLog(@"Network Request =>\nGET: %@", urlString);
            
            [managerAFSession GET:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                NSLog(@"Request Succeeded=>\nPOST: %@", urlString);
                
                RSOSResponseStatusDataModel *response = [[RSOSResponseStatusDataModel alloc] initWithTask:task response:responseObject error:nil];
                
                if ([response isSuccess] == YES) {
                    
                    RSOSDataUserProfile *profile = [[RSOSDataUserProfile alloc] initWithDictionary:responseObject];
                
                    self.modelProfile = profile;
                    [self saveProfileInfoToLocalstorage];
                    
                    
                    [self requestSavedLocationsWithCallback:^(RSOSResponseStatusDataModel *status) {
                        
                        if (callback) {
                            callback(status);
                        }
                        
                    }];
                    return;
                }
                
                if (callback) {
                    callback(status);
                }
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
                RSOSResponseStatusDataModel *status = [[RSOSResponseStatusDataModel alloc] initWithTask:task response:nil error:error];
                NSLog(@"Request Failed=>\nPOST: %@\nResponse: %@", urlString, status);
                
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

- (void)requestUpdateProfileWithCallback:(void (^)(RSOSResponseStatusDataModel *status))callback {
    
    [[RSOSAuthManager sharedInstance] refreshUserAccessTokenIfNeededWithCallback:^(RSOSResponseStatusDataModel *status) {
        
        if ([status isSuccess] == YES) {
            
            // update profile request URL
            NSString *urlString = [NSString stringWithFormat:@"%@/v1/rain/personal-info", RSOS_BASE_URL];
            
            // session manager
            AFHTTPSessionManager *managerAFSession = [AFHTTPSessionManager manager];
            managerAFSession.requestSerializer = [AFJSONRequestSerializer serializer];
            managerAFSession.responseSerializer = [AFJSONResponseSerializer serializer];
            
            // Add Header
            [managerAFSession.requestSerializer setValue:[RSOSAuthManager sharedInstance].getUserAuthorizationToken forHTTPHeaderField:@"Authorization"];
            
            // parameters
            NSDictionary *params = [self.modelProfile serializeToDictionary];
            
            NSLog(@"Network Request =>\nPATCH: %@\nParams: %@", urlString, params);
            
            [managerAFSession PATCH:urlString parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                NSLog(@"Request Succeeded=>\nPOST: %@", urlString);
                
                RSOSResponseStatusDataModel *response = [[RSOSResponseStatusDataModel alloc] initWithTask:task response:responseObject error:nil];
                
                if ([response isSuccess] == YES) {
                    
                    RSOSDataUserProfile *newProfile = [[RSOSDataUserProfile alloc] initWithDictionary:responseObject];
                    self.modelProfile = newProfile;
                    [self saveProfileInfoToLocalstorage];
                    
                    [self synchronizeSavedLocations];
                    
                }
                
                if (callback) {
                    callback(status);
                }
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
                RSOSResponseStatusDataModel *status = [[RSOSResponseStatusDataModel alloc] initWithTask:task response:nil error:error];
                NSLog(@"Request Failed=>\nPOST: %@\nResponse: %@", urlString, status);
                
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

#pragma mark - Saved Locations

- (void)requestSavedLocationsWithCallback:(void (^)(RSOSResponseStatusDataModel *status))callback {
    
    [[RSOSAuthManager sharedInstance] refreshUserAccessTokenIfNeededWithCallback:^(RSOSResponseStatusDataModel *status) {
        
        if ([status isSuccess] == YES) {
            
            // profile info request URL
            NSString *urlString = [NSString stringWithFormat:@"%@/v1/rain/locations", RSOS_BASE_URL];
            
            // session manager
            AFHTTPSessionManager *managerAFSession = [AFHTTPSessionManager manager];
            managerAFSession.requestSerializer = [AFJSONRequestSerializer serializer];
            managerAFSession.responseSerializer = [AFJSONResponseSerializer serializer];
            
            // Add Header
            [managerAFSession.requestSerializer setValue:[RSOSAuthManager sharedInstance].getUserAuthorizationToken forHTTPHeaderField:@"Authorization"];
            
            NSLog(@"Network Request =>\nGET: %@", urlString);
            
            [managerAFSession GET:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                NSLog(@"Request Succeeded=>\nGET: %@", urlString);
                
                RSOSResponseStatusDataModel *response = [[RSOSResponseStatusDataModel alloc] initWithTask:task response:responseObject error:nil];
                
                if ([response isSuccess] == YES) {
                    
                    NSMutableArray<RSOSDataSavedLocation *> *updatedLocations = [NSMutableArray array];
                    
                    if([responseObject isKindOfClass:[NSArray class]]) {
                        
                        for (id locationDict in (NSArray *)responseObject) {
                            
                            if([locationDict isKindOfClass:[NSDictionary class]]) {
                                RSOSDataSavedLocation *location = [[RSOSDataSavedLocation alloc] initWithDictionary:locationDict];
                                
                                [updatedLocations addObject:location];
                            }
                            
                        }
                    }
                    
                    
                    self.savedLocations = updatedLocations;
                    [self saveProfileInfoToLocalstorage];
                }
                
                if (callback) {
                    callback(status);
                }
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
                RSOSResponseStatusDataModel *status = [[RSOSResponseStatusDataModel alloc] initWithTask:task response:nil error:error];
                NSLog(@"Request Failed=>\nPOST: %@\nResponse: %@", urlString, status);
                
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

- (void)addSavedLocation:(RSOSDataSavedLocation *)savedLocation callback:(void (^)(RSOSResponseStatusDataModel *status))callback {
    
    [[RSOSAuthManager sharedInstance] refreshUserAccessTokenIfNeededWithCallback:^(RSOSResponseStatusDataModel *status) {
        
        if ([status isSuccess] == YES) {
            
            // update profile request URL
            NSString *urlString = [NSString stringWithFormat:@"%@/v1/rain/locations", RSOS_BASE_URL];
            
            // session manager
            AFHTTPSessionManager *managerAFSession = [AFHTTPSessionManager manager];
            managerAFSession.requestSerializer = [AFJSONRequestSerializer serializer];
            managerAFSession.responseSerializer = [AFJSONResponseSerializer serializer];
            
            // Add Header
            [managerAFSession.requestSerializer setValue:[RSOSAuthManager sharedInstance].getUserAuthorizationToken forHTTPHeaderField:@"Authorization"];
            
            // parameters
            
            NSDictionary *params = [savedLocation serializeToDictionary];
            
            NSLog(@"Network Request =>\nPATCH: %@\nParams: %@", urlString, params);
            
            [managerAFSession POST:urlString parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                NSLog(@"Request Succeeded=>\nPOST: %@", urlString);
                
                RSOSResponseStatusDataModel *response = [[RSOSResponseStatusDataModel alloc] initWithTask:task response:responseObject error:nil];
                
                if ([response isSuccess] == YES) {
                    [savedLocation setWithDictionary:responseObject];
                    [self saveProfileInfoToLocalstorage];
                }
                
                if (callback) {
                    callback(status);
                }
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
                RSOSResponseStatusDataModel *status = [[RSOSResponseStatusDataModel alloc] initWithTask:task response:nil error:error];
                NSLog(@"Request Failed=>\nPOST: %@\nResponse: %@", urlString, status);
                
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

- (void)updateSavedLocation:(RSOSDataSavedLocation *)savedLocation callback:(void (^)(RSOSResponseStatusDataModel *status))callback {
    
    [[RSOSAuthManager sharedInstance] refreshUserAccessTokenIfNeededWithCallback:^(RSOSResponseStatusDataModel *status) {
        
        if ([status isSuccess] == YES) {
            
            // update profile request URL
            NSString *urlString = [NSString stringWithFormat:@"%@/v1/rain/locations/%@", RSOS_BASE_URL, savedLocation.locationID];
            
            // session manager
            AFHTTPSessionManager *managerAFSession = [AFHTTPSessionManager manager];
            managerAFSession.requestSerializer = [AFJSONRequestSerializer serializer];
            managerAFSession.responseSerializer = [AFJSONResponseSerializer serializer];
            
            // Add Header
            [managerAFSession.requestSerializer setValue:[RSOSAuthManager sharedInstance].getUserAuthorizationToken forHTTPHeaderField:@"Authorization"];
            
            // parameters
            
            NSDictionary *params = [savedLocation serializeToDictionary];
            
            NSLog(@"Network Request =>\nPATCH: %@\nParams: %@", urlString, params);
            
            [managerAFSession PATCH:urlString parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                NSLog(@"Request Succeeded=>\nPOST: %@", urlString);
                
                RSOSResponseStatusDataModel *response = [[RSOSResponseStatusDataModel alloc] initWithTask:task response:responseObject error:nil];
                
                if ([response isSuccess] == YES) {
                    [savedLocation setWithDictionary:responseObject];
                    [self saveProfileInfoToLocalstorage];
                }
                
                if (callback) {
                    callback(status);
                }
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
                RSOSResponseStatusDataModel *status = [[RSOSResponseStatusDataModel alloc] initWithTask:task response:nil error:error];
                NSLog(@"Request Failed=>\nPOST: %@\nResponse: %@", urlString, status);
                
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

#pragma mark - Upload Photo

/**
 * @abstract Request an AWS file upload URL from the RapidSOS Emergency Data API
 * @param filename The name of the file to be uploaded
 * @param callback A block which executes after the request completes. This block has no return value, and
 * takes two parameters: a `RSOSDataFileUploadAWSSignatureDataModel` object that contains the upload URL and
 * parameters required to upload the file (see -requestUploadPhoto:callback: to see this in use), and an
 * RSOSResponseStatusDataModel object that indicates whether the request succeeded
 */

- (void)requestAwsFileUploadUrlWithFilename:(NSString *)filename callback:(void (^)(RSOSDataFileUploadAWSSignature *signature, RSOSResponseStatusDataModel *status))callback {
    
    // AWS upload request URL
    NSString *urlString = [NSString stringWithFormat:@"%@/v1/kronos/upload-url?key=%@", ERA_BACKEND_URL, filename];
    
    // session manager
    AFHTTPSessionManager *managerAFSession = [AFHTTPSessionManager manager];
    managerAFSession.responseSerializer = [AFJSONResponseSerializer serializer];
    
    NSLog(@"Network Request =>\nGET: %@", urlString);
    
    [managerAFSession GET:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"Request Succeeded=>\nPOST: %@", urlString);
        
        RSOSDataFileUploadAWSSignature *signature = [[RSOSDataFileUploadAWSSignature alloc] initWithDictionary:responseObject];
        RSOSResponseStatusDataModel *status = [[RSOSResponseStatusDataModel alloc] initWithTask:task response:responseObject error:nil];
        
        if ([status isSuccess] == YES) {
            if (callback) {
                callback(signature, status);
            }
        }
        else {
            if (callback) {
                callback(nil, status);
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        RSOSResponseStatusDataModel *status = [[RSOSResponseStatusDataModel alloc] initWithTask:task response:nil error:error];
        NSLog(@"Request Failed=>\nPOST: %@\nResponse: %@", urlString, status);
        
        if (callback) {
            callback(nil, status);
        }
    }];
}

- (void)requestUploadPhoto:(UIImage *)image callback:(void (^)(NSString *photoUrlString, RSOSResponseStatusDataModel *status))callback {
    
    // generate a random filename for the image we will upload
    NSString *filename = [NSString stringWithFormat:@"%@.jpeg", [RSOSUtilsString generateRandomString:16]];
    
    // request an upload URL and signature from the RapidSOS Emergency Data API
    [self requestAwsFileUploadUrlWithFilename:filename callback:^(RSOSDataFileUploadAWSSignature *signature, RSOSResponseStatusDataModel *status) {
        
        if ([status isSuccess] == YES && signature != nil) {
            
            NSData *dataPhoto = UIImageJPEGRepresentation(image, 1.0);
            
            // session manager
            AFHTTPSessionManager *managerAFSession = [AFHTTPSessionManager manager];
            managerAFSession.requestSerializer = [AFHTTPRequestSerializer serializer];
            managerAFSession.responseSerializer = [AFJSONResponseSerializer serializer];
            
            [managerAFSession.requestSerializer setValue:@"application/x-www-form-urlencoded; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
            
            // AWS upload keys
            NSDictionary *param = @{@"AWSAccessKeyId": signature.accessKeyId,
                                    @"key": signature.key,
                                    @"policy": signature.policy,
                                    @"signature": signature.signature,
                                    @"x-amz-security-token": signature.securityToken,
                                    };
            
            NSLog(@"Network Request =>\nPOST: %@\nParams: %@", signature.uploadUrl, param);
            
            [managerAFSession POST:signature.uploadUrl parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                
                [formData appendPartWithFileData:dataPhoto
                                            name:@"file"
                                        fileName:@"profile_photo.jpeg"
                                        mimeType:@"image/jpeg"];
                
            } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                NSLog(@"Request Succeeded=>\nPOST: %@", signature.uploadUrl);
                RSOSResponseStatusDataModel *response = [[RSOSResponseStatusDataModel alloc] initWithTask:task response:responseObject error:nil];
                
                if ([response isSuccess] == YES) {
                    
                    if (callback) {
                        NSString *uploadURLString = [NSString stringWithFormat:@"%@%@", signature.uploadUrl, filename];
                        callback(uploadURLString, status);
                    }
                }
                else {
                    
                    // upload request failed
                    if (callback) {
                        callback(nil, status);
                    }
                }
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
                RSOSResponseStatusDataModel *status = [[RSOSResponseStatusDataModel alloc] initWithTask:task response:nil error:error];
                NSLog(@"Request Failed=>\nPOST: %@\nResponse: %@", signature.uploadUrl, status);
                
                if (callback) {
                    callback(nil, status);
                }
            }];
        }
        else {
            if (callback) {
                callback(nil, status);
            }
        }
    }];
}

#pragma mark - Emergency API Call Flow

- (void)requestTriggerCallWithCallback:(void (^)(RSOSResponseStatusDataModel *status))callback {
    
    /** Sample Callflow payload
     * The sample callflow requires the following parameters:
     *
     * - location
     * the user's current location
     *
     * - user
     * the user making the emergency call
     *
     * - contacts
     * an array of emergency contacts, each of which will be called in sequence
     * if the user does not answer the emergency call they trigger
     *
     * JSON Example:
     *
     * {
     *   "variables" : {
     *     "location" : {
     *       "latitude": "40.7128",
     *       "longitude": " -74.0059",
     *       "uncertainty": "65.0"
     *     },
     *     "user": {
     *       "full_name": "Alice Smith",
     *       "phone_number": "+12345551234"
     *     },
     *     "contacts": [
     *       {
     *         "full_name": "Bob Smith",
     *         "phone_number": "+12345554321"
     *       }
     *     ]
     *   }
     * }
     *
     */
    
    /**
     * Don't trigger call flow if an active flow already exists
     *
     */
    
    if(self.startingCallFlow) {
        
        RSOSResponseStatusDataModel *responseStatus = [[RSOSResponseStatusDataModel alloc] init];
        responseStatus.status = RSOSHTTPResponseCodeThrottle;
        responseStatus.message = @"There is already an active call flow.";
        
        if(callback) {
            callback(responseStatus);
        }
        
        return;
    }
    
    _startingCallFlow = YES;
    
    [[RSOSFailSafeManager sharedInstance] activateFailsafe];
    
    RSOSLocationManager *managerLocation = [RSOSLocationManager sharedInstance];
    
    NSDictionary *dictLocation = @{@"latitude": [NSString stringWithFormat:@"%.6f", managerLocation.location.coordinate.latitude],
                                   @"longitude": [NSString stringWithFormat:@"%.6f", managerLocation.location.coordinate.longitude],
                                   @"uncertainty": [NSString stringWithFormat:@"%.6f", managerLocation.location.horizontalAccuracy],
                                   };
    
    NSString *callerFullName = [self.modelProfile.fullName getPrimaryValue];
    
    if(callerFullName.length == 0) {
        
        _startingCallFlow = NO;
        
        RSOSResponseStatusDataModel *responseStatus = [[RSOSResponseStatusDataModel alloc] init];
        responseStatus.status = RSOSHTTPResponseCodeBadRequest;
        responseStatus.message = @"You must fill out your user profile before triggering a call flow.";
        
        if(callback) {
            callback(responseStatus);
        }
        
        [[RSOSFailSafeManager sharedInstance] triggerFailsafe];
        
        return;
    }
    
    /**
     * If the user has not set their profile phone number, fall back on their verified phone number
     */
    
    NSString *callerPhone = [self.modelProfile.phoneNumbers getPrimaryValue].phoneNumber;
    if(!callerPhone) {
        callerPhone = self.phoneNumber;
    }
    
    if(callerPhone == nil || [RSOSUtilsString normalizePhoneNumber:callerPhone prefix:@""].length != 11) {
        
        /**
         * No valid phone number -- trigger callback with error
         */
        
        RSOSResponseStatusDataModel *responseStatus = [[RSOSResponseStatusDataModel alloc] init];
        responseStatus.status = RSOSHTTPResponseCodeBadRequest;
        responseStatus.message = ( callerPhone ? [NSString stringWithFormat:@"Invalid phone number: %@", callerPhone] : @"No valid phone number." );
        
        if(callback) {
            callback(responseStatus);
        }
        
        return;
    }
    
    callerPhone = [RSOSUtilsString normalizePhoneNumber:callerPhone prefix:@"+"];
    
    NSDictionary *dictUser = @{@"full_name": callerFullName,
                               @"phone_number": callerPhone
                               };
    
    NSMutableArray *arrayContacts = [[NSMutableArray alloc] init];
    
    if ([self.modelProfile.emergencyContacts isSet] == YES) {
        
        for (RSOSDataEmergencyContact *contact in self.modelProfile.emergencyContacts.values) {
            
            [arrayContacts addObject:@{@"full_name": contact.fullName,
                                       @"phone_number": [RSOSUtilsString normalizePhoneNumber:contact.phoneNumber prefix:@"+"]
                                       }];
        }
    }
    
    NSDictionary *variables = @{@"location": dictLocation,
                                @"user": dictUser,
                                @"contacts": arrayContacts,
                                @"company": CONSTANTS_COMPANYNAME
                                };
    
    NSString *callFlow = @"kronos_contacts";
    
    [RSOSCallFlowAPIManager requestTriggerCallWithCallFlow:callFlow variables:variables callback:^(RSOSResponseStatusDataModel *status) {
        _startingCallFlow = NO;
        
        if(![status isSuccess]) {
            [[RSOSFailSafeManager sharedInstance] triggerFailsafe];
        }
        
        if(callback) {
            callback(status);
        }
    }];
}

- (void)downloadProfileImageWithCallback:(void (^)(RSOSResponseStatusDataModel *status, UIImage * _Nullable image))callback {
    
    NSString * imgURLString = [self.modelProfile.photo getPrimaryValue].url;
    
    if(!imgURLString) {
        
        RSOSResponseStatusDataModel *response = [[RSOSResponseStatusDataModel alloc] init];
        response.status = RSOSHTTPResponseCodeNotFound;
        
        if(callback) {
            callback(response, nil);
        }
        
        return;
    }
    
    NSURL *imgURL = [NSURL URLWithString:imgURLString];
    
    if(!imgURL) {
        RSOSResponseStatusDataModel *response = [[RSOSResponseStatusDataModel alloc] init];
        response.status = RSOSHTTPResponseCodeBadRequest;
        
        if(callback) {
            callback(response, nil);
        }
        
        return;
    }
    
    [self downloadImageFromSource:imgURL
                         callback:callback];
}

- (void)downloadImageFromSource:(NSURL *)sourceURL
                       callback:(void (^)(RSOSResponseStatusDataModel *status, UIImage * _Nullable image))callback {
    
    NSURLRequest *sourceURLRequest = [NSURLRequest requestWithURL:sourceURL];
    
    /**
     * Use `AFImageDownloader` to download the image. This uses `AFImageResponseSerializer`
     * to process the downloaded image data
     */
    
    AFImageDownloader *imgDownloader = [[AFImageDownloader alloc] init];
    
    /**
     * `AFImageResponseSerializer` by default doesn't include 'binary/octet-stream' -- the format returned by S3 --
     * in its list of acceptable content types, so we'll add it here
     */
    
    AFImageResponseSerializer *imgResponseSerializer = (AFImageResponseSerializer *)imgDownloader.sessionManager.responseSerializer;
    
    NSSet *acceptableContentTypes = [imgResponseSerializer acceptableContentTypes];
    NSSet *newAcceptableContentTypes = [acceptableContentTypes setByAddingObject:@"binary/octet-stream"];
    
    [imgResponseSerializer setAcceptableContentTypes:newAcceptableContentTypes];
    
    
    [imgDownloader downloadImageForURLRequest:sourceURLRequest success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull responseImage) {
        
        RSOSResponseStatusDataModel *responseStatus = [[RSOSResponseStatusDataModel alloc] init];
        responseStatus.status = RSOSHTTPResponseCodeOK;
        
        if(callback) {
            callback(responseStatus, responseImage);
        }
        
    } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
        
        RSOSResponseStatusDataModel *responseStatus = [[RSOSResponseStatusDataModel alloc] initWithTask:nil response:response error:error];
        
        if(callback) {
            callback(responseStatus, nil);
        }
    }];
}


/**
 * @abstract update saved locations with user profile data
 * and synchronize saved locations with the back end
 */

- (void)synchronizeSavedLocations {
    
    /**
     * propogate changes to the profile address to the
     * user's saved location
     */
    
    if(self.modelProfile && self.modelProfile.addresses.getPrimaryValue) {
        
        RSOSDataAddress *homeAddress = [self.modelProfile.addresses getPrimaryValue];
        
        RSOSDataSavedLocation *savedHomeLocation;
        
        if(self.savedLocations.count > 0) {
            savedHomeLocation = self.savedLocations[0];
        }
        else {
            savedHomeLocation = [[RSOSDataSavedLocation alloc] init];
            [self.savedLocations addObject:savedHomeLocation];
        }
        
        [savedHomeLocation.addresses setPrimaryValue:homeAddress];
    }
    
    for(RSOSDataSavedLocation *savedLocation in self.savedLocations) {
        
        if(![savedLocation savedToRemote]) {
            [self addSavedLocation:savedLocation
                          callback:^(RSOSResponseStatusDataModel * _Nonnull status) {
                              
                          }];
        }
        else {
            [self updateSavedLocation:savedLocation
                             callback:^(RSOSResponseStatusDataModel * _Nonnull status) {
                                 
                             }];
        }
        
    }
}

- (NSArray *)serializeSavedLocationsToDictionaries {
    
    NSMutableArray *ret = [NSMutableArray arrayWithCapacity:self.savedLocations.count];
    
    for (RSOSDataSavedLocation *savedLocation in self.savedLocations) {
        [ret addObject:[savedLocation serializeToDictionary]];
    }
    
    return ret;
}

@end
