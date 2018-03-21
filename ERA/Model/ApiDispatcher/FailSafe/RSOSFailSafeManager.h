//
//  RSOSFailSafeManager.h
//  EmergencyReferenceApp
//
//  Created by Gabe Mahoney on 1/18/18.
//  Copyright © 2018 RapidSOS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


/** @enum Current state of the failsafe manager.
 * `RSOSFailSafeStateInactive - Default state. Failsafe is inactive.
 * `RSOSFailSafeStateActive` - failsafe has been activated. The failsafe can be explicitly
 * triggered or de-activated. If neither happens before the timout interval elapses, the
 * failsafe will trigger.
 * `RSOSFailSafeStateTriggered` The failsafe has been triggered. When the failsafe trigger handler
 * has finished executing, it must call -resetFailSafe to reset the failsafe to the inactive state.
 */

typedef NS_ENUM(NSInteger,RSOSFailSafeState) {
    RSOSFailSafeStateInactive,
    RSOSFailSafeStateActive,
    RSOSFailSafeStateTriggered
};

@class RSOSFailSafeManager;

typedef void (^RSOSFailSafeTriggeredHandler)(RSOSFailSafeManager *manager);

@interface RSOSFailSafeManager : NSObject


/**
 * @abstract Flag indicating that the fail safe manager is enabled or disabled.
 * When the manager is disabled, activating and triggering the fail safe will have no effect
 */

@property (nonatomic,getter=isEnabled) BOOL enabled;

/**
 * @abstract Current state of the failsafe manager.
 */

@property (atomic,readonly) RSOSFailSafeState state;

/**
 * @abstract Timer that starts when the failsafe is activated. When the timer
 * has elapsed, the failSafeTriggeredHandler block will be executed
 */

@property (nonatomic,readonly,nullable) NSTimer *failSafeTimer;


// configurable properties

/**
 * @abstract Block that executes when the failSafeTimer has elapsed.
 * This block takes one parameter, the `RSOSFailSafeManager` which has
 * triggered the failsafe.
 * This block MUST call -resetFailSafe before it finishes executing.
 */

@property (nonatomic,copy,nullable) RSOSFailSafeTriggeredHandler failSafeTriggeredHandler;


/**
 * @abstract Timeout interval of the failsafe manager. After this time interval has
 * elapsed, the failSafeTriggeredHandler block will be executed
 */

@property (nonatomic) NSTimeInterval failSafeTimeOutInterval;

+ (instancetype)sharedInstance;
- (void)initializeManager;

/**
 * @abstract Put the failsafe in the Active state, allowing it to be triggered.
 * After the failSafeTimeOutInterval has elapsed, the failsafe will trigger, unless
 * it was already triggered or reset.
 * This is a no-op if the failsafe is in an Active or Triggered state
 */

- (void)activateFailsafe;

/**
 * @abstract Trigger the failsafe, causing the `failSafeTriggeredHandler` block to execute.
 * The manager will remain in the Triggered state until the block calls -resetFailSafe.
 */

- (void)triggerFailsafe;

/**
 * @abstract Reset the failsafe manager and put it in the Inactive state. When the manager
 * is in this state, it needs to be activated before it can be triggered.
 */

- (void)resetFailSafe;

/**
 * @abstract Register the user's device for remote notifications from the Emergency
 * Reference App back end. This will allow the back end to communicate with the device
 * in the event that something goes wrong during the call flow, or to acknowledge that
 * the call flow successfully executed.
 * @param deviceToken a hexadecimal string representation of the device token received
 * by APNS.
 * @param phoneNumber the phone number validated by the user
 */

- (void)registerDeviceToken:(NSString *)deviceToken forPhoneNumber:(NSString *)phoneNumber;

/**
 * @abstract parse and interpret push notifications sent by the Emergency Reference App
 * back end
 * @param payload the `userInfo` NSDictionary inclduded in the remote notification
 */

- (void)handleNotificationPayload:(NSDictionary *)payload;

/**
 * @abstract alert the Fail Safe Manager that the application has entered the background. If
 * the Manager state is Active, it will start a background task to listen for remote notifications
 * @note Alternatively, this could be done by listening for the UIApplicationDidEnterBackgroundNotification
 * notification
 */

- (void)applicationDidEnterBackground;

/**
 * @abstract alert the Fail Safe Manager that the application has entered the foreground. The Manager
 * will end any ongoing background tasks
 * @note Alternatively, this could be done by listening for the UIApplicationWillEnterForegroundNotification
 * notification
 */

- (void)applicationWillEnterForeground;

@end

NS_ASSUME_NONNULL_END
