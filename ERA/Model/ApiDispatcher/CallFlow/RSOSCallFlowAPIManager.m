//
//  RSOSCallFlowAPIManager.m
//  Emergency Reference Application
//
//  Created by Chris Lin on 11/30/17.
//  Copyright © 2017 RapidSOS. All rights reserved.
//

#import "RSOSCallFlowAPIManager.h"
#import "RSOSAuthManager.h"
#import "RSOSUtils.h"

#import "RSOSUtils.h"
#import "AppConstants.h"
#import <AFNetworking.h>

NSString * const RSOSCallFlowSample = @"kronos_contact";

@implementation RSOSCallFlowAPIManager

#pragma mark - Request

+ (void)requestTriggerCallWithCallFlow:(NSString *)callFlow variables:(NSDictionary *)variables callback:(void (^)(RSOSResponseStatusDataModel *status))callback {
    
    RSOSAuthManager *managerAuth = [RSOSAuthManager sharedInstance];
    
    [managerAuth refreshClientAccessTokenIfNeededWithCallback:^(RSOSResponseStatusDataModel *status) {
        
        if ([status isSuccess] == YES) {
            
            // callflow request URL
            NSString *urlString = [NSString stringWithFormat:@"%@/v1/rem/trigger", RSOS_BASE_URL];
            
            // session manager
            AFHTTPSessionManager *managerAFSession = [AFHTTPSessionManager manager];
            managerAFSession.requestSerializer = [AFJSONRequestSerializer serializer];
            managerAFSession.responseSerializer = [AFJSONResponseSerializer serializer];
            
            // add header
            [managerAFSession.requestSerializer setValue:[[RSOSAuthManager sharedInstance] getClientAuthorizationToken] forHTTPHeaderField:@"Authorization"];
            
            // parameters
            NSDictionary *params = @{@"callflow": callFlow,
                                     @"variables": variables,
                                     };
            
            NSLog(@"Network Request =>\nPOST: %@\nParams: %@\n", urlString, params);
            
            [managerAFSession POST:urlString parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                NSLog(@"Request Succeeded =>\nPOST: %@", urlString);
                
                RSOSResponseStatusDataModel *response = [[RSOSResponseStatusDataModel alloc] initWithTask:task response:responseObject error:nil];
                
                if (callback) {
                    callback(response);
                }
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
                RSOSResponseStatusDataModel *response = [[RSOSResponseStatusDataModel alloc] initWithTask:task response:nil error:error];
                
                NSLog(@"Request Failed =>\nPOST: %@\nCode: %d\nMessage: %@", urlString, (int)response.status, response.message);
                
                if (callback) {
                    callback(response);
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

@end
