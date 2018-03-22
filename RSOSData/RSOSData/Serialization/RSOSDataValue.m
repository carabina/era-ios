//
//  RSOSDataValue.m
//  EmergencyReferenceApp
//
//  Created by Gabe Mahoney on 1/31/18.
//  Copyright © 2018 RapidSOS. All rights reserved.
//

#import "RSOSDataValue.h"

NSString * const RSOSDataBloodTypeAPositive = @"A+";
NSString * const RSOSDataBloodTypeANegative = @"A-";
NSString * const RSOSDataBloodTypeBPositive = @"B+";
NSString * const RSOSDataBloodTypeBNegative = @"B-";
NSString * const RSOSDataBloodTypeABPositive = @"AB+";
NSString * const RSOSDataBloodTypeABNegative = @"AB-";
NSString * const RSOSDataBloodTypeOPositive = @"O+";
NSString * const RSOSDataBloodTypeONegative = @"O-";

NSString * const RSOSDataDeviceClassificationCordless = @"cordless";
NSString * const RSOSDataDeviceClassificationFixed = @"fixed";
NSString * const RSOSDataDeviceClassificationSatellite = @"satellite";
NSString * const RSOSDataDeviceClassificationSensorFixed = @"sensor-fixed";
NSString * const RSOSDataDeviceClassificationDesktop = @"desktop";
NSString * const RSOSDataDeviceClassificationLaptop = @"laptop";
NSString * const RSOSDataDeviceClassificationTablet = @"tablet";
NSString * const RSOSDataDeviceClassificationAlarmMonitored = @"alarm-monitored";
NSString * const RSOSDataDeviceClassificationSensorMobile = @"sensor-mobile";
NSString * const RSOSDataDeviceClassificationAircraft = @"aircraft";
NSString * const RSOSDataDeviceClassificationAutomobile = @"automobile";
NSString * const RSOSDataDeviceClassificationTruck = @"truck";
NSString * const RSOSDataDeviceClassificationFarm = @"farm";
NSString * const RSOSDataDeviceClassificationMarine = @"marine";
NSString * const RSOSDataDeviceClassificationPersonal = @"personal";
NSString * const RSOSDataDeviceClassificationFeaturePhone = @"feature-phone";
NSString * const RSOSDataDeviceClassificationSmartPhone = @"smart-phone";
NSString * const RSOSDataDeviceClassificationSmartPhoneApp = @"smart-phone-app";
NSString * const RSOSDataDeviceClassificationUnknownDevice = @"unknown-device";
NSString * const RSOSDataDeviceClassificationGame = @"text-only";
NSString * const RSOSDataDeviceClassificationTextOnly = @"game";
NSString * const RSOSDataDeviceClassificationNomadic = @"nomadic";
NSString * const RSOSDataDeviceClassificationMobile = @"mobile";
NSString * const RSOSDataDeviceClassificationVehicle = @"vehicle";
NSString * const RSOSDataDeviceClassificationHome = @"home";
NSString * const RSOSDataDeviceClassificationOther = @"other";
NSString * const RSOSDataDeviceClassificationNA = @"NA";

@implementation RSOSDataValue

- (instancetype) init{
    
    self = [super init];
    
    if (self) {
        
    }
    return self;
}

- (instancetype) initWithDictionary: (NSDictionary *) dict {
    self = [super init];
    
    if (self) {
        [self setWithDictionary:dict];
    }
    return self;
}

- (void)setWithDictionary:(NSDictionary *)dict {

}

- (NSDictionary *)serializeToDictionary {
    return @{};
}

- (NSString *)validate {
    return nil;
}

@end
