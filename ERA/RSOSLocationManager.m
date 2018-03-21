//
//  RSOSLocationManager.m
//  Emergency Reference Application
//
//  Created by Chris Lin on 12/20/17.
//  Copyright © 2017 RapidSOS. All rights reserved.
//

#import "RSOSLocationManager.h"
#import <UIKit/UIKit.h>

#define CONSTANT_LOCATION_DEFAULTLATITUDE                        40.7128
#define CONSTANT_LOCATION_DEFAULTLONGITUDE                       -74.0059

@implementation RSOSLocationManager

+ (instancetype) sharedInstance{
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (id) init{
    if (self = [super init]){
        // [self initializeManager];
        self.isLocationSet = NO;
    }
    return self;
}

- (void) dealloc{
    [self.locationManager stopUpdatingLocation];
}

- (void) initializeManager{
    if (self.locationManager != nil){
        [self.locationManager stopUpdatingLocation];
    }
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    //self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    // self.locationManager.distanceFilter = 50;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    self.location = [[CLLocation alloc]initWithLatitude:CONSTANT_LOCATION_DEFAULTLATITUDE longitude:CONSTANT_LOCATION_DEFAULTLONGITUDE];
    
    [self requestCurrentLocation];
}

- (void) startLocationUpdate{
    NSLog(@"startLocationUpdate called");
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0 &&
        [CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorizedWhenInUse
        && [CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorizedAlways
        ) {
        [self.locationManager requestAlwaysAuthorization];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.locationManager startUpdatingLocation];
        });
    }
}

- (void) stopLocationUpdate{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.locationManager stopUpdatingLocation];
    });
}

- (void) requestCurrentLocation{
    [self stopLocationUpdate];
    [self startLocationUpdate];
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    switch (status) {
        case kCLAuthorizationStatusDenied:
        {
            NSLog(@"Location service is off.");
            break;
        }
        case kCLAuthorizationStatusNotDetermined:
        case kCLAuthorizationStatusAuthorizedWhenInUse:
        case kCLAuthorizationStatusAuthorizedAlways:
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.locationManager startUpdatingLocation];
            });
            break;
        }
        default:
            break;
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    if ([locations count] == 0) return;
    CLLocation *newLocation = [locations lastObject];
    NSTimeInterval locationAge = [newLocation.timestamp timeIntervalSinceNow];
    if (fabs(locationAge) > 15 && self.isLocationSet == YES) return;
    
    self.isLocationSet = YES;
    self.location = newLocation;
    NSLog(@"%@", self.location);
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSString *sz = @"";
    BOOL shouldRetry = YES;
    switch([error code])
    {
        case kCLErrorNetwork:{ // general, network-related error
            sz = @"Location service failed!\nPlease check your network connection or that you are not in aireplane mode.";
            shouldRetry = YES;
            break;
        }
        case kCLErrorDenied:{
            sz = @"User denied to use location service.";
            shouldRetry = NO;
            break;
        }
        case kCLErrorLocationUnknown:{
            sz = @"Unable to obtain geo-location information right now.";
            // Automatically retried
            
            return;
            shouldRetry = YES;
            break;
        }
        default:{
            sz = [NSString stringWithFormat:@"Location service failed due to unknown error.\n%@", error.description];
            shouldRetry = YES;
            break;
        }
    }
    NSLog(@"locationManager didFailWithError: %@", error.description);
    
    [self.locationManager stopUpdatingLocation];
    if (shouldRetry){
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.locationManager startUpdatingLocation];
        });
    }
}

@end
