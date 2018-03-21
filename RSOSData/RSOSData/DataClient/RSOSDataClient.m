//
//  RSOSDataClient.m
//  RSOSData
//
//  Created by Gabe Mahoney on 2/19/18.
//  Copyright © 2018 RapidSOS. All rights reserved.
//

#import "RSOSDataClient.h"
#import "RSOSAuthManager.h"
#import "AFNetworking.h"

@implementation RSOSDataClient


+ (instancetype)defaultClient {
    return [[RSOSDataClient alloc] init];
}


- (void)getProfileWithCallback:(void (^)(RSOSResponseStatusDataModel *status, RSOSDataUserProfile *profile))callback {
    
    [[RSOSAuthManager sharedInstance] refreshUserAccessTokenIfNeededWithCallback:^(RSOSResponseStatusDataModel *status) {
        
        if ([status isSuccess] == YES) {
            
            // profile info request URL
            NSString *urlString = [NSString stringWithFormat:@"%@/v1/rain/personal-info", [RSOSAuthManager sharedInstance].baseURL];
            
            // session manager
            AFHTTPSessionManager *managerAFSession = [AFHTTPSessionManager manager];
            managerAFSession.requestSerializer = [AFJSONRequestSerializer serializer];
            managerAFSession.responseSerializer = [AFJSONResponseSerializer serializer];
            
            // Add Header
            [managerAFSession.requestSerializer setValue:[RSOSAuthManager sharedInstance].getUserAuthorizationToken forHTTPHeaderField:@"Authorization"];
            
            [managerAFSession GET:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                RSOSResponseStatusDataModel *response = [[RSOSResponseStatusDataModel alloc] initWithTask:task response:responseObject error:nil];
                
                if ([response isSuccess] == YES) {
                    
                    RSOSDataUserProfile *profile = [[RSOSDataUserProfile alloc] initWithDictionary:responseObject];
                    
                    callback(response, profile);
                    
                    return;
                }
                
                if (callback) {
                    callback(status,nil);
                }
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
                RSOSResponseStatusDataModel *status = [[RSOSResponseStatusDataModel alloc] initWithTask:task response:nil error:error];
                
                if (callback) {
                    callback(status, nil);
                }
            }];
        }
        else {
            if (callback) {
                callback(status, nil);
            }
        }
    }];
}

- (void)patchProfile:(RSOSDataUserProfile *)profile callback:(void (^)(RSOSResponseStatusDataModel *status, RSOSDataUserProfile *profile))callback {
    
    [[RSOSAuthManager sharedInstance] refreshUserAccessTokenIfNeededWithCallback:^(RSOSResponseStatusDataModel *status) {
        
        if ([status isSuccess] == YES) {
            
            // update profile request URL
            NSString *urlString = [NSString stringWithFormat:@"%@/v1/rain/personal-info", [RSOSAuthManager sharedInstance].baseURL];
            
            // session manager
            AFHTTPSessionManager *managerAFSession = [AFHTTPSessionManager manager];
            managerAFSession.requestSerializer = [AFJSONRequestSerializer serializer];
            managerAFSession.responseSerializer = [AFJSONResponseSerializer serializer];
            
            // Add Header
            [managerAFSession.requestSerializer setValue:[RSOSAuthManager sharedInstance].getUserAuthorizationToken forHTTPHeaderField:@"Authorization"];
            
            // parameters
            NSDictionary *params = [profile serializeToDictionary];
            
            [managerAFSession PATCH:urlString parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                RSOSResponseStatusDataModel *response = [[RSOSResponseStatusDataModel alloc] initWithTask:task response:responseObject error:nil];
                
                if ([response isSuccess] == YES) {
                    
                    RSOSDataUserProfile *newProfile = [[RSOSDataUserProfile alloc] initWithDictionary:responseObject];
                    
                    if(callback) {
                        callback(response, newProfile);
                    }
                }
                else {
                    if (callback) {
                        callback(status, nil);
                    }
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
                RSOSResponseStatusDataModel *status = [[RSOSResponseStatusDataModel alloc] initWithTask:task response:nil error:error];
                NSLog(@"Request Failed=>\nPOST: %@\nResponse: %@", urlString, status);
                
                if (callback) {
                    callback(status, nil);
                }
            }];
        }
        else {
            if (callback) {
                callback(status, nil);
            }
        }
    }];
}


