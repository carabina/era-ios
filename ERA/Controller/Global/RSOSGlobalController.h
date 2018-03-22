//
//  RSOSGlobalController.h
//  Emergency Reference Application
//
//  Created by Chris Lin on 11/29/17.
//  Copyright © 2017 RapidSOS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^RSOSPopoverListItemSelectionHandler)(int index, NSString *title);
typedef void (^RSOSPopoverCalendarSelectionHandler)(NSDate *dateSelected);

@interface RSOSGlobalController : NSObject

+ (instancetype) sharedInstance;
- (void) initializeManager;

#pragma mark - Navigation

+ (void) logout;
+ (void) gotoLoginVC;
+ (void) gotoSignupVC;
+ (void) gotoForgotPasswordVC;

#pragma mark - Popover

- (void) showPopoverListVCWithItems: (NSArray *) items ParentVC: (UIViewController *) parentVC anchorView: (UIView *) anchorView SelectedIndex: (int) indexSelected Callback: (RSOSPopoverListItemSelectionHandler) callback;

#pragma mark - Utils

+ (void) setUITextField: (UITextField *) textField Placeholder: (NSString *) placeholder PlaceholderColor: (UIColor *) color;
+ (UIViewController *)getTopMostViewController;
+ (void) showAlertControllerWithVC: (UIViewController *) vc Title:(NSString *)title Message:(NSString *)message Callback: (void (^)(void)) callback;
+ (void) promptWithVC: (UIViewController *) vc Title: (NSString *) title Message: (NSString *) message ButtonYes: (NSString *) buttonYes ButtonNo: (NSString *) buttonNo CallbackYes: (void (^)(void)) callbackYes CallbackNo: (void (^)(void)) callbackNo;

#pragma mark - Animations

+ (void) shakeView: (UIView *) view;
+ (void) shakeView: (UIView *) view InScrollView: (UIScrollView *) scrollView;

#pragma mark - ProgressHUD

+ (void) showHudProgress;
+ (void) showHudProgressWithMessage: (NSString *) message;
+ (void) showHudInfoWithMessage: (NSString *) message DismissAfter: (int) delay Callback: (void (^)(void)) callback;
+ (void) showHudSuccessWithMessage: (NSString *) message DismissAfter: (int) delay Callback: (void (^)(void)) callback;
+ (void) showHudErrorWithMessage: (NSString *) message DismissAfter: (int) delay Callback: (void (^)(void)) callback;
+ (void) hideHudProgress;
+ (void) hideHudProgressWithCallback: (void (^)(void)) callback;

@end
