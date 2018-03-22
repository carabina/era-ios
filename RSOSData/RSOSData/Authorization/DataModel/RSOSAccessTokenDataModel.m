//
//  RSOSAccessTokenDataModel.m
//  Emergency Reference Application
//
//  Created by Chris Lin on 12/16/17.
//  Copyright © 2017 RapidSOS. All rights reserved.
//

#import "RSOSAccessTokenDataModel.h"
#import "RSOSUtils.h"

@implementation RSOSAccessTokenDataModel

- (instancetype) init{
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    
    if (self) {
        [self initialize];
        [self setWithDictionary:dict];
    }
    return self;
}

- (void)initialize {
    self.accessToken = @"";
    self.tokenType = @"";
    self.dateIssued = nil;
    self.expiresIn = 0;
    self.refreshToken = @"";
}

- (void)setWithDictionary:(NSDictionary *)dict {
    
    self.accessToken = [RSOSUtilsString refineNSString:[dict objectForKey:@"access_token"]];
    self.tokenType = [RSOSUtilsString refineNSString:[dict objectForKey:@"token_type"]];
    self.expiresIn = [RSOSUtilsString refineInt:[dict objectForKey:@"expires_in"] defaultValue:0];
    self.refreshToken = [RSOSUtilsString refineNSString:[dict objectForKey:@"refresh_token"]];
    
    NSTimeInterval interval = [[dict objectForKey:@"issued_at"] doubleValue] / 1000;
    self.dateIssued = [NSDate dateWithTimeIntervalSince1970:interval];
}

- (NSDictionary *)serializeToDictionary {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    [dict setObject:self.accessToken forKey:@"access_token"];
    [dict setObject:self.tokenType forKey:@"token_type"];
    [dict setObject:@((long) [self.dateIssued timeIntervalSince1970] * 1000) forKey:@"issued_at"];
    [dict setObject:@(self.expiresIn) forKey:@"expires_in"];
    [dict setObject:self.refreshToken forKey:@"refresh_token"];
    return dict;
}

- (NSString *)getAuthorizationToken {
    return [NSString stringWithFormat:@"Bearer %@", self.accessToken];
}

- (BOOL)isTokenExpired {
    
    // return true for empty or invalid token
    if(!self.self.dateIssued || self.accessToken.length == 0) {
        return YES;
    }
    
    NSDate *dateExpire = [NSDate dateWithTimeInterval:self.expiresIn sinceDate:self.dateIssued];
    if ([dateExpire compare:[NSDate date]] == NSOrderedAscending) return YES;
    return NO;
}

@end
