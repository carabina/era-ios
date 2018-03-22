//
//  RSOSDataDevice.m
//  RSOSData
//
//  Created by Chris Lin on 2/27/18.
//  Copyright © 2018 RapidSOS. All rights reserved.
//

#import "RSOSDataDevice.h"

#import "RSOSUtilsString.h"

@implementation RSOSDataDevice

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
    
    self.deviceID = @"";
    self.batteryPower = [[RSOSDataObject alloc] initWithDisplayName:@"Battery Level" type:@"realtime-metric" units:@"percentage"];
    self.bloodGlucose = [[RSOSDataObject alloc] initWithDisplayName:@"Glucose (mg/DL)" type:@"realtime-metric" units:@"mg/DL"];
    self.bloodOxygenSaturation = [[RSOSDataObject alloc] initWithDisplayName:@"Oxygen Saturation (% Sp02)" type:@"realtime-metric" units:@"%sp02"];
    self.bodyTemperature = [[RSOSDataObject alloc] initWithDisplayName:@"Body Temperature (F)" type:@"realtime-metric" units:@"F"];
    self.callbackPhone = [[RSOSDataObject alloc] initWithDisplayName:@"Callback Number" type:@"phone-number"];
    self.classification = [[RSOSDataObject alloc] initWithDisplayName:@"Device Classification" type:@"string"];
    self.color = [[RSOSDataObject alloc] initWithDisplayName:@"Color" type:@"string"];
    self.comment = [[RSOSDataObject alloc] initWithDisplayName:@"Comments" type:@"string"];
    self.crashPulse = [[RSOSDataObject alloc] initWithDisplayName:@"Crash Pulse" type:@"image-url"];
    self.deviceName = [[RSOSDataObject alloc] initWithDisplayName:@"Device Name" type:@"string"];
    self.ekg12 = [[RSOSDataObject alloc] initWithDisplayName:@"EKG 12-lead" type:@"image-url"];
    self.ekg4 = [[RSOSDataObject alloc] initWithDisplayName:@"EKG 4-lead" type:@"image-url"];
    self.hardwareDescription = [[RSOSDataObject alloc] initWithDisplayName:@"Device Description" type:@"string"];
    self.heartRate = [[RSOSDataObject alloc] initWithDisplayName:@"Heart Rate (bpm)" type:@"realtime-metric" units:@"bpm"];
    self.licensePlate = [[RSOSDataObject alloc] initWithDisplayName:@"LicensePlate" type:@"string"];
    self.manufacturer = [[RSOSDataObject alloc] initWithDisplayName:@"Device Manufacturer" type:@"string"];
    self.model = [[RSOSDataObject alloc] initWithDisplayName:@"Device Model" type:@"string"];
    self.networkCarrierRegistration = [[RSOSDataObject alloc] initWithDisplayName:@"Network Carrier" type:@"string"];
    self.respiratoryRate = [[RSOSDataObject alloc] initWithDisplayName:@"Respiratory Rate (bpm)" type:@"realtime-metric"/* units:@"bpm"*/];
    self.stepsTaken = [[RSOSDataObject alloc] initWithDisplayName:@"Steps Taken" type:@"realtime-metric"];
    self.uniqueID = [[RSOSDataObject alloc] initWithDisplayName:@"Unique Device ID" type:@"device-id"];
    self.userAgent = [[RSOSDataObject alloc] initWithDisplayName:@"User Agent" type:@"string"];
    self.videoFeed = [[RSOSDataObject alloc] initWithDisplayName:@"Video Feed" type:@"video-stream"];
}