- (void)getSavedLocationsWithCallback:(void (^ _Nullable)(RSOSResponseStatusDataModel *status, NSArray<RSOSDataSavedLocation *> *savedLocations))callback {
    
    [[RSOSAuthManager sharedInstance] refreshUserAccessTokenIfNeededWithCallback:^(RSOSResponseStatusDataModel *status) {
        
        if ([status isSuccess] == YES) {
            
            // profile info request URL
            NSString *urlString = [NSString stringWithFormat:@"%@/v1/rain/locations", [RSOSAuthManager sharedInstance].baseURL];
            
            // session manager
            AFHTTPSessionManager *managerAFSession = [AFHTTPSessionManager manager];
            managerAFSession.requestSerializer = [AFJSONRequestSerializer serializer];
            managerAFSession.responseSerializer = [AFJSONResponseSerializer serializer];
            
            // Add Header
            [managerAFSession.requestSerializer setValue:[RSOSAuthManager sharedInstance].getUserAuthorizationToken forHTTPHeaderField:@"Authorization"];
            
            [managerAFSession GET:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                RSOSResponseStatusDataModel *response = [[RSOSResponseStatusDataModel alloc] initWithTask:task response:responseObject error:nil];
                
                if ([response isSuccess] == YES) {
                    
                    NSMutableArray *tempSavedLocations = [NSMutableArray array];
                    
                    if([responseObject isKindOfClass:[NSArray class]]) {
                        
                        for(NSDictionary *savedLocationDict in responseObject) {
                            
                            RSOSDataSavedLocation *savedLocation = [[RSOSDataSavedLocation alloc] initWithDictionary:savedLocationDict];
                            [tempSavedLocations addObject:savedLocation];
                        }
                    }
                    
                    NSArray *savedLocations = [NSArray arrayWithArray:tempSavedLocations];
                    
                    if(callback) {
                        callback(response, savedLocations);
                    }
                    return;
                }
                
                if (callback) {
                    callback(status,nil);
                }
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
                RSOSResponseStatusDataModel *status = [[RSOSResponseStatusDataModel alloc] initWithTask:task response:nil error:error];
                
                if (callback) {
                    callback(status, nil);
                }
            }];
        }
        else {
            if (callback) {
                callback(status, nil);
            }
        }
    }];
    
}

- (void)createSavedLocation:(RSOSDataSavedLocation *)savedLocation callback:(void (^ _Nullable)(RSOSResponseStatusDataModel *status, RSOSDataSavedLocation * _Nullable savedLocation))callback {
    
    [[RSOSAuthManager sharedInstance] refreshUserAccessTokenIfNeededWithCallback:^(RSOSResponseStatusDataModel *status) {
        
        if ([status isSuccess] == YES) {
            
            // update profile request URL
            NSString *urlString = [NSString stringWithFormat:@"%@/v1/rain/locations", [RSOSAuthManager sharedInstance].baseURL];
            
            // session manager
            AFHTTPSessionManager *managerAFSession = [AFHTTPSessionManager manager];
            managerAFSession.requestSerializer = [AFJSONRequestSerializer serializer];
            managerAFSession.responseSerializer = [AFJSONResponseSerializer serializer];
            
            // Add Header
            [managerAFSession.requestSerializer setValue:[RSOSAuthManager sharedInstance].getUserAuthorizationToken forHTTPHeaderField:@"Authorization"];
            
            // parameters
            NSDictionary *params = [savedLocation serializeToDictionary];
            
            [managerAFSession POST:urlString parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                RSOSResponseStatusDataModel *response = [[RSOSResponseStatusDataModel alloc] initWithTask:task response:responseObject error:nil];
                
                if ([response isSuccess] == YES) {
                    
                    RSOSDataSavedLocation *savedLocation = [[RSOSDataSavedLocation alloc] initWithDictionary:responseObject];
                    
                    if(callback) {
                        callback(response, savedLocation);
                    }
                    return;
                }
                else {
                    if (callback) {
                        callback(status, nil);
                    }
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
                RSOSResponseStatusDataModel *status = [[RSOSResponseStatusDataModel alloc] initWithTask:task response:nil error:error];
                NSLog(@"Request Failed=>\nPOST: %@\nResponse: %@", urlString, status);
                
                if (callback) {
                    callback(status, nil);
                }
            }];
        }
        else {
            if (callback) {
                callback(status, nil);
            }
        }
    }];
}


