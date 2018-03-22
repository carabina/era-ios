//
//  RSOSCredentialStorage.h
//  Emergency Reference Application
//
//  Created by Gabe Mahoney on 1/3/18.
//  Copyright © 2018 rapidsos. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RSOSCredentialStorage : NSObject

+ (BOOL)storeCredentials:(NSDictionary *)credentials;
+ (NSDictionary *)loadStoredCredentials;
+ (BOOL)deleteStoredCredentials;

@end

NS_ASSUME_NONNULL_END
