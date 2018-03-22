//
//  RSOSDataPhoto.m
//  RSOSData
//
//  Created by Chris Lin on 2/22/18.
//  Copyright © 2018 RapidSOS. All rights reserved.
//

#import "RSOSDataPhoto.h"
#import "RSOSUtils.h"

@implementation RSOSDataPhoto

- (instancetype)init {
    self = [super init];
    if (self) {
        self.label = @"kronos_profile_pic";
        self.note = @"";
        self.url = @"";
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
    self.url = [RSOSUtilsString refineNSString:[dict objectForKey:@"url"]];
}

- (NSDictionary *)serializeToDictionary {
    NSMutableDictionary *ret = [NSMutableDictionary dictionaryWithDictionary:[super serializeToDictionary]];
    
    [ret setValuesForKeysWithDictionary:
     @{@"label": self.label,
       @"note": self.note,
       @"url": self.url,
       }];
    
    return [NSDictionary dictionaryWithDictionary:ret];
}

@end
