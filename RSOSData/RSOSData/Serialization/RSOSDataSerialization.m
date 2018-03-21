//
//  RSOSDataSerialization.m
//  EmergencyReferenceApp
//
//  Created by Gabe Mahoney on 2/7/18.
//  Copyright © 2018 RapidSOS. All rights reserved.
//

#import "RSOSDataSerialization.h"

#import "RSOSDataAddress.h"
#import "RSOSDataEmail.h"
#import "RSOSDataEmergencyContact.h"
#import "RSOSDataLanguage.h"
#import "RSOSDataPhoneNumber.h"
#import "RSOSDataPhoto.h"
#import "RSOSDataAnimal.h"
#import "RSOSDataVideoFeed.h"
#import "RSOSDataURL.h"
#import "RSOSDataRealtimeMetric.h"
#import "RSOSDataUniqueDeviceID.h"

#import "RSOSUtils.h"

@implementation RSOSDataSerialization

+ (NSArray *)deserializeValuesArray:(NSArray *)valuesArray objectType:(NSString *)type {
    
    NSMutableArray *ret = [NSMutableArray arrayWithCapacity:valuesArray.count];
    
    if([type isEqualToString:@"string"]) {
        // Allergy, Blood Type, Disability, Ethnicity, Name, Gender, Medical Condition, Medical Notes, Medication, Occupation
        [ret addObjectsFromArray:valuesArray];
    }
    else if ([type isEqualToString:@"integer"]) {
        // Device.ImpactSpeed
        for (int i = 0; i < (int) [valuesArray count]; i++) {
            BOOL value = [RSOSUtilsString refineInt:[valuesArray objectAtIndex:i] defaultValue:NO];
            [ret addObject:@(value)];
        }
    }
    else if ([type isEqualToString:@"boolean"]) {
        // Device.BreakInDetected, CarbonDioxideDetected, CarbonMonxideDetected,
        for (int i = 0; i < (int) [valuesArray count]; i++) {
            BOOL value = [RSOSUtilsString refineBool:[valuesArray objectAtIndex:i] defaultValue:NO];
            [ret addObject:@(value)];
        }
    }
    else if ([type isEqualToString:@"float"]) {
        // Height, Weight
        for (int i = 0; i < (int) [valuesArray count]; i++) {
            float value = [RSOSUtilsString refineFloat:[valuesArray objectAtIndex:i] defaultValue:0];
            [ret addObject:@(value)];
        }
    }
    else if ([type isEqualToString:@"timestamp"]) {
        // Birthday
        for (int i = 0; i < (int) [valuesArray count]; i++) {
            NSTimeInterval interval = [[valuesArray objectAtIndex:i] doubleValue] / 1000;
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
            [ret addObject:date];
        }
    }
    else if([type isEqualToString:@"address"]) {
        // Address
        for(NSDictionary *addressDict in valuesArray) {
            
            @try {
                RSOSDataAddress *address = [[RSOSDataAddress alloc] initWithDictionary:addressDict];
                if(address) {
                    [ret addObject:address];
                }
            }
            @catch (NSException *e) {
                NSLog(@"Error parsing address: %@", addressDict.description);
            }
        }
    }
    else if([type isEqualToString:@"animal"]) {
        // SavedLocation.Animal
        for(NSDictionary *animalDict in valuesArray) {
            
            @try {
                RSOSDataAnimal *animal = [[RSOSDataAnimal alloc] initWithDictionary:animalDict];
                if(animal) {
                    [ret addObject:animal];
                }
            }
            @catch (NSException *e) {
                NSLog(@"Error parsing animal: %@", animalDict.description);
            }
        }
    }
    else if([type isEqualToString:@"video-stream"] == YES) {
        // SavedLocation.FixedVideoFeed, SavedLocation.MobileVideoFeed, Device.VideoFeed
        for(NSDictionary *feedDict in valuesArray) {
            
            @try {
                RSOSDataVideoFeed *feed = [[RSOSDataVideoFeed alloc] initWithDictionary:feedDict];
                if(feed) {
                    [ret addObject:feed];
                }
            }
            @catch (NSException *e) {
                NSLog(@"Error parsing video feed: %@", feedDict.description);
            }
        }
    }
    else if([type isEqualToString:@"device"]) {
        
    }
    else if([type isEqualToString:@"email"]) {
        // Email
        for(NSDictionary *emailDict in valuesArray) {
            
            @try {
                RSOSDataEmail *email = [[RSOSDataEmail alloc] initWithDictionary:emailDict];
                if(email) {
                    [ret addObject:email];
                }
            }
            @catch (NSException *e) {
                NSLog(@"Error parsing email: %@", emailDict.description);
            }
        }
    }
    else if([type isEqualToString:@"emergency-contact"]) {
        // Emergency Contacts
        for(NSDictionary *contactDict in valuesArray) {
            
            @try {
                RSOSDataEmergencyContact *contact = [[RSOSDataEmergencyContact alloc] initWithDictionary:contactDict];
                if(contact) {
                    [ret addObject:contact];
                }
            }
            @catch (NSException *e) {
                NSLog(@"Error parsing emergency contact: %@", contactDict.description);
            }
        }
    }
    else if([type isEqualToString:@"language"]) {
        // Language
        for(NSDictionary *languageDict in valuesArray) {
            
            @try {
                RSOSDataLanguage *language = [[RSOSDataLanguage alloc] initWithDictionary:languageDict];
                if(language) {
                    [ret addObject:language];
                }
            }
            @catch (NSException *e) {
                NSLog(@"Error parsing language: %@", languageDict.description);
            }
        }
    }
    else if([type isEqualToString:@"phone-number"]) {
        // Phone Number
        for(NSDictionary *phoneDict in valuesArray) {
            
            @try {
                RSOSDataPhoneNumber *phone = [[RSOSDataPhoneNumber alloc] initWithDictionary:phoneDict];
                if(phone) {
                    [ret addObject:phone];
                }
            }
            @catch (NSException *e) {
                NSLog(@"Error parsing phone: %@", phoneDict.description);
            }
        }
    }
    else if([type isEqualToString:@"image-url"]) {
        // Photo
        for(NSDictionary *photoDict in valuesArray) {
            
            @try {
                RSOSDataPhoto *photo = [[RSOSDataPhoto alloc] initWithDictionary:photoDict];
                if(photo) {
                    [ret addObject:photo];
                }
            }
            @catch (NSException *e) {
                NSLog(@"Error parsing photo: %@", photoDict.description);
            }
        }
    }
    else if([type isEqualToString:@"realtime-metric"]) {
        // Realtime Metric
        for(NSDictionary *metricDict in valuesArray) {
            
            @try {
                RSOSDataRealtimeMetric *metric = [[RSOSDataRealtimeMetric alloc] initWithDictionary:metricDict];
                if(metric) {
                    [ret addObject:metric];
                }
            }
            @catch (NSException *e) {
                NSLog(@"Error parsing realtime-metric: %@", metricDict.description);
            }
        }
    }
    else if([type isEqualToString:@"service"]) {
        
    }
    else if([type isEqualToString:@"device-id"]) {
        // Device.UniqueDeviceId
        for(NSDictionary *deviceIdDict in valuesArray) {
            
            @try {
                RSOSDataUniqueDeviceID *deviceId = [[RSOSDataUniqueDeviceID alloc] initWithDictionary:deviceIdDict];
                if(deviceId) {
                    [ret addObject:deviceId];
                }
            }
            @catch (NSException *e) {
                NSLog(@"Error parsing unique device id: %@", deviceIdDict.description);
            }
        }
    }
    else if([type isEqualToString:@"web-url"] == YES) {
        // SavedLocation.ExternalDataPortal
        for(NSDictionary *urlDict in valuesArray) {
            
            @try {
                RSOSDataURL *url = [[RSOSDataURL alloc] initWithDictionary:urlDict];
                if(url) {
                    [ret addObject:url];
                }
            }
            @catch (NSException *e) {
                NSLog(@"Error parsing %@: %@", type, urlDict.description);
            }
        }
    }
    
    return [NSArray arrayWithArray:ret];
}

