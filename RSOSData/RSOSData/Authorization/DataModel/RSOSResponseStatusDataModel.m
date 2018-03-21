//
//  RSOSResponseStatusDataModel.m
//  Emergency Reference Application
//
//  Created by Chris Lin on 11/30/17.
//  Copyright © 2017 RapidSOS. All rights reserved.
//

#import "RSOSResponseStatusDataModel.h"
#import "RSOSUtils.h"


#ifndef AFNetworkingOperationFailingURLResponseDataErrorKey
#define AFNetworkingOperationFailingURLResponseDataErrorKey @"com.alamofire.serialization.response.error.data"
#endif

@implementation RSOSResponseStatusDataModel

- (instancetype)init{
    self = [super init];
    if (self){
        [self initialize];
    }
    return self;
}

- (instancetype _Nonnull)initWithTask:(NSURLSessionDataTask  * _Nullable )task response:(id _Nullable)responseObject error:(NSError * _Null_unspecified)error {
    self = [super init];
    if (self){
        [self analyzeResponseWithTask:task response:responseObject error:error];
    }
    return self;
}

- (void)initialize{
    self.status = RSOSHTTPResponseCodeOK;
    self.message = @"";
}

- (void)setWithDictionary:(NSDictionary *)dict {
    self.message = [RSOSUtilsString refineNSString:[dict objectForKey:@"detail"]];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"{\rCode = %d\rMessage = %@\r}", (int)self.status, self.message];
}

#pragma mark - Error Analysis

- (void)analyzeResponseWithTask:(NSURLSessionDataTask  * _Nullable )task response:(id _Nullable)responseObject error:(NSError * _Null_unspecified)error {
    
    self.status = RSOSHTTPResponseCodeUnknown;
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
    
    if ([httpResponse isKindOfClass:[NSHTTPURLResponse class]]) {
        self.status = [RSOSResponseStatusDataModel getHTTPStatusCode:(int)httpResponse.statusCode];
    }
    else {
        self.message = [error.userInfo objectForKey:@"NSLocalizedDescription"];
        return;
    }

    if ([self isSuccess] == YES) {
        self.message = @"Succeeded";
        return;
    }
    
    NSDictionary *dictError = [RSOSResponseStatusDataModel getResponseObjectFromAFError:error];
    
    if (dictError == nil || [dictError isKindOfClass:[NSDictionary class]] == NO){
        
        self.message = @"Sorry, we've encountered an unknown error.";
        return;
    }
    
    self.message = [RSOSUtilsString refineNSString:[dictError objectForKey:@"detail"]];
}

+ (id) getResponseObjectFromAFError: (NSError *) error{
    if (error == nil) return nil;
    
    if ([error.userInfo objectForKey:AFNetworkingOperationFailingURLResponseDataErrorKey] == nil) return nil;
    NSString *errResponse = [[NSString alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding];
    return [RSOSUtilsString getObjectFromJSONStringRepresentation:errResponse];
}

+ (RSOSHTTPResponseCode)getHTTPStatusCode:(int)code {
    switch (code) {
        case 200:
        case 201:
        case 202:
        case 204:
        case 400:
        case 401:
        case 403:
        case 404:
        case 408:
        case 429:
        case 500:
        case 502:
        case 503:
            return (RSOSHTTPResponseCode)code;
            break;
    }
    return RSOSHTTPResponseCodeUnknown;
}

#pragma mark - Utils

- (BOOL)isSuccess {
    if (self.status / 100 == 2) {
        return YES;
    }
    return NO;
}

- (NSString * _Nullable)getErrorMessage {
    
    if ([self isSuccess] == NO && (self.message == nil || self.message.length == 0)) {
        return @"Sorry, we've encountered an error.";
    }
    
    return self.message;
}

@end
