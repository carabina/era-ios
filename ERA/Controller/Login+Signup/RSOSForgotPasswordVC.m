//
//  RSOSForgotPasswordVC.m
//  Emergency Reference Application
//
//  Created by Chris Lin on 11/29/17.
//  Copyright © 2017 RapidSOS. All rights reserved.
//

#import "RSOSForgotPasswordVC.h"

#import "RSOSGlobalController.h"
#import "RSOSDataUserManager.h"

#import "UIColor+RSOS.h"
#import <UIView+Shake.h>

#import <RSOSData.h>

@interface RSOSForgotPasswordVC () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *viewEmail;
@property (weak, nonatomic) IBOutlet UITextField *textfieldEmail;
@property (weak, nonatomic) IBOutlet UIButton *buttonReset;

@end

@implementation RSOSForgotPasswordVC

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
    self.buttonReset.layer.borderWidth = 1;
    self.buttonReset.layer.borderColor = [UIColor whiteColor].CGColor;
    
    self.textfieldEmail.delegate = self;
    [RSOSGlobalController setUITextField:self.textfieldEmail Placeholder:@"Email address" PlaceholderColor:[UIColor RSOSTextfieldPlaceholderColorWhite]];
}

#pragma mark -Logic

- (BOOL) checkMandatoryFields {
    NSString *email = self.textfieldEmail.text;
    if (email.length == 0 || [RSOSUtilsString isValidEmail:email] == NO) {
        [RSOSGlobalController shakeView:self.viewEmail];
        return NO;
    }
    return YES;
}

- (void) doReset {
    if ([self checkMandatoryFields] == NO) return;
    NSString *email = self.textfieldEmail.text;
    RSOSDataUserManager *managerUser = [RSOSDataUserManager sharedInstance];
    [RSOSGlobalController showHudProgressWithMessage:@"Please wait..."];
    
    [managerUser requestPasswordResetWithEmail:email callback:^(RSOSResponseStatusDataModel *status) {
        if ([status isSuccess] == YES) {
            [RSOSGlobalController showHudSuccessWithMessage:@"Email instructions should be sent in a moment." DismissAfter:-1 Callback:nil];
        }
        else {
            [RSOSGlobalController showHudErrorWithMessage:[status getErrorMessage] DismissAfter:-1 Callback:nil];
        }
    }];
}

#pragma mark -Navigation

- (void) gotoLoginVC {
    [RSOSGlobalController gotoLoginVC];
}

- (void) gotoRegisterVC {
    [RSOSGlobalController gotoSignupVC];
}

#pragma mark -UIButton Event Listeners

- (IBAction)onButtonResetClick:(id)sender {
    [self.view endEditing:YES];
    [self doReset];
}

- (IBAction)onButtonLoginClick:(id)sender {
    [self.view endEditing:YES];
    [self gotoLoginVC];
}

- (IBAction)onButtonRegisterClick:(id)sender {
    [self.view endEditing:YES];
    [self gotoRegisterVC];
}

#pragma mark -UITextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

@end
