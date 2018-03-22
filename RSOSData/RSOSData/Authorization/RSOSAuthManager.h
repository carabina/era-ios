//
//  RSOSAuthManager.h
//  Emergency Reference Application
//
//  Created by Chris Lin on 11/30/17.
//  Copyright © 2017 RapidSOS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RSOSResponseStatusDataModel.h"

#import "RSOSAccessTokenDataModel.h"
#import "RSOSUserAccessTokenDataModel.h"

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXPORT NSString * const RSOSDataAPIHostProduction;
FOUNDATION_EXPORT NSString * const RSOSDataAPIHostStaging;
FOUNDATION_EXPORT NSString * const RSOSDataAPIHostSandbox;

@interface RSOSAuthManager : NSObject

/** @abstract Basic Auth token used to make unauthenticated API requests
 */
@property (strong, nonatomic, nullable) RSOSAccessTokenDataModel *modelClientToken;

/** @abstract User OAuth token used to make Emergency Data API requests
 */
@property (strong, nonatomic, nullable) RSOSUserAccessTokenDataModel *modelUserToken;

@property (strong, nonatomic, nonnull) NSString *baseURL;

@property (strong, nonatomic) NSString *clientID;
@property (strong, nonatomic) NSString *clientSecret;


+ (instancetype)sharedInstance;
- (void)initializeManager;

#pragma mark - Utils



/** @abstract Retrieve and return the client authorization token. Returns @"" if no token is present.
 */
 
- (NSString *)getClientAuthorizationToken;
- (NSString *)getUserAuthorizationToken;

#pragma mark - Request

/**
 * @abstract Fetch the client access token, which allows requests to be made again
 * against the RapidSOS Callflow, Data and Location APIs
 * @param callback A block which executes after the request completes. This block has no return value, and
 * takes a single argument: a `RSOSResponseStatusDataModel` object that indicates whether the request succeeded.
 */

- (void)requestClientAccessTokenWithCallback:(void (^)(RSOSResponseStatusDataModel *responseStatus))callback;

/** @abstract Check for a client access token, and fetch it if it is expired or not present.
 * If this user is logged in, an authenticated user access token will be requested instead.
 * @param callback A block which executes if the current token is valid, or after the request completes otherwise.
 * This block has no return value, and takes a single argument: a `RSOSResponseStatusDataModel`
 * object that indicates whether the request succeeded.
 */

- (void)refreshClientAccessTokenIfNeededWithCallback:(void (^)(RSOSResponseStatusDataModel *responseStatus))callback;

/** @abstract Request an access token for a specific RapidSOS Data API account user.
 * @param username The user account's username
 * @param password The user account's password
 * @param callback A block which executes after the request completes. This block has no return value, and
 * takes a single argument: a `RSOSResponseStatusDataModel` object that indicates whether the request succeeded.
 */

- (void)requestUserAccessTokenWithUsername:(NSString *)username password:(NSString *)password callback:(void (^)(RSOSResponseStatusDataModel *responseStatus))callback;

/** @abstract Check for a client user access token, and fetch it if it is expired or not present.
 *
 * Note that this request will fail if the request requires a user token and the user is not
 * logged in (that is, the current access token is not a user token).
 *
 * @param callback A block which executes if the current token is valid, or after the request completes otherwise.
 * This block has no return value, and takes a single argument: a `RSOSResponseStatusDataModel`
 * object that indicates whether the request succeeded.
 */

- (void)refreshUserAccessTokenIfNeededWithCallback:(void (^)(RSOSResponseStatusDataModel *responseStatus))callback;

/** @abstract Log out the user by deleting saved user credentials, and removing stored user credentials from the keychain
 */

- (void)clearUserCredentials;


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
                           callback:(void (^)(RSOSResponseStatusDataModel *status))callback;


/**
 * @abstract Logs in a user by requesting an access token tied to a user account.
 * @param username String containing the user's username
 * @param password String containing the user's password
 * @param callback A block which executes after the request completes. This block has no return value, and
 * takes a single argument: a RSOSResponseStatusDataModel object that indicates whether the request succeeded
 */

- (void)requestLoginWithUsername:(NSString *)username
                        password:(NSString *)password
                        callback:(void (^)(RSOSResponseStatusDataModel *status))callback;


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
                         callback:(void (^)(RSOSResponseStatusDataModel *status))callback;

/**
 * @abstract Validate the phone by POSTing the pin that was sent to the user's phone.
 * This works by sending a PATCH request to the RapidSOS Data API with the user's phone number and the
 * verification code set to the user.
 * @param pin String of the pin sent to the user's phone.
 * @param callback A block which executes after the request completes. This block has no return value, and
 * takes a single argument: a RSOSResponseStatusDataModel object that indicates whether the request succeeded
 */

- (void)requestValidatePin:(NSString *)pin forPhoneNumber:(NSString *)phoneNumber callback:(void (^)(RSOSResponseStatusDataModel *status))callback;

@end

NS_ASSUME_NONNULL_END
