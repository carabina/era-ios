//
//  RSOSDataUserProfile.m
//  Emergency Reference Application
//
//  Created by Chris Lin on 12/1/17.
//  Copyright © 2017 RapidSOS. All rights reserved.
//

#import "RSOSDataUserProfile.h"
#import "RSOSUtils.h"

@implementation RSOSDataUserProfile

- (instancetype) init{
    self = [super init];
    if (self){
        [self initialize];
    }
    return self;
}

- (instancetype) initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    if (self){
        [self setWithDictionary:dict];
    }
    return self;
}

- (void) initialize{
    self.szId = @"";
    
    self.addresses = [[RSOSDataObject alloc] initWithDisplayName:@"Home Address" type:@"address"];
    self.allergies = [[RSOSDataObject alloc] initWithDisplayName:@"Allergies" type:@"string"];
    self.birthday = [[RSOSDataObject alloc] initWithDisplayName:@"Birthday" type:@"timestamp" units:@"millisecond"];
    self.bloodType = [[RSOSDataObject alloc] initWithDisplayName:@"Blood Type" type:@"string"];
    self.disability = [[RSOSDataObject alloc] initWithDisplayName:@"Disabilities" type:@"string"];
    self.emails = [[RSOSDataObject alloc] initWithDisplayName:@"Emails" type:@"email"];
    self.emergencyContacts = [[RSOSDataObject alloc] initWithDisplayName:@"Emergency Contacts" type:@"emergency-contact"];
    self.ethnicity = [[RSOSDataObject alloc] initWithDisplayName:@"Ethnicity" type:@"string"];
    self.fullName = [[RSOSDataObject alloc] initWithDisplayName:@"Name" type:@"string"];
    self.gender = [[RSOSDataObject alloc] initWithDisplayName:@"Gender" type:@"string"];
    self.languages = [[RSOSDataObject alloc] initWithDisplayName:@"Languages" type:@"language"];
    self.medicalCondition = [[RSOSDataObject alloc] initWithDisplayName:@"Medical Conditions" type:@"string"];
    self.medicalNotes = [[RSOSDataObject alloc] initWithDisplayName:@"Medical Notes" type:@"string"];
    self.medication = [[RSOSDataObject alloc] initWithDisplayName:@"Medications" type:@"string"];
    self.occupation = [[RSOSDataObject alloc] initWithDisplayName:@"Occupation" type:@"string"];
    self.phoneNumbers = [[RSOSDataObject alloc] initWithDisplayName:@"Known Phone Numbers" type:@"phone-number"];
    self.height = [[RSOSDataObject alloc] initWithDisplayName:@"Height" type:@"float" units:@"inches"];
    self.weight = [[RSOSDataObject alloc] initWithDisplayName:@"Weight" type:@"float" units:@"lbs"];
    self.photo = [[RSOSDataObject alloc] initWithDisplayName:@"Profile Picture" type:@"image-url"];
}

- (void) setWithDictionary:(NSDictionary *)dict {
    [self initialize];
    
    self.szId = [RSOSUtilsString refineNSString:[dict objectForKey:@"id"]];
    
    NSDictionary *dictAddress = [dict objectForKey:@"address"];
    NSDictionary *dictAllergy = [dict objectForKey:@"allergy"];
    NSDictionary *dictBirthday = [dict objectForKey:@"birthday"];
    NSDictionary *dictBloodType = [dict objectForKey:@"blood_type"];
    NSDictionary *dictDisability = [dict objectForKey:@"disability"];
    NSDictionary *dictEmail = [dict objectForKey:@"email"];
    NSDictionary *dictContact = [dict objectForKey:@"emergency_contact"];
    NSDictionary *dictEthnicity = [dict objectForKey:@"ethnicity"];
    NSDictionary *dictFullName = [dict objectForKey:@"full_name"];
    NSDictionary *dictGender = [dict objectForKey:@"gender"];
    NSDictionary *dictHeight = [dict objectForKey:@"height"];
    NSDictionary *dictLanguage = [dict objectForKey:@"language"];
    NSDictionary *dictMedicalCondition = [dict objectForKey:@"medical_condition"];
    NSDictionary *dictMedicalNote = [dict objectForKey:@"medical_note"];
    NSDictionary *dictMedication = [dict objectForKey:@"medication"];
    NSDictionary *dictOccupation = [dict objectForKey:@"occupation"];
    NSDictionary *dictPhoneNumber = [dict objectForKey:@"phone_number"];
    NSDictionary *dictWeight = [dict objectForKey:@"weight"];
    NSDictionary *dictPhoto = [dict objectForKey:@"photo"];
    
    if (dictAddress != nil && [dictAddress isKindOfClass:[NSDictionary class]] == YES) {
        [self.addresses setWithDictionary:dictAddress];
    }
    if (dictAllergy != nil && [dictAllergy isKindOfClass:[NSDictionary class]] == YES) {
        [self.allergies setWithDictionary:dictAllergy];
    }
    if (dictBirthday != nil && [dictBirthday isKindOfClass:[NSDictionary class]] == YES) {
        [self.birthday setWithDictionary:dictBirthday];
    }
    if (dictBloodType != nil && [dictBloodType isKindOfClass:[NSDictionary class]] == YES) {
        [self.bloodType setWithDictionary:dictBloodType];
    }
    if (dictDisability != nil && [dictDisability isKindOfClass:[NSDictionary class]] == YES) {
        [self.disability setWithDictionary:dictDisability];
    }
    if (dictEmail != nil && [dictEmail isKindOfClass:[NSDictionary class]] == YES) {
        [self.emails setWithDictionary:dictEmail];
    }
    if (dictContact != nil && [dictContact isKindOfClass:[NSDictionary class]] == YES) {
        [self.emergencyContacts setWithDictionary:dictContact];
    }
    if (dictEthnicity != nil && [dictEthnicity isKindOfClass:[NSDictionary class]] == YES) {
        [self.ethnicity setWithDictionary:dictEthnicity];
    }
    if (dictFullName != nil && [dictFullName isKindOfClass:[NSDictionary class]] == YES) {
        [self.fullName setWithDictionary:dictFullName];
    }
    if (dictGender != nil && [dictGender isKindOfClass:[NSDictionary class]] == YES) {
        [self.gender setWithDictionary:dictGender];
    }
    if (dictLanguage != nil && [dictLanguage isKindOfClass:[NSDictionary class]] == YES) {
        [self.languages setWithDictionary:dictLanguage];
    }
    if (dictMedicalCondition != nil && [dictMedicalCondition isKindOfClass:[NSDictionary class]] == YES) {
        [self.medicalCondition setWithDictionary:dictMedicalCondition];
    }
    if (dictMedicalNote != nil && [dictMedicalNote isKindOfClass:[NSDictionary class]] == YES) {
        [self.medicalNotes setWithDictionary:dictMedicalNote];
    }
    if (dictMedication != nil && [dictMedication isKindOfClass:[NSDictionary class]] == YES) {
        [self.medication setWithDictionary:dictMedication];
    }
    if (dictOccupation != nil && [dictOccupation isKindOfClass:[NSDictionary class]] == YES) {
        [self.occupation setWithDictionary:dictOccupation];
    }
    if (dictPhoneNumber != nil && [dictPhoneNumber isKindOfClass:[NSDictionary class]] == YES) {
        [self.phoneNumbers setWithDictionary:dictPhoneNumber];
    }
    if (dictHeight != nil && [dictHeight isKindOfClass:[NSDictionary class]] == YES) {
        [self.height setWithDictionary:dictHeight];
    }
    if (dictWeight != nil && [dictWeight isKindOfClass:[NSDictionary class]] == YES) {
        [self.weight setWithDictionary:dictWeight];
    }
    if (dictPhoto != nil && [dictPhoto isKindOfClass:[NSDictionary class]] == YES) {
        [self.photo setWithDictionary:dictPhoto];
    }
}

