//
//  RSOSProfileDetailsVC.m
//  Emergency Reference Application
//
//  Created by Chris Lin on 11/29/17.
//  Copyright © 2017 RapidSOS. All rights reserved.
//

#import "RSOSProfileDetailsVC.h"
#import "RSOSDataUserManager.h"

#import "RSOSGlobalController.h"
#import "RSOSUtils.h"
#import "RSOSUtilsImage.h"
#import "RSOSUIPhoneTextField.h"
#import "RSOSFadeTransitionDelegate.h"
#import "RSOSDatePickerDialogVC.h"

@interface RSOSProfileDetailsVC () <UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, RSOSDatePickerDelegate>

// Photo
@property (weak, nonatomic) IBOutlet UIImageView *imagePhoto;

// Demographics

@property (weak, nonatomic) IBOutlet UIView *viewGender;
@property (weak, nonatomic) IBOutlet UIView *viewLanguage;
@property (weak, nonatomic) IBOutlet UIView *viewFeet;
@property (weak, nonatomic) IBOutlet UIView *viewInches;
@property (weak, nonatomic) IBOutlet UIView *viewName;
@property (weak, nonatomic) IBOutlet UIView *viewEthnicity;
@property (weak, nonatomic) IBOutlet UIView *viewWeight;
@property (weak, nonatomic) IBOutlet UIView *viewOccupation;

@property (weak, nonatomic) IBOutlet UITextField *textfieldGender;
@property (weak, nonatomic) IBOutlet UITextField *textfieldLanguage;
@property (weak, nonatomic) IBOutlet UITextField *textfieldFeet;
@property (weak, nonatomic) IBOutlet UITextField *textfieldInches;
@property (weak, nonatomic) IBOutlet UITextField *textfieldName;
@property (weak, nonatomic) IBOutlet UITextField *textfieldEthnicity;
@property (weak, nonatomic) IBOutlet UITextField *textfieldWeight;
@property (weak, nonatomic) IBOutlet UITextField *textfieldOccupation;

@property (weak, nonatomic) IBOutlet UIButton *buttonBirthday;

// Contact Information

@property (weak, nonatomic) IBOutlet UIView *viewContactType;
@property (weak, nonatomic) IBOutlet UIView *viewContactPhoneNumber;
@property (weak, nonatomic) IBOutlet UIView *viewEmail;

@property (weak, nonatomic) IBOutlet UITextField *textfieldContactType;
@property (weak, nonatomic) IBOutlet RSOSUIPhoneTextField *textfieldPhoneNumber;
@property (weak, nonatomic) IBOutlet UITextField *textfieldEmail;

// Address

@property (weak, nonatomic) IBOutlet UIView *viewAddressLabel;
@property (weak, nonatomic) IBOutlet UIView *viewAddress;
@property (weak, nonatomic) IBOutlet UIView *viewLocality;
@property (weak, nonatomic) IBOutlet UIView *viewPostalCode;
@property (weak, nonatomic) IBOutlet UIView *viewRegion;
@property (weak, nonatomic) IBOutlet UIView *viewCountry;

@property (weak, nonatomic) IBOutlet UITextField *textfieldAddressLabel;
@property (weak, nonatomic) IBOutlet UITextField *textfieldAddress;
@property (weak, nonatomic) IBOutlet UITextField *textfieldLocality;
@property (weak, nonatomic) IBOutlet UITextField *textfieldPostalCode;
@property (weak, nonatomic) IBOutlet UITextField *textfieldRegion;
@property (weak, nonatomic) IBOutlet UITextField *textfieldCountry;

// Health Data

@property (weak, nonatomic) IBOutlet UIView *viewBloodType;
@property (weak, nonatomic) IBOutlet UIView *viewAllergies;
@property (weak, nonatomic) IBOutlet UIView *viewMedicalCondition;
@property (weak, nonatomic) IBOutlet UIView *viewDisabilities;
@property (weak, nonatomic) IBOutlet UIView *viewMedications;
@property (weak, nonatomic) IBOutlet UIView *viewMedicalNotes;

