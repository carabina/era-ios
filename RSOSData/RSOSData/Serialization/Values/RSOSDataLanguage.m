//
//  RSOSDataLanguage.m
//  RSOSData
//
//  Created by Gabe Mahoney on 2/14/18.
//  Copyright © 2018 RapidSOS. All rights reserved.
//

#import "RSOSDataLanguage.h"
#import "RSOSUtils.h"

@implementation RSOSDataLanguage

- (instancetype) init{
    self = [super init];
    if (self){
        self.languageCode = @"en";
        self.preference = 0;
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
    
    self.languageCode = [RSOSUtilsString refineNSString:[dict objectForKey:@"language_code"]];
    self.preference = [RSOSUtilsString refineInt:[dict objectForKey:@"preference"] defaultValue:0];
}

- (NSDictionary *) serializeToDictionary {
    NSMutableDictionary *ret = [NSMutableDictionary dictionaryWithDictionary:[super serializeToDictionary]];
    
    [ret setValuesForKeysWithDictionary:
     @{@"language_code": self.languageCode,
       @"preference": @(self.preference),
       }];
    
    return [NSDictionary dictionaryWithDictionary:ret];
}

@end
