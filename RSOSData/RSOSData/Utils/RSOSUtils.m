//
//  RSOSUtils.m
//  Emergency Reference Application
//
//  Created by Chris Lin on 11/29/17.
//  Copyright © 2017 RapidSOS. All rights reserved.
//

#import "RSOSUtils.h"

@implementation RSOSUtils

+ (instancetype)sharedInstance {
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (id)init {
    if (self = [super init]) {
    }
    return self;
}

- (void)initializeManager {
    [self buildLanguageList];
}

- (void)buildLanguageList {
    self.arrayLanguageDisplayNames = [[NSMutableArray alloc] init];
    self.arrayLanguageCodes = [[NSMutableArray alloc] init];
    
    NSMutableArray *codes = [NSMutableArray arrayWithArray:[NSLocale ISOLanguageCodes]];
    
    NSMutableArray<NSDictionary *> *languageCodeDicts = [NSMutableArray arrayWithCapacity:codes.count];

    for (NSString *code in codes) {
        
        if(code.length > 2) {
            continue;
        }
        
        NSString *displayName = [[[NSLocale alloc] initWithLocaleIdentifier:code] displayNameForKey:NSLocaleIdentifier value:code];
        if (displayName == nil || [displayName isKindOfClass:[NSString class]] == NO) continue;
        
        NSDictionary *dict = @{@"code":code,
                               @"name":displayName};
        
        [languageCodeDicts addObject:dict];
    }
    
    [languageCodeDicts sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        
        NSDictionary *dict1 = (NSDictionary *)obj1;
        NSDictionary *dict2 = (NSDictionary *)obj2;
        
        return [dict1[@"name"] compare:dict2[@"name"] options:NSCaseInsensitiveSearch];
        
    }];
    
    [languageCodeDicts insertObject:@{@"code":@"de",@"name":@"Deutsch"} atIndex:0];
    [languageCodeDicts insertObject:@{@"code":@"fr",@"name":@"Français"} atIndex:0];
    [languageCodeDicts insertObject:@{@"code":@"es",@"name":@"Español"} atIndex:0];
    [languageCodeDicts insertObject:@{@"code":@"en",@"name":@"English"} atIndex:0];
    
    for(NSDictionary *dict in languageCodeDicts) {
        
        NSString *code = dict[@"code"];
        NSString *displayName = [dict[@"name"] capitalizedString];
        
        [self.arrayLanguageCodes addObject:code];
        [self.arrayLanguageDisplayNames addObject:displayName];
    }
    
}

- (NSArray *)getLanguageDisplayNamesArray {
    return self.arrayLanguageDisplayNames;
}

- (NSString *)getLanguageCodeAtIndex:(int)index {
    if ([self.arrayLanguageCodes count] <= index) return @"en";
    return [self.arrayLanguageCodes objectAtIndex:index];
}

- (int)getIndexForLanguageCode:(NSString *)code {
    for (int i = 0; i < (int) [self.arrayLanguageCodes count]; i++) {
        NSString *c = [self.arrayLanguageCodes objectAtIndex:i];
        if ([c caseInsensitiveCompare:code] == NSOrderedSame) return i;
    }
    return -1;
}

- (NSString *)getLanguageDisplayNameForCode:(NSString *)code {
    int index = [self getIndexForLanguageCode:code];
    if (index == -1 || index >= (int) [self.arrayLanguageDisplayNames count]) return @"English";
    return [self.arrayLanguageDisplayNames objectAtIndex:index];
}

- (NSArray *)getBloodTypesArray {
    return @[@"O+", @"O-", @"A+", @"A-", @"B+", @"B-", @"AB+", @"AB-"];
}

- (int)getIndexForBloodType:(NSString *)blood {
    NSArray *arrayBloodTypes = [self getBloodTypesArray];
    for (int i = 0; i < (int) [arrayBloodTypes count]; i++) {
        if ([[arrayBloodTypes objectAtIndex:i] caseInsensitiveCompare:blood] == NSOrderedSame) return i;
    }
    return -1;
}

- (NSArray *)getGendersArray {
    return @[@"Male",
             @"Female",
             @"Not Specified",
             ];
}

// App

+ (NSString *)getAppVersionString {
    NSString *szVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    return szVersion;
}

+ (NSString *)getAppBuildString {
    NSString *szVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleVersionKey];
    return szVersion;
}

// Utility Methods

+ (NSString *)getStringFromGender:(RSOSDataGender)gender {
    if (gender == RSOSDataGenderNone) return @"";
    if (gender == RSOSDataGenderMale) return @"Male";
    if (gender == RSOSDataGenderFemale) return @"Female";
    if (gender == RSOSDataGenderNotSpecified) return @"Not Specified";
    return @"Male";
}

+ (RSOSDataGender)getGenderFromString:(NSString *)gender {
    if ([gender caseInsensitiveCompare:@"Male"] == NSOrderedSame) return RSOSDataGenderMale;
    if ([gender caseInsensitiveCompare:@"Female"] == NSOrderedSame) return RSOSDataGenderFemale;
    if ([gender caseInsensitiveCompare:@"Not Specified"] == NSOrderedSame) return RSOSDataGenderNotSpecified;
    return RSOSDataGenderNone;
}

@end


@implementation NSData (RSOSUtils)

- (NSString *)hexadecimalString {
    
    NSUInteger length = self.length;
    if (length == 0) {
        return nil;
    }
    
    const unsigned char *buffer = self.bytes;
    NSMutableString *ret  = [NSMutableString stringWithCapacity:(length * 2)];
    for (int i = 0; i < length; ++i) {
        [ret appendFormat:@"%02x", buffer[i]];
    }
    
    return [[NSString alloc] initWithString:ret];
    
}

@end