@property (weak, nonatomic) IBOutlet UITextField *textfieldBloodType;
@property (weak, nonatomic) IBOutlet UITextField *textfieldAllergies;
@property (weak, nonatomic) IBOutlet UITextField *textfieldMedicalConditions;
@property (weak, nonatomic) IBOutlet UITextField *textfieldDisabilities;
@property (weak, nonatomic) IBOutlet UITextField *textfieldMedications;
@property (weak, nonatomic) IBOutlet UITextField *textfieldMedicalNotes;

// Selected Values

@property (assign, atomic) RSOSDataGender enumGender;
@property (assign, atomic) int indexLanguage;
@property (assign, atomic) int indexBloodType;
@property (strong, nonatomic) NSDate *dateBirthday;

@property (strong, nonatomic) UIImage *imgProfilePhoto;
@property (strong, nonatomic) RSOSFadeTransitionDelegate *transController;

@end

@implementation RSOSProfileDetailsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.imgProfilePhoto = nil;
    self.enumGender = RSOSDataGenderNone;
    self.indexLanguage = -1;
    self.indexBloodType = -1;
    self.dateBirthday = nil;
    self.transController = [[RSOSFadeTransitionDelegate alloc] init];
    
    [self refreshFields];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews {
    [self.imagePhoto.superview layoutIfNeeded];
    
    float width = self.imagePhoto.frame.size.width;
    self.imagePhoto.layer.cornerRadius = width / 2;
    self.imagePhoto.clipsToBounds = YES;
    self.imagePhoto.layer.borderColor = [UIColor whiteColor].CGColor;
    self.imagePhoto.layer.borderWidth = 2;
}

