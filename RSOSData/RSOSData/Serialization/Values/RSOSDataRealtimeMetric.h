//
//  RSOSDataRealtimeMetric.h
//  RSOSData
//
//  Created by Gabe Mahoney on 2/14/18.
//  Copyright © 2018 RapidSOS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RSOSDataValue.h"


NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, RSOSDataProtocol) {
    RSOSDataProtocolHTTP,
    RSOSDataProtocolHTTPS,
    RSOSDataProtocolWS,
    RSOSDataProtocolWSS
};

@interface RSOSDataRealtimeMetric : RSOSDataValue

@property (strong, nonatomic) NSString *label;
@property (strong, nonatomic) NSString *dataFeed;
@property (nonatomic) RSOSDataProtocol protocol;
@property (strong, nonatomic) NSString *note;

- (NSString *)protocolString;

FOUNDATION_EXPORT NSString * NSStringFromRSOSDataProtocol(RSOSDataProtocol protocol);
FOUNDATION_EXPORT RSOSDataProtocol RSOSDataProtocolFromNSString(NSString * string);

@end

NS_ASSUME_NONNULL_END
