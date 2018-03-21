//
//  RSOSProfileSummaryVC.m
//  Emergency Reference Application
//
//  Created by Chris Lin on 11/29/17.
//  Copyright © 2017 RapidSOS. All rights reserved.
//

#import "RSOSProfileSummaryVC.h"
#import "RSOSDataUserManager.h"

#import "RSOSUtils.h"
#import "RSOSUtilsImage.h"
#import "UIColor+RSOS.h"
#import <UIImageView+AFNetworking.h>

@interface RSOSProfileSummaryVC ()

// Profile Photo

@property (weak, nonatomic) IBOutlet UILabel *labelName;
@property (weak, nonatomic) IBOutlet UILabel *labelBirthday;
@property (weak, nonatomic) IBOutlet UIImageView *imageProfilePhoto;

// Contacts

@property (weak, nonatomic) IBOutlet UIView *viewContacts;
@property (weak, nonatomic) IBOutlet UILabel *labelContactsCount;
@property (weak, nonatomic) IBOutlet UIButton *buttonEditContacts;

// Address

@property (weak, nonatomic) IBOutlet UIView *viewAddress;
@property (weak, nonatomic) IBOutlet UILabel *labelAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *labelAddress;
@property (weak, nonatomic) IBOutlet UILabel *labelLocality;
@property (weak, nonatomic) IBOutlet UILabel *labelRegion;
@property (weak, nonatomic) IBOutlet UILabel *labelPostalCode;
@property (weak, nonatomic) IBOutlet UILabel *labelCountryCode;

// Demographics

@property (weak, nonatomic) IBOutlet UIView *viewDemographics;
@property (weak, nonatomic) IBOutlet UILabel *labelGender;
@property (weak, nonatomic) IBOutlet UILabel *labelEthnicity;
@property (weak, nonatomic) IBOutlet UILabel *labelWeight;
@property (weak, nonatomic) IBOutlet UILabel *labelHeight;
@property (weak, nonatomic) IBOutlet UILabel *labelLanguage;
@property (weak, nonatomic) IBOutlet UILabel *labelOccupation;

// Contact Information

@property (weak, nonatomic) IBOutlet UIView *viewContactInformation;
@property (weak, nonatomic) IBOutlet UILabel *labelContactType1;
@property (weak, nonatomic) IBOutlet UILabel *labelContact1;
@property (weak, nonatomic) IBOutlet UILabel *labelContactType2;
@property (weak, nonatomic) IBOutlet UILabel *labelContact2;

// Health Data

@property (weak, nonatomic) IBOutlet UIView *viewHealthData;
@property (weak, nonatomic) IBOutlet UILabel *labelAllergies;
@property (weak, nonatomic) IBOutlet UILabel *labelMedicalCondition;
@property (weak, nonatomic) IBOutlet UILabel *labelDisabilities;
@property (weak, nonatomic) IBOutlet UILabel *labelMedications;
@property (weak, nonatomic) IBOutlet UILabel *labelBloodType;
@property (weak, nonatomic) IBOutlet UILabel *labelHealthNotes;

@property (assign, atomic) BOOL isShadowApplied;

@end

@implementation RSOSProfileSummaryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.isShadowApplied = NO;
    [self setupViews];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self refreshFields];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setupViews {
    self.viewContacts.layer.borderWidth = 1;
    self.viewContacts.layer.borderColor = [UIColor RSOSMainColor].CGColor;
    self.viewContacts.layer.cornerRadius = 3;
    
    self.buttonEditContacts.layer.borderWidth = 1;
    self.buttonEditContacts.layer.borderColor = [UIColor RSOSMainColor].CGColor;
    self.buttonEditContacts.layer.cornerRadius = 3;
    
    self.viewAddress.layer.borderWidth = 1;
    self.viewAddress.layer.borderColor = [UIColor RSOSMainColor].CGColor;
    self.viewAddress.layer.cornerRadius = 3;
    
    self.viewDemographics.layer.borderWidth = 1;
    self.viewDemographics.layer.borderColor = [UIColor RSOSMainColor].CGColor;
    self.viewDemographics.layer.cornerRadius = 3;
    
    self.viewContactInformation.layer.borderWidth = 1;
    self.viewContactInformation.layer.borderColor = [UIColor RSOSMainColor].CGColor;
    self.viewContactInformation.layer.cornerRadius = 3;
    
    self.viewHealthData.layer.borderWidth = 1;
    self.viewHealthData.layer.borderColor = [UIColor RSOSMainColor].CGColor;
    self.viewHealthData.layer.cornerRadius = 3;

    [self applyShadow:self.viewContacts];
}