- (void) refreshFields {
    
    RSOSDataUserManager *managerUser = [RSOSDataUserManager sharedInstance];
    if (managerUser.modelProfile == nil) return;
    RSOSDataUserProfile *profile = managerUser.modelProfile;
    
    // Photo
    
    if(self.imgProfilePhoto != nil) {
        
        // use edited profile photo
        
        self.imagePhoto.image = self.imgProfilePhoto;
    }
    else {
        
        // load saved profile photo
        
        if ([profile.photo isSet] == YES) {
            [[RSOSDataUserManager sharedInstance] downloadProfileImageWithCallback:^(RSOSResponseStatusDataModel * _Nonnull status, UIImage * _Nullable image) {
                
                if([status isSuccess]) {
                    
                    UIImage *croppedImage = [RSOSUtilsImage scaleAndRotateImage:image maxResolution:320];
                    [self.imagePhoto setImage:croppedImage];
                }
                else {
                    [self.imagePhoto setImage:[UIImage imageNamed:@"user-nophoto"]];
                }
                
            }];
        }
    }
    
    // Name
    if ([profile.fullName isSet] == YES) {
        self.textfieldName.text = [profile.fullName getPrimaryValue];
    }
    else {
        self.textfieldName.text = @"";
    }
    
    // Birthday
    if ([profile.birthday isSet] == YES) {
        self.dateBirthday = [profile.birthday getPrimaryValue];
        [self.buttonBirthday setTitle:[NSString stringWithFormat: @"Birthday: %@", [RSOSUtilsDate getFormattedDateStringFromDateTime:self.dateBirthday]] forState:UIControlStateNormal];
    }
    else {
        [self.buttonBirthday setTitle:@"Birthday: N/A" forState:UIControlStateNormal];
    }
    
    // Address
    RSOSDataAddress *address = nil;
    if ([profile.addresses isSet] == YES) {
        address = [profile.addresses getPrimaryValue];
    }
    if (address != nil) {
        self.textfieldAddressLabel.text = address.label;
        self.textfieldAddress.text = address.streetAddress;
        self.textfieldLocality.text = address.locality;
        self.textfieldPostalCode.text = address.postalCode;
        self.textfieldRegion.text = address.region;
        self.textfieldCountry.text = address.countryCode;
    }
    
    // Demographics
    if ([profile.gender isSet] == YES) {
        self.enumGender = [RSOSUtils getGenderFromString:[profile.gender getPrimaryValue]];
        self.textfieldGender.text = [RSOSUtils getStringFromGender:self.enumGender];
    }
    else {
        self.textfieldGender.text = @"Gender";
    }
    if ([profile.ethnicity isSet] == YES) {
        self.textfieldEthnicity.text = [profile.ethnicity getPrimaryValue];
    }
    else {
        self.textfieldEthnicity.text = @"";
    }
    if ([profile.weight isSet] == YES) {
        self.textfieldWeight.text = [NSString stringWithFormat:@"%d", [[profile.weight getPrimaryValue] intValue]];
    }
    else {
        self.textfieldWeight.text = @"";
    }
    if ([profile.height isSet] == YES) {
        int height = [[profile.height getPrimaryValue] intValue];
        self.textfieldFeet.text = [NSString stringWithFormat:@"%d", height / 12];
        self.textfieldInches.text = [NSString stringWithFormat:@"%d", height % 12];
    }
    else {
        self.textfieldFeet.text = @"";
        self.textfieldInches.text = @"";
    }
    if ([profile.languages isSet] == YES) {
        RSOSDataLanguage *language = [profile.languages getPrimaryValue];
        if (language != nil) {
            self.indexLanguage = [[RSOSUtils sharedInstance] getIndexForLanguageCode:language.languageCode];
            self.textfieldLanguage.text = [[[RSOSUtils sharedInstance] getLanguageDisplayNamesArray] objectAtIndex:self.indexLanguage];
        }
        else {
            self.textfieldLanguage.text = @"Language";
        }
    }
    else {
        self.textfieldLanguage.text = @"Language";
    }
    if ([profile.occupation isSet] == YES) {
        self.textfieldOccupation.text = [profile.occupation getPrimaryValue];
    }
    else {
        self.textfieldOccupation.text = @"";
    }
    
    // Contact Information
    if ([profile.phoneNumbers isSet] == YES) {
        RSOSDataPhoneNumber *phone = [profile.phoneNumbers getPrimaryValue];
        if (phone != nil) {
            self.textfieldContactType.text = phone.label;
            self.textfieldPhoneNumber.text = [RSOSUtilsString beautifyPhoneNumber:phone.phoneNumber countryCode:@""];
        }
        else {
            self.textfieldContactType.text = @"";
            self.textfieldPhoneNumber.text = @"";
        }
    }
    else {
        self.textfieldContactType.text = @"";
        self.textfieldPhoneNumber.text = @"";
    }
    if ([profile.emails isSet] == YES) {
        RSOSDataEmail *email = [profile.emails getPrimaryValue];
        if (email != nil) {
            self.textfieldEmail.text = email.emailAddress;
        }
        else {
            self.textfieldEmail.text = @"";
            
        }
    }
    else {
        self.textfieldEmail.text = @"";
    }
    
    // Health Data
    if ([profile.allergies isSet] == YES) {
        self.textfieldAllergies.text = [profile.allergies getPrimaryValue];
    }
    else {
        self.textfieldAllergies.text = @"";
    }
    if ([profile.medicalCondition isSet] == YES) {
        self.textfieldMedicalConditions.text = [profile.medicalCondition getPrimaryValue];
    }
    else {
        self.textfieldMedicalConditions.text = @"";
    }
    if ([profile.disability isSet] == YES) {
        self.textfieldDisabilities.text = [profile.disability getPrimaryValue];
    }
    else {
        self.textfieldDisabilities.text = @"";
    }
    if ([profile.medication isSet] == YES) {
        self.textfieldMedications.text = [profile.medication getPrimaryValue];
    }
    else {
        self.textfieldMedications.text = @"";
    }
    if ([profile.bloodType isSet] == YES) {
        self.textfieldBloodType.text = [profile.bloodType getPrimaryValue];
        self.indexBloodType = [[RSOSUtils sharedInstance] getIndexForBloodType:self.textfieldBloodType.text];
    }
    else {
        self.textfieldBloodType.text = @"Blood Type";
    }
    if ([profile.medicalNotes isSet] == YES) {
        self.textfieldMedicalNotes.text = [profile.medicalNotes getPrimaryValue];
    }
    else {
        self.textfieldMedicalNotes.text = @"";
    }
}