- (void)getSavedLocation:(NSString *)locationID callback:(void (^ _Nullable)(RSOSResponseStatusDataModel *status, RSOSDataSavedLocation * _Nullable savedLocation))callback {
    
    [[RSOSAuthManager sharedInstance] refreshUserAccessTokenIfNeededWithCallback:^(RSOSResponseStatusDataModel *status) {
        
        if ([status isSuccess] == YES) {
            
            // update profile request URL
            NSString *urlString = [NSString stringWithFormat:@"%@/v1/rain/locations/%@", [RSOSAuthManager sharedInstance].baseURL, locationID];
            
            // session manager
            AFHTTPSessionManager *managerAFSession = [AFHTTPSessionManager manager];
            managerAFSession.requestSerializer = [AFJSONRequestSerializer serializer];
            managerAFSession.responseSerializer = [AFJSONResponseSerializer serializer];
            
            // Add Header
            [managerAFSession.requestSerializer setValue:[RSOSAuthManager sharedInstance].getUserAuthorizationToken forHTTPHeaderField:@"Authorization"];
            
            [managerAFSession GET:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                RSOSResponseStatusDataModel *response = [[RSOSResponseStatusDataModel alloc] initWithTask:task response:responseObject error:nil];
                
                if ([response isSuccess] == YES) {
                    
                    RSOSDataSavedLocation *savedLocation = [[RSOSDataSavedLocation alloc] initWithDictionary:responseObject];
                    
                    if(callback) {
                        callback(response, savedLocation);
                    }
                    return;
                }
                else {
                    if (callback) {
                        callback(status, nil);
                    }
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
                RSOSResponseStatusDataModel *status = [[RSOSResponseStatusDataModel alloc] initWithTask:task response:nil error:error];
                NSLog(@"Request Failed=>\nPOST: %@\nResponse: %@", urlString, status);
                
                if (callback) {
                    callback(status, nil);
                }
            }];
        }
        else {
            if (callback) {
                callback(status, nil);
            }
        }
    }];
}


- (void)deleteSavedLocation:(NSString *)locationID callback:(void (^ _Nullable)(RSOSResponseStatusDataModel *status, RSOSDataSavedLocation * _Nullable savedLocation))callback {
    
    [[RSOSAuthManager sharedInstance] refreshUserAccessTokenIfNeededWithCallback:^(RSOSResponseStatusDataModel *status) {
        
        if ([status isSuccess] == YES) {
            
            // update profile request URL
            NSString *urlString = [NSString stringWithFormat:@"%@/v1/rain/locations/%@", [RSOSAuthManager sharedInstance].baseURL, locationID];
            
            // session manager
            AFHTTPSessionManager *managerAFSession = [AFHTTPSessionManager manager];
            managerAFSession.requestSerializer = [AFJSONRequestSerializer serializer];
            managerAFSession.responseSerializer = [AFJSONResponseSerializer serializer];
            
            // Add Header
            [managerAFSession.requestSerializer setValue:[RSOSAuthManager sharedInstance].getUserAuthorizationToken forHTTPHeaderField:@"Authorization"];
            
            [managerAFSession DELETE:urlString parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                RSOSResponseStatusDataModel *response = [[RSOSResponseStatusDataModel alloc] initWithTask:task response:responseObject error:nil];
                
                if ([response isSuccess] == YES) {
                    
                    RSOSDataSavedLocation *savedLocation = [[RSOSDataSavedLocation alloc] initWithDictionary:responseObject];
                    
                    if(callback) {
                        callback(response, savedLocation);
                    }
                    return;
                }
                else {
                    if (callback) {
                        callback(status, nil);
                    }
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
                RSOSResponseStatusDataModel *status = [[RSOSResponseStatusDataModel alloc] initWithTask:task response:nil error:error];
                NSLog(@"Request Failed=>\nPOST: %@\nResponse: %@", urlString, status);
                
                if (callback) {
                    callback(status, nil);
                }
            }];
        }
        else {
            if (callback) {
                callback(status, nil);
            }
        }
    }];
}


