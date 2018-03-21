//
//  RSOSDataValue.h
//  EmergencyReferenceApp
//
//  Created by Gabe Mahoney on 1/31/18.
//  Copyright © 2018 RapidSOS. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "RSOSDataObject.h"

FOUNDATION_EXPORT NSString * const RSOSDataBloodTypeAPositive;
FOUNDATION_EXPORT NSString * const RSOSDataBloodTypeANegative;
FOUNDATION_EXPORT NSString * const RSOSDataBloodTypeBPositive;
FOUNDATION_EXPORT NSString * const RSOSDataBloodTypeBNegative;
FOUNDATION_EXPORT NSString * const RSOSDataBloodTypeABPositive;
FOUNDATION_EXPORT NSString * const RSOSDataBloodTypeABNegative;
FOUNDATION_EXPORT NSString * const RSOSDataBloodTypeOPositive;
FOUNDATION_EXPORT NSString * const RSOSDataBloodTypeONegative;

FOUNDATION_EXPORT NSString * const RSOSDataDeviceClassificationCordless;
FOUNDATION_EXPORT NSString * const RSOSDataDeviceClassificationFixed;
FOUNDATION_EXPORT NSString * const RSOSDataDeviceClassificationSatellite;
FOUNDATION_EXPORT NSString * const RSOSDataDeviceClassificationSensorFixed;
FOUNDATION_EXPORT NSString * const RSOSDataDeviceClassificationDesktop;
FOUNDATION_EXPORT NSString * const RSOSDataDeviceClassificationLaptop;
FOUNDATION_EXPORT NSString * const RSOSDataDeviceClassificationTablet;
FOUNDATION_EXPORT NSString * const RSOSDataDeviceClassificationAlarmMonitored;
FOUNDATION_EXPORT NSString * const RSOSDataDeviceClassificationSensorMobile;
FOUNDATION_EXPORT NSString * const RSOSDataDeviceClassificationAircraft;
FOUNDATION_EXPORT NSString * const RSOSDataDeviceClassificationAutomobile;
FOUNDATION_EXPORT NSString * const RSOSDataDeviceClassificationTruck;
FOUNDATION_EXPORT NSString * const RSOSDataDeviceClassificationFarm;
FOUNDATION_EXPORT NSString * const RSOSDataDeviceClassificationMarine;
FOUNDATION_EXPORT NSString * const RSOSDataDeviceClassificationPersonal;
FOUNDATION_EXPORT NSString * const RSOSDataDeviceClassificationFeaturePhone;
FOUNDATION_EXPORT NSString * const RSOSDataDeviceClassificationSmartPhone;
FOUNDATION_EXPORT NSString * const RSOSDataDeviceClassificationSmartPhoneApp;
FOUNDATION_EXPORT NSString * const RSOSDataDeviceClassificationUnknownDevice;
FOUNDATION_EXPORT NSString * const RSOSDataDeviceClassificationGame;
FOUNDATION_EXPORT NSString * const RSOSDataDeviceClassificationTextOnly;
FOUNDATION_EXPORT NSString * const RSOSDataDeviceClassificationNomadic;
FOUNDATION_EXPORT NSString * const RSOSDataDeviceClassificationMobile;
FOUNDATION_EXPORT NSString * const RSOSDataDeviceClassificationVehicle;
FOUNDATION_EXPORT NSString * const RSOSDataDeviceClassificationHome;
FOUNDATION_EXPORT NSString * const RSOSDataDeviceClassificationOther;
FOUNDATION_EXPORT NSString * const RSOSDataDeviceClassificationNA;

@interface RSOSDataValue : NSObject<RSOSDataSerializable>

- (NSString *)validate;

@end
