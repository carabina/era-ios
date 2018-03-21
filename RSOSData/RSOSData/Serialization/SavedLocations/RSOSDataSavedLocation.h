//
//  RSOSDataSavedLocation.h
//  EmergencyReferenceApp
//
//  Created by Gabe Mahoney on 1/23/18.
//  Copyright © 2018 rapidsos. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "RSOSDataObject.h"
#import "RSOSDataAddress.h"
#import "RSOSDataAnimal.h"
#import "RSOSDataURL.h"
#import "RSOSDataPhoto.h"
#import "RSOSDataEmergencyContact.h"
#import "RSOSDataVideoFeed.h"

NS_ASSUME_NONNULL_BEGIN

@interface RSOSDataSavedLocation : NSObject <RSOSDataSerializable>

@property (strong, nonatomic) NSString *locationID;

@property (strong, nonatomic) RSOSDataObject<RSOSDataAddress *> *addresses;
@property (strong, nonatomic) RSOSDataObject<RSOSDataAnimal *> *animal;
@property (strong, nonatomic) RSOSDataObject<NSString *> *comment;
@property (strong, nonatomic) RSOSDataObject<RSOSDataURL *> *externalDataPortal;
@property (strong, nonatomic) RSOSDataObject<RSOSDataVideoFeed *> *fixedVideoFeed;
@property (strong, nonatomic) RSOSDataObject<RSOSDataPhoto *> *floorPlan;
@property (strong, nonatomic) RSOSDataObject<RSOSDataEmergencyContact *> *locationContact;
@property (strong, nonatomic) RSOSDataObject<NSString *> *locationName;
@property (strong, nonatomic) RSOSDataObject<RSOSDataVideoFeed *> *mobileVideoFeed;

- (BOOL)savedToRemote;

@end

NS_ASSUME_NONNULL_END