- (void)updateSavedLocation:(RSOSDataSavedLocation *)savedLocation callback:(void (^ _Nullable)(RSOSResponseStatusDataModel *status, RSOSDataSavedLocation * _Nullable savedLocation))callback {
    
    if(savedLocation.locationID.length == 0) {
        
        RSOSResponseStatusDataModel *response = [[RSOSResponseStatusDataModel alloc] init];
        response.status = RSOSHTTPResponseCodeBadRequest;
        response.message = @"No location ID";
        
        if(callback) {
            callback(response, nil);
        }
        
        return;
    }
    
    [[RSOSAuthManager sharedInstance] refreshUserAccessTokenIfNeededWithCallback:^(RSOSResponseStatusDataModel *status) {
        
        if ([status isSuccess] == YES) {
            
            // update profile request URL
            NSString *urlString = [NSString stringWithFormat:@"%@/v1/rain/locations/%@", [RSOSAuthManager sharedInstance].baseURL, savedLocation.locationID];
            
            // session manager
            AFHTTPSessionManager *managerAFSession = [AFHTTPSessionManager manager];
            managerAFSession.requestSerializer = [AFJSONRequestSerializer serializer];
            managerAFSession.responseSerializer = [AFJSONResponseSerializer serializer];
            
            // Add Header
            [managerAFSession.requestSerializer setValue:[RSOSAuthManager sharedInstance].getUserAuthorizationToken forHTTPHeaderField:@"Authorization"];
            
            // parameters
            NSDictionary *params = @{@"id":savedLocation.locationID};
            
            [managerAFSession PUT:urlString parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                RSOSResponseStatusDataModel *response = [[RSOSResponseStatusDataModel alloc] initWithTask:task response:responseObject error:nil];
                
                if ([response isSuccess] == YES) {
                    
                    RSOSDataSavedLocation *savedLocation = [[RSOSDataSavedLocation alloc] initWithDictionary:responseObject];
                    
                    if(callback) {
                        callback(response, savedLocation);
                    }
                    return;
                }
                else {
                    if (callback) {
                        callback(status, nil);
                    }
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
                RSOSResponseStatusDataModel *status = [[RSOSResponseStatusDataModel alloc] initWithTask:task response:nil error:error];
                NSLog(@"Request Failed=>\nPOST: %@\nResponse: %@", urlString, status);
                
                if (callback) {
                    callback(status, nil);
                }
            }];
        }
        else {
            if (callback) {
                callback(status, nil);
            }
        }
    }];
}


- (void)patchSavedLocation:(RSOSDataSavedLocation *)savedLocation callback:(void (^ _Nullable)(RSOSResponseStatusDataModel *status, RSOSDataSavedLocation * _Nullable savedLocation))callback {
    
    if(savedLocation.locationID.length == 0) {
        
        RSOSResponseStatusDataModel *response = [[RSOSResponseStatusDataModel alloc] init];
        response.status = RSOSHTTPResponseCodeBadRequest;
        response.message = @"No location ID";
        
        if(callback) {
            callback(response, nil);
        }
        
        return;
    }
    
    [[RSOSAuthManager sharedInstance] refreshUserAccessTokenIfNeededWithCallback:^(RSOSResponseStatusDataModel *status) {
        
        if ([status isSuccess] == YES) {
            
            // update profile request URL
            NSString *urlString = [NSString stringWithFormat:@"%@/v1/rain/locations/%@", [RSOSAuthManager sharedInstance].baseURL, savedLocation.locationID];
            
            // session manager
            AFHTTPSessionManager *managerAFSession = [AFHTTPSessionManager manager];
            managerAFSession.requestSerializer = [AFJSONRequestSerializer serializer];
            managerAFSession.responseSerializer = [AFJSONResponseSerializer serializer];
            
            // Add Header
            [managerAFSession.requestSerializer setValue:[RSOSAuthManager sharedInstance].getUserAuthorizationToken forHTTPHeaderField:@"Authorization"];
            
            // parameters
            NSDictionary *params = @{@"id":savedLocation.locationID};
            
            [managerAFSession PATCH:urlString parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                RSOSResponseStatusDataModel *response = [[RSOSResponseStatusDataModel alloc] initWithTask:task response:responseObject error:nil];
                
                if ([response isSuccess] == YES) {
                    
                    RSOSDataSavedLocation *savedLocation = [[RSOSDataSavedLocation alloc] initWithDictionary:responseObject];
                    
                    if(callback) {
                        callback(response, savedLocation);
                    }
                    return;
                }
                else {
                    if (callback) {
                        callback(status, nil);
                    }
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
                RSOSResponseStatusDataModel *status = [[RSOSResponseStatusDataModel alloc] initWithTask:task response:nil error:error];
                NSLog(@"Request Failed=>\nPOST: %@\nResponse: %@", urlString, status);
                
                if (callback) {
                    callback(status, nil);
                }
            }];
        }
        else {
            if (callback) {
                callback(status, nil);
            }
        }
    }];
}

