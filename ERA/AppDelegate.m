//
//  AppDelegate.m
//  Emergency Reference Application
//
//  Created by Chris Lin on 11/29/17.
//  Copyright © 2017 RapidSOS. All rights reserved.
//

#import "AppDelegate.h"
#import "RSOSAppManager.h"
#import "RSOSDataUserManager.h"
#import "UIColor+RSOS.h"

#import "RSOSGlobalController.h"

#import "RSOSFailSafeManager.h"

#import "AppConstants.h"

#import <UserNotifications/UserNotifications.h>


@interface AppDelegate () <UNUserNotificationCenterDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [[UINavigationBar appearance] setBarTintColor:[UIColor RSOSMainColor]];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTranslucent:NO];
    [[UIBarButtonItem appearance] setTintColor:[UIColor whiteColor]];
    
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    [[UITabBar appearance] setTintColor:[UIColor RSOSMainColor]];
    
    [[RSOSAppManager sharedInstance] initializeManagersAfterLaunch];

    if ([[RSOSDataUserManager sharedInstance] isLoggedIn] == YES) {
        // Create main window
        self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *vc = [storyboard instantiateInitialViewController];
        self.window.rootViewController = vc;
        [self.window makeKeyAndVisible];
        return YES;
    }
    return YES;
}


 /**
  * Notify `AppManager` when the application enters the background and foreground
  */

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    [[RSOSAppManager sharedInstance] applicationDidEnterBackground:application];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    [[RSOSAppManager sharedInstance] applicationWillEnterForeground:application];
}


 /**
  * Notifications are handled by `RSOSAppManager`
  */

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    [[RSOSAppManager sharedInstance] application:application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(nonnull NSError *)error {
    
    [[RSOSAppManager sharedInstance] application:application didFailToRegisterForRemoteNotificationsWithError:error];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(nonnull NSDictionary *)userInfo fetchCompletionHandler:(nonnull void (^)(UIBackgroundFetchResult))completionHandler {
    
    [[RSOSAppManager sharedInstance] application:application didReceiveRemoteNotification:userInfo fetchCompletionHandler:completionHandler];
}


@end
