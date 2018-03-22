//
//  RSOSDataAddress.m
//  Emergency Reference Application
//
//  Created by Chris Lin on 11/30/17.
//  Copyright © 2017 RapidSOS. All rights reserved.
//

#import "RSOSDataAddress.h"
#import "RSOSUtils.h"

@implementation RSOSDataAddress

- (instancetype) init{
    self = [super init];
    if (self) {
        self.countryCode = @"";
        self.label = @"";
        self.latitude = 0;
        self.longitude = 0;
        self.locality = @"";
        self.postalCode = @"";
        self.region = @"";
        self.streetAddress = @"";
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
    
    self.countryCode = [RSOSUtilsString refineNSString:[dict objectForKey:@"country_code"]];
    self.label = [RSOSUtilsString refineNSString:[dict objectForKey:@"label"]];
    self.latitude = [RSOSUtilsString refineFloat:[dict objectForKey:@"latitude"] defaultValue:0];
    self.longitude = [RSOSUtilsString refineFloat:[dict objectForKey:@"longitude"] defaultValue:0];
    self.locality = [RSOSUtilsString refineNSString:[dict objectForKey:@"locality"]];
    self.postalCode = [RSOSUtilsString refineNSString:[dict objectForKey:@"postal_code"]];
    self.region = [RSOSUtilsString refineNSString:[dict objectForKey:@"region"]];
    self.streetAddress = [RSOSUtilsString refineNSString:[dict objectForKey:@"street_address"]];
    self.note = [RSOSUtilsString refineNSString:[dict objectForKey:@"note"]];
}

- (NSDictionary *) serializeToDictionary {
    
    NSMutableDictionary *ret = [NSMutableDictionary dictionaryWithDictionary:[super serializeToDictionary]];
    
    [ret setValuesForKeysWithDictionary:
     @{@"country_code": self.countryCode,
       @"label": self.label,
       @"latitude": [NSString stringWithFormat:@"%.6f", self.latitude],
       @"longitude": [NSString stringWithFormat:@"%.6f", self.longitude],
       @"locality": self.locality,
       @"postal_code": self.postalCode,
       @"region": self.region,
       @"street_address": self.streetAddress,
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
