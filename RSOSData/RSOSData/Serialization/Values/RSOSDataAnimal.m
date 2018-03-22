//
//  RSOSDataAnimal.m
//  RSOSData
//
//  Created by Gabe Mahoney on 2/14/18.
//  Copyright © 2018 RapidSOS. All rights reserved.
//

#import "RSOSDataAnimal.h"
#import "RSOSUtils.h"

@implementation RSOSDataAnimal

- (instancetype) init{
    self = [super init];
    if (self) {
        self.label = @"";
        self.fullName = @"";
        self.species = @"";
        self.photo = @"";
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
    self.fullName = [RSOSUtilsString refineNSString:[dict objectForKey:@"full_name"]];
    self.species = [RSOSUtilsString refineNSString:[dict objectForKey:@"species"]];
    self.photo = [RSOSUtilsString refineNSString:[dict objectForKey:@"photo"]];
    self.note = [RSOSUtilsString refineNSString:[dict objectForKey:@"note"]];
}

- (NSDictionary *) serializeToDictionary {
    
    NSMutableDictionary *ret = [NSMutableDictionary dictionaryWithDictionary:[super serializeToDictionary]];
    
    [ret setValuesForKeysWithDictionary:
     @{@"label": self.label,
       @"full_name": self.fullName,
       @"species": self.species,
       @"photo": self.photo,
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