- (void)setWithDictionary:(NSDictionary *)dict {
    [self initialize];
    
    self.deviceID = [RSOSUtilsString refineNSString:[dict objectForKey:@"id"]];
    
    NSDictionary *dictBatteryPower = [dict objectForKey:@"battery_power"];
    NSDictionary *dictBloodGlucose = [dict objectForKey:@"blood_glucose"];
    NSDictionary *dictBloodOxygenSaturation = [dict objectForKey:@"blood_oxygen_saturation"];
    NSDictionary *dictBodyTemperature = [dict objectForKey:@"body_temperature"];
    NSDictionary *dictCallbackPhone = [dict objectForKey:@"callback_phone"];
    NSDictionary *dictClassification = [dict objectForKey:@"classification"];
    NSDictionary *dictColor = [dict objectForKey:@"color"];
    NSDictionary *dictComment = [dict objectForKey:@"comment"];
    NSDictionary *dictCrashPulse = [dict objectForKey:@"crash_pulse"];
    NSDictionary *dictDeviceName = [dict objectForKey:@"device_name"];
    NSDictionary *dictEkg12 = [dict objectForKey:@"ekg12"];
    NSDictionary *dictEkg4 = [dict objectForKey:@"ekg4"];
    NSDictionary *dictHardwareDescription = [dict objectForKey:@"hardware_description"];
    NSDictionary *dictHeartRate = [dict objectForKey:@"heart_rate"];
    NSDictionary *dictLicensePlate = [dict objectForKey:@"license_plate"];
    NSDictionary *dictManufacturer = [dict objectForKey:@"manufacturer"];
    NSDictionary *dictModel = [dict objectForKey:@"model"];
    NSDictionary *dictNetworkCarrier = [dict objectForKey:@"network_carrier"];
    NSDictionary *dictRespiratoryRate = [dict objectForKey:@"respiratory_rate"];
    NSDictionary *dictStepsTaken = [dict objectForKey:@"steps_taken"];
    NSDictionary *dictUniqueID = [dict objectForKey:@"unique_id"];
    NSDictionary *dictUserAgent = [dict objectForKey:@"user_agent"];
    NSDictionary *dictVideoFeed = [dict objectForKey:@"video_feed"];
    
    if (dictBatteryPower != nil && [dictBatteryPower isKindOfClass:[NSDictionary class]] == YES) {
        [self.batteryPower setWithDictionary:dictBatteryPower];
    }
    if (dictBloodGlucose != nil && [dictBloodGlucose isKindOfClass:[NSDictionary class]] == YES) {
        [self.bloodGlucose setWithDictionary:dictBloodGlucose];
    }
    if (dictBloodOxygenSaturation != nil && [dictBloodOxygenSaturation isKindOfClass:[NSDictionary class]] == YES) {
        [self.bloodOxygenSaturation setWithDictionary:dictBloodOxygenSaturation];
    }
    if (dictBodyTemperature != nil && [dictBodyTemperature isKindOfClass:[NSDictionary class]] == YES) {
        [self.bodyTemperature setWithDictionary:dictBodyTemperature];
    }
    if (dictCallbackPhone != nil && [dictCallbackPhone isKindOfClass:[NSDictionary class]] == YES) {
        [self.callbackPhone setWithDictionary:dictCallbackPhone];
    }
    if (dictClassification != nil && [dictClassification isKindOfClass:[NSDictionary class]] == YES) {
        [self.classification setWithDictionary:dictClassification];
    }
    if (dictColor != nil && [dictColor isKindOfClass:[NSDictionary class]] == YES) {
        [self.color setWithDictionary:dictColor];
    }
    if (dictComment != nil && [dictComment isKindOfClass:[NSDictionary class]] == YES) {
        [self.comment setWithDictionary:dictComment];
    }
    if (dictCrashPulse != nil && [dictCrashPulse isKindOfClass:[NSDictionary class]] == YES) {
        [self.crashPulse setWithDictionary:dictCrashPulse];
    }
    if (dictDeviceName != nil && [dictDeviceName isKindOfClass:[NSDictionary class]] == YES) {
        [self.deviceName setWithDictionary:dictDeviceName];
    }
    if (dictEkg12 != nil && [dictEkg12 isKindOfClass:[NSDictionary class]] == YES) {
        [self.ekg12 setWithDictionary:dictEkg12];
    }
    if (dictEkg4 != nil && [dictEkg4 isKindOfClass:[NSDictionary class]] == YES) {
        [self.ekg4 setWithDictionary:dictEkg4];
    }
    if (dictHardwareDescription != nil && [dictHardwareDescription isKindOfClass:[NSDictionary class]] == YES) {
        [self.hardwareDescription setWithDictionary:dictHardwareDescription];
    }
    if (dictHeartRate != nil && [dictHeartRate isKindOfClass:[NSDictionary class]] == YES) {
        [self.heartRate setWithDictionary:dictHeartRate];
    }
    if (dictLicensePlate != nil && [dictLicensePlate isKindOfClass:[NSDictionary class]] == YES) {
        [self.licensePlate setWithDictionary:dictLicensePlate];
    }
    if (dictManufacturer != nil && [dictManufacturer isKindOfClass:[NSDictionary class]] == YES) {
        [self.manufacturer setWithDictionary:dictManufacturer];
    }
    if (dictModel != nil && [dictModel isKindOfClass:[NSDictionary class]] == YES) {
        [self.model setWithDictionary:dictModel];
    }
    if (dictNetworkCarrier != nil && [dictNetworkCarrier isKindOfClass:[NSDictionary class]] == YES) {
        [self.networkCarrierRegistration setWithDictionary:dictNetworkCarrier];
    }
    if (dictRespiratoryRate != nil && [dictRespiratoryRate isKindOfClass:[NSDictionary class]] == YES) {
        [self.respiratoryRate setWithDictionary:dictRespiratoryRate];
    }
    if (dictStepsTaken != nil && [dictStepsTaken isKindOfClass:[NSDictionary class]] == YES) {
        [self.stepsTaken setWithDictionary:dictStepsTaken];
    }
    if (dictUniqueID != nil && [dictUniqueID isKindOfClass:[NSDictionary class]] == YES) {
        [self.uniqueID setWithDictionary:dictUniqueID];
    }
    if (dictUserAgent != nil && [dictUserAgent isKindOfClass:[NSDictionary class]] == YES) {
        [self.userAgent setWithDictionary:dictUserAgent];
    }
    if (dictVideoFeed != nil && [dictVideoFeed isKindOfClass:[NSDictionary class]] == YES) {
        [self.videoFeed setWithDictionary:dictVideoFeed];
    }
}

