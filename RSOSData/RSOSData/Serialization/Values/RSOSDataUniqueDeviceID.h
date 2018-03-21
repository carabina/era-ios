//
//  RSOSDataUniqueDeviceID.h
//  RSOSData
//
//  Created by Gabe Mahoney on 2/14/18.
//  Copyright © 2018 RapidSOS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RSOSDataValue.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, RSOSDataDeviceIDType) {
    RSOSDataDeviceIDTypeMEID,
    RSOSDataDeviceIDTypeESN,
    RSOSDataDeviceIDTypeMAC,
    RSOSDataDeviceIDTypeWiMAX,
    RSOSDataDeviceIDTypeIMEI,
    RSOSDataDeviceIDTypeIMSI,
    RSOSDataDeviceIDTypeUDI,
    RSOSDataDeviceIDTypeRFID,
    RSOSDataDeviceIDTypeSN
};

@interface RSOSDataUniqueDeviceID : RSOSDataValue

@property (nonatomic) RSOSDataDeviceIDType deviceIDType;
@property (strong, nonatomic) NSString *deviceID;

- (NSString *)deviceIDTypeString;

FOUNDATION_EXPORT NSString * NSStringFromRSOSDataDeviceIDType(RSOSDataDeviceIDType deviceIDType);
FOUNDATION_EXPORT RSOSDataDeviceIDType RSOSDataDeviceIDTypeFromNSString(NSString * string);


@end

NS_ASSUME_NONNULL_END
