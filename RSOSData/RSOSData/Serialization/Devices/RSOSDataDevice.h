//
//  RSOSDataDevice.h
//  RSOSData
//
//  Created by Chris Lin on 2/27/18.
//  Copyright © 2018 RapidSOS. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "RSOSDataObject.h"
#import "RSOSDataRealtimeMetric.h"
#import "RSOSDataPhoneNumber.h"
#import "RSOSDataPhoto.h"
#import "RSOSDataUniqueDeviceID.h"
#import "RSOSDataVideoFeed.h"

NS_ASSUME_NONNULL_BEGIN

@interface RSOSDataDevice : NSObject <RSOSDataSerializable>

@property (strong, nonatomic) NSString *deviceID;

@property (strong, nonatomic) RSOSDataObject<RSOSDataRealtimeMetric *> *batteryPower;
@property (strong, nonatomic) RSOSDataObject<RSOSDataRealtimeMetric *> *bloodGlucose;
@property (strong, nonatomic) RSOSDataObject<RSOSDataRealtimeMetric *> *bloodOxygenSaturation;
@property (strong, nonatomic) RSOSDataObject<RSOSDataRealtimeMetric *> *bodyTemperature;
@property (strong, nonatomic) RSOSDataObject<RSOSDataPhoneNumber *> *callbackPhone;
@property (strong, nonatomic) RSOSDataObject<NSString *> *classification;
@property (strong, nonatomic) RSOSDataObject<NSString *> *color;
@property (strong, nonatomic) RSOSDataObject<NSString *> *comment;
@property (strong, nonatomic) RSOSDataObject<RSOSDataPhoto *> *crashPulse;
@property (strong, nonatomic) RSOSDataObject<NSString *> *deviceName;
@property (strong, nonatomic) RSOSDataObject<RSOSDataPhoto *> *ekg12;
@property (strong, nonatomic) RSOSDataObject<RSOSDataPhoto *> *ekg4;
@property (strong, nonatomic) RSOSDataObject<NSString *> *hardwareDescription;
@property (strong, nonatomic) RSOSDataObject<RSOSDataRealtimeMetric *> *heartRate;
@property (strong, nonatomic) RSOSDataObject<NSString *> *licensePlate;
@property (strong, nonatomic) RSOSDataObject<NSString *> *manufacturer;
@property (strong, nonatomic) RSOSDataObject<NSString *> *model;
@property (strong, nonatomic) RSOSDataObject<NSString *> *networkCarrierRegistration;
@property (strong, nonatomic) RSOSDataObject<RSOSDataRealtimeMetric *> *respiratoryRate;
@property (strong, nonatomic) RSOSDataObject<RSOSDataRealtimeMetric *> *stepsTaken;
@property (strong, nonatomic) RSOSDataObject<RSOSDataUniqueDeviceID *> *uniqueID;
@property (strong, nonatomic) RSOSDataObject<NSString *> *userAgent;
@property (strong, nonatomic) RSOSDataObject<RSOSDataVideoFeed *> *videoFeed;

@end

NS_ASSUME_NONNULL_END