- (void)viewDidLayoutSubviews {
    if (self.isShadowApplied == YES) return;
    self.isShadowApplied = YES;
    
    [self.viewContacts layoutIfNeeded];
    [self.viewAddress layoutIfNeeded];
    [self.viewDemographics layoutIfNeeded];
    [self.viewContactInformation layoutIfNeeded];
    [self.viewHealthData layoutIfNeeded];
    
    [self applyShadow:self.viewContacts];
    [self applyShadow:self.viewAddress];
    [self applyShadow:self.viewDemographics];
    [self applyShadow:self.viewContactInformation];
    [self applyShadow:self.viewHealthData];
    
    [self.imageProfilePhoto.superview layoutIfNeeded];
    
    float width = self.imageProfilePhoto.frame.size.width;
    self.imageProfilePhoto.layer.cornerRadius = width / 2;
    self.imageProfilePhoto.clipsToBounds = YES;
    self.imageProfilePhoto.layer.borderColor = [UIColor whiteColor].CGColor;
    self.imageProfilePhoto.layer.borderWidth = 2;
}

- (void) applyShadow: (UIView *) view {
    view.layer.shadowRadius = 1.5f;
    view.layer.shadowColor = [UIColor RSOSMainColor].CGColor;
    view.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    view.layer.shadowOpacity = 0.9f;
    view.clipsToBounds = YES;
    view.layer.masksToBounds = NO;
    
    UIEdgeInsets shadowInsets = UIEdgeInsetsMake(0, 0, -1.5f, 0);
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:UIEdgeInsetsInsetRect(view.bounds, shadowInsets)];
    view.layer.shadowPath = shadowPath.CGPath;
}

