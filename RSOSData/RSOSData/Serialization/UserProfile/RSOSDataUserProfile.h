//
//  RSOSDataUserProfile.h
//  Emergency Reference Application
//
//  Created by Chris Lin on 12/1/17.
//  Copyright © 2017 RapidSOS. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "RSOSDataObject.h"
#import "RSOSDataValue.h"
#import "RSOSDataAddress.h"
#import "RSOSDataEmail.h"
#import "RSOSDataEmergencyContact.h"
#import "RSOSDataLanguage.h"
#import "RSOSDataPhoneNumber.h"
#import "RSOSDataPhoto.h"

@interface RSOSDataUserProfile : NSObject <RSOSDataSerializable>

@property (strong, nonatomic) NSString *szId;

@property (strong, nonatomic) RSOSDataObject<RSOSDataAddress *> *addresses;
@property (strong, nonatomic) RSOSDataObject<NSString *> *allergies;
@property (strong, nonatomic) RSOSDataObject<NSDate *> *birthday;
@property (strong, nonatomic) RSOSDataObject<NSString *> *bloodType;
@property (strong, nonatomic) RSOSDataObject<NSString *> *disability;
@property (strong, nonatomic) RSOSDataObject<RSOSDataEmail *> *emails;
@property (strong, nonatomic) RSOSDataObject<RSOSDataEmergencyContact *> *emergencyContacts;
@property (strong, nonatomic) RSOSDataObject<NSString *> *ethnicity;
@property (strong, nonatomic) RSOSDataObject<NSString *> *fullName;
@property (strong, nonatomic) RSOSDataObject<NSString *> *gender;
@property (strong, nonatomic) RSOSDataObject<RSOSDataLanguage *> *languages;
@property (strong, nonatomic) RSOSDataObject<NSString *> *medicalCondition;
@property (strong, nonatomic) RSOSDataObject<NSString *> *medicalNotes;
@property (strong, nonatomic) RSOSDataObject<NSString *> *medication;
@property (strong, nonatomic) RSOSDataObject<NSString *> *occupation;
@property (strong, nonatomic) RSOSDataObject<RSOSDataPhoneNumber *> *phoneNumbers;
@property (strong, nonatomic) RSOSDataObject<NSNumber *> *height;
@property (strong, nonatomic) RSOSDataObject<NSNumber *> *weight;
@property (strong, nonatomic) RSOSDataObject<RSOSDataPhoto *> *photo;

@end