#pragma mark - Action

- (void) promptForProfileImage {
    UIAlertController *actionsheet = [UIAlertController alertControllerWithTitle:nil
                                                                         message:nil
                                                                  preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *actionLibrary = [UIAlertAction actionWithTitle:@"Pick image from library" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
        pickerController.delegate = self;
        pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        pickerController.allowsEditing = NO;
        [self presentViewController:pickerController animated:YES completion:nil];
    }];
    UIAlertAction *actionCamera = [UIAlertAction actionWithTitle:@"Take photo with camera" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
        pickerController.delegate = self;
        pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        pickerController.allowsEditing = NO;
        [self presentViewController:pickerController animated:YES completion:nil];
    }];
    
    [actionsheet addAction:actionCancel];
    [actionsheet addAction:actionCamera];
    [actionsheet addAction:actionLibrary];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:actionsheet animated:YES completion:nil];
    });
}

- (void) doSave {
    RSOSDataUserManager *managerUser = [RSOSDataUserManager sharedInstance];
    RSOSDataUserProfile *profile = [[RSOSDataUserProfile alloc] init];
    
    // Birthday
    if (self.dateBirthday == nil) {
        profile.birthday = managerUser.modelProfile.birthday;
    }
    else {
        if ([self.dateBirthday compare:[NSDate date]] != NSOrderedAscending) {
            [RSOSGlobalController showHudErrorWithMessage:@"Please select correct birthday" DismissAfter:-1 Callback:nil];
            return;
        }
        [profile.birthday setPrimaryValue:self.dateBirthday];
    }
    
    // Gender
    if (self.enumGender == RSOSDataGenderNone) {
        profile.gender = managerUser.modelProfile.gender;
    }
    else {
        [profile.gender setPrimaryValue:[RSOSUtils getStringFromGender:self.enumGender]];
    }
    
    // Language
    if (self.indexLanguage == -1) {
        profile.languages = managerUser.modelProfile.languages;
    }
    else {
        NSString *code = [[RSOSUtils sharedInstance] getLanguageCodeAtIndex:self.indexLanguage];
        RSOSDataLanguage *language = [[RSOSDataLanguage alloc] init];
        language.languageCode = code;
        language.preference = 0;
        [profile.languages setPrimaryValue:language];
    }
    
    // Height + Inches
    int height = [self.textfieldFeet.text intValue];
    int inches = [self.textfieldInches.text intValue];
    if (height <= 0 && inches <= 0) {
        profile.height = managerUser.modelProfile.height;
        self.textfieldFeet.text = @"";
        self.textfieldInches.text = @"";
    }
    else {
        int total_inches = height * 12 + inches;
        if (total_inches < 10 || total_inches > 100) {
            [RSOSGlobalController showHudErrorWithMessage:@"Please input valid height" DismissAfter:-1 Callback:nil];
            return;
        }
        [profile.height setPrimaryValue:@(total_inches)];
    }
    
    // Full name
    NSString *name = self.textfieldName.text;
    if (name.length == 0) {
        [RSOSGlobalController showHudErrorWithMessage:@"Please enter your name" DismissAfter:-1 Callback:nil];
        return;
    }
    else {
        [profile.fullName setPrimaryValue:name];
    }
    
    //Ethnicity
    NSString *ethnicity = self.textfieldEthnicity.text;
    if (ethnicity.length == 0) {
        profile.ethnicity = managerUser.modelProfile.ethnicity;
    }
    else {
        [profile.ethnicity setPrimaryValue:ethnicity];
    }
    
    // Weight
    int weight = [self.textfieldWeight.text intValue];
    if (weight <= 0) {
        profile.weight = managerUser.modelProfile.weight;
        self.textfieldWeight.text = @"";
    }
    else {
        if (weight < 80 || weight > 600) {
            [RSOSGlobalController showHudErrorWithMessage:@"Please input valid weight" DismissAfter:-1 Callback:nil];
            return;
        }
        [profile.weight setPrimaryValue:@(weight)];
    }
    
    // Occupation
    NSString *occupation = self.textfieldOccupation.text;
    if (occupation.length == 0) {
        profile.occupation = managerUser.modelProfile.occupation;
    }
    else {
        [profile.occupation setPrimaryValue:occupation];
    }
    
    // Phone Number
    
    NSString *type = self.textfieldContactType.text;
    NSString *phone = [RSOSUtilsString getValidPhoneNumber:self.textfieldPhoneNumber.text];
    
    if (phone.length == 0) {
        [RSOSGlobalController showHudErrorWithMessage:@"Please input valid phone number" DismissAfter:-1 Callback:nil];
        return;
    }
    
    RSOSDataPhoneNumber *phoneObject = [[RSOSDataPhoneNumber alloc] init];
    phoneObject.label = type;
    phoneObject.phoneNumber = [RSOSUtilsString normalizePhoneNumber:phone prefix:@"+"];
    [profile.phoneNumbers setPrimaryValue:phoneObject];

    // Email
    
    // remove trailing and leading whitespace
    
    self.textfieldEmail.text = [self.textfieldEmail.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSString *email = self.textfieldEmail.text;
    if (email.length == 0) {
        profile.emails = managerUser.modelProfile.emails;
    }
    else {
        if ([RSOSUtilsString isValidEmail:email] == NO) {
            [RSOSGlobalController showHudErrorWithMessage:@"Please input valid email address" DismissAfter:-1 Callback:nil];
            return;
        }
        
        RSOSDataEmail *emailObject = [[RSOSDataEmail alloc] init];
        emailObject.emailAddress = email;
        [profile.emails setPrimaryValue:emailObject];
    }
    
    // Address
    NSString *addressLabel = self.textfieldAddressLabel.text;
    NSString *address = self.textfieldAddress.text;
    NSString *locality = self.textfieldLocality.text;
    NSString *postalCode = self.textfieldPostalCode.text;
    NSString *region = self.textfieldRegion.text;
    NSString *countryCode = self.textfieldCountry.text;
    
    if (addressLabel.length == 0 &&
        addressLabel.length == 0 &&
        locality.length == 0 &&
        postalCode.length == 0 &&
        region.length == 0 &&
        countryCode.length == 0) {
        
        // clear address
        [profile.addresses deletePrimaryValue];
    }
    else {
        if (addressLabel.length == 0) {
            [RSOSGlobalController showHudErrorWithMessage:@"Please input address label" DismissAfter:-1 Callback:nil];
            return;
        }
        if (address.length == 0) {
            [RSOSGlobalController showHudErrorWithMessage:@"Please input address" DismissAfter:-1 Callback:nil];
            return;
        }
        if (locality.length == 0) {
            [RSOSGlobalController showHudErrorWithMessage:@"Please input locality" DismissAfter:-1 Callback:nil];
            return;
        }
        if (postalCode.length == 0) {
            [RSOSGlobalController showHudErrorWithMessage:@"Please input postal code" DismissAfter:-1 Callback:nil];
            return;
        }
        if (region.length == 0) {
            [RSOSGlobalController showHudErrorWithMessage:@"Please input region" DismissAfter:-1 Callback:nil];
            return;
        }
        if (countryCode.length == 0) {
            [RSOSGlobalController showHudErrorWithMessage:@"Please input country code" DismissAfter:-1 Callback:nil];
            return;
        }
        
        RSOSDataAddress *addressObject = [[RSOSDataAddress alloc] init];
        
        addressObject.label = addressLabel;
        addressObject.streetAddress = address;
        addressObject.locality = locality;
        addressObject.postalCode = postalCode;
        addressObject.region = region;
        addressObject.countryCode = countryCode;
        
        // validate address
        NSString *errorMsg = [addressObject validate];
        if(errorMsg) {
            [RSOSGlobalController showHudErrorWithMessage:errorMsg DismissAfter:-1 Callback:nil];
            return;
        }
        else {
            [profile.addresses setPrimaryValue:addressObject];
        }
    }
    
    // Blood Type
    if (self.indexBloodType == -1) {
        profile.bloodType = managerUser.modelProfile.bloodType;
    }
    else {
        [profile.bloodType setPrimaryValue:self.textfieldBloodType.text];
    }
    
    // Allergies
    NSString *allergies = self.textfieldAllergies.text;
    [profile.allergies setPrimaryValue:allergies];
    
    // Medical Condition
    NSString *medicalCondition = self.textfieldMedicalConditions.text;
    if (medicalCondition.length == 0) {
        profile.medicalCondition = managerUser.modelProfile.medicalCondition;
    }
    else {
        [profile.medicalCondition setPrimaryValue:medicalCondition];
    }
    
    // Disabilities
    NSString *disability = self.textfieldDisabilities.text;
    if (disability.length == 0) {
        profile.disability = managerUser.modelProfile.disability;
    }
    else {
        [profile.disability setPrimaryValue:disability];
    }
    
    // Medications
    NSString *medication = self.textfieldMedications.text;
    if (medication.length == 0) {
        profile.medication = managerUser.modelProfile.medication;
    }
    else {
        [profile.medication setPrimaryValue:medication];
    }
    
    // Medical Notes
    NSString *note = self.textfieldMedicalNotes.text;
    if (note.length == 0) {
        profile.medicalNotes = managerUser.modelProfile.medicalNotes;
    }
    else {
        [profile.medicalNotes setPrimaryValue:note];
    }
    
    // Contacts
    profile.emergencyContacts = managerUser.modelProfile.emergencyContacts;
    profile.photo = managerUser.modelProfile.photo;
    
    [self uploadProfilePhotoIfNeededWithCallback:^(NSString *photoUrlString, RSOSResponseStatusDataModel *status) {
        if ([status isSuccess] == NO) {
            return;
        }
        
        if ([status isSuccess] == YES && photoUrlString != nil) {
            RSOSDataPhoto *photoObject = [[RSOSDataPhoto alloc] init];
            photoObject.label = @"kronos_profile_pic";
            photoObject.url = photoUrlString;
            [profile.photo setPrimaryValue:photoObject];
        }
        
        // Request
        managerUser.modelProfile = profile;
        
        [RSOSGlobalController showHudProgressWithMessage:@"Please wait..."];
        [managerUser requestUpdateProfileWithCallback:^(RSOSResponseStatusDataModel *status) {
            if ([status isSuccess] == YES) {
                [RSOSGlobalController showHudSuccessWithMessage:@"Your profile has been updated successfully." DismissAfter:-1 Callback:^{
                    [self.navigationController popViewControllerAnimated:YES];
                }];
            }
            else {
                [RSOSGlobalController showHudErrorWithMessage:[status getErrorMessage] DismissAfter:-1 Callback:nil];
            }
        }];

    }];
}

- (void) uploadProfilePhotoIfNeededWithCallback:(void (^)(NSString *photoUrlString, RSOSResponseStatusDataModel *status)) callback {
    if (self.imgProfilePhoto == nil) {
        if (callback) {
            RSOSResponseStatusDataModel *status = [[RSOSResponseStatusDataModel alloc] init];
            status.status = RSOSHTTPResponseCodeOK;
            callback(nil, status);
        }
        return;
    }
    
    RSOSDataUserManager *managerUser = [RSOSDataUserManager sharedInstance];
    [RSOSGlobalController showHudProgressWithMessage:@"Uploading photo..."];
    [managerUser requestUploadPhoto:self.imgProfilePhoto callback:^(NSString *photoUrlString, RSOSResponseStatusDataModel *status) {
        if ([status isSuccess] == NO) {
            [RSOSGlobalController showHudErrorWithMessage:[status getErrorMessage] DismissAfter:-1 Callback:nil];
            if (callback) callback(photoUrlString, status);
        }
        else {
            [RSOSGlobalController hideHudProgressWithCallback:^{
                if (callback) callback(photoUrlString, status);
            }];
        }
    }];
}

#pragma mark - Popover

- (void) showPopoverForGender{
    __weak typeof(self) wSelf = self;
    [[RSOSGlobalController sharedInstance] showPopoverListVCWithItems:[[RSOSUtils sharedInstance] getGendersArray] ParentVC:self anchorView:self.viewGender SelectedIndex:self.enumGender Callback:^(int index, NSString *title) {
        __strong typeof(wSelf) sSelf = wSelf;
        sSelf.textfieldGender.text = title;
        sSelf.enumGender = index;
    }];
}

- (void) showPopoverForLanguage{
    __weak typeof(self) wSelf = self;
    [[RSOSGlobalController sharedInstance] showPopoverListVCWithItems:[[RSOSUtils sharedInstance] getLanguageDisplayNamesArray] ParentVC:self anchorView:self.viewLanguage SelectedIndex:self.indexLanguage Callback:^(int index, NSString *title) {
        __strong typeof(wSelf) sSelf = wSelf;
        sSelf.textfieldLanguage.text = title;
        sSelf.indexLanguage = index;
    }];
}

- (void) showPopoverForBloodType{
    __weak typeof(self) wSelf = self;
    [[RSOSGlobalController sharedInstance] showPopoverListVCWithItems:[[RSOSUtils sharedInstance] getBloodTypesArray] ParentVC:self anchorView:self.viewBloodType SelectedIndex:self.indexBloodType Callback:^(int index, NSString *title) {
        __strong typeof(wSelf) sSelf = wSelf;
        sSelf.textfieldBloodType.text = title;
        sSelf.indexBloodType = index;
    }];
}

- (void) showDialogForDoB{
    __weak typeof(self) wSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        
        __strong typeof(wSelf) sSelf = wSelf;
        
        RSOSDatePickerDialogVC *datePickerVC = [[RSOSDatePickerDialogVC alloc] initWithNibName:@"RSOSDatePickerDialogVC" bundle:nil];
        datePickerVC.view.backgroundColor = [UIColor clearColor];
        datePickerVC.transitioningDelegate = sSelf.transController;
        datePickerVC.modalPresentationStyle = UIModalPresentationCustom;
        datePickerVC.delegate = wSelf;
        
        if(sSelf.dateBirthday != nil) {
            datePickerVC.datePicker.date = sSelf.dateBirthday;
        }
        
        [sSelf presentViewController:datePickerVC animated:YES completion:^{
            
        }];
    });
}

