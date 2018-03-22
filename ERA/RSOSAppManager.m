//
//  RSOSAppManager.m
//  Emergency Reference Application
//
//  Created by Chris Lin on 12/1/17.
//  Copyright © 2017 RapidSOS. All rights reserved.
//

#import "RSOSAppManager.h"
#import "RSOSDataUserManager.h"
#import "RSOSLocationManager.h"
#import "RSOSFailSafeManager.h"
#import "RSOSUtils.h"
#import "AppConstants.h"
#import <IQKeyboardManager.h>
#import <RSOSData/RSOSData.h>

#import "RSOSGlobalController.h"

#import <UserNotifications/UserNotifications.h>

#import <PushKit/PushKit.h>


@implementation RSOSAppManager

+ (instancetype)sharedInstance {
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (id)init{
    if (self = [super init]) {
        [self initializeManagers];
    }
    return self;
}

- (void)initializeManagers {
}

- (void)initializeManagersAfterLaunch {
    IQKeyboardManager *sharedInstance = [IQKeyboardManager sharedManager];
    sharedInstance.shouldResignOnTouchOutside = YES;
    sharedInstance.keyboardDistanceFromTextField = 70;
    sharedInstance.enableAutoToolbar = NO;
    
    [[RSOSAuthManager sharedInstance] initializeManager];
    [RSOSAuthManager sharedInstance].baseURL = RSOS_BASE_URL;
    [RSOSAuthManager sharedInstance].clientID = RSOS_CONSTANTS_CLIENTID;
    [RSOSAuthManager sharedInstance].clientSecret = RSOS_CONSTANTS_CLIENTSECRET;
    
    [[RSOSDataUserManager sharedInstance] loadDeviceInfoFromLocalstorage];
    [[RSOSDataUserManager sharedInstance] loadProfileInfoFromLocalstorage];
    [[RSOSUtils sharedInstance] initializeManager];
    [[RSOSLocationManager sharedInstance] initializeManager];
    
    // clean up after partial login
    if([[RSOSDataUserManager sharedInstance] isLoggedIn]) {
        [self initializeManagersAfterLogin];
    }
    else {
        [[RSOSDataUserManager sharedInstance] logoutUser];
    }
}

- (void)initializeManagersAfterLogin {
    
    [[RSOSFailSafeManager sharedInstance] initializeManager];
    
    [self registerForRemoteNotificationsIfNeeded];
    
    [RSOSFailSafeManager sharedInstance].failSafeTriggeredHandler = ^(RSOSFailSafeManager * _Nonnull manager) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSURL *callURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", RSOS_CONSTANTS_FAILSAFE_NUMBER]];
            if([[UIApplication sharedApplication] canOpenURL:callURL]) {
                [[UIApplication sharedApplication] openURL:callURL
                                                   options:@{}
                                         completionHandler:^(BOOL success) {
                                             
                                             // reset failsafe
                                             [manager resetFailSafe];
                                         }];
            }
            else {
                
                // reset failsafe
                [manager resetFailSafe];
            }
            
            
        });
    };
}

- (void)initializeManagersAfterLogout{
    [[RSOSDataUserManager sharedInstance] logoutUser];
    
    [[RSOSAuthManager sharedInstance] initializeManager];
    [RSOSAuthManager sharedInstance].baseURL = RSOS_BASE_URL;
    [RSOSAuthManager sharedInstance].clientID = RSOS_CONSTANTS_CLIENTID;
    [RSOSAuthManager sharedInstance].clientSecret = RSOS_CONSTANTS_CLIENTSECRET;
}

- (void)registerForRemoteNotificationsIfNeeded {
    
    UNUserNotificationCenter* center = [UNUserNotificationCenter currentNotificationCenter];
    [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert)
                          completionHandler:^(BOOL granted, NSError * _Nullable error) {
                              
                              dispatch_async(dispatch_get_main_queue(), ^{
                                  [[UIApplication sharedApplication] registerForRemoteNotifications];
                              });
                              
                          }];
}

- (void)registerDeviceTokenForPhoneNumberIfPossible {
    
    if([self canRegisterDeviceToken]) {
        [[RSOSFailSafeManager sharedInstance] registerDeviceToken:self.deviceToken forPhoneNumber:[RSOSDataUserManager sharedInstance].phoneNumber];
    }
}

- (BOOL)canRegisterDeviceToken {
    return (self.deviceToken.length > 0 && [RSOSDataUserManager sharedInstance].phoneNumber.length > 0);
}


- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSLog(@"Registered for remote notifications");
    
    NSLog(@"%@", deviceToken.description);
    
    self.deviceToken = [deviceToken hexadecimalString];
    
    [self registerDeviceTokenForPhoneNumberIfPossible];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(nonnull NSError *)error {
    NSLog(@"Error registering for remote notifications: %@", error.localizedDescription);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(nonnull NSDictionary *)userInfo fetchCompletionHandler:(nonnull void (^)(UIBackgroundFetchResult))completionHandler {
    
    NSLog(@"Received remote notifictaion: %@", userInfo.description);
    
    NSString *action = userInfo[@"action"];
    
    if(action) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [[RSOSFailSafeManager sharedInstance] handleNotificationPayload:userInfo];
            
            completionHandler(UIBackgroundFetchResultNewData);
        });
        
        return;
    }
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    [[RSOSFailSafeManager sharedInstance] applicationDidEnterBackground];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [[RSOSFailSafeManager sharedInstance] applicationWillEnterForeground];
}

@end
