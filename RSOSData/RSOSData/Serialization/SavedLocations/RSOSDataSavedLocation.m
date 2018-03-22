//
//  RSOSDataSavedLocation.m
//  EmergencyReferenceApp
//
//  Created by Gabe Mahoney on 1/23/18.
//  Copyright © 2018 rapidsos. All rights reserved.
//

#import "RSOSDataSavedLocation.h"

#import "RSOSUtilsString.h"

@implementation RSOSDataSavedLocation

- (instancetype) init{
    self = [super init];
    if (self){
        [self initialize];
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

- (void) initialize{
    
    self.locationID = @"";
    self.addresses = [[RSOSDataObject alloc] initWithDisplayName:@"Home Address" type:@"address"];
    self.animal = [[RSOSDataObject alloc] initWithDisplayName:@"Animals" type:@"animal"];
    self.comment = [[RSOSDataObject alloc] initWithDisplayName:@"Comments" type:@"string"];
    self.externalDataPortal = [[RSOSDataObject alloc] initWithDisplayName:@"Additional Location Information" type:@"web-url"];
    self.fixedVideoFeed = [[RSOSDataObject alloc] initWithDisplayName:@"Video Feed" type:@"video-stream"];
    self.floorPlan = [[RSOSDataObject alloc] initWithDisplayName:@"Floor Plans" type:@"image-url"];
    self.locationContact = [[RSOSDataObject alloc] initWithDisplayName:@"Emergency Contacts" type:@"emergency-contact"];
    self.locationName = [[RSOSDataObject alloc] initWithDisplayName:@"Location Names" type:@"string"];
    self.mobileVideoFeed = [[RSOSDataObject alloc] initWithDisplayName:@"Video Feed" type:@"video-stream"];
}


- (void)setWithDictionary:(NSDictionary *)dict {
    [self initialize];
    
    self.locationID = [RSOSUtilsString refineNSString:[dict objectForKey:@"id"]];
    
    NSDictionary *dictAddress = [dict objectForKey:@"address"];
    NSDictionary *dictAnimal = [dict objectForKey:@"animal"];
    NSDictionary *dictComment = [dict objectForKey:@"comment"];
    NSDictionary *dictExternalDataPortal = [dict objectForKey:@"external_data_portal"];
    NSDictionary *dictFixedVideoFeed = [dict objectForKey:@"fixed_video_feed"];
    NSDictionary *dictFloorPlan = [dict objectForKey:@"floor_plan"];
    NSDictionary *dictLocationContact = [dict objectForKey:@"location_contact"];
    NSDictionary *dictLocationName = [dict objectForKey:@"location_name"];
    NSDictionary *dictMobileVideoFeed = [dict objectForKey:@"mobile_video_feed"];
    
    if (dictAddress != nil && [dictAddress isKindOfClass:[NSDictionary class]] == YES) {
        [self.addresses setWithDictionary:dictAddress];
    }
    if (dictAnimal != nil && [dictAnimal isKindOfClass:[NSDictionary class]] == YES) {
        [self.animal setWithDictionary:dictAnimal];
    }
    if (dictComment != nil && [dictComment isKindOfClass:[NSDictionary class]] == YES) {
        [self.comment setWithDictionary:dictComment];
    }
    if (dictExternalDataPortal != nil && [dictExternalDataPortal isKindOfClass:[NSDictionary class]] == YES) {
        [self.externalDataPortal setWithDictionary:dictExternalDataPortal];
    }
    if (dictFixedVideoFeed != nil && [dictFixedVideoFeed isKindOfClass:[NSDictionary class]] == YES) {
        [self.fixedVideoFeed setWithDictionary:dictFixedVideoFeed];
    }
    if (dictFloorPlan != nil && [dictFloorPlan isKindOfClass:[NSDictionary class]] == YES) {
        [self.floorPlan setWithDictionary:dictFloorPlan];
    }
    if (dictLocationContact != nil && [dictLocationContact isKindOfClass:[NSDictionary class]] == YES) {
        [self.locationContact setWithDictionary:dictLocationContact];
    }
    if (dictLocationName != nil && [dictLocationName isKindOfClass:[NSDictionary class]] == YES) {
        [self.locationName setWithDictionary:dictLocationName];
    }
    if (dictMobileVideoFeed != nil && [dictMobileVideoFeed isKindOfClass:[NSDictionary class]] == YES) {
        [self.mobileVideoFeed setWithDictionary:dictMobileVideoFeed];
    }
}

- (NSDictionary *)serializeToDictionary {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    if (self.locationID != nil & self.locationID.length > 0) {
        [dict setObject:self.locationID forKey:@"id"];
    }
    
    if ([self.addresses isSet] == YES) {
        [dict setObject:[self.addresses serializeToDictionary] forKey:@"address"];
    }
    if ([self.animal isSet] == YES) {
        [dict setObject:[self.animal serializeToDictionary] forKey:@"animal"];
    }
    if ([self.comment isSet] == YES) {
        [dict setObject:[self.comment serializeToDictionary] forKey:@"comment"];
    }
    if ([self.externalDataPortal isSet] == YES) {
        [dict setObject:[self.externalDataPortal serializeToDictionary] forKey:@"external_data_portal"];
    }
    if ([self.fixedVideoFeed isSet] == YES) {
        [dict setObject:[self.fixedVideoFeed serializeToDictionary] forKey:@"fixed_video_feed"];
    }
    if ([self.floorPlan isSet] == YES) {
        [dict setObject:[self.floorPlan serializeToDictionary] forKey:@"floor_plan"];
    }
    if ([self.locationContact isSet] == YES) {
        [dict setObject:[self.locationContact serializeToDictionary] forKey:@"location_contact"];
    }
    if ([self.locationName isSet] == YES) {
        [dict setObject:[self.locationName serializeToDictionary] forKey:@"location_name"];
    }
    if ([self.mobileVideoFeed isSet] == YES) {
        [dict setObject:[self.mobileVideoFeed serializeToDictionary] forKey:@"mobile_video_feed"];
    }
    
    return dict;
}

- (BOOL)savedToRemote {
    return (self.locationID != nil && self.locationID.length > 0);
}

@end
