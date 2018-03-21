//
//  RSOSDataEmail.m
//  Emergency Reference Application
//
//  Created by Chris Lin on 11/30/17.
//  Copyright © 2017 RapidSOS. All rights reserved.
//

#import "RSOSDataEmail.h"
#import "RSOSUtils.h"

@implementation RSOSDataEmail

- (instancetype) init{
    self = [super init];
    if (self){
        self.emailAddress = @"";
        self.label = @"";
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

- (void) setWithDictionary: (NSDictionary *) dict {
    [super setWithDictionary:dict];
    
    self.emailAddress = [RSOSUtilsString refineNSString:[dict objectForKey:@"email_address"]];
    self.label = [RSOSUtilsString refineNSString:[dict objectForKey:@"label"]];
    self.note = [RSOSUtilsString refineNSString:[dict objectForKey:@"note"]];
}

- (NSDictionary *) serializeToDictionary {
    NSMutableDictionary *ret = [NSMutableDictionary dictionaryWithDictionary:[super serializeToDictionary]];
    
    [ret setValuesForKeysWithDictionary:
     @{@"email_address": self.emailAddress,
       @"label": self.label,
       @"note": self.note,
       }];
    
    return [NSDictionary dictionaryWithDictionary:ret];
}

@end
