//
//  RSOSDataPhoneNumber.m
//  Emergency Reference Application
//
//  Created by Chris Lin on 11/30/17.
//  Copyright © 2017 RapidSOS. All rights reserved.
//

#import "RSOSDataPhoneNumber.h"
#import "RSOSUtils.h"

@implementation RSOSDataPhoneNumber

- (instancetype)init {
    self = [super init];
    if (self) {
        self.label = @"";
        self.note = @"";
        self.phoneNumber = @"";
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
    self.note = [RSOSUtilsString refineNSString:[dict objectForKey:@"note"]];
    self.phoneNumber = [RSOSUtilsString refineNSString:[dict objectForKey:@"number"]];
}

- (NSDictionary *)serializeToDictionary {
    NSMutableDictionary *ret = [NSMutableDictionary dictionaryWithDictionary:[super serializeToDictionary]];
    
    [ret setValuesForKeysWithDictionary:
     @{@"label": self.label,
       @"note": self.note,
       @"number": [RSOSUtilsString normalizePhoneNumber:self.phoneNumber prefix:@"+"],
       }];
    
    return [NSDictionary dictionaryWithDictionary:ret];
}

@end
