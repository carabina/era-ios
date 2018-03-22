//
//  RSOSVerificationPhoneVC.m
//  Emergency Reference Application
//
//  Created by Chris Lin on 11/29/17.
//  Copyright © 2017 RapidSOS. All rights reserved.
//

#import "RSOSVerificationPhoneVC.h"
#import "RSOSDataUserManager.h"

#import "RSOSUtils.h"
#import "RSOSGlobalController.h"
#import "RSOSAgreementViewController.h"
#import "UIColor+RSOS.h"
#import <UIView+Shake.h>

@interface RSOSVerificationPhoneVC () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *viewPhone;
@property (weak, nonatomic) IBOutlet UITextField *textfieldPhone;

@property (nonatomic, weak) IBOutlet UILabel *termsConditionsLabel;
@property (nonatomic, weak) IBOutlet UIButton *termsConditionsButton;

@end

@implementation RSOSVerificationPhoneVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupViews];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.textfieldPhone becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setupViews {
    self.textfieldPhone.delegate = self;
    self.textfieldPhone.placeholder = @"(555) 555-5555";
    
    NSString *termsPrivacyText = @"By using ERA, you agree to the\nTerms of Use and Privacy Policy.";
    
    UIFont *regularFont = [UIFont systemFontOfSize:13];
    UIFont *boldFont = [UIFont boldSystemFontOfSize:13.0];
    
    NSMutableParagraphStyle *termsParagraphStyle = [[NSMutableParagraphStyle alloc] init];
    termsParagraphStyle.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attribs1 = @{
                               NSFontAttributeName: regularFont,
                               NSForegroundColorAttributeName: [UIColor blackColor],
                               NSParagraphStyleAttributeName:termsParagraphStyle
                               };
    
    NSDictionary *attribs2 = @{
                               NSFontAttributeName: boldFont,
                               NSForegroundColorAttributeName: [UIColor blackColor],
                               NSParagraphStyleAttributeName:termsParagraphStyle
                               };
    
    
    
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:termsPrivacyText attributes:attribs1];
    
    NSRange range1 = [termsPrivacyText rangeOfString:@"Terms of Use"];
    NSRange range2 = [termsPrivacyText rangeOfString:@"Privacy Policy"];
    [attributedText setAttributes:attribs2 range:range1];
    [attributedText setAttributes:attribs2 range:range2];
    
    self.termsConditionsLabel.attributedText = attributedText;
    
}

#pragma mark -Navigation

- (void) gotoBack {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:YES];
    });
}

- (void) gotoVerifyCodeVC {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Login+Signup" bundle:nil];
        UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"STORYBOARD_VERIFICATION_CODE"];
        [self.navigationController pushViewController:vc animated:YES];
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    });
}

- (void)goToTerms {
    
    RSOSAgreementViewController *termsController = [[UIStoryboard storyboardWithName:@"Login+Signup" bundle:nil] instantiateViewControllerWithIdentifier:@"RSOSAgreementViewController"];
    
    termsController.sourceURL = [[NSBundle mainBundle] URLForResource:@"terms" withExtension:@"txt"];
    termsController.docTitle = @"Terms of Use";
    
    [self.navigationController pushViewController:termsController animated:YES];
}

- (void)goToPrivacy {
    
    RSOSAgreementViewController *termsController = [[UIStoryboard storyboardWithName:@"Login+Signup" bundle:nil] instantiateViewControllerWithIdentifier:@"RSOSAgreementViewController"];
    
    termsController.sourceURL = [[NSBundle mainBundle] URLForResource:@"privacy" withExtension:@"txt"];
    termsController.docTitle = @"Privacy Policy";
    
    [self.navigationController pushViewController:termsController animated:YES];
}

#pragma mark -Logic

- (BOOL) checkMandatoryFields {
    NSString *phoneNumber = self.textfieldPhone.text;
    phoneNumber = [RSOSUtilsString getValidPhoneNumber:phoneNumber];
    if (phoneNumber.length == 0) {
        [RSOSGlobalController shakeView:self.viewPhone];
        return NO;
    }
    return YES;
}

- (void) doRequestPin {
    if ([self checkMandatoryFields] == NO) return;
    NSString *phoneNumber = self.textfieldPhone.text;
    phoneNumber = [RSOSUtilsString normalizePhoneNumber:phoneNumber prefix:@""];
    
    [RSOSGlobalController showHudProgressWithMessage:@"Please wait..."];
    [[RSOSDataUserManager sharedInstance] requestPinWithPhoneNumber:phoneNumber callback:^(RSOSResponseStatusDataModel *status) {
        if ([status isSuccess] == YES) {
            [RSOSGlobalController hideHudProgressWithCallback:^{
                [self gotoVerifyCodeVC];
            }];
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
    [self doRequestPin];
}

- (IBAction)onButtonTermsPrivacyClick:(id)sender {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *termsAction = [UIAlertAction actionWithTitle:@"Terms of Use" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self goToTerms];
    }];
    
    UIAlertAction *privacyAction = [UIAlertAction actionWithTitle:@"Privacy Policy" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self goToPrivacy];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alertController addAction:termsAction];
    [alertController addAction:privacyAction];
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}

#pragma mark -UITextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

@end
