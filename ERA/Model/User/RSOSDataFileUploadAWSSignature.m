//
//  RSOSDataFileUploadAWSSignature.m
//  RSOSData
//
//  Created by Chris Lin on 2/22/18.
//  Copyright © 2018 RapidSOS. All rights reserved.
//

#import "RSOSDataFileUploadAWSSignature.h"
#import "RSOSUtils.h"

@implementation RSOSDataFileUploadAWSSignature

- (instancetype)init {
    self = [super init];
    if (self){
        [self initialize];
    }
    return self;
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    if (self){
        [self setWithDictionary:dict];
    }
    return self;
}

- (void)initialize{
    self.uploadUrl = @"https://kronos-images.s3.amazonaws.com/";
    self.accessKeyId = @"";
    self.key = @"";
    self.policy = @"";
    self.signature = @"";
    self.securityToken = @"";
}

- (void)setWithDictionary:(NSDictionary *)dict {
    [self initialize];
    
    if (dict == nil) return;
    self.uploadUrl = [RSOSUtilsString refineNSString:[dict objectForKey:@"url"]];
    
    NSDictionary *fields = [dict objectForKey:@"fields"];
    if (fields == nil) return;
    
    self.accessKeyId = [RSOSUtilsString refineNSString:[fields objectForKey:@"AWSAccessKeyId"]];
    self.key = [RSOSUtilsString refineNSString:[fields objectForKey:@"key"]];
    self.policy = [RSOSUtilsString refineNSString:[fields objectForKey:@"policy"]];
    self.signature = [RSOSUtilsString refineNSString:[fields objectForKey:@"signature"]];
    self.securityToken = [RSOSUtilsString refineNSString:[fields objectForKey:@"x-amz-security-token"]];
}

@end