- (void)getDevicesWithCallback:(void (^ _Nullable)(RSOSResponseStatusDataModel *status, NSArray<RSOSDataDevice *> *devices))callback {
    
    [[RSOSAuthManager sharedInstance] refreshUserAccessTokenIfNeededWithCallback:^(RSOSResponseStatusDataModel *status) {
        
        if ([status isSuccess] == YES) {
            
            // profile info request URL
            NSString *urlString = [NSString stringWithFormat:@"%@/v1/rain/devices", [RSOSAuthManager sharedInstance].baseURL];
            
            // session manager
            AFHTTPSessionManager *managerAFSession = [AFHTTPSessionManager manager];
            managerAFSession.requestSerializer = [AFJSONRequestSerializer serializer];
            managerAFSession.responseSerializer = [AFJSONResponseSerializer serializer];
            
            // Add Header
            [managerAFSession.requestSerializer setValue:[RSOSAuthManager sharedInstance].getUserAuthorizationToken forHTTPHeaderField:@"Authorization"];
            
            [managerAFSession GET:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                RSOSResponseStatusDataModel *response = [[RSOSResponseStatusDataModel alloc] initWithTask:task response:responseObject error:nil];
                
                if ([response isSuccess] == YES) {
                    
                    NSMutableArray *tempDevices = [NSMutableArray array];
                    
                    if([responseObject isKindOfClass:[NSArray class]]) {
                        
                        for(NSDictionary *responseDict in responseObject) {
                            
                            RSOSDataDevice *device = [[RSOSDataDevice alloc] initWithDictionary:responseDict];
                            [tempDevices addObject:device];
                        }
                    }
                    
                    NSArray *devices = [NSArray arrayWithArray:tempDevices];
                    
                    if(callback) {
                        callback(response, devices);
                    }
                    return;
                }
                
                if (callback) {
                    callback(status,nil);
                }
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
                RSOSResponseStatusDataModel *status = [[RSOSResponseStatusDataModel alloc] initWithTask:task response:nil error:error];
                
                if (callback) {
                    callback(status, nil);
                }
            }];
        }
        else {
            if (callback) {
                callback(status, nil);
            }
        }
    }];
}


- (void)postDevice:(RSOSDataDevice *)device callback:(void (^ _Nullable)(RSOSResponseStatusDataModel *status, RSOSDataDevice * _Nullable device))callback {
    
    [[RSOSAuthManager sharedInstance] refreshUserAccessTokenIfNeededWithCallback:^(RSOSResponseStatusDataModel *status) {
        
        if ([status isSuccess] == YES) {
            
            // update profile request URL
            NSString *urlString = [NSString stringWithFormat:@"%@/v1/rain/devices", [RSOSAuthManager sharedInstance].baseURL];
            
            // session manager
            AFHTTPSessionManager *managerAFSession = [AFHTTPSessionManager manager];
            managerAFSession.requestSerializer = [AFJSONRequestSerializer serializer];
            managerAFSession.responseSerializer = [AFJSONResponseSerializer serializer];
            
            // Add Header
            [managerAFSession.requestSerializer setValue:[RSOSAuthManager sharedInstance].getUserAuthorizationToken forHTTPHeaderField:@"Authorization"];
            
            // parameters
            NSDictionary *params = [device serializeToDictionary];
            
            [managerAFSession POST:urlString parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                RSOSResponseStatusDataModel *response = [[RSOSResponseStatusDataModel alloc] initWithTask:task response:responseObject error:nil];
                
                if ([response isSuccess] == YES) {
                    
                    RSOSDataDevice *device = [[RSOSDataDevice alloc] initWithDictionary:responseObject];
                    
                    if(callback) {
                        callback(response, device);
                    }
                    return;
                }
                else {
                    if (callback) {
                        callback(status, nil);
                    }
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
                RSOSResponseStatusDataModel *status = [[RSOSResponseStatusDataModel alloc] initWithTask:task response:nil error:error];
                NSLog(@"Request Failed=>\nPOST: %@\nResponse: %@", urlString, status);
                
                if (callback) {
                    callback(status, nil);
                }
            }];
        }
        else {
            if (callback) {
                callback(status, nil);
            }
        }
    }];
}

