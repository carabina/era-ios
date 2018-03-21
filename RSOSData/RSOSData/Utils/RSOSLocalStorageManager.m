//
//  RSOSLocalStorageManager.m
//  Emergency Reference Application
//
//  Created by Chris Lin on 12/1/17.
//  Copyright © 2017 RapidSOS. All rights reserved.
//

#import "RSOSLocalStorageManager.h"

NSString * const RSOSLocalStoragePrefix = @"RSOS_LOCALSTORAGE_";

@implementation RSOSLocalStorageManager

+ (void)saveObject:(id)obj key:(NSString *)key {
    NSString *szKey = [NSString stringWithFormat:@"%@%@", RSOSLocalStoragePrefix, key];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:obj forKey:szKey];
    [userDefaults synchronize];
}

+ (id)loadObjectForKey:(NSString *)key {
    NSString *szKey = [NSString stringWithFormat:@"%@%@", RSOSLocalStoragePrefix, key];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults objectForKey:szKey];
}

+ (void)removeObjectForKey:(NSString *)key {
    NSString *szKey = [NSString stringWithFormat:@"%@%@", RSOSLocalStoragePrefix, key];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:szKey];
    [userDefaults synchronize];
}

@end