- (NSDictionary *) serializeToDictionary {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    if (self.szId != nil & self.szId.length > 0) {
        [dict setObject:self.szId forKey:@"id"];
    }
    
    if ([self.addresses isSet] == YES) {
        [dict setObject:[self.addresses serializeToDictionary] forKey:@"address"];
    }
    if ([self.allergies isSet] == YES) {
        [dict setObject:[self.allergies serializeToDictionary] forKey:@"allergy"];
    }
    if ([self.birthday isSet] == YES) {
        [dict setObject:[self.birthday serializeToDictionary] forKey:@"birthday"];
    }
    if ([self.bloodType isSet] == YES) {
        [dict setObject:[self.bloodType serializeToDictionary] forKey:@"blood_type"];
    }
    if ([self.disability isSet] == YES) {
        [dict setObject:[self.disability serializeToDictionary] forKey:@"disability"];
    }
    if ([self.emails isSet] == YES) {
        [dict setObject:[self.emails serializeToDictionary] forKey:@"email"];
    }
    if ([self.emergencyContacts isSet] == YES) {
        [dict setObject:[self.emergencyContacts serializeToDictionary] forKey:@"emergency_contact"];
    }
    if ([self.ethnicity isSet] == YES) {
        [dict setObject:[self.ethnicity serializeToDictionary] forKey:@"ethnicity"];
    }
    if ([self.fullName isSet] == YES) {
        [dict setObject:[self.fullName serializeToDictionary] forKey:@"full_name"];
    }
    if ([self.gender isSet] == YES) {
        [dict setObject:[self.gender serializeToDictionary] forKey:@"gender"];
    }
    if ([self.languages isSet] == YES) {
        [dict setObject:[self.languages serializeToDictionary] forKey:@"languages"];
    }
    if ([self.medicalCondition isSet] == YES) {
        [dict setObject:[self.medicalCondition serializeToDictionary] forKey:@"medical_condition"];
    }
    if ([self.medicalNotes isSet] == YES) {
        [dict setObject:[self.medicalNotes serializeToDictionary] forKey:@"medical_note"];
    }
    if ([self.medication isSet] == YES) {
        [dict setObject:[self.medication serializeToDictionary] forKey:@"medication"];
    }
    if ([self.occupation isSet] == YES) {
        [dict setObject:[self.occupation serializeToDictionary] forKey:@"occupation"];
    }
    if ([self.phoneNumbers isSet] == YES) {
        [dict setObject:[self.phoneNumbers serializeToDictionary] forKey:@"phone_number"];
    }
    if ([self.height isSet] == YES) {
        [dict setObject:[self.height serializeToDictionary] forKey:@"height"];
    }
    if ([self.weight isSet] == YES) {
        [dict setObject:[self.weight serializeToDictionary] forKey:@"weight"];
    }
    if ([self.photo isSet] == YES) {
        [dict setObject:[self.photo serializeToDictionary] forKey:@"photo"];
    }
    return dict;
}

- (instancetype)deepCopy {
    
    NSDictionary *profileDict = [self serializeToDictionary];
    return [[RSOSDataUserProfile alloc] initWithDictionary:profileDict];
}

@end
