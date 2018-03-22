//
//  RSOSDataUserManager.h
//  Emergency Reference Application
//
//  Created by Chris Lin on 11/30/17.
//  Copyright © 2017 RapidSOS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import <RSOSData.h>

NS_ASSUME_NONNULL_BEGIN

@interface RSOSDataUserManager : NSObject

/**
 * @abstract User profile data model
 */

@property (strong, nonatomic) RSOSDataUserProfile *modelProfile;

/**
 *
 */

@property (strong, nonatomic) NSMutableArray<RSOSDataSavedLocation *> *savedLocations;

/**
 * @abstract User profile phone number
 */

@property (strong, nonatomic) NSString *phoneNumber;

/**
 * @abstract Flag indicating the user phone has been verified
 */

@property (assign, atomic) BOOL isPhoneVerified;

/**
 * @abstract Flag indicating that a call flow request is active
 */

@property (atomic,readonly,assign) BOOL startingCallFlow;


+ (instancetype) sharedInstance;

#pragma mark - Utils

- (BOOL)isLoggedIn;
- (void)logoutUser;

#pragma mark - Localstorage

- (void)saveDeviceInfoToLocalStorage;
- (void)loadDeviceInfoFromLocalstorage;
- (void)saveProfileInfoToLocalstorage;
- (void)loadProfileInfoFromLocalstorage;

#pragma mark - Authentication

/**
 * @abstract Register a new user to the RapidSOS Data API. This method attemps to create a new
 * user object through the RapidSOS Data API. If it is successful, it will log in the user
 * and retrieve a user access token in order to start making requests as that user.
 * @param username String containing the user's username. Can be the same as their email address
 * @param password String containing the user's password
 * @param email String containing the user's email address
 * @param callback A block which executes after the request completes. This block has no return value, and
 * takes a single argument: a RSOSResponseStatusDataModel object that indicates whether the request succeeded
 */

- (void)requestRegisterWithUsername:(NSString *)username
                            password:(NSString *)password
                               email:(NSString *)email
                            callback:(void (^ _Nullable)(RSOSResponseStatusDataModel *status))callback;

/**
 * @abstract Sends a password reset email to the specified email address
 * @param email String to which the reset password email will be sent
 * @param callback A block which executes after the request completes. This block has no return value, and
 * takes a single argument: a RSOSResponseStatusDataModel object that indicates whether the request succeeded
 */

- (void)requestPasswordResetWithEmail:(NSString *)email
                              callback:(void (^ _Nullable)(RSOSResponseStatusDataModel *status))callback;

/**
 * @abstract Logs in a user by requesting an access token tied to a user account.
 * @param username String containing the user's username
 * @param password String containing the user's password
 * @param callback A block which executes after the request completes. This block has no return value, and
 * takes a single argument: a RSOSResponseStatusDataModel object that indicates whether the request succeeded
 */

- (void)requestLoginWithUsername:(NSString *)username
                         password:(NSString *)password
                         callback:(void (^ _Nullable)(RSOSResponseStatusDataModel *status))callback;

/**
 * @abstract Request an SMS pin be sent to the specified phone number.
 * This works by sending a POST request to the RapidSOS Data API with the user's phone number.
 * @param phoneNumber The user's phone number. Phone numbers must start with a country code and otherwise
 * contain only numeric characters representing the phone number. For example, the U.S. number (234) 567-8888
 * would be represented as "+12345678888". The method [RSOSUtilsString normalizePhoneNumber:] will produce
 * a correctly formatted phone number.
 * @param callback A block which executes after the request completes. This block has no return value, and
 * takes a single argument: a RSOSResponseStatusDataModel object that indicates whether the request succeeded
 */

- (void)requestPinWithPhoneNumber:(NSString *)phoneNumber
                                 callback:(void (^ _Nullable)(RSOSResponseStatusDataModel *status))callback;

/**
 * @abstract Validate the phone by POSTing the pin that was sent to the user's phone.
 * This works by sending a PATCH request to the RapidSOS Data API with the user's phone number and the
 * verification code set to the user.
 * @param pin String of the pin sent to the user's phone.
 * @param callback A block which executes after the request completes. This block has no return value, and
 * takes a single argument: a RSOSResponseStatusDataModel object that indicates whether the request succeeded
 */

- (void)requestValidatePin:(NSString *)pin
                  callback:(void (^ _Nullable)(RSOSResponseStatusDataModel *status))callback;

#pragma mark - User Profile

/**
 * @abstract Request the user's RapidSOS Emergency Data profile. If successful, this method sets the
 * user manager's modelProfile field.
 * @param callback A block which executes after the request completes. This block has no return value, and
 * takes a single argument: a RSOSResponseStatusDataModel object that indicates whether the request succeeded
 */

- (void)requestProfileWithCallback:(void (^ _Nullable)(RSOSResponseStatusDataModel *status))callback;

/**
 * @abstract Update the user's RapidSOS Emergency Data profile. This request saves any changes made locally
 * to the user's profile to the RapidSOS Emergency Data API.
 * @param callback A block which executes after the request completes. This block has no return value, and
 * takes a single argument: a RSOSResponseStatusDataModel object that indicates whether the request succeeded
 */
- (void)requestUpdateProfileWithCallback:(void (^ _Nullable)(RSOSResponseStatusDataModel *status) )callback;

/**
 * @abstract Upload an image to be the user's RapidSOS Emergency Data profile photo.
 * @param image UIImage of the user's profile photo.
 * @param callback A block which executes after the request completes. This block has no return value, and
 * takes two arguments: a string representing the URL of the saved profile photo, and a RSOSResponseStatusDataModel
 * object that indicates whether the request succeeded
 */

- (void)requestUploadPhoto:(UIImage *)image callback:(void (^ _Nullable)(NSString * _Nullable photoUrlString, RSOSResponseStatusDataModel *status))callback;

#pragma mark - Callflow API

/**
 * @abstract Trigger the Emergency Reference Application sample callflow. See
 * RSOSCallFlowAPIManager for more details.
 * @param callback A block which executes after the request completes. This block has no return value, and
 * takes a single argument: a RSOSResponseStatusDataModel object that indicates whether the request succeeded
 */

- (void)requestTriggerCallWithCallback:(void (^ _Nullable)(RSOSResponseStatusDataModel *status))callback;


/**
 * @abstract Download the user's profile photo
 * @param callback A block which executes after the request completes. This block has no return value, and
 * takes two argument: a RSOSResponseStatusDataModel object that indicates whether the request succeeded,
 * and a UIImage returned in the response if the request succeeded.
 */

- (void)downloadProfileImageWithCallback:(void (^)(RSOSResponseStatusDataModel *status, UIImage * _Nullable image))callback;


/**
 * @abstract Download UIImage from a source URL.
 * @param sourceURL The `NSURL` from which the image will be downloaded.
 * @param callback A block which executes after the request completes. This block has no return value, and
 * takes two argument: a RSOSResponseStatusDataModel object that indicates whether the request succeeded,
 * and a UIImage returned in the response if the request succeeded.
 */

- (void)downloadImageFromSource:(NSURL *)sourceURL
                       callback:(void (^ _Nullable)(RSOSResponseStatusDataModel *status, UIImage * _Nullable image))callback;


- (void)addSavedLocation:(RSOSDataSavedLocation *)savedLocation
                callback:(void (^ _Nullable)(RSOSResponseStatusDataModel *status) )callback;

- (void)updateSavedLocation:(RSOSDataSavedLocation *)savedLocation
                callback:(void (^ _Nullable)(RSOSResponseStatusDataModel *status) )callback;

@end

NS_ASSUME_NONNULL_END