- (void) refreshFields {
    RSOSDataUserManager *managerUser = [RSOSDataUserManager sharedInstance];
    if (managerUser.modelProfile == nil) return;
    RSOSDataUserProfile *profile = managerUser.modelProfile;
    
    // Photo
    
    if ([profile.photo isSet] == YES) {
        [[RSOSDataUserManager sharedInstance] downloadProfileImageWithCallback:^(RSOSResponseStatusDataModel * _Nonnull status, UIImage * _Nullable image) {
            
            if([status isSuccess]) {
                
                UIImage *croppedImage = [RSOSUtilsImage scaleAndRotateImage:image maxResolution:320];
                [self.imageProfilePhoto setImage:croppedImage];
            }
            else {
                 [self.imageProfilePhoto setImage:[UIImage imageNamed:@"user-nophoto"]];
            }
            
        }];
    }
    else {
        [self.imageProfilePhoto setImage:[UIImage imageNamed:@"user-nophoto"]];
    }
    
    // Name
    if ([profile.fullName isSet] == YES) {
        self.labelName.text = [profile.fullName getPrimaryValue];
    }
    else {
        self.labelName.text = @"";
    }
    
    // Birthday
    if ([profile.birthday isSet] == YES) {
        self.labelBirthday.text = [RSOSUtilsDate getFormattedDateStringFromDateTime:[profile.birthday getPrimaryValue]];
    }
    else {
        self.labelBirthday.text = @"";
    }
    
    // Contacts
    if ([profile.emergencyContacts isSet] == YES) {
        int nContacts = (int) [profile.emergencyContacts.values count];
        if (nContacts > 0) {
            [self.buttonEditContacts setTitle:@"Edit Contacts" forState:UIControlStateNormal];
        }
        else {
            [self.buttonEditContacts setTitle:@"Add Contacts" forState:UIControlStateNormal];
        }
        self.labelContactsCount.text = [NSString stringWithFormat:@"%d", nContacts];
    }
    else {
        self.labelContactsCount.text = @"0";
        [self.buttonEditContacts setTitle:@"Add Contacts" forState:UIControlStateNormal];
    }
    
    // Address
    RSOSDataAddress *address = nil;
    if ([profile.addresses isSet] == YES) {
        address = [profile.addresses getPrimaryValue];
    }
    if (address != nil) {
        self.labelAddressLabel.text = address.label;
        self.labelAddress.text = address.streetAddress;
        self.labelLocality.text = address.locality;
        self.labelRegion.text = address.region;
        self.labelPostalCode.text = address.postalCode;
        self.labelCountryCode.text = address.countryCode;
    }
    else {
        self.labelAddressLabel.text = @"";
        self.labelAddress.text = @"";
        self.labelLocality.text = @"";
        self.labelRegion.text = @"";
        self.labelPostalCode.text = @"";
        self.labelCountryCode.text = @"";
    }
    
    // Demographics
    if ([profile.gender isSet] == YES) {
        self.labelGender.text = [profile.gender getPrimaryValue];
    }
    else {
        self.labelGender.text = @"";
    }
    if ([profile.ethnicity isSet] == YES) {
        self.labelEthnicity.text = [profile.ethnicity getPrimaryValue];
    }
    else {
        self.labelEthnicity.text = @"";
    }
    if ([profile.weight isSet] == YES) {
        self.labelWeight.text = [NSString stringWithFormat:@"%d lb", [[profile.weight getPrimaryValue] intValue]];
    }
    else {
        self.labelWeight.text = @"";
    }
    if ([profile.height isSet] == YES) {
        int height = [[profile.height getPrimaryValue] intValue];
        self.labelHeight.text = [NSString stringWithFormat:@"%d'%d\"", height / 12, height % 12];
    }
    else {
        self.labelHeight.text = @"";
    }
    if ([profile.languages isSet] == YES) {
        RSOSDataLanguage *language = [profile.languages getPrimaryValue];
        if (language != nil) {
            self.labelLanguage.text = [[RSOSUtils sharedInstance] getLanguageDisplayNameForCode:language.languageCode];
        }
        else {
            self.labelLanguage.text = @"";
        }
    }
    else {
        self.labelLanguage.text = @"";
    }
    if ([profile.occupation isSet] == YES) {
        self.labelOccupation.text = [profile.occupation getPrimaryValue];
    }
    else {
        self.labelOccupation.text = @"";
    }
    
    // Contact Information
    if ([profile.phoneNumbers isSet] == YES) {
        RSOSDataPhoneNumber *phone = [profile.phoneNumbers getPrimaryValue];
        if (phone != nil) {
            self.labelContactType1.text = phone.label;
            self.labelContact1.text = [RSOSUtilsString beautifyPhoneNumber:phone.phoneNumber countryCode:@""];
        }
        else {
            self.labelContactType1.text = @"";
            self.labelContact1.text = @"";
        }
    }
    else {
        self.labelContactType1.text = @"";
        self.labelContact1.text = @"";
    }
    if ([profile.emails isSet] == YES) {
        RSOSDataEmail *email = [profile.emails getPrimaryValue];
        if (email != nil) {
            self.labelContactType2.text = @"Email";
            self.labelContact2.text = email.emailAddress;
        }
        else {
            self.labelContactType2.text = @"";
            self.labelContact2.text = @"";

        }
    }
    else {
        self.labelContactType2.text = @"";
        self.labelContact2.text = @"";
    }
    
    // Health Data
    if ([profile.allergies isSet] == YES) {
        self.labelAllergies.text = [profile.allergies getPrimaryValue];
    }
    else {
        self.labelAllergies.text = @"";
    }
    if ([profile.medicalCondition isSet] == YES) {
        self.labelMedicalCondition.text = [profile.medicalCondition getPrimaryValue];
    }
    else {
        self.labelMedicalCondition.text = @"";
    }
    if ([profile.disability isSet] == YES) {
        self.labelDisabilities.text = [profile.disability getPrimaryValue];
    }
    else {
        self.labelDisabilities.text = @"";
    }
    if ([profile.medication isSet] == YES) {
        self.labelMedications.text = [profile.medication getPrimaryValue];
    }
    else {
        self.labelMedications.text = @"";
    }
    if ([profile.bloodType isSet] == YES) {
        self.labelBloodType.text = [profile.bloodType getPrimaryValue];
    }
    else {
        self.labelBloodType.text = @"";
    }
    if ([profile.medicalNotes isSet] == YES) {
        self.labelHealthNotes.text = [profile.medicalNotes getPrimaryValue];
    }
    else {
        self.labelHealthNotes.text = @"";
    }
}

#pragma mark -Navigation

- (void) gotoProfileDetailsVC {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"STORYBOARD_PROFILE_DETAILS"];
        [self.navigationController pushViewController:vc animated:YES];
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    });
}

- (void) gotoContactListVC {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"STORYBOARD_CONTACT_LIST"];
        [self.navigationController pushViewController:vc animated:YES];
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    });
}

#pragma mark - UIButton Event Listeners

- (IBAction)onButtonEditProfileClick:(id)sender {
    [self gotoProfileDetailsVC];
}

- (IBAction)onButtonEditContactsClick:(id)sender {
    [self gotoContactListVC];
}

@end
