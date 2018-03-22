//
//  RSOSResponseStatusDataModel.h
//  Emergency Reference Application
//
//  Created by Chris Lin on 11/30/17.
//  Copyright © 2017 RapidSOS. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger,RSOSHTTPResponseCode) {
    RSOSHTTPResponseCodeUnknown = 0,
    RSOSHTTPResponseCodeOK = 200,
    RSOSHTTPResponseCodeCreated = 201,
    RSOSHTTPResponseCodeAccepted = 202,
    RSOSHTTPResponseCodeNoContent = 204,
    RSOSHTTPResponseCodeBadRequest = 400,
    RSOSHTTPResponseCodeUnauthorized = 401,
    RSOSHTTPResponseCodeForbidden = 403,
    RSOSHTTPResponseCodeNotFound = 404,
    RSOSHTTPResponseCodeRequestTimeout = 408,
    RSOSHTTPResponseCodeThrottle = 429,
    RSOSHTTPResponseCodeServerError = 500,
    RSOSHTTPResponseCodeBadGateway = 502,
    RSOSHTTPResponseCodeUnavailable = 503
};

@interface RSOSResponseStatusDataModel : NSObject

@property (assign, atomic) RSOSHTTPResponseCode status;
@property (strong, nonatomic) NSString * _Nullable message;

- (instancetype _Nonnull)initWithTask:(NSURLSessionDataTask  * _Nullable )task response:(id _Nullable)responseObject error:(NSError * _Null_unspecified)error;
- (void)setWithDictionary:(NSDictionary * _Nullable) dict;

#pragma mark - Error Analysis

- (void)analyzeResponseWithTask:(NSURLSessionDataTask  * _Nullable )task response:(id _Nullable)responseObject error:(NSError * _Null_unspecified)error;

#pragma mark - Utils

- (BOOL)isSuccess;
- (NSString * _Nullable)getErrorMessage;

@end

NS_ASSUME_NONNULL_END