#pragma mark - UIButton Event Listeners

- (IBAction)buttonPhotoClick:(id)sender {
    [self.view endEditing:YES];
    [self promptForProfileImage];
}

- (IBAction)buttonBirthdayClick:(id)sender {
    [self.view endEditing:YES];
    [self showDialogForDoB];
}

- (IBAction)buttonGenderClick:(id)sender {
    [self.view endEditing:YES];
    [self showPopoverForGender];
}

- (IBAction)buttonLanguageClick:(id)sender {
    [self.view endEditing:YES];
    [self showPopoverForLanguage];
}

- (IBAction)onButtonBloodTypeClick:(id)sender {
    [self.view endEditing:YES];
    [self showPopoverForBloodType];
}

- (IBAction)onButtonSaveClick:(id)sender {
    [self.view endEditing:YES];
    [self doSave];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    if (image == nil || [image isKindOfClass:[UIImage class]] == NO){
        [self dismissViewControllerAnimated:YES completion:nil];
        return;
    }
    
    self.imgProfilePhoto = [RSOSUtilsImage scaleAndRotateImage:image maxResolution:320];
    
    [self dismissViewControllerAnimated:YES completion:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.imagePhoto setImage:self.imgProfilePhoto];
        });
    }];
}

#pragma mark - RSOSDatePickerVC Delegate

- (void)datePickerController:(RSOSDatePickerDialogVC *)controller didSelectDate:(NSDate *)date {
    __weak typeof(self) wSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        __strong typeof(wSelf) sSelf = wSelf;
        sSelf.dateBirthday = date;
        [sSelf.buttonBirthday setTitle:[NSString stringWithFormat:@"Birthday: %@", [RSOSUtilsDate getFormattedDateStringFromDateTime:self.dateBirthday]] forState:UIControlStateNormal];
    });
}

@end
