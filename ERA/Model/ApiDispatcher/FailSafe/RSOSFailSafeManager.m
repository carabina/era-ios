//
//  RSOSFailSafeManager.m
//  EmergencyReferenceApp
//
//  Created by Gabe Mahoney on 1/18/18.
//  Copyright © 2018 RapidSOS. All rights reserved.
//

#import "RSOSFailSafeManager.h"

#import "AppConstants.h"

#import <RSOSData/RSOSData.h>
#import <AFNetworking.h>
#import <UserNotifications/UserNotifications.h>

NSString * const RSOSKronosActionFailsafe = @"com.rapidsos.kronos.failsafe";
NSString * const RSOSKronosActionEmergencyAcknowledge = @"com.rapidsos.kronos.emergencyAck";

@interface RSOSFailSafeManager () <UNUserNotificationCenterDelegate>

@property (nonatomic) UIBackgroundTaskIdentifier backgroundTask;

@end

@implementation RSOSFailSafeManager

+ (instancetype)sharedInstance {
    
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (void)initializeManager {
    
    self.enabled = YES;
    
    self.failSafeTriggeredHandler = nil;
    self.failSafeTimeOutInterval = 120.0;
    
    _state = RSOSFailSafeStateInactive;
    _failSafeTimer = nil;
}

- (void)enableFailSafe {
    self.enabled = YES;
}

- (void)disableFailSafe {
    self.enabled = NO;
}

- (void)registerDeviceToken:(NSString *)deviceToken forPhoneNumber:(NSString *)phoneNumber {
    
    [[RSOSAuthManager sharedInstance] refreshClientAccessTokenIfNeededWithCallback:^(RSOSResponseStatusDataModel * _Nonnull responseStatus) {
        
        // register user request URL
        NSString *urlString = [NSString stringWithFormat:@"%@/v1/apollo-config/register", ERA_BACKEND_URL];
        
        NSString *formattedPhoneNumber = [RSOSUtilsString stripNonnumericsFromNSString:phoneNumber];
        
        // session manager
        AFHTTPSessionManager *managerAFSession = [AFHTTPSessionManager manager];
        managerAFSession.requestSerializer = [AFJSONRequestSerializer serializer];
        managerAFSession.responseSerializer = [AFJSONResponseSerializer serializer];
        
        // add authentication header
        [managerAFSession.requestSerializer setValue:[[RSOSAuthManager sharedInstance] getClientAuthorizationToken] forHTTPHeaderField:@"Authorization"];
        
        // parameters
        NSDictionary *params = @{@"caller_id": formattedPhoneNumber,
                                 @"push_token": deviceToken};
        
        NSLog(@"Network Request =>\nPOST: %@", urlString);
        
        [managerAFSession POST:urlString parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSLog(@"Successfully registed device token for %@", phoneNumber);
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            RSOSResponseStatusDataModel *status = [[RSOSResponseStatusDataModel alloc] initWithTask:task response:nil error:error];
            NSLog(@"Request Failed =>\nRequest: %@\nResponse: %@", urlString, status);
            
        }];
    }];
}

- (void)handleNotificationPayload:(NSDictionary *)payload {
    
    NSString *action = payload[@"action"];
    
    if([action isEqualToString:RSOSKronosActionEmergencyAcknowledge]) {
        [self resetFailSafe];
    }
    else if([action isEqualToString:RSOSKronosActionFailsafe]) {
        [self triggerFailsafe];
    }
    
}

- (void)activateFailsafe {
    
    if(!self.enabled ||
       self.state == RSOSFailSafeStateActive ||
       self.state == RSOSFailSafeStateTriggered) {
        
        return;
    }
    
    _state = RSOSFailSafeStateActive;
    
    // activate timer
    // create and schedule to run on main loop
    
    _failSafeTimer = [NSTimer timerWithTimeInterval:self.failSafeTimeOutInterval
                           repeats:NO
                             block:^(NSTimer * _Nonnull timer) {
                                 [self triggerFailsafe];
                             }];
    [[NSRunLoop mainRunLoop] addTimer:self.failSafeTimer forMode:NSDefaultRunLoopMode];
    
    NSLog(@"Failsafe activated");
    
}

- (void)triggerFailsafe {
    
    if(!self.enabled ||
       self.state == RSOSFailSafeStateInactive ||
       self.state == RSOSFailSafeStateTriggered) {
        return;
    }
    
    _state = RSOSFailSafeStateTriggered;
    
    if(self.failSafeTriggeredHandler != nil) {
        
        NSLog(@"Failsafe triggered");
        
        RSOSFailSafeManager * __weak weakFailsafeManager = self;
        
        self.failSafeTriggeredHandler(weakFailsafeManager);
    }
    else {
        [self resetFailSafe];
    }
}

- (void)resetFailSafe {
    
    NSLog(@"Failsafe reset");
    
    _state = RSOSFailSafeStateInactive;
    
    if(self.backgroundTask != UIBackgroundTaskInvalid) {
        [[UIApplication sharedApplication] endBackgroundTask:self.backgroundTask];
        self.backgroundTask = UIBackgroundTaskInvalid;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.failSafeTimer invalidate];
    });
}

- (void)applicationDidEnterBackground {
    
    if(self.state == RSOSFailSafeStateActive) {
        
        RSOSFailSafeManager __weak *weakSelf = self;
        
        self.backgroundTask = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
            
            [[UIApplication sharedApplication] endBackgroundTask:weakSelf.backgroundTask];
            weakSelf.backgroundTask = UIBackgroundTaskInvalid;
            
        }];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
           
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.failSafeTimeOutInterval * NSEC_PER_SEC)), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                [[UIApplication sharedApplication] endBackgroundTask:weakSelf.backgroundTask];
                weakSelf.backgroundTask = UIBackgroundTaskInvalid;
            });
            
        });
    }
    
}

- (void)applicationWillEnterForeground {
    
    if(self.backgroundTask != UIBackgroundTaskInvalid) {
        [[UIApplication sharedApplication] endBackgroundTask:self.backgroundTask];
        self.backgroundTask = UIBackgroundTaskInvalid;
    }
    
}

@end
