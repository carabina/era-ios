//
//  RSOSGlobalController.m
//  Emergency Reference Application
//
//  Created by Chris Lin on 11/29/17.
//  Copyright © 2017 RapidSOS. All rights reserved.
//

#import "RSOSGlobalController.h"
#import "RSOSListPopoverVC.h"
#import "RSOSLoginVC.h"
#import "RSOSSignupVC.h"
#import "RSOSForgotPasswordVC.h"
#import "AppDelegate.h"
#import <SVProgressHUD.h>
#import <UIView+Shake.h>

#define SVPROGRESSHUD_DISMISSAFTER_DEFAULT                      3

@interface RSOSGlobalController () <RSOSListPopoverVCDelegate, UIPopoverPresentationControllerDelegate>

@property (strong, nonatomic) RSOSListPopoverVC *vcPopoverList;
@property (copy, nonatomic) RSOSPopoverListItemSelectionHandler callbackForPopover;

@end

@implementation RSOSGlobalController

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

- (void) initializeManager{
}

#pragma mark - Navigation

+ (void) logout {
    dispatch_async(dispatch_get_main_queue(), ^{
        UINavigationController *nav = (UINavigationController *) [[(AppDelegate *) [[UIApplication sharedApplication] delegate] window] rootViewController];
        if ([nav isKindOfClass:[UINavigationController class]] == NO) return;
        
        UIViewController *vcLast = [nav.viewControllers lastObject];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Login+Signup" bundle:nil];
        UIViewController *vcLogin = [storyboard instantiateViewControllerWithIdentifier:@"STORYBOARD_LOGIN"];
        [nav setViewControllers:@[vcLogin, vcLast]];
        [nav popViewControllerAnimated:YES];
    });
}

+ (void) gotoLoginVC {
    dispatch_async(dispatch_get_main_queue(), ^{
        UINavigationController *nav = (UINavigationController *) [[(AppDelegate *) [[UIApplication sharedApplication] delegate] window] rootViewController];
        if ([nav isKindOfClass:[UINavigationController class]] == NO) return;
        
        NSArray <UIViewController *> *arrayVCs = nav.viewControllers;
        for (UIViewController *vc in arrayVCs) {
            if ([vc isKindOfClass:[RSOSLoginVC class]] == YES) {
                [nav popToViewController:vc animated:YES];
                return;
            }
        }
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Login+Signup" bundle:nil];
        UIViewController *vcLogin = [storyboard instantiateViewControllerWithIdentifier:@"STORYBOARD_LOGIN"];
        [nav pushViewController:vcLogin animated:YES];
    });
}

+ (void) gotoSignupVC {
    dispatch_async(dispatch_get_main_queue(), ^{
        UINavigationController *nav = (UINavigationController *) [[(AppDelegate *) [[UIApplication sharedApplication] delegate] window] rootViewController];
        if ([nav isKindOfClass:[UINavigationController class]] == NO) return;
        
        NSArray <UIViewController *> *arrayVCs = nav.viewControllers;
        for (UIViewController *vc in arrayVCs) {
            if ([vc isKindOfClass:[RSOSSignupVC class]] == YES) {
                [nav popToViewController:vc animated:YES];
                return;
            }
        }
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Login+Signup" bundle:nil];
        UIViewController *vcSignup = [storyboard instantiateViewControllerWithIdentifier:@"STORYBOARD_SIGNUP"];
        [nav pushViewController:vcSignup animated:YES];
    });
}

+ (void) gotoForgotPasswordVC {
    dispatch_async(dispatch_get_main_queue(), ^{
        UINavigationController *nav = (UINavigationController *) [[(AppDelegate *) [[UIApplication sharedApplication] delegate] window] rootViewController];
        if ([nav isKindOfClass:[UINavigationController class]] == NO) return;
        
        NSArray <UIViewController *> *arrayVCs = nav.viewControllers;
        for (UIViewController *vc in arrayVCs) {
            if ([vc isKindOfClass:[RSOSForgotPasswordVC class]] == YES) {
                [nav popToViewController:vc animated:YES];
                return;
            }
        }
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Login+Signup" bundle:nil];
        UIViewController *vcForgotPassword = [storyboard instantiateViewControllerWithIdentifier:@"STORYBOARD_FORGOTPASSWORD"];
        [nav pushViewController:vcForgotPassword animated:YES];
    });
}

