//
//  RSOSUtils.h
//  Emergency Reference Application
//
//  Created by Chris Lin on 11/29/17.
//  Copyright © 2017 RapidSOS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RSOSUtilsString.h"
#import "RSOSUtilsDate.h"
#import "RSOSLocalStorageManager.h"

typedef NS_ENUM(NSInteger,RSOSDataGender){
    RSOSDataGenderNone = -1,
    RSOSDataGenderMale = 0,
    RSOSDataGenderFemale = 1,
    RSOSDataGenderNotSpecified = 2,
};

@interface RSOSUtils : NSObject

@property (strong, nonatomic) NSMutableArray <NSString *> *arrayLanguageDisplayNames;
@property (strong, nonatomic) NSMutableArray <NSString *> *arrayLanguageCodes;

+ (instancetype)sharedInstance;
- (void)initializeManager;

- (NSArray *)getLanguageDisplayNamesArray;
- (NSString *)getLanguageCodeAtIndex:(int)index;
- (int)getIndexForLanguageCode:(NSString *)code;
- (NSString *)getLanguageDisplayNameForCode:(NSString *)code;

- (NSArray *)getBloodTypesArray;
- (int)getIndexForBloodType:(NSString *)blood;

- (NSArray *)getGendersArray;

+ (NSString *)getAppVersionString;
+ (NSString *)getAppBuildString;

+ (NSString *)getStringFromGender:(RSOSDataGender)gender;
+ (RSOSDataGender)getGenderFromString:(NSString *)gender;

@end

@interface NSData (RSOSUtils)

- (NSString *)hexadecimalString;

@end
