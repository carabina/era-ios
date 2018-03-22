//
//  RSOSDataUniqueDeviceID.m
//  RSOSData
//
//  Created by Gabe Mahoney on 2/14/18.
//  Copyright © 2018 RapidSOS. All rights reserved.
//

#import "RSOSDataUniqueDeviceID.h"
#import "RSOSUtils.h"

@implementation RSOSDataUniqueDeviceID

- (instancetype)init {
    self = [super init];
    if (self) {
        self.deviceIDType = RSOSDataDeviceIDTypeIMEI;
        self.deviceID = @"";
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
    
    self.deviceIDType = RSOSDataDeviceIDTypeFromNSString([RSOSUtilsString refineNSString:[dict objectForKey:@"type"]]);
    self.deviceID = [RSOSUtilsString refineNSString:[dict objectForKey:@"id"]];
}

- (NSDictionary *)serializeToDictionary {
    NSMutableDictionary *ret = [NSMutableDictionary dictionaryWithDictionary:[super serializeToDictionary]];
    
    [ret setValuesForKeysWithDictionary:
     @{@"type": self.deviceIDTypeString,
       @"id": self.deviceID,
       }];
    
    return [NSDictionary dictionaryWithDictionary:ret];
}

- (NSString *)deviceIDTypeString {
    return NSStringFromRSOSDataDeviceIDType(self.deviceIDType);
}

NSString * NSStringFromRSOSDataDeviceIDType(RSOSDataDeviceIDType deviceIDType) {
    
    switch (deviceIDType) {
            
        case RSOSDataDeviceIDTypeMEID:
            return @"MEID";
            break;
            
        case RSOSDataDeviceIDTypeESN:
            return @"ESN";
            break;
            
        case RSOSDataDeviceIDTypeMAC:
            return @"MAC";
            break;
            
        case RSOSDataDeviceIDTypeWiMAX:
            return @"WiMAX";
            break;
            
        case RSOSDataDeviceIDTypeIMSI:
            return @"IMSI";
            break;
            
        case RSOSDataDeviceIDTypeUDI:
            return @"UDI";
            break;
            
        case RSOSDataDeviceIDTypeRFID:
            return @"RFID";
            break;
            
        case RSOSDataDeviceIDTypeSN:
            return @"SN";
            break;
            
        case RSOSDataDeviceIDTypeIMEI:
        default:
            return @"IMEI";
            break;
    }
}

RSOSDataDeviceIDType RSOSDataDeviceIDTypeFromNSString(NSString * string) {
    
    if([[string uppercaseString] isEqualToString:@"MEID"]) {
        return RSOSDataDeviceIDTypeMEID;
    }
    else if([[string uppercaseString] isEqualToString:@"ESN"]) {
        return RSOSDataDeviceIDTypeESN;
    }
    else if([[string uppercaseString] isEqualToString:@"MAC"]) {
        return RSOSDataDeviceIDTypeMAC;
    }
    else if([[string uppercaseString] isEqualToString:@"WiMAX"]) {
        return RSOSDataDeviceIDTypeWiMAX;
    }
    else if([[string uppercaseString] isEqualToString:@"IMSI"]) {
        return RSOSDataDeviceIDTypeIMSI;
    }
    else if([[string uppercaseString] isEqualToString:@"UDI"]) {
        return RSOSDataDeviceIDTypeUDI;
    }
    else if([[string uppercaseString] isEqualToString:@"RFID"]) {
        return RSOSDataDeviceIDTypeRFID;
    }
    else if([[string uppercaseString] isEqualToString:@"SN"]) {
        return RSOSDataDeviceIDTypeSN;
    }
    else {
        // default
        return RSOSDataDeviceIDTypeIMEI;
    }
}

@end