- (NSDictionary *)serializeToDictionary {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    if (self.deviceID != nil & self.deviceID.length > 0) {
        [dict setObject:self.deviceID forKey:@"id"];
    }
    
    if ([self.batteryPower isSet] == YES) {
        [dict setObject:[self.batteryPower serializeToDictionary] forKey:@"battery_power"];
    }
    if ([self.bloodGlucose isSet] == YES) {
        [dict setObject:[self.bloodGlucose serializeToDictionary] forKey:@"blood_glocose"];
    }
    if ([self.bloodOxygenSaturation isSet] == YES) {
        [dict setObject:[self.bloodOxygenSaturation serializeToDictionary] forKey:@"blood_oxygen_saturation"];
    }
    if ([self.bodyTemperature isSet] == YES) {
        [dict setObject:[self.bodyTemperature serializeToDictionary] forKey:@"body_temperature"];
    }
    if ([self.callbackPhone isSet] == YES) {
        [dict setObject:[self.callbackPhone serializeToDictionary] forKey:@"callback_phone"];
    }
    if ([self.classification isSet] == YES) {
        [dict setObject:[self.classification serializeToDictionary] forKey:@"classification"];
    }
    if ([self.color isSet] == YES) {
        [dict setObject:[self.color serializeToDictionary] forKey:@"color"];
    }
    if ([self.comment isSet] == YES) {
        [dict setObject:[self.comment serializeToDictionary] forKey:@"comment"];
    }
    if ([self.crashPulse isSet] == YES) {
        [dict setObject:[self.crashPulse serializeToDictionary] forKey:@"crash_pulse"];
    }
    if ([self.deviceName isSet] == YES) {
        [dict setObject:[self.deviceName serializeToDictionary] forKey:@"device_name"];
    }
    if ([self.ekg12 isSet] == YES) {
        [dict setObject:[self.ekg12 serializeToDictionary] forKey:@"ekg12"];
    }
    if ([self.ekg4 isSet] == YES) {
        [dict setObject:[self.ekg4 serializeToDictionary] forKey:@"ekg4"];
    }
    if ([self.hardwareDescription isSet] == YES) {
        [dict setObject:[self.hardwareDescription serializeToDictionary] forKey:@"hardware_description"];
    }
    if ([self.heartRate isSet] == YES) {
        [dict setObject:[self.heartRate serializeToDictionary] forKey:@"heart_rate"];
    }
    if ([self.licensePlate isSet] == YES) {
        [dict setObject:[self.licensePlate serializeToDictionary] forKey:@"license_plate"];
    }
    if ([self.manufacturer isSet] == YES) {
        [dict setObject:[self.manufacturer serializeToDictionary] forKey:@"manufacturer"];
    }
    if ([self.model isSet] == YES) {
        [dict setObject:[self.model serializeToDictionary] forKey:@"model"];
    }
    if ([self.networkCarrierRegistration isSet] == YES) {
        [dict setObject:[self.networkCarrierRegistration serializeToDictionary] forKey:@"network_carrier"];
    }
    if ([self.respiratoryRate isSet] == YES) {
        [dict setObject:[self.respiratoryRate serializeToDictionary] forKey:@"respiratory_rate"];
    }
    if ([self.stepsTaken isSet] == YES) {
        [dict setObject:[self.stepsTaken serializeToDictionary] forKey:@"steps_taken"];
    }
    if ([self.uniqueID isSet] == YES) {
        [dict setObject:[self.uniqueID serializeToDictionary] forKey:@"unique_id"];
    }
    if ([self.userAgent isSet] == YES) {
        [dict setObject:[self.userAgent serializeToDictionary] forKey:@"user_agent"];
    }
    if ([self.videoFeed isSet] == YES) {
        [dict setObject:[self.videoFeed serializeToDictionary] forKey:@"video_feed"];
    }
    return dict;
}

@end
