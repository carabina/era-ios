//
//  RSOSDataURL.m
//  RSOSData
//
//  Created by Gabe Mahoney on 2/14/18.
//  Copyright © 2018 RapidSOS. All rights reserved.
//

#import "RSOSDataURL.h"
#import "RSOSUtils.h"

@implementation RSOSDataURL

- (instancetype) init{
    self = [super init];
    if (self) {
        self.label = @"";
        self.url = @"";
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
    self.note = [RSOSUtilsString refineNSString:[dict objectForKey:@"note"]];
}

- (NSDictionary *) serializeToDictionary {
    
    NSMutableDictionary *ret = [NSMutableDictionary dictionaryWithDictionary:[super serializeToDictionary]];
    
    [ret setValuesForKeysWithDictionary:
     @{@"label": self.label,
       @"url": self.url,
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
