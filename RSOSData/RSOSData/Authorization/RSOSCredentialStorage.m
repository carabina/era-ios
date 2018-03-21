//
//  RSOSCredentialStorage.m
//  Emergency Reference Application
//
//  Created by Gabe Mahoney on 1/3/18.
//  Copyright © 2018 rapidsos. All rights reserved.
//
//  For more info on working with Keychain Services, please see https://developer.apple.com/library/content/documentation/Security/Conceptual/keychainServConcepts/iPhoneTasks/iPhoneTasks.html#//apple_ref/doc/uid/TP30000897-CH208-SW3
//

#import "RSOSCredentialStorage.h"

#import <Security/Security.h>

@implementation RSOSCredentialStorage

+ (BOOL)storeCredentials:(NSDictionary *)credentials {
    
    NSString *email = credentials[@"username"];
    NSString *password = credentials[@"password"];
    
    if(email.length == 0 || password.length == 0) {
        return NO;
    }
    
    // create the dictionary used to query for user credentials
    NSMutableDictionary *credentialsQuery = [NSMutableDictionary dictionary];
    
    credentialsQuery[(__bridge id)kSecClass] = (__bridge id)kSecClassInternetPassword;
    credentialsQuery[(__bridge id)kSecMatchLimit] = (__bridge id)kSecMatchLimitOne;
    credentialsQuery[(__bridge id)kSecReturnAttributes] = (__bridge id)kCFBooleanTrue;
    
    
    // Create the updated username/password keychain item
    NSMutableDictionary *keychainData = [NSMutableDictionary dictionary];
    
    // item class
    keychainData[(__bridge id)kSecClass] = (__bridge id)kSecClassInternetPassword;
    
    // user account (email address)
    keychainData[(__bridge id)kSecAttrAccount] = email;
    
    // user password
    keychainData[(__bridge id)kSecValueData] = [password dataUsingEncoding:NSUTF8StringEncoding];
    
    // make data available only on this device, when the device is unlocked
    keychainData[(__bridge id)kSecAttrAccessible] = (__bridge id)kSecAttrAccessibleWhenUnlockedThisDeviceOnly;
    
    
    OSStatus keychainErr = noErr;
    
    CFDictionaryRef attributes = nil;
    NSMutableDictionary *updateItemQuery = nil;
    
    
    keychainErr = SecItemCopyMatching((__bridge CFDictionaryRef)credentialsQuery, (CFTypeRef *)&attributes);
    
    if(keychainErr == noErr) {
        
        // user account exists in keychain; update existing item
        
        // query for existing item using item attributes retrieved by previous query
        updateItemQuery = [NSMutableDictionary dictionaryWithDictionary:(__bridge_transfer NSDictionary *)attributes];
        
        // add the item class to the item query
        updateItemQuery[(__bridge id)kSecClass] = (__bridge id)kSecClassInternetPassword;
        
        // remove class from update data -- not a keychain attribute
        keychainData[(__bridge id)kSecClass] = nil;
        
        // update existing item with new keychain data
        OSStatus errorCode = SecItemUpdate((__bridge CFDictionaryRef)updateItemQuery,
                                           (__bridge CFDictionaryRef)keychainData);
        
        if(errorCode != noErr) {
            
            NSLog(@"error updating keychain: %d", (int)errorCode);
            return NO;
        }
        else {
            
            NSLog(@"successfully updated keychain!");
            return YES;
        }
    }
    else {
        
        // no user acocunt in keychain - add it
        
        OSStatus errorCode = SecItemAdd((__bridge CFDictionaryRef)keychainData, nil);
        
        if(errorCode != noErr) {
            
            NSLog(@"error updating keychain: %d", (int)errorCode);
            return NO;
        }
        else {
            
            NSLog(@"successfully updated keychain!");
            return YES;
        }
    }
}

+ (NSDictionary *)loadStoredCredentials {
    
    NSDictionary *ret = nil;
    
    // create the dictionary used to query for user credentials
    NSMutableDictionary *credentialsQuery = [NSMutableDictionary dictionary];
    
    credentialsQuery[(__bridge id)kSecClass] = (__bridge id)kSecClassInternetPassword;
    credentialsQuery[(__bridge id)kSecMatchLimit] = (__bridge id)kSecMatchLimitOne;
    credentialsQuery[(__bridge id)kSecReturnAttributes] = (__bridge id)kCFBooleanTrue;
    credentialsQuery[(__bridge id)kSecReturnData] = (__bridge id)kCFBooleanTrue;
    
    OSStatus keychainErr = noErr;
    
    CFMutableDictionaryRef responseDictCF = nil;
    
    // search keychain for existing credentials
    keychainErr = SecItemCopyMatching((__bridge CFDictionaryRef)credentialsQuery, (CFTypeRef *)&responseDictCF);
    
    // if stored credentials exist
    if(keychainErr == noErr) {
        
        NSMutableDictionary *responseDict = (__bridge NSMutableDictionary *)responseDictCF;
        
        // parse account username
        NSString *username = responseDict[(__bridge id)kSecAttrAccount];
        
        NSData *passwordData = responseDict[(__bridge id)kSecValueData];
        if(passwordData) {
            NSString *password = [[NSString alloc] initWithData:passwordData encoding:NSUTF8StringEncoding];
            
            if(username.length > 0 && passwordData.length > 0) {
                
                // successfully retrieved credentials
                
                ret = @{@"username":username,
                        @"password":password
                        };
            }
        }
    }
    
    return ret;
}

+ (BOOL)deleteStoredCredentials {
    
    // create the dictionary used to query for user credentials
    NSMutableDictionary *credentialsQuery = [NSMutableDictionary dictionary];
    
    credentialsQuery[(__bridge id)kSecClass] = (__bridge id)kSecClassInternetPassword;
    credentialsQuery[(__bridge id)kSecMatchLimit] = (__bridge id)kSecMatchLimitOne;
    credentialsQuery[(__bridge id)kSecReturnAttributes] = (__bridge id)kCFBooleanTrue;
    
    OSStatus keychainErr = noErr;
    
    CFMutableDictionaryRef attributes = nil;
    NSMutableDictionary *deleteItemQuery = nil;
    
    // search keychain for existing credentials
    keychainErr = SecItemCopyMatching((__bridge CFDictionaryRef)credentialsQuery, (CFTypeRef *)&attributes);
    
    // if stored credentials exist
    if(keychainErr == noErr) {
        
        // create query for returned item by attributes
        deleteItemQuery = [NSMutableDictionary dictionaryWithDictionary:(__bridge_transfer NSDictionary *)attributes];
        
        // add class to item query
        deleteItemQuery[(__bridge id)kSecClass] = (__bridge id)kSecClassInternetPassword;
        
        // delete stored credentials
        keychainErr = SecItemDelete((__bridge CFDictionaryRef)deleteItemQuery);
        
        if(keychainErr != noErr) {
            NSLog(@"Error deleting item from keychain: %d", (int)keychainErr);
        }
        else {
            NSLog(@"Successfully deleted item from keychain!");
        }
    }
    else {
        NSLog(@"No matching credentials found");
    }
    
    return (keychainErr == noErr);
}

@end