#pragma mark - Popover

- (void) showPopoverListVCWithItems: (NSArray *) items ParentVC: (UIViewController *) parentVC anchorView: (UIView *) anchorView SelectedIndex: (int) indexSelected Callback: (RSOSPopoverListItemSelectionHandler) callback{
    CGRect anchorFrame = anchorView.bounds;
    self.vcPopoverList = [[RSOSListPopoverVC alloc] initWithNibName:@"ListPopover" bundle:nil];
    self.vcPopoverList.arrItems = items;
    
    self.vcPopoverList.modalPresentationStyle = UIModalPresentationPopover;
    self.vcPopoverList.popoverPresentationController.sourceView = anchorView;
    self.vcPopoverList.popoverPresentationController.sourceRect = anchorFrame;
    self.vcPopoverList.preferredContentSize = [self.vcPopoverList calculateBestFrameSize];
    self.vcPopoverList.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionAny;
    self.vcPopoverList.popoverPresentationController.backgroundColor = [UIColor whiteColor];
    self.vcPopoverList.delegate = self;
    self.vcPopoverList.popoverPresentationController.delegate = self;
    
    self.vcPopoverList.indexSelected = indexSelected;
    self.callbackForPopover = callback;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [parentVC presentViewController:self.vcPopoverList animated:YES completion:nil];
    });
}

- (void) popoverListVC:(RSOSListPopoverVC *) vc didListItemSelected:(NSString *) title AtIndex:(int) index{
    __weak typeof(self) wSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.vcPopoverList dismissViewControllerAnimated:YES completion:^{
            wSelf.vcPopoverList = nil;
        }];
    });
    
    if (self.callbackForPopover){
        self.callbackForPopover(index, title);
        self.callbackForPopover = nil;
    }
}

- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller{
    return UIModalPresentationNone;
}

#pragma mark - Utils

+ (void) setUITextField: (UITextField *) textField Placeholder: (NSString *) placeholder PlaceholderColor: (UIColor *) color {
    if ([textField respondsToSelector:@selector(setAttributedPlaceholder:)] == YES) {
        textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeholder attributes:@{NSForegroundColorAttributeName: color}];
    }
}

+ (UIViewController *)findBestViewControllerFromViewController:(UIViewController *)vc {
    if (vc.presentedViewController &&
        [vc.presentedViewController isKindOfClass:[UIAlertController class]] == NO) {
        return [RSOSGlobalController findBestViewControllerFromViewController:vc.presentedViewController];
    }
    else if ([vc isKindOfClass:[UISplitViewController class]]) {
        // Return right hand side
        UISplitViewController *svc = (UISplitViewController *)vc;
        if (svc.viewControllers.count > 0) {
            return [RSOSGlobalController findBestViewControllerFromViewController:svc.viewControllers.lastObject];
        }
        else {
            return vc;
        }
    }
    else if ([vc isKindOfClass:[UINavigationController class]]) {
        // Return top view
        UINavigationController *svc = (UINavigationController *)vc;
        if (svc.viewControllers.count > 0) {
            return [RSOSGlobalController findBestViewControllerFromViewController:svc.topViewController];
        }
        else {
            return vc;
        }
    }
    else if ([vc isKindOfClass:[UITabBarController class]]) {
        // Return visible view
        UITabBarController *svc = (UITabBarController *)vc;
        if (svc.viewControllers.count > 0) {
            return [RSOSGlobalController findBestViewControllerFromViewController:svc.selectedViewController];
        }
        else {
            return vc;
        }
    }
    
    // Unknown view controller type
    return vc;
}

+ (UIViewController *)getTopMostViewController {
    UIViewController *viewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    return [RSOSGlobalController findBestViewControllerFromViewController:viewController];
}

#pragma mark - Animations

+ (void) shakeView: (UIView *) view{
    dispatch_async(dispatch_get_main_queue(), ^{
        [view shake:6 withDelta:8 speed:0.07];
    });
}

