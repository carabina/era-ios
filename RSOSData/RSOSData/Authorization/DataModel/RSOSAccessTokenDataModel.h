//
//  RSOSAccessTokenDataModel.h
//  Emergency Reference Application
//
//  Created by Chris Lin on 12/16/17.
//  Copyright © 2017 RapidSOS. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RSOSAccessTokenDataModel : NSObject

@property (strong, nonatomic) NSString *accessToken;
@property (strong, nonatomic) NSString *tokenType;
@property (strong, nonatomic, nullable) NSDate *dateIssued;
@property (assign, atomic) int expiresIn;
@property (strong, nonatomic) NSString *refreshToken;

- (instancetype)initWithDictionary:(NSDictionary *)dict;

- (void)initialize;

- (void)setWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)serializeToDictionary;
- (NSString *)getAuthorizationToken;
- (BOOL)isTokenExpired;

@end

NS_ASSUME_NONNULL_END
