//
//  RSOSUtilsString.h
//  Emergency Reference Application
//
//  Created by Chris Lin on 11/29/17.
//  Copyright © 2017 RapidSOS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RSOSUtilsString : NSObject

#pragma mark -String Manipulation

+ (NSString *)refineNSString:(NSString *)string;
+ (int)refineInt:(id)value defaultValue:(int)defValue;
+ (float)refineFloat:(id)value defaultValue:(float)defValue;
+ (BOOL)refineBool:(id)value defaultValue:(BOOL)defValue;

+ (NSString *)beautifyPhoneNumber:(NSString *)localNumber countryCode:(NSString *)countryCode;
+ (NSString *)getValidPhoneNumber:(NSString *)phoneNumber;
+ (NSString *)normalizePhoneNumber:(NSString *)phoneNumber prefix:(NSString *)prefix;
+ (NSString *)stripNonnumericsFromNSString:(NSString *)string;
+ (NSString *)stripNonAlphanumericsFromNSString:(NSString *)string;
+ (BOOL)isValidEmail:(NSString *)candidate;
+ (NSString *)generateRandomString:(int)length;

#pragma mark -Utils

+ (NSString *)getJSONStringRepresentation:(id)object;
+ (id)getObjectFromJSONStringRepresentation:(NSString *)string;

+ (NSString *)urlEncode:(NSString *)originalString;

+ (NSString *)encodeNSStringToBase64: (NSString *)originalString;

@end
