//
//  RSOSDataObject.m
//  EmergencyReferenceApp
//
//  Created by Gabe Mahoney on 1/31/18.
//  Copyright © 2018 RapidSOS. All rights reserved.
//

#import "RSOSDataObject.h"
#import "RSOSDataSerialization.h"
#import "RSOSUtils.h"

@implementation RSOSDataObject

- (instancetype) init {
    
    self = [super init];
    
    if (self) {
        self.values = [NSMutableArray array];
    }
    return self;
}

- (instancetype)initWithDisplayName:(NSString *)name type:(NSString *)type {
    self = [self init];
    if(self) {
        self.displayName = name;
        self.type = type;
        self.units = nil;
    }
    return self;
}

- (instancetype)initWithDisplayName:(NSString *)name type:(NSString *)type units: (NSString *) units{
    self = [self init];
    if(self) {
        self.displayName = name;
        self.type = type;
        self.units = units;
    }
    return self;
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [self init];
    
    if (self) {
        [self setWithDictionary:dict];
    }
    return self;
}

#pragma mark - Serialization

- (void)setWithDictionary:(NSDictionary *)dict {
    
    self.displayName = [RSOSUtilsString refineNSString: [dict objectForKey:@"display_name"]];
    self.type = [RSOSUtilsString refineNSString: [dict objectForKey:@"type"]];
    
    if(dict[@"units"]) {
        self.units = [RSOSUtilsString refineNSString: [dict objectForKey:@"units"]];
    }
    
    [self.values removeAllObjects];
    
    NSArray *valueDicts = dict[@"value"];
    
    NSString *objectType = self.type;
    NSArray *newValues = [RSOSDataSerialization deserializeValuesArray:valueDicts objectType:objectType];
    
    if(!self.values) {
        self.values = [NSMutableArray array];
    }
    
    [self.values addObjectsFromArray:newValues];
    
}

- (NSDictionary *)serializeToDictionary {
    NSMutableDictionary *ret = [NSMutableDictionary dictionary];
    
    ret[@"display_name"] = self.displayName;
    ret[@"type"] = self.type;
    
    if(self.units) {
        ret[@"units"] = self.units;
    }
    
    NSString *objectType = self.type;
    ret[@"value"] = [RSOSDataSerialization serializeValuesArray:self.values objectType:objectType];
    
    return [NSDictionary dictionaryWithDictionary:ret];
}

- (id)getPrimaryValue {
    if(self.values.count > 0) {
        return self.values[0];
    }
    return nil;
}

- (void)setPrimaryValue:(id)value {
    
    [self.values removeAllObjects];
    [self.values addObject:value];
}

- (void) addValue: (id) value{
    [self.values addObject:value];
}

- (void) replaceValueAtIndex: (int) index withValue: (id) value{
    [self.values replaceObjectAtIndex:index withObject:value];
}

- (void)deletePrimaryValue {
    
    [self.values removeAllObjects];
}

- (void) deleteValueAtIndex: (int) index{
    [self.values removeObjectAtIndex:index];
}

- (BOOL)isSet {
    return ([self.values count] > 0);
}

@end
