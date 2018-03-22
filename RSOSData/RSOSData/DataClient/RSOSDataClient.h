//
//  RSOSDataClient.h
//  RSOSData
//
//  Created by Gabe Mahoney on 2/19/18.
//  Copyright © 2018 RapidSOS. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "RSOSResponseStatusDataModel.h"
#import "RSOSDataUserProfile.h"
#import "RSOSDataSavedLocation.h"
#import "RSOSDataDevice.h"

NS_ASSUME_NONNULL_BEGIN

@interface RSOSDataClient : NSObject

/**
 *
 */
+ (instancetype)defaultClient;

/**
 * @abstract Request the user's RapidSOS Emergency Data profile.
 * @param callback A block which executes after the request completes. This block has no return value, and
 * takes two arguments: a `RSOSResponseStatusDataModel` object that indicates whether the request succeeded,
 * and, if successful, the user profile owned by the current logged in user
 */

- (void)getProfileWithCallback:(void (^ _Nullable)(RSOSResponseStatusDataModel *status, RSOSDataUserProfile *profile))callback;

/**
 * @abstract Update the user's RapidSOS Emergency Data profile.
 * @param profile The user profile to be updated
 * @param callback A block which executes after the request completes. This block has no return value, and
 * takes two arguments: a `RSOSResponseStatusDataModel` object that indicates whether the request succeeded,
 * and, if successful, the user profile owned by the current logged in user
 */

- (void)patchProfile:(RSOSDataUserProfile *)profile callback:(void (^ _Nullable)(RSOSResponseStatusDataModel *status, RSOSDataUserProfile *profile) )callback;


/**
 * @abstract Request the user's RapidSOS Emergency Data saved locations.
 * @discussion This executes a GET request to /rain/locations
 * @param callback A block which executes after the request completes. This block has no return value, and
 * takes two arguments: a `RSOSResponseStatusDataModel` object that indicates whether the request succeeded,
 * and, if successful, an array of `RSOSDataSavedLocation` objects containing the user's saved locations
 */

- (void)getSavedLocationsWithCallback:(void (^ _Nullable)(RSOSResponseStatusDataModel *status, NSArray<RSOSDataSavedLocation *> * _Nullable savedLocations))callback;


/**
 * @abstract Create a new Saved Location owned by the user
 * @discussion This executes a POST request to /rain/locations
 * @param savedLocation The location being created.
 * @param callback A block which executes after the request completes. This block has no return value, and
 * takes two arguments: a `RSOSResponseStatusDataModel` object that indicates whether the request succeeded,
 * and, if successful, an `RSOSDataSavedLocation` object representing the newly created Location
 */

- (void)createSavedLocation:(RSOSDataSavedLocation *)savedLocation callback:(void (^ _Nullable)(RSOSResponseStatusDataModel *status, RSOSDataSavedLocation * _Nullable savedLocation))callback;


/**
 * @abstract Request a copy of a specific Saved Location owned by the user
 * @discussion This executes a GET request to /rain/locations/<location-ID>
 * @param locationID The ID of the Saved Location being requested.
 * @param callback A block which executes after the request completes. This block has no return value, and
 * takes two arguments: a `RSOSResponseStatusDataModel` object that indicates whether the request succeeded,
 * and, if successful, an `RSOSDataSavedLocation` object representing a complete copy of the location
 */

- (void)getSavedLocation:(NSString *)locationID callback:(void (^ _Nullable)(RSOSResponseStatusDataModel *status, RSOSDataSavedLocation * _Nullable savedLocation))callback;


/**
 * @abstract Delete a user's Saved Location
 * @discussion This executes a DELETE request to /rain/locations/<location-ID>
 * @param locationID The ID of the Saved Location to be deleted
 * @param callback A block which executes after the request completes. This block has no return value, and
 * takes two arguments: a `RSOSResponseStatusDataModel` object that indicates whether the request succeeded,
 * and, if successful, an `RSOSDataSavedLocation` object representing a copy of the deleted Saved Location
 */

- (void)deleteSavedLocation:(NSString *)locationID callback:(void (^ _Nullable)(RSOSResponseStatusDataModel *status, RSOSDataSavedLocation * _Nullable savedLocation))callback;


/**
 * @abstract Fully update a user's Saved Location. The remote copy of the location will be completely replaced
 * by the location passed as a parameter
 * @discussion This executes a PUT request to /rain/locations/<location-ID>
 * @param savedLocation The Saved Location to be updated. The locations `locationID` property will be used
 * to update the correct location
 * @param callback A block which executes after the request completes. This block has no return value, and
 * takes two arguments: a `RSOSResponseStatusDataModel` object that indicates whether the request succeeded,
 * and, if successful, an `RSOSDataDevice` object representing a copy of the updated device
 */

