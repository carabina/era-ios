//
//  RSOSDataFileUploadAWSSignature.h
//  RSOSData
//
//  Created by Chris Lin on 2/22/18.
//  Copyright © 2018 RapidSOS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RSOSDataFileUploadAWSSignature : NSObject

@property (strong, nonatomic) NSString *uploadUrl;
@property (strong, nonatomic) NSString *accessKeyId;
@property (strong, nonatomic) NSString *key;
@property (strong, nonatomic) NSString *policy;
@property (strong, nonatomic) NSString *signature;
@property (strong, nonatomic) NSString *securityToken;

- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (void)setWithDictionary:(NSDictionary *)dict;

@end
