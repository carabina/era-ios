//
//  RSOSUtilsString.m
//  Emergency Reference Application
//
//  Created by Chris Lin on 11/29/17.
//  Copyright © 2017 RapidSOS. All rights reserved.
//

#import "RSOSUtilsString.h"

@implementation RSOSUtilsString

#pragma mark -String Manipulation

+ (NSString *)refineNSString:(NSString *)string {
    NSString *result = @"";
    if ((string == nil) || ([string isKindOfClass:[NSNull class]] == YES)) result = @"";
    else result = [NSString stringWithFormat:@"%@", string];
    return result;
}

+ (int)refineInt:(id)value defaultValue:(int)defValue {
    if (value == nil || [value isKindOfClass:[NSNull class]] == YES) return defValue;
    int v = defValue;
    @try {
        v = [value intValue];
    }
    @catch (NSException *exception) {
    }
    return v;
}

+ (float)refineFloat:(id)value defaultValue:(float)defValue {
    if (value == nil || [value isKindOfClass:[NSNull class]] == YES) return defValue;
    float v = defValue;
    @try {
        v = [value floatValue];
    }
    @catch (NSException *exception) {
    }
    return v;
}

+ (BOOL)refineBool:(id)value defaultValue:(BOOL)defValue {
    if (value == nil || [value isKindOfClass:[NSNull class]] == YES) return defValue;
    BOOL v = defValue;
    @try {
        v = [value boolValue];
    }
    @catch (NSException *exception) {
    }
    return v;
}

+ (NSString *)beautifyPhoneNumber:(NSString *)localNumber countryCode:(NSString *)countryCode {
    localNumber = [RSOSUtilsString stripNonnumericsFromNSString:localNumber];
    if (localNumber.length == 11 & [localNumber hasPrefix:@"1"] == YES) {
        localNumber = [localNumber substringFromIndex:1];
    }
    
    NSString *szPattern = @"(xxx) xxx-xxxx";
    int nMaxLength = (int) szPattern.length;
    NSString *szFormattedNumber = @"";
    
    int index = 0;
    for (int i = 0; i < (int) localNumber.length; i++){
        NSRange r = [szPattern rangeOfString:@"x" options:0 range:NSMakeRange(index, szPattern.length - index)];
        if (r.location == NSNotFound) break;
        
        if (r.location != index){
            // should add nun-numeric characters like whitespace or brackets
            szFormattedNumber = [NSString stringWithFormat:@"%@%@", szFormattedNumber, [szPattern substringWithRange:NSMakeRange(index, r.location - index)]];
        }
        szFormattedNumber = [NSString stringWithFormat:@"%@%@", szFormattedNumber, [localNumber substringWithRange:NSMakeRange(i, 1)]];
        index = (int) r.location + 1;
    }
    
    if (localNumber.length > 0 && (localNumber.length < szPattern.length)){
        // Add extra non-numeric characters at the end
        NSRange r = [szPattern rangeOfString:@"x" options:0 range:NSMakeRange(szFormattedNumber.length, szPattern.length - szFormattedNumber.length)];
        if (r.location != NSNotFound){
            szFormattedNumber = [NSString stringWithFormat:@"%@%@", szFormattedNumber, [szPattern substringWithRange:NSMakeRange(szFormattedNumber.length, r.location - szFormattedNumber.length)]];
        }
        else {
            szFormattedNumber = [NSString stringWithFormat:@"%@%@", szFormattedNumber, [szPattern substringWithRange:NSMakeRange(szFormattedNumber.length, szPattern.length - szFormattedNumber.length)]];
        }
    }
    
    if (szFormattedNumber.length > nMaxLength){
        szFormattedNumber = [szFormattedNumber substringToIndex:nMaxLength];
    }
    //    szFormattedNumber = [NSString stringWithFormat:@"+1 %@", szFormattedNumber];
    return szFormattedNumber;
}

+ (NSString *)getValidPhoneNumber:(NSString *)phoneNumber {
    NSString *ret = [[phoneNumber componentsSeparatedByCharactersInSet: [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet]] componentsJoinedByString:@""];
    
    NSString *phoneRegex = @"[0-9]{10}";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    
    if([phoneTest evaluateWithObject:ret] == NO)
        return @"";
    
    return ret;
}

+ (NSString *)normalizePhoneNumber:(NSString *)phoneNumber prefix:(NSString *)prefix {
    
    // 16262267361
    phoneNumber = [RSOSUtilsString stripNonnumericsFromNSString:phoneNumber];
    if (phoneNumber.length == 10) {
        phoneNumber = [NSString stringWithFormat:@"1%@", phoneNumber];
    }
    phoneNumber = [NSString stringWithFormat:@"%@%@", prefix, phoneNumber];
    return phoneNumber;
}

+ (NSString *)stripNonnumericsFromNSString:(NSString *)string {
    NSString *result = string;
    result = [[result componentsSeparatedByCharactersInSet: [[NSCharacterSet characterSetWithCharactersInString:@"0123456789*●"] invertedSet]] componentsJoinedByString:@""];
    return result;
}

+ (NSString *)stripNonAlphanumericsFromNSString:(NSString *)string {
    NSString *szResult = string;
    
    szResult = [[szResult componentsSeparatedByCharactersInSet: [[NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ0123456789-"] invertedSet]] componentsJoinedByString:@""];
    return szResult;
}

+ (BOOL)isValidEmail:(NSString *)candidate {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:candidate];
}

+ (NSString *)generateRandomString:(int)length {
    NSString *pattern = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    NSMutableString *randomString = [NSMutableString stringWithCapacity: length];
    for (int i = 0; i < length; i++) {
        [randomString appendFormat: @"%C", [pattern characterAtIndex: arc4random_uniform((int)[pattern length])]];
    }
    return randomString;
}

#pragma mark -Utils

+ (NSString *)getJSONStringRepresentation:(id)object {
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object options:0 error:&error];
    NSString *szResult = @"";
    if (!jsonData){
        NSLog(@"Error while serializing customer details into JSON\r\n%@", error.localizedDescription);
    }
    else{
        szResult = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return szResult;
}

+ (id)getObjectFromJSONStringRepresentation:(NSString *)string{
    NSError *jsonError;
    NSData *objectData = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:objectData
                                                         options:NSJSONReadingMutableContainers
                                                           error:&jsonError];
    if (jsonError != nil) return nil;
    return dict;
}

+ (NSString *)urlEncode:(NSString *)string{
    return [string stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
}

+ (NSString *)encodeNSStringToBase64:(NSString *)string {
    NSData *plainData = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64String = [plainData base64EncodedStringWithOptions:kNilOptions];  // iOS 7+
    return base64String;
}

@end