- (void)updateSavedLocation:(RSOSDataSavedLocation *)savedLocation callback:(void (^ _Nullable)(RSOSResponseStatusDataModel *status, RSOSDataSavedLocation * _Nullable savedLocation))callback;


/**
 * @abstract Partially update a user's Saved Location. Only properties set on the location included in the request
 * will be updated. Any `nil` properties will be ignored.
 * @discussion This executes a PATCH request to /rain/locations/<location-ID>
 * @param savedLocation The Saved Location to be updated. The locations `locationID` property will be used
 * to update the correct location
 * @param callback A block which executes after the request completes. This block has no return value, and
 * takes two arguments: a `RSOSResponseStatusDataModel` object that indicates whether the request succeeded,
 * and, if successful, an `RSOSDataDevice` object representing a copy of the updated device
 */

- (void)patchSavedLocation:(RSOSDataSavedLocation *)savedLocation callback:(void (^ _Nullable)(RSOSResponseStatusDataModel *status, RSOSDataSavedLocation * _Nullable savedLocation))callback;


/**
 * @abstract Request the user's RapidSOS Emergency Data devices.
 * @discussion This executes a GET request to /rain/devices
 * @param callback A block which executes after the request completes. This block has no return value, and
 * takes two arguments: a `RSOSResponseStatusDataModel` object that indicates whether the request succeeded,
 * and, if successful, an NSArray of `RSOSDataDevice` objects containing the user's devices
 */

- (void)getDevicesWithCallback:(void (^ _Nullable)(RSOSResponseStatusDataModel *status, NSArray<RSOSDataDevice *> * _Nullable devices))callback;


/**
 * @abstract Create a new Device owned by the user
 * @discussion This executes a POST request to /rain/devices
 * @param device The device being created.
 * @param callback A block which executes after the request completes. This block has no return value, and
 * takes two arguments: a `RSOSResponseStatusDataModel` object that indicates whether the request succeeded,
 * and, if successful, an `RSOSDataDevice` object representing the newly created Device
 */

- (void)postDevice:(RSOSDataDevice *)device callback:(void (^ _Nullable)(RSOSResponseStatusDataModel *status, RSOSDataDevice * _Nullable device))callback;


/**
 * @abstract Request a copy of a user's specific device
 * @discussion This executes a GET request to /rain/devices/<device-ID>
 * @param deviceID The ID of the Device being requested.
 * @param callback A block which executes after the request completes. This block has no return value, and
 * takes two arguments: a `RSOSResponseStatusDataModel` object that indicates whether the request succeeded,
 * and, if successful, an `RSOSDataDevice` object representing a complete copy of the device
 */

- (void)getDevice:(NSString *)deviceID callback:(void (^ _Nullable)(RSOSResponseStatusDataModel *status, RSOSDataDevice * _Nullable device))callback;


/**
 * @abstract Delete a user's device
 * @discussion This executes a DELETE request to /rain/devices/<device-ID>
 * @param deviceID The ID of the Device to be deleted
 * @param callback A block which executes after the request completes. This block has no return value, and
 * takes two arguments: a `RSOSResponseStatusDataModel` object that indicates whether the request succeeded,
 * and, if successful, an `RSOSDataDevice` object representing a copy of the deleted device
 */

- (void)deleteDevice:(NSString *)deviceID callback:(void (^ _Nullable)(RSOSResponseStatusDataModel *status, RSOSDataDevice * _Nullable device))callback;


/**
 * @abstract Fully update a user's device. The remote copy of the device will be completely replaced
 * by the device passed as a parameter
 * @discussion This executes a PUT request to /rain/devices/<device-ID>
 * @param device The Device to be updated. The device's `deviceID` property will be used
 * to update the correct device
 * @param callback A block which executes after the request completes. This block has no return value, and
 * takes two arguments: a `RSOSResponseStatusDataModel` object that indicates whether the request succeeded,
 * and, if successful, an `RSOSDataDevice` object representing a copy of the updated device
 */

- (void)updateDevice:(RSOSDataDevice *)device callback:(void (^ _Nullable)(RSOSResponseStatusDataModel *status, RSOSDataDevice * _Nullable device))callback;


/**
 * @abstract Partially update a user's device. Only properties set on the device included in the request
 * will be updated. Any `nil` properties will be ignored.
 * @discussion This executes a PATCH request to /rain/devices/<device-ID>
 * @param device The Device to be updated. The device's `deviceID` property will be used
 * to update the correct device
 * @param callback A block which executes after the request completes. This block has no return value, and
 * takes two arguments: a `RSOSResponseStatusDataModel` object that indicates whether the request succeeded,
 * and, if successful, an `RSOSDataDevice` object representing a copy of the updated device
 */

- (void)patchDevice:(RSOSDataDevice *)device callback:(void (^ _Nullable)(RSOSResponseStatusDataModel *status, RSOSDataDevice * _Nullable device))callback;

@end

NS_ASSUME_NONNULL_END
