//
//  RSOSDataEmergencyContact.m
//  Emergency Reference Application
//
//  Created by Chris Lin on 11/30/17.
//  Copyright © 2017 RapidSOS. All rights reserved.
//

#import "RSOSDataEmergencyContact.h"
#import "RSOSUtils.h"

@implementation RSOSDataEmergencyContact

- (instancetype)init {
    self = [super init];
    if (self){
        self.emailAddress = @"";
        self.fullName = @"";
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
    
    self.emailAddress = [RSOSUtilsString refineNSString:[dict objectForKey:@"email"]];
    self.fullName = [RSOSUtilsString refineNSString:[dict objectForKey:@"full_name"]];
    self.label = [RSOSUtilsString refineNSString:[dict objectForKey:@"label"]];
    self.note = [RSOSUtilsString refineNSString:[dict objectForKey:@"note"]];
    self.phoneNumber = [RSOSUtilsString refineNSString:[dict objectForKey:@"phone"]];
}

- (NSDictionary *)serializeToDictionary {
    NSMutableDictionary *ret = [NSMutableDictionary dictionaryWithDictionary:[super serializeToDictionary]];
    
    [ret setValuesForKeysWithDictionary:
     @{@"email": self.emailAddress,
       @"full_name": self.fullName,
       @"label": self.label,
       @"note": self.note,
       @"phone": [RSOSUtilsString normalizePhoneNumber:self.phoneNumber prefix:@"+"],
       }];
    
    return [NSDictionary dictionaryWithDictionary:ret];
}

@end
