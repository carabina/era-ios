//
//  RSOSLoginVC.m
//  Emergency Reference Application
//
//  Created by Chris Lin on 11/29/17.
//  Copyright © 2017 RapidSOS. All rights reserved.
//

#import "RSOSLoginVC.h"

#import "RSOSDataUserManager.h"

#import "RSOSGlobalController.h"
#import "RSOSAppManager.h"
#import "UIColor+RSOS.h"
#import <UIView+Shake.h>

@interface RSOSLoginVC () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *viewUsername;
@property (weak, nonatomic) IBOutlet UIView *viewPassword;

@property (weak, nonatomic) IBOutlet UITextField *textfieldUsername;
@property (weak, nonatomic) IBOutlet UITextField *textfieldPassword;

@property (weak, nonatomic) IBOutlet UIButton *buttonLogin;

@end

@implementation RSOSLoginVC

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
    self.buttonLogin.layer.borderWidth = 1;
    self.buttonLogin.layer.borderColor = [UIColor whiteColor].CGColor;
    
    self.textfieldUsername.delegate = self;
    self.textfieldPassword.delegate = self;
    
    [RSOSGlobalController setUITextField:self.textfieldUsername Placeholder:@"Username" PlaceholderColor:[UIColor RSOSTextfieldPlaceholderColorWhite]];
    [RSOSGlobalController setUITextField:self.textfieldPassword Placeholder:@"Password" PlaceholderColor:[UIColor RSOSTextfieldPlaceholderColorWhite]];
}

#pragma mark -Logic

- (BOOL) checkMandatoryFields {
    if (self.textfieldUsername.text.length == 0) {
        [RSOSGlobalController shakeView:self.viewUsername];
        return NO;
    }
    if (self.textfieldPassword.text.length == 0) {
        [RSOSGlobalController shakeView:self.viewPassword];
        return NO;
    }
    return YES;
}

- (void) doLogin {
    if ([self checkMandatoryFields] == NO) return;
    NSString *username = self.textfieldUsername.text;
    NSString *password = self.textfieldPassword.text;
    RSOSDataUserManager *managerUser = [RSOSDataUserManager sharedInstance];
    [RSOSGlobalController showHudProgressWithMessage:@"Please wait..."];
    
    [managerUser requestLoginWithUsername:username password:password callback:^(RSOSResponseStatusDataModel *status) {
        if ([status isSuccess] == YES) {
            [RSOSGlobalController hideHudProgressWithCallback:^{
                
                [[RSOSAppManager sharedInstance] initializeManagersAfterLogin];
                
                [self gotoVerifyPhoneVC];
            }];
        }
        else {
            [RSOSGlobalController showHudErrorWithMessage:[status getErrorMessage] DismissAfter:-1 Callback:nil];
        }
    }];
}

#pragma mark -Navigation

- (void) gotoRegisterVC {
    [RSOSGlobalController gotoSignupVC];
}

- (void) gotoForgotPasswordVC {
    [RSOSGlobalController gotoForgotPasswordVC];
}

- (void) gotoVerifyPhoneVC {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Login+Signup" bundle:nil];
        UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"STORYBOARD_VERIFICATION_PHONE"];
        [self.navigationController pushViewController:vc animated:YES];
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    });
}

#pragma mark -UIButton Event Listeners

- (IBAction)onButtonLoginClick:(id)sender {
    [self.viewPassword endEditing:YES];
    [self doLogin];
}

- (IBAction)onButtonRegisterClick:(id)sender {
    [self.view endEditing:YES];
    [self gotoRegisterVC];
}

- (IBAction)onButtonForgotPasswordClick:(id)sender {
    [self.view endEditing:YES];
    [self gotoForgotPasswordVC];
}

#pragma mark -UITextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

@end
