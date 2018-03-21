//
//  RSOSAppManager.h
//  Emergency Reference Application
//
//  Created by Chris Lin on 12/1/17.
//  Copyright © 2017 RapidSOS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RSOSAppManager : NSObject

+ (instancetype) sharedInstance;

@property (nonatomic) NSString *deviceToken;


- (void)initializeManagersAfterLaunch;
- (void)initializeManagersAfterLogin;
- (void)initializeManagersAfterLogout;

- (void)registerDeviceTokenForPhoneNumberIfPossible;

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken;
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(nonnull NSError *)error;
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(nonnull NSDictionary *)userInfo fetchCompletionHandler:(nonnull void (^)(UIBackgroundFetchResult))completionHandler;

- (void)applicationDidEnterBackground:(UIApplication *)application;
- (void)applicationWillEnterForeground:(UIApplication *)application;

@end

NS_ASSUME_NONNULL_END
