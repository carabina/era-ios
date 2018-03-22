//
//  RSOSLocationManager.h
//  Emergency Reference Application
//
//  Created by Chris Lin on 12/20/17.
//  Copyright © 2017 RapidSOS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface RSOSLocationManager : NSObject <CLLocationManagerDelegate>

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *location;

@property (assign, atomic) BOOL isLocationSet;

+ (instancetype)sharedInstance;
- (void)initializeManager;

- (void)startLocationUpdate;
- (void)stopLocationUpdate;
- (void)requestCurrentLocation;

@end