- (void)getDevice:(NSString *)deviceID callback:(void (^ _Nullable)(RSOSResponseStatusDataModel *status, RSOSDataDevice * _Nullable device))callback {
    
    [[RSOSAuthManager sharedInstance] refreshUserAccessTokenIfNeededWithCallback:^(RSOSResponseStatusDataModel *status) {
        
        if ([status isSuccess] == YES) {
            
            // update profile request URL
            NSString *urlString = [NSString stringWithFormat:@"%@/v1/rain/devices/%@", [RSOSAuthManager sharedInstance].baseURL, deviceID];
            
            // session manager
            AFHTTPSessionManager *managerAFSession = [AFHTTPSessionManager manager];
            managerAFSession.requestSerializer = [AFJSONRequestSerializer serializer];
            managerAFSession.responseSerializer = [AFJSONResponseSerializer serializer];
            
            // Add Header
            [managerAFSession.requestSerializer setValue:[RSOSAuthManager sharedInstance].getUserAuthorizationToken forHTTPHeaderField:@"Authorization"];
            
            [managerAFSession GET:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                RSOSResponseStatusDataModel *response = [[RSOSResponseStatusDataModel alloc] initWithTask:task response:responseObject error:nil];
                
                if ([response isSuccess] == YES) {
                    
                    RSOSDataDevice *device = [[RSOSDataDevice alloc] initWithDictionary:responseObject];
                    
                    if(callback) {
                        callback(response, device);
                    }
                    return;
                }
                else {
                    if (callback) {
                        callback(status, nil);
                    }
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
                RSOSResponseStatusDataModel *status = [[RSOSResponseStatusDataModel alloc] initWithTask:task response:nil error:error];
                NSLog(@"Request Failed=>\nPOST: %@\nResponse: %@", urlString, status);
                
                if (callback) {
                    callback(status, nil);
                }
            }];
        }
        else {
            if (callback) {
                callback(status, nil);
            }
        }
    }];
}

- (void)deleteDevice:(NSString *)deviceID callback:(void (^ _Nullable)(RSOSResponseStatusDataModel *status, RSOSDataDevice * _Nullable device))callback {
    
    [[RSOSAuthManager sharedInstance] refreshUserAccessTokenIfNeededWithCallback:^(RSOSResponseStatusDataModel *status) {
        
        if ([status isSuccess] == YES) {
            
            // update profile request URL
            NSString *urlString = [NSString stringWithFormat:@"%@/v1/rain/devices/%@", [RSOSAuthManager sharedInstance].baseURL, deviceID];
            
            // session manager
            AFHTTPSessionManager *managerAFSession = [AFHTTPSessionManager manager];
            managerAFSession.requestSerializer = [AFJSONRequestSerializer serializer];
            managerAFSession.responseSerializer = [AFJSONResponseSerializer serializer];
            
            // Add Header
            [managerAFSession.requestSerializer setValue:[RSOSAuthManager sharedInstance].getUserAuthorizationToken forHTTPHeaderField:@"Authorization"];
            
            
            [managerAFSession DELETE:urlString parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                RSOSResponseStatusDataModel *response = [[RSOSResponseStatusDataModel alloc] initWithTask:task response:responseObject error:nil];
                
                if ([response isSuccess] == YES) {
                    
                    RSOSDataDevice *device = [[RSOSDataDevice alloc] initWithDictionary:responseObject];
                    
                    if(callback) {
                        callback(response, device);
                    }
                    return;
                }
                else {
                    if (callback) {
                        callback(status, nil);
                    }
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
                RSOSResponseStatusDataModel *status = [[RSOSResponseStatusDataModel alloc] initWithTask:task response:nil error:error];
                NSLog(@"Request Failed=>\nPOST: %@\nResponse: %@", urlString, status);
                
                if (callback) {
                    callback(status, nil);
                }
            }];
        }
        else {
            if (callback) {
                callback(status, nil);
            }
        }
    }];
}

