//
//  RSOSVerificationCodeVC.m
//  Emergency Reference Application
//
//  Created by Chris Lin on 11/29/17.
//  Copyright © 2017 RapidSOS. All rights reserved.
//

#import "RSOSVerificationCodeVC.h"
#import "RSOSDataUserManager.h"

#import "RSOSGlobalController.h"
#import "UIColor+RSOS.h"
#import <UIView+Shake.h>

@interface RSOSVerificationCodeVC () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *viewCode;
@property (weak, nonatomic) IBOutlet UITextField *textfieldCode;
@property (weak, nonatomic) IBOutlet UIButton *buttonResend;

@end

@implementation RSOSVerificationCodeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setupViews {
    self.buttonResend.layer.borderColor = [UIColor RSOSMainColor].CGColor;
    self.buttonResend.layer.borderWidth = 1;

    self.textfieldCode.delegate = self;
}

#pragma mark -Navigation

- (void) gotoBack {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:YES];
    });
}

- (void) gotoHomeVC {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"STORYBOARD_MAIN_TABBARCONTROLLER"];
        [self.navigationController setViewControllers:@[vc] animated:YES];
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    });
}

#pragma mark -Logic

- (BOOL) checkMandatoryFields {
    if (self.textfieldCode.text.length == 0) {
        [RSOSGlobalController shakeView:self.viewCode];
        return NO;
    }
    return YES;
}

- (void) doVerifyPin {
    if ([self checkMandatoryFields] == NO) return;
    NSString *code = self.textfieldCode.text;
    
    [RSOSGlobalController showHudProgressWithMessage:@"Please wait"];
    [[RSOSDataUserManager sharedInstance] requestValidatePin:code callback:^(RSOSResponseStatusDataModel *status) {
        if ([status isSuccess] == YES) {
            [RSOSGlobalController hideHudProgressWithCallback:^{
                [self doLoadProfile];
            }];
        }
        else {
            [RSOSGlobalController showHudErrorWithMessage:[status getErrorMessage] DismissAfter:-1 Callback:nil];
        }
    }];
}

- (void) doLoadProfile {
    [RSOSGlobalController showHudProgressWithMessage:@"Please wait"];
    [[RSOSDataUserManager sharedInstance] requestProfileWithCallback:^(RSOSResponseStatusDataModel *status) {
        if ([status isSuccess] == YES) {
            [RSOSGlobalController hideHudProgressWithCallback:^{
                [self gotoHomeVC];
            }];
        }
        else {
            [RSOSGlobalController showHudErrorWithMessage:[status getErrorMessage] DismissAfter:-1 Callback:nil];
        }
    }];
}

- (void) doResendPin {
    RSOSDataUserManager *managerUser = [RSOSDataUserManager sharedInstance];
    NSString *phoneNumber = managerUser.phoneNumber;
    
    [RSOSGlobalController showHudProgressWithMessage:@"Please wait..."];
    [managerUser requestPinWithPhoneNumber:phoneNumber callback:^(RSOSResponseStatusDataModel *status) {
        if ([status isSuccess] == YES) {
            [RSOSGlobalController showHudSuccessWithMessage:@"Pin code should be sent in a moment." DismissAfter:-1 Callback:nil];
        }
        else {
            [RSOSGlobalController showHudErrorWithMessage:[status getErrorMessage] DismissAfter:-1 Callback:nil];
        }
    }];
}

#pragma mark -UIButton Event Listeners

- (IBAction)onButtonBackClick:(id)sender {
    [self.view endEditing:YES];
    [self gotoBack];
}

- (IBAction)onButtonContinueClick:(id)sender {
    [self.view endEditing:YES];
    [self doVerifyPin];
}

- (IBAction)onButtonResendClick:(id)sender {
    [self.view endEditing:YES];
    [self doResendPin];
}

#pragma mark -UITextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

@end
