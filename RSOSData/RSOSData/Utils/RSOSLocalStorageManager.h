//
//  RSOSLocalStorageManager.h
//  Emergency Reference Application
//
//  Created by Chris Lin on 12/1/17.
//  Copyright © 2017 RapidSOS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RSOSLocalStorageManager : NSObject

+ (void)saveObject:(id)obj key:(NSString *)key;
+ (id)loadObjectForKey:(NSString *)key;
+ (void)removeObjectForKey:(NSString *)key;

@end