- (void)updateDevice:(RSOSDataDevice *)device callback:(void (^ _Nullable)(RSOSResponseStatusDataModel *status, RSOSDataDevice * _Nullable device))callback {
    
    if(device.deviceID.length == 0) {
        
        RSOSResponseStatusDataModel *response = [[RSOSResponseStatusDataModel alloc] init];
        response.status = RSOSHTTPResponseCodeBadRequest;
        response.message = @"No device ID";
        
        if(callback) {
            callback(response, nil);
        }
        
        return;
    }
    [[RSOSAuthManager sharedInstance] refreshUserAccessTokenIfNeededWithCallback:^(RSOSResponseStatusDataModel *status) {
        
        if ([status isSuccess] == YES) {
            
            // update profile request URL
            NSString *urlString = [NSString stringWithFormat:@"%@/v1/rain/devices/%@", [RSOSAuthManager sharedInstance].baseURL, device.deviceID];
            
            // session manager
            AFHTTPSessionManager *managerAFSession = [AFHTTPSessionManager manager];
            managerAFSession.requestSerializer = [AFJSONRequestSerializer serializer];
            managerAFSession.responseSerializer = [AFJSONResponseSerializer serializer];
            
            // Add Header
            [managerAFSession.requestSerializer setValue:[RSOSAuthManager sharedInstance].getUserAuthorizationToken forHTTPHeaderField:@"Authorization"];
            
            // parameters
            NSDictionary *params = [device serializeToDictionary];
            
            [managerAFSession PUT:urlString parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                RSOSResponseStatusDataModel *response = [[RSOSResponseStatusDataModel alloc] initWithTask:task response:responseObject error:nil];
                
                if ([response isSuccess] == YES) {
                    
                    RSOSDataDevice *device = [[RSOSDataDevice alloc] initWithDictionary:responseObject];
                    
                    if(callback) {
                        callback(response, device);
                    }
                    return;
                }
                else {
                    if (callback) {
                        callback(status, nil);
                    }
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
                RSOSResponseStatusDataModel *status = [[RSOSResponseStatusDataModel alloc] initWithTask:task response:nil error:error];
                NSLog(@"Request Failed=>\nPOST: %@\nResponse: %@", urlString, status);
                
                if (callback) {
                    callback(status, nil);
                }
            }];
        }
        else {
            if (callback) {
                callback(status, nil);
            }
        }
    }];
}

- (void)patchDevice:(RSOSDataDevice *)device callback:(void (^ _Nullable)(RSOSResponseStatusDataModel *status, RSOSDataDevice * _Nullable device))callback {
    
    if(device.deviceID.length == 0) {
        
        RSOSResponseStatusDataModel *response = [[RSOSResponseStatusDataModel alloc] init];
        response.status = RSOSHTTPResponseCodeBadRequest;
        response.message = @"No device ID";
        
        if(callback) {
            callback(response, nil);
        }
        
        return;
    }
    [[RSOSAuthManager sharedInstance] refreshUserAccessTokenIfNeededWithCallback:^(RSOSResponseStatusDataModel *status) {
        
        if ([status isSuccess] == YES) {
            
            // update profile request URL
            NSString *urlString = [NSString stringWithFormat:@"%@/v1/rain/devices/%@", [RSOSAuthManager sharedInstance].baseURL, device.deviceID];
            
            // session manager
            AFHTTPSessionManager *managerAFSession = [AFHTTPSessionManager manager];
            managerAFSession.requestSerializer = [AFJSONRequestSerializer serializer];
            managerAFSession.responseSerializer = [AFJSONResponseSerializer serializer];
            
            // Add Header
            [managerAFSession.requestSerializer setValue:[RSOSAuthManager sharedInstance].getUserAuthorizationToken forHTTPHeaderField:@"Authorization"];
            
            // parameters
            NSDictionary *params = [device serializeToDictionary];
            
            [managerAFSession PUT:urlString parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                RSOSResponseStatusDataModel *response = [[RSOSResponseStatusDataModel alloc] initWithTask:task response:responseObject error:nil];
                
                if ([response isSuccess] == YES) {
                    
                    RSOSDataDevice *device = [[RSOSDataDevice alloc] initWithDictionary:responseObject];
                    
                    if(callback) {
                        callback(response, device);
                    }
                    return;
                }
                else {
                    if (callback) {
                        callback(status, nil);
                    }
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
                RSOSResponseStatusDataModel *status = [[RSOSResponseStatusDataModel alloc] initWithTask:task response:nil error:error];
                NSLog(@"Request Failed=>\nPOST: %@\nResponse: %@", urlString, status);
                
                if (callback) {
                    callback(status, nil);
                }
            }];
        }
        else {
            if (callback) {
                callback(status, nil);
            }
        }
    }];
}

@end
