
# RapidSOS ERA Guide

## Overview

This guide will walk through each step required to access the Emergency API, create a profile with the Emergency Data API, and trigger a Call Flow, and point to the corresponding sections of the Emergency Reference Application.

### Getting Started

Building this reference app requires **Xcode 9.0 or later**, and the deployment target of the app is **iOS 10.0**.

The app was build using [CocoaPods](https://guides.cocoapods.org/using/getting-started.html), and depends on the [AFNetworking Library](https://github.com/AFNetworking/AFNetworking). It is not required that you install CocoaPods to build and run the reference app, but it is recommended for your development based on the reference app.

To build and run the Emergency Reference App:

1. Make sure CocoaPods 1.0 or later is installed.

2. Clone the Emergency Reference App repository:
```sh
> git clone https://github.com/RapidSOS/era-ios.git
```

3. Open the project workspace: 'EmergencyReferenceApp.xcworkspace'

4. Build and Run the project.

### Sections

This guide covers the following topics:

#### Setup
- [Client Keys](#client-id-and-client-secret)
- [Client Authetication](#client-authentication)
- [User Authentication](#user-authentication)
- [User Registration](#user-registration)
- [Device Verification](#device-verification)

#### Call Flow
- [Triggering a Call Flow](#triggering-a-call-flow)

#### Emergency Data
- [Fetching Emergency Data](#fetching-emergency-data)
- [Updating Emergency Data](#updating-emergency-data)

## Setup and Authentication

### Client ID and Client Secret

Request a **Client ID** and **Client Secret** from the [RapidSOS Emergency Console](https://rec.rapidsos.com/). These are the credentials your client application will use to access the RapidSOS Emergency APIs.

Keep references to your **Client ID** and **Client Secret** somewhere in your code base. In the ERA, the **Client ID** and **Client Secret** are kept in the `Global.h` file:

```obj-c
#define RSOS_CONSTANTS_CLIENTID       @"MY_CLIENT_ID"
#define RSOS_CONSTANTS_CLIENTSECRET   @"MY_CLIENT_SECRET"
```

### Client Authentication

To access the RapidSOS Emergency APIs, use your client credentials to fetch and store an anonymous access token, which should be included in the the `Authentication` HTTP header field of every anonymous request to the API.

```obj-c
- (void)requestClientAccessTokenWithCallback:(void (^) (RSOSResponseStatusDataModel *status))callback {

    NSString *RSOSBaseURL = @"https://api-dev.rapidsos.com";
    NSString *urlString = [NSString stringWithFormat:@"%@/oauth/token", RSOSBaseURL];
    
    // parameters
    NSDictionary *params = @{@"grant_type": @"client_credentials",
                             @"client_id":RSOS_CONSTANTS_CLIENTID,
                             @"client_secret":RSOS_CONSTANTS_CLIENTSECRET
                             };
```

The Emergency Reference App uses the [AFNetowrking](https://github.com/AFNetworking/AFNetworking) library to manage its networking.

The request for the access token must be form-encoded. The response will be JSON-encoded, and other requests to the Emergency and Emergency Data APIs can be JSON-encoded. 

```obj-c
    
    // session manager
    AFHTTPSessionManager *managerAFSession = [AFHTTPSessionManager manager];
    
    // Use HTTP
    managerAFSession.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    [managerAFSession.requestSerializer setValue:@"application/x-www-form-urlencoded"
                              forHTTPHeaderField:@"Content-Type"];
    
    managerAFSession.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [managerAFSession POST:urlString
                parameters:params
                  progress:nil
                   success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                       // ...
                   }
                   failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                       // ...
                   }];
```

If the request succeeds, store the token:

```obj-c
success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    RSOSResponseStatusDataModel *response = [[RSOSResponseStatusDataModel alloc] initWithTask:task response:responseObject error:nil];

    if ([response isSuccess] == YES) {
       
       // save client token to local storage
       self.modelClientToken = [[RSOSAccessTokenDataModel alloc] initWithDictionary:responseObject];
       [self storeClientToken];
    }
    
    // ...
}
failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    // ...
}];

```

Now, when you make requests to the Emergency API, add the auth token to your request header:

```obj-c

NSString *authToken = [NSString stringWithFormat:@"Bearer %@", self.clientAccessToken];
[managerAFSession.requestSerializer setValue:authToken forHTTPHeaderField:@"Authorization"];

```


### User Authentication

The Emergency Data API allows users to securely store personal information that will be made available to first responders in the event of an emergency.

Most requests to the Emergency Data API require a user access token, which grants the client permission to view and edit the user's Emergency Data. (Requests that are not performed by authenticated users, such as user registration or forgot password, only require an anonymous access token).

To request a user access token from the Emergency API, retrieve the user's account credentials and use them to create a user access token request:

```obj-c
- (void)requestClientAccessTokenWithCallback:(void (^) (RSOSResponseStatusDataModel *status))callback {

    NSString *RSOSBaseURL = @"https://api-dev.rapidsos.com";
    NSString *urlString = [NSString stringWithFormat:@"%@/oauth/token", RSOSBaseURL];
    
    // the request parameters are similar to the request for an anonymous access token,
    // but the grant type should be 'password' instead of 'client_credentials' and 
    // the user's credentials are included in the request
    
    NSDictionary *params = @{@"grant_type": @"password",
                             @"client_id":RSOS_CONSTANTS_CLIENTID,
                             @"client_secret":RSOS_CONSTANTS_CLIENTSECRET,
                             @"username": username,
                             @"password": password
                             };
```

As with the anonymous access token request, the request should be form-encoded, and the response will be JSON-encoded.

```obj-c

    AFHTTPSessionManager *managerAFSession = [AFHTTPSessionManager manager];
    managerAFSession.requestSerializer = [AFHTTPRequestSerializer serializer];
    managerAFSession.responseSerializer = [AFJSONResponseSerializer serializer];
    [managerAFSession POST:urlString parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // ...
    }
    failure:
        // ...
    }];
```

The Emergency Reference App stores the user access token separately from the anonymous access token, and uses each as needed by the API:

```obj-c
success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

    self.modelUserToken = [[RSOSUserAccessTokenDataModel alloc] initWithDictionary:responseObject];
    
    self.modelUserToken.username = username;
    self.modelUserToken.password = password;
    
    [self storeUserToken];
```

Session tokens only last for an hour, so if you don't want to require the user to log in every hour, you should store their credentials in order to automatically request a new token.

**Important - user credentials should be stored securely. NSUserDefaults are not secure, and using them to store user credentials is not recommended.**

The Emergency Reference App uses the iOS Keychain to store user credential. This is managed by the wrapper class `RSOSCredentialStorage`.

After a user successfully authenticates, the user's credential record is added to or updated in the keychain:

```obj-c
NSDictionary *credentials = @{
                              @"username":username,
                              @"password":password
                              };
                              
[RSOSCredentialStorage storeCredentials:credentials];
```

For more information on working with the Keychain, please see Apple's [Keychain Services Programming Guide](https://developer.apple.com/library/content/documentation/Security/Conceptual/keychainServConcepts/iPhoneTasks/iPhoneTasks.html).

### User Registration

When you create a new user account through the Emergency Data API, you need to include three parameters:
- *username* - the username of the new account. This username must be unique within your organization
- *password* - the password for the new account
- *email* - the email address associated with the new account.

Note - you can use the user's email address as their username, passing the same value in both fields, and only show them the email field when signing up or logging in.

The request to register a user requires a valid client access token. In the Emergency Reference App, we'll use a convenience method that checks for a non-expired token, and fetches one if necessary (a similar method is used for the user access token):

```obj-c
- (void)refreshClientAccessTokenIfNeededWithCallback:(void (^) (RSOSResponseStatusDataModel *status))callback {
    
    if (self.modelClientToken == nil || [self.modelClientToken isTokenExpired] == YES) {
        
        // expired or missing client token -- request a new client token
        [self requestClientAccessTokenWithCallback:callback];
    }
    else {
        
        // valid client token -- execute callback block with successful status
        RSOSResponseStatusDataModel *responseStatus = [[RSOSResponseStatusDataModel alloc] init];
        responseStatus.status = RSOSHTTPResponseCodeOK;
        
        if (callback) {
            callback(responseStatus);
        }
    }
}
```

After the client access token has been verified, you can make the register user request:

```obj-c
- (void)requestRegisterWithUsername:(NSString *)username
                            password:(NSString *)password
                               email:(NSString *)email
                            callback:(void (^) (RSOSResponseStatusDataModel *status))callback {
                            
    [[RSOSAuthManager sharedInstance] refreshClientAccessTokenIfNeededWithCallback:^(RSOSResponseStatusDataModel *status) {
        
        if ([status isSuccess] == YES) {
            
            // register user request URL
            NSString *urlString = [NSString stringWithFormat:@"%@/v1/rain/user", RSOSBaseURL];
            
            // session manager
            AFHTTPSessionManager *managerAFSession = [AFHTTPSessionManager manager];
            managerAFSession.requestSerializer = [AFJSONRequestSerializer serializer];
            managerAFSession.responseSerializer = [AFJSONResponseSerializer serializer];
            
            // add authentication header
            [managerAFSession.requestSerializer setValue:[[RSOSAuthManager sharedInstance] getClientAuthorizationToken] forHTTPHeaderField:@"Authorization"];
            
            // parameters
            NSDictionary *params = @{@"username": username,
                                     @"password": password,
                                     @"email": email,
                                     };
```

If the request succeeds, you will then need to log in as the new user using their credentials:

```obj-c

[managerAFSession POST:urlString parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

    [self requestLoginWithUsername:username
                          password:password
                          callback:^(RSOSResponseStatusDataModel *status) {
                              if(callback) {
                                  callback(status);
                              }
                          }];
}
failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    // ...
}];

```

### Device Verification

In order for your user's Emergency Data to be made available to first responders, your users must verify their cell phone numbers. 

It is also recommended that you verify your users' phone number before allowing them to trigger an emergency call flow. This will help ensure that they have not entered an incorrect number when they call 9-1-1, and help prevent fraudulent 9-1-1 calls.

In the Emergency Reference App, we will use the Emergency Data API to validate a user phone number, and use this validated number in any call flows triggered by the user. *All device validation requests require a valid user access token.*

First, send a `POST` request to create or update a user's phone number:

```obj-c

- (void)requestPinWithPhoneNumber:(NSString *)phoneNumber
                                 callback:(void (^)(RSOSResponseStatusDataModel *status))callback {
    
    phoneNumber = [RSOSUtilsString normalizePhoneNumber:phoneNumber prefix:@"+"];
    
```
To normalize the user's phone number, strip all non-numeric characters, then make sure it includes the leading country code, including the '+' character. So, `(234) 567-8888` should be formatted as `+12345678888`.

Ensure the user has a valid user access token:
```obj-c
    [[RSOSAuthManager sharedInstance] refreshUserAccessTokenIfNeededWithCallback:^(RSOSResponseStatusDataModel *status) {
        
        if ([status isSuccess] == YES) {
```
Then construct the `POST` request:

```obj-c
NSString *urlString = [NSString stringWithFormat:@"%@/v1/rain/caller-ids", RSOSBaseURL];

NSDictionary *params = @{@"caller_id": phoneNumber};
```

As with all API requests other than the token requests, both the request and response can be in the JSON format.

```obj-c
AFHTTPSessionManager *managerAFSession = [AFHTTPSessionManager manager];
managerAFSession.requestSerializer = [AFJSONRequestSerializer serializer];
managerAFSession.responseSerializer = [AFJSONResponseSerializer serializer];
            
[managerAFSession.requestSerializer setValue:[RSOSAuthManager sharedInstance].getUserAuthorizationToken forHTTPHeaderField:@"Authorization"];

[managerAFSession POST:urlString parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    
    self.phoneNumber = phoneNumber;
```

If the request is successful, an SMS verification code will be sent to the phone number in the request.

The user should be instructed to enter the code they receive, which is then used to validate the phone via a `PATCH` request:

```obj-c
- (void)requestValidatePin:(NSString *)pin callback:(void (^)(RSOSResponseStatusDataModel *status))callback {

    // refresh access token if needed
    // ...
    
    NSString *urlString = [NSString stringWithFormat:@"%@/v1/rain/caller-ids", RSOSBaseURL];
    
    NSDictionary *params = @{@"caller_id": self.phoneNumber,
                             @"validation_code": pin,
                             };
    
    // create session manager
    // ...
    
    [managerAFSession PATCH:urlString parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // ...
    }
    failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) { 
        // ...
    }];
```

If the request succeeds, the phone has been successfully validated:

```obj-c
    success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        RSOSResponseStatusDataModel *status = [[RSOSResponseStatusDataModel alloc] initWithTask:task response:responseObject error:nil];
            
        // store verified device
        if ([status isSuccess] == YES) {
            self.isPhoneVerified = YES;
            [self saveDeviceInfoToLocalStorage];
        }
```

## Call Flow Management

### Triggering a Call Flow

The parameters needed to trigger a call flow are defined by the call flow. You can view the parameters of a specific call flow in the [RapidSOS Emergency Console](https://rec.rapidsos.com/flows/manage).

The Emergency Reference App example call flow takes the following parameters:
- **location** - *Dictionary* - The caller's current location
  - **latitude** - *Number* - The latitude of the user's current location
  - **longitude** - *Number* - The longitude of the user's current location
  - **uncertainty** - *Number* - The uncertainty radius of the user's current location
  
- **user** - *Dictionary* - The user triggering the call flow
  - **full_mame** - *String* - The caller's full name
  - **phone_number** - *String* - The caller's phone number
  
- **contacts** - *Array* - An array of user contact objects. Each contact has the following format:
  - **full_name** - *String* - The contact's full name
  - **phone_number** - *String* - The contact's phone number

In the Emergency Reference App, we populate most of these values using the emergency data entered by the user.

First, we get the user's current location:

```obj-c
- (void)requestTriggerCallWithCallback:(void (^)(RSOSResponseStatusDataModel *status))callback {

RSOSLocationManager *managerLocation = [RSOSLocationManager sharedInstance];
    
    NSDictionary *dictLocation = @{@"latitude": [NSString stringWithFormat:@"%.6f", managerLocation.location.coordinate.latitude],
                                   @"longitude": [NSString stringWithFormat:@"%.6f", managerLocation.location.coordinate.longitude],
                                   @"uncertainty": [NSString stringWithFormat:@"%.6f", managerLocation.location.horizontalAccuracy],
                                   };
```

In the reference app, we retrieve the caller name and phone number from the Emergency Data profile. If they haven't set a profile phone number, we fall back on their verified device number:

```obj-c
NSString *callerFullName = (self.modelProfile.modelFullNameHolder != nil) ? [self.modelProfile.modelFullNameHolder getPrimaryValue] : @"";
    
    /**
     * If the user has not set their profile phone number, fall back on their verified phone number
     */
    
    NSString *callerPhone = self.modelProfile.modelPhoneNumberHolder.getPrimaryValue.szPhoneNumber;
    if(!callerPhone) {
        callerPhone = self.phoneNumber;
    }
    
    if(callerPhone == nil || [RSOSUtilsString normalizePhoneNumber:callerPhone prefix:@""].length != 11) {
        
        /**
         * No valid phone number -- trigger callback with error
         */
        
        RSOSResponseStatusDataModel *responseStatus = [[RSOSResponseStatusDataModel alloc] init];
        responseStatus.status = RSOSHTTPResponseCodeBadRequest;
        responseStatus.message = ( callerPhone ? [NSString stringWithFormat:@"Invalid phone number: %@", callerPhone] : @"No valid phone number." );
        
        if(callback) {
            callback(responseStatus);
        }
        
        return;
    }
    
    callerPhone = [RSOSUtilsString normalizePhoneNumber:callerPhone prefix:@"+"];
    
    NSDictionary *dictUser = @{@"full_name": callerFullName,
                               @"phone_number": callerPhone
                               };
```

We'll iterate through the user's emergency contacts to build the contacts array:

```obj-c
    NSMutableArray *arrayContacts = [[NSMutableArray alloc] init];
    
    if (self.modelProfile.modelContactHolder != nil) {
        
        for (RSOSDataContactDataModel *contact in self.modelProfile.modelContactHolder.arrayContacts) {
            
            [arrayContacts addObject:@{@"full_name": contact.szFullName,
                                       @"phone_number": [RSOSUtilsString normalizePhoneNumber:contact.szPhoneNumber prefix:@"+"]
                                       }];
        }
    }
```

All of the parameter dictionaries are packaged together, and sent with the flow name to the `RSOSCallFlowAPIManager`:

```obj-c
    NSDictionary *variables = @{@"location": dictLocation,
                                @"user": dictUser,
                                @"contacts": arrayContacts,
                                @"company": CONSTANTS_COMPANYNAME
                                };
    
    NSString *callFlow = @"kronos_contacts";
    
    [RSOSCallFlowAPIManager requestTriggerCallWithCallFlow:callFlow variables:variables callback:^(RSOSResponseStatusDataModel *status) {
        _startingCallFlow = NO;
        
        if(callback) {
            callback(status);
        }
    }];
```

The `RSOSCallFlowAPIManager` sends the request to the Emergency API to trigger the call flow. Note that triggering the call flow requires a **client** access token and not a **user** Accesss token:


```obj-c

+ (void)requestTriggerCallWithCallFlow:(NSString *)callFlow variables:(NSDictionary *)variables callback:(void (^)(RSOSResponseStatusDataModel *status))callback {
    
    RSOSAuthManager *managerAuth = [RSOSAuthManager sharedInstance];
    
    [managerAuth refreshClientAccessTokenIfNeededWithCallback:^(RSOSResponseStatusDataModel *status) {
        
        if ([status isSuccess] == YES) {
            
            // callflow request URL
            NSString *urlString = [NSString stringWithFormat:@"%@/v1/rem/trigger", RSOSBaseURL];
            
            // create session manager
            // ...
            
            // add header
            [managerAFSession.requestSerializer setValue:[[RSOSAuthManager sharedInstance] getClientAuthorizationToken] forHTTPHeaderField:@"Authorization"];
            
            // parameters
            NSDictionary *params = @{@"callflow": callFlow,
                                     @"variables": variables,
                                     };
            
            NSLog(@"Network Request =>\nPOST: %@\nParams: %@\n", urlString, params);
            
            [managerAFSession POST:urlString parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
```

## Editing Emergency Data

Creating a profile through the Emergency Data API allows users to make vital information available to first responders during an emergency.

### Fetching Emergency Data

In the Emergency Reference App, the app fetches a user's Emergency Data profile as soon as they log in or finish signing up. New users will have Emergency Data profiles that are empty except for a profile ID.

The app fetches the user's profile data with the method `-RSOSDataUserManager:requestProfileWithCallback:`, first checking that the app has a valid user token:

```obj-c
- (void)requestProfileWithCallback:(void (^)(RSOSResponseStatusDataModel *status))callback {
    
    [[RSOSAuthManager sharedInstance] refreshUserAccessTokenIfNeededWithCallback:^(RSOSResponseStatusDataModel *status) {
        
        if ([status isSuccess] == YES) {
            
            // profile info request URL
            NSString *urlString = [NSString stringWithFormat:@"%@/v1/rain/personal-info", RSOSBaseURL];

```

If the request succeeds, the response is parsed into a `RSOSDataUserProfileDataModel` object:

```obj-c

            [managerAFSession GET:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                RSOSResponseStatusDataModel *response = [[RSOSResponseStatusDataModel alloc] initWithTask:task response:responseObject error:nil];
                
                if ([response isSuccess] == YES) {
                    
                    RSOSDataUserProfileDataModel *profile = [[RSOSDataUserProfileDataModel alloc] initWithDictionary:responseObject];
                
                    self.modelProfile = profile;
                    [self saveProfileInfoToLocalstorage];
                }
```
`RSOSDataUserProfileDataModel` takes the JSON response dictionary and deserializes it into the constituent parts of the uer profile:

```obj-c

- (instancetype) initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    if (self){
        [self setWithDictionary:dict];
    }
    return self;
}


- (void) setWithDictionary:(NSDictionary *)dict {
    [self initialize];
    
    self.szId = [RSOSUtilsString refineNSString:[dict objectForKey:@"id"]];
    
    NSDictionary *dictAddress = [dict objectForKey:@"address"];
    
    NSDictionary *dictAllergy = [dict objectForKey:@"allergy"];
    
    // ...
    
    if (dictAddress != nil && [dictAddress isKindOfClass:[NSDictionary class]] == YES) {
        self.modelAddressHolder = [[RSOSDataAddressHolderDataModel alloc] initWithDictionary:dictAddress];
    }
    
    if (dictAllergy != nil && [dictAllergy isKindOfClass:[NSDictionary class]] == YES) {
        self.modelAllergyHolder = [[RSOSDataAllergyHolderDataModel alloc] initWithDictionary:dictAllergy];
    }
    
    // ...
}
```

### Updating Emergency Data

To save any changes to a user's emergency data with the Emergency Data API, the data must be serialized into JSON and then sent to the API in a `POST` request:

```obj-c

- (void)requestUpdateProfileWithCallback:(void (^)(RSOSResponseStatusDataModel *status))callback {
    
    [[RSOSAuthManager sharedInstance] refreshUserAccessTokenIfNeededWithCallback:^(RSOSResponseStatusDataModel *status) {
        
        if ([status isSuccess] == YES) {
            
            // update profile request URL
            NSString *urlString = [NSString stringWithFormat:@"%@/v1/rain/personal-info", RSOS_BASE_URL];
            
            // parameters
            NSDictionary *params = [self.modelProfile serializeToDictionary];
            
            // create session manager
            // ...
            
            [managerAFSession PATCH:urlString parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                RSOSResponseStatusDataModel *response = [[RSOSResponseStatusDataModel alloc] initWithTask:task response:responseObject error:nil];
                
                if ([response isSuccess] == YES) {
                    
                    RSOSDataUserProfileDataModel *newProfile = [[RSOSDataUserProfileDataModel alloc] initWithDictionary:responseObject];
                    self.modelProfile = newProfile;
                    [self saveProfileInfoToLocalstorage];
                }
```

The `RSOSDataUserProfileDataModel` `-serializeToDictionary` method serializes each constituent part of the profile into a dictionary that can in turn be serialized to JSON:

```obj-c

- (NSDictionary *) serializeToDictionary {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    if (self.szId != nil & self.szId.length > 0) {
        [dict setObject:self.szId forKey:@"id"];
    }
    
    if (self.modelAddressHolder != nil && [self.modelAddressHolder isSet] == YES) {
        [dict setObject:[self.modelAddressHolder serializeToDictionary] forKey:@"address"];
    }
    
    // ...
    
    return dict;
}
```
