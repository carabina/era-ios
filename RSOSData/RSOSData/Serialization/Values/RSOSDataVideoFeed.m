//
//  RSOSDataVideoFeed.m
//  RSOSData
//
//  Created by Chris Lin on 2/23/18.
//  Copyright © 2018 RapidSOS. All rights reserved.
//

#import "RSOSDataVideoFeed.h"
#import "RSOSUtils.h"

@implementation RSOSDataVideoFeed

- (instancetype) init{
    self = [super init];
    if (self) {
        self.label = @"";
        self.url = @"";
        self.format = @"";
        self.latitude = 0;
        self.longitude = 0;
        self.note = @"";
    }
    return self;
}

- (instancetype) initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    if (self){
        [self setWithDictionary:dict];
    }
    return self;
}

- (void)setWithDictionary:(NSDictionary *)dict {
    
    [super setWithDictionary:dict];
    
    self.label = [RSOSUtilsString refineNSString:[dict objectForKey:@"label"]];
    self.url = [RSOSUtilsString refineNSString:[dict objectForKey:@"url"]];
    self.format = [RSOSUtilsString refineNSString:[dict objectForKey:@"format"]];
    self.latitude = [RSOSUtilsString refineFloat:[dict objectForKey:@"latitude"] defaultValue:0];
    self.longitude = [RSOSUtilsString refineFloat:[dict objectForKey:@"longitude"] defaultValue:0];
    self.note = [RSOSUtilsString refineNSString:[dict objectForKey:@"note"]];
}

- (NSDictionary *) serializeToDictionary {
    
    NSMutableDictionary *ret = [NSMutableDictionary dictionaryWithDictionary:[super serializeToDictionary]];
    
    [ret setValuesForKeysWithDictionary:
     @{@"label": self.label,
       @"url": self.url,
       @"format": self.format,
       @"latitude": [NSString stringWithFormat:@"%.6f", self.latitude],
       @"longitude": [NSString stringWithFormat:@"%.6f", self.longitude],
       @"note": self.note,
       }];
    
    return [NSDictionary dictionaryWithDictionary:ret];
}

- (NSString *)validate {
    
    NSString *ret = [super validate];
    if(ret) {
        return ret;
    }
    
    return nil;
}

@end
