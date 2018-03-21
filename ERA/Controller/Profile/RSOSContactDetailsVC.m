//
//  RSOSContactDetailsVC.m
//  Emergency Reference Application
//
//  Created by Chris Lin on 11/29/17.
//  Copyright © 2017 RapidSOS. All rights reserved.
//

#import "RSOSContactDetailsVC.h"
#import "RSOSDataUserManager.h"
#import "AppConstants.h"
#import "RSOSGlobalController.h"
#import "RSOSUtils.h"
#import "RSOSUIPhoneTextField.h"

@interface RSOSContactDetailsVC () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *viewName;
@property (weak, nonatomic) IBOutlet UIView *viewPhone;
@property (weak, nonatomic) IBOutlet UIView *viewEmail;

@property (weak, nonatomic) IBOutlet UITextField *textfieldName;
@property (weak, nonatomic) IBOutlet RSOSUIPhoneTextField *textfieldPhone;
@property (weak, nonatomic) IBOutlet UITextField *textfieldEmail;

@property (weak, nonatomic) IBOutlet UIButton *buttonDelete;

@property (strong, nonatomic) RSOSDataEmergencyContact *contact;

@end

@implementation RSOSContactDetailsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupViews];
    [self refreshFields];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setupViews {
    self.textfieldName.delegate = self;
    self.textfieldPhone.delegate = self;
    self.textfieldEmail.delegate = self;
}

- (void) refreshFields {
    if (self.indexContact == -1) {
        self.buttonDelete.hidden = YES;
        self.contact = [[RSOSDataEmergencyContact alloc] init];
        self.navigationItem.title = @"New Contact";
    }
    else {
        RSOSDataUserManager *managerUser = [RSOSDataUserManager sharedInstance];
        self.contact = [managerUser.modelProfile.emergencyContacts.values objectAtIndex:self.indexContact];
        self.textfieldName.text = self.contact.fullName;
        self.textfieldPhone.text = [RSOSUtilsString beautifyPhoneNumber:self.contact.phoneNumber countryCode:@""];
        self.textfieldEmail.text = self.contact.emailAddress;
        self.navigationItem.title = @"Edit Contact";
    }
}

#pragma mark - Action

- (void) promptForDelete {
    [RSOSGlobalController promptWithVC:self Title:@"Warning!" Message:@"Are you sure you want to delete this contact?" ButtonYes:@"Yes" ButtonNo:@"No" CallbackYes:^{
        [self doDelete];
    } CallbackNo:nil];
}

- (BOOL) checkMandatoryFields {
    
    // trim leading and trailing whitespace from email address
    self.textfieldEmail.text = [self.textfieldEmail.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSString *name = self.textfieldName.text;
    NSString *phone = [RSOSUtilsString getValidPhoneNumber:self.textfieldPhone.text];
    NSString *email = self.textfieldEmail.text;
    
    if (name.length == 0) {
        [RSOSGlobalController showHudErrorWithMessage:@"Please input name" DismissAfter:-1 Callback:nil];
        return NO;
    }
    if (phone.length == 0) {
        [RSOSGlobalController showHudErrorWithMessage:@"Please input valid phone number" DismissAfter:-1 Callback:nil];
        return NO;
    }
    if (email.length == 0) {
        [RSOSGlobalController showHudErrorWithMessage:@"Please input email address" DismissAfter:-1 Callback:nil];
        return NO;
    }
    if ([RSOSUtilsString isValidEmail:email] == NO) {
        [RSOSGlobalController showHudErrorWithMessage:@"Please input valid email address" DismissAfter:-1 Callback:nil];
        return NO;
    }
    return YES;
}

- (void) doSave {
    
    if ([self checkMandatoryFields] == NO) return;
    RSOSDataUserManager *managerUser = [RSOSDataUserManager sharedInstance];
    
    self.contact.fullName = self.textfieldName.text;
    self.contact.phoneNumber = [RSOSUtilsString stripNonnumericsFromNSString:self.textfieldPhone.text];
    self.contact.emailAddress = self.textfieldEmail.text;
    
    if (self.indexContact == -1) {
        [managerUser.modelProfile.emergencyContacts addValue:self.contact];
    }
    else {
        [managerUser.modelProfile.emergencyContacts replaceValueAtIndex:self.indexContact withValue:self.contact];
    }
    
    [RSOSGlobalController showHudProgressWithMessage:@"Please wait..."];
    [managerUser requestUpdateProfileWithCallback:^(RSOSResponseStatusDataModel *status) {
        if ([status isSuccess] == YES) {
            NSString *message = @"Contact is updated successfully.";
            if (self.indexContact == -1) {
                message = @"New contact is added successfully.";
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:RSOSLOCALNOTIFICATION_CONTACTLIST_UPDATED object:nil];
            
            [RSOSGlobalController showHudSuccessWithMessage:message DismissAfter:-1 Callback:^{
                [self.navigationController popViewControllerAnimated:YES];
            }];
        }
        else {
            [RSOSGlobalController showHudErrorWithMessage:[status getErrorMessage] DismissAfter:-1 Callback:nil];
        }
    }];
}

- (void)doDelete {
    
    RSOSDataUserManager *managerUser = [RSOSDataUserManager sharedInstance];
    [managerUser.modelProfile.emergencyContacts deleteValueAtIndex:self.indexContact];
    
    [RSOSGlobalController showHudProgressWithMessage:@"Please wait..."];
    
    [managerUser requestUpdateProfileWithCallback:^(RSOSResponseStatusDataModel *status) {
        
        if ([status isSuccess] == YES) {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:RSOSLOCALNOTIFICATION_CONTACTLIST_UPDATED object:nil];
            
            [RSOSGlobalController showHudSuccessWithMessage:@"Contact is removed successfully." DismissAfter:-1 Callback:^{
                [self.navigationController popViewControllerAnimated:YES];
            }];
        }
        else {
            [RSOSGlobalController showHudErrorWithMessage:[status getErrorMessage] DismissAfter:-1 Callback:nil];
        }
    }];
}

#pragma mark - UIButton Event Listeners

- (IBAction)onButtonDeleteClick:(id)sender {
    [self.view endEditing:YES];
    [self promptForDelete];
}

- (IBAction)onButtonSaveClick:(id)sender {
    [self.view endEditing:YES];
    [self doSave];
}

#pragma mark - UITextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

@end
