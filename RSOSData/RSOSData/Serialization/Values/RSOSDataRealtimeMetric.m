//
//  RSOSDataRealtimeMetric.m
//  RSOSData
//
//  Created by Gabe Mahoney on 2/14/18.
//  Copyright © 2018 RapidSOS. All rights reserved.
//

#import "RSOSDataRealtimeMetric.h"
#import "RSOSUtils.h"

@implementation RSOSDataRealtimeMetric

- (instancetype)init {
    
    self = [super init];
    
    if (self) {
        self.label = @"";
        self.dataFeed = @"";
        self.protocol = RSOSDataProtocolHTTPS;
        self.note = @"";
    }
    return self;
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        [self setWithDictionary:dict];
    }
    return self;
}

- (void)setWithDictionary:(NSDictionary *)dict {
    [super setWithDictionary:dict];
    
    self.label = [RSOSUtilsString refineNSString:[dict objectForKey:@"label"]];
    self.dataFeed = [RSOSUtilsString refineNSString:[dict objectForKey:@"data_feed"]];
    self.protocol = RSOSDataProtocolFromNSString([RSOSUtilsString refineNSString:[dict objectForKey:@"protocol"]]);
    self.note = [RSOSUtilsString refineNSString:[dict objectForKey:@"note"]];
}

- (NSDictionary *)serializeToDictionary {
    
    NSMutableDictionary *ret = [NSMutableDictionary dictionaryWithDictionary:[super serializeToDictionary]];
    
    [ret setValuesForKeysWithDictionary:
     @{@"label": self.label,
       @"data_feed": self.dataFeed,
       @"protocol": NSStringFromRSOSDataProtocol(self.protocol),
       @"note": self.note,
       }];
    
    return [NSDictionary dictionaryWithDictionary:ret];
}

- (NSString *)protocolString {
    return NSStringFromRSOSDataProtocol(self.protocol);
}

NSString * NSStringFromRSOSDataProtocol(RSOSDataProtocol protocol) {
    
    switch (protocol) {
            
        case RSOSDataProtocolHTTP:
            return @"http";
            break;
            
        case RSOSDataProtocolWS:
            return @"ws";
            break;
            
        case RSOSDataProtocolWSS:
            return @"wss";
            break;
            
        case RSOSDataProtocolHTTPS:
        default:
            return @"https";
            break;
    }
}

RSOSDataProtocol RSOSDataProtocolFromNSString(NSString * string) {
    
    if([[string uppercaseString] isEqualToString:@"HTTP"]) {
        return RSOSDataProtocolHTTP;
    }
    else if([[string uppercaseString] isEqualToString:@"WS"]) {
        return RSOSDataProtocolWS;
    }
    else if([[string uppercaseString] isEqualToString:@"WSS"]) {
        return RSOSDataProtocolWSS;
    }
    else {
        // default
        return RSOSDataProtocolHTTPS;
    }
}

@end