+ (NSArray *)serializeValuesArray:(NSArray *)valuesArray objectType:(NSString *)type {
    
    NSMutableArray *ret = [NSMutableArray arrayWithCapacity:valuesArray.count];
    
    if([type isEqualToString:@"string"]) {
        [ret addObjectsFromArray:valuesArray];
    }
    else if([type isEqualToString:@"integer"]) {
        [ret addObjectsFromArray:valuesArray];
    }
    else if([type isEqualToString:@"boolean"]) {
        [ret addObjectsFromArray:valuesArray];
    }
    else if([type isEqualToString:@"float"]) {
        [ret addObjectsFromArray:valuesArray];
    }
    else if ([type isEqualToString:@"timestamp"]) {
        for (NSDate *date in valuesArray) {
            [ret addObject:@((long) [date timeIntervalSince1970] * 1000)];
        }
    }
    else if([type isEqualToString:@"address"]) {
        
        for(RSOSDataAddress *address in valuesArray) {
            
            NSDictionary *addressDict = [address serializeToDictionary];
            if(addressDict) {
                [ret addObject:addressDict];
            }
        }
        
    }
    else if([type isEqualToString:@"animal"]) {
        for(RSOSDataAnimal *animal in valuesArray) {
            
            NSDictionary *animalDict = [animal serializeToDictionary];
            if(animalDict) {
                [ret addObject:animalDict];
            }
        }
    }
    else if([type isEqualToString:@"video-stream"] == YES) {
        for(RSOSDataVideoFeed *feed in valuesArray) {
            
            NSDictionary *feedDict = [feed serializeToDictionary];
            if(feedDict) {
                [ret addObject:feedDict];
            }
        }
    }
    else if([type isEqualToString:@"device"]) {
        
    }
    else if([type isEqualToString:@"email"]) {
        for(RSOSDataEmail *email in valuesArray) {
            
            NSDictionary *emailDict = [email serializeToDictionary];
            if(emailDict) {
                [ret addObject:emailDict];
            }
        }
    }
    else if([type isEqualToString:@"emergency-contact"]) {
        for(RSOSDataEmergencyContact *contact in valuesArray) {
            
            NSDictionary *contactDict = [contact serializeToDictionary];
            if(contactDict) {
                [ret addObject:contactDict];
            }
        }
    }
    else if([type isEqualToString:@"language"]) {
        for(RSOSDataLanguage *language in valuesArray) {
            
            NSDictionary *languageDict = [language serializeToDictionary];
            if(languageDict) {
                [ret addObject:languageDict];
            }
        }
    }
    else if([type isEqualToString:@"phone-number"]) {
        for(RSOSDataPhoneNumber *phone in valuesArray) {
            
            NSDictionary *phoneDict = [phone serializeToDictionary];
            if(phoneDict) {
                [ret addObject:phoneDict];
            }
        }
    }
    else if([type isEqualToString:@"image-url"]) {
        for(RSOSDataPhoto *photo in valuesArray) {
            
            NSDictionary *photoDict = [photo serializeToDictionary];
            if(photoDict) {
                [ret addObject:photoDict];
            }
        }
    }
    else if([type isEqualToString:@"realtime-metric"]) {
        for(RSOSDataRealtimeMetric *metric in valuesArray) {
            
            NSDictionary *metricDict = [metric serializeToDictionary];
            if(metricDict) {
                [ret addObject:metricDict];
            }
        }
    }
    else if([type isEqualToString:@"service"]) {
        
    }
    else if([type isEqualToString:@"device-id"]) {
        for(RSOSDataUniqueDeviceID *deviceId in valuesArray) {
            
            NSDictionary *deviceIdDict = [deviceId serializeToDictionary];
            if(deviceIdDict) {
                [ret addObject:deviceIdDict];
            }
        }
    }
    else if([type isEqualToString:@"web-url"] == YES) {
        for(RSOSDataURL *url in valuesArray) {
            
            NSDictionary *urlDict = [url serializeToDictionary];
            if(urlDict) {
                [ret addObject:urlDict];
            }
        }
    }
    
    return [NSArray arrayWithArray:ret];
}

@end