+ (void) shakeView: (UIView *) view InScrollView: (UIScrollView *) scrollView{
    BOOL isVisible = CGRectIntersectsRect(scrollView.bounds, view.frame);
    if (isVisible == NO){
        CGRect rc = view.frame;
        CGPoint pt = rc.origin;
        pt.x = 0;
        pt.y -= 60;
        pt.y = MAX(0, pt.y);
        float maxOffsetY = scrollView.contentSize.height - scrollView.frame.size.height;
        pt.y = MIN(pt.y, maxOffsetY);
        
        [scrollView setContentOffset:pt animated:YES];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [view shake:6 withDelta:8 speed:0.07];
        });
    }
    else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [view shake:6 withDelta:8 speed:0.07];
        });
    }
}

#pragma mark -UI

+ (void)showAlertControllerWithVC: (UIViewController *) vc Title:(NSString *)title Message:(NSString *)message Callback: (void (^)(void)) callback {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (callback) callback();
    }];
    [alertController addAction:actionOk];
    dispatch_async(dispatch_get_main_queue(), ^{
        [vc presentViewController:alertController animated:YES completion:nil];
    });
}

+ (void) promptWithVC: (UIViewController *) vc Title: (NSString *) title Message: (NSString *) message ButtonYes: (NSString *) buttonYes ButtonNo: (NSString *) buttonNo CallbackYes: (void (^)(void)) callbackYes CallbackNo: (void (^)(void)) callbackNo{
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:title
                                          message:message
                                          preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *actionDelete = [UIAlertAction
                                   actionWithTitle:buttonYes
                                   style:UIAlertActionStyleDestructive
                                   handler:^(UIAlertAction *action)
                                   {
                                       if (callbackYes) callbackYes();
                                   }];
    [alertController addAction:actionDelete];
    
    if (buttonNo != nil){
        UIAlertAction *actionCancel = [UIAlertAction
                                       actionWithTitle:buttonNo
                                       style:UIAlertActionStyleCancel
                                       handler:^(UIAlertAction *action)
                                       {
                                           if (callbackNo) callbackNo();
                                       }];
        
        [alertController addAction:actionCancel];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [vc presentViewController:alertController animated:YES completion:nil];
    });
}

#pragma mark - ProgressHUD

+ (void) showHudProgress{
    dispatch_async(dispatch_get_main_queue(), ^{
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
        [SVProgressHUD show];
    });
}

+ (void) showHudProgressWithMessage: (NSString *) message{
    dispatch_async(dispatch_get_main_queue(), ^{
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
        [SVProgressHUD showWithStatus:message];
    });
}

+ (void) showHudInfoWithMessage: (NSString *) message DismissAfter: (int) delay Callback: (void (^)(void)) callback{
    if (delay == -1) delay = SVPROGRESSHUD_DISMISSAFTER_DEFAULT;
    dispatch_async(dispatch_get_main_queue(), ^{
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
        [SVProgressHUD showInfoWithStatus:message];
        [SVProgressHUD dismissWithDelay:delay completion:callback];
    });
}

+ (void) showHudSuccessWithMessage: (NSString *) message DismissAfter: (int) delay Callback: (void (^)(void)) callback{
    if (delay == -1) delay = SVPROGRESSHUD_DISMISSAFTER_DEFAULT;
    dispatch_async(dispatch_get_main_queue(), ^{
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
        [SVProgressHUD showSuccessWithStatus:message];
        [SVProgressHUD dismissWithDelay:delay completion:callback];
    });
}

+ (void) showHudErrorWithMessage: (NSString *) message DismissAfter: (int) delay Callback: (void (^)(void)) callback{
    if (delay == -1) delay = SVPROGRESSHUD_DISMISSAFTER_DEFAULT;
    dispatch_async(dispatch_get_main_queue(), ^{
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
        [SVProgressHUD showErrorWithStatus:message];
        [SVProgressHUD dismissWithDelay:delay completion:callback];
    });
}

+ (void) hideHudProgress{
    dispatch_async(dispatch_get_main_queue(), ^{
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
        [SVProgressHUD dismiss];
    });
}

+ (void) hideHudProgressWithCallback: (void (^)(void)) callback{
    dispatch_async(dispatch_get_main_queue(), ^{
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
        [SVProgressHUD dismissWithCompletion:callback];
    });
}

@end
