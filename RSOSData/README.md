# Emergency Data SDK

## Overview

The Emergency Data SDK interfaces with the RAIN (**RA**pidSOS **A**ditional Data **IN**gestion) API to allow developers to access and modify their users' Emergency Data. This data will be made securely available to first responders in the event of an emergency.

The RAIN data schema consists of several core object types:

- `User` - the authenticated User account, used to access and edit the user's information.

- `Caller ID` - the verified phone number belonging to the user. Users must verify that a phone number belongs to them in order for their emergency information to be made available to public safety officials.

- `UserProfile` - personal information about the user, including Medical info, emergency contacts, demographic info.

- `Device` - information about the user's device. This can be identifying information about a phone or other smart device - make, model, unique ID. It can also contain links to live information being reported by the device, such as the live camera feed from a smart home camera or connected car.

- `Saved Location` - a location listed by the user as one of their habitual locations - home, work, etc. 

## Getting Started

The RAIN SDK can be added to an existing iOS application or to a brand-new iOS application. The recommended way to install the RAIN SDK is through Cocoapods

### 1. CocoaPods Installation

Make sure [CocoaPods](https://guides.cocoapods.org/using/getting-started.html) version 1.0.0 or later is installed.

If you are adding CocoaPods to your project for the first time, follow the instructions in the [Using Cocoapods](https://guides.cocoapods.org/using/using-cocoapods.html) guide.

---
**Note**: The `RSOSData` pod is currently in **Beta**. To install it using CocoaPods, you will need to perform the following additional steps:

1. Add the RapidSOS pod repo to your instance of Cocoapods:
```sh
>  pod repo add RSOSData https://github.com/RapidSOS/beacon-ios-sdk.git`
```
2. Add the following two lines to the top of your `Podfile` under the line starting with "platform" (e.g. "platform :ios, 9.0"):
``` 

source 'https://github.com/CocoaPods/Specs.git'
source 'https://github.com/RapidSOS/beacon-ios-sdk.git'
```
---

Open the `Podfile` in your workspace with a text editor and add `pod 'RSOSData'` to your list of pods.

Run `> pod install --repo-update` to install the RSOSData Pod into your project.

### 2. User Authentication

In order to start adding and editing additional user data, you will create a user account and a validated phone number for your user. Emergency services will be able to query this validated phone number and retrieve this user's additional data.

First, import the `RSOSData` library to the file you are working in:

`#import <RSOSData.h>`

Create a shared instance of the singleton class `RSOSAuthManager`, and assign it your `CLIENT ID` and `CLIENT SECRET`. If you need a `CLIENT ID` and `CLIENT SECRET`, you can get them from the (RapidSOS Emergency Console)[rec.rapidsos.com].
```obj-c
[[RSOSAuthManager sharedInstance] initializeManager];

[RSOSAuthManager sharedInstance].clientID = MY_CLIENT_ID;
[RSOSAuthManager sharedInstance].clientSecret = MY_CLIENT_SECRET;
```
Register a new user using the `RSOSAuthManager` class. Have the user enter an email and password, and pass them to the User Manager. *(Note - the request to register a user takes three parameters: **username**, **email** and **password**. For simplicity, your application can use the user's email address as their username, passing the same parameter in both fields.)*
 ```obj-c

NSString *userEmail = @"new.user@example.com";
NSString *userPassword = @"SecurePassw0rd!";

RSOSAuthManager *userManager = [RSOSAuthManager sharedInstance];

[userManager requestRegisterWithUsername:userEmail password:userPassword email:userEmail callback:^(RSOSResponseStatusDataModel *status) {
    
    if([status isSuccess]) {
        // handle success
    }
    else {
        // handle error
    }
    
}];
```

If this is an existing user, you can simply log them in:

```obj-c

NSString *userEmail = @"existing.user@example.com";
NSString *userPassword = @"SecurePassw0rd!";

RSOSAuthManager *userManager = [RSOSAuthManager sharedInstance];

[userManager requestLoginWithUsername:userEmail password:userPassword callback:^(RSOSResponseStatusDataModel *status) {
    
    if([status isSuccess]) {
        // handle success
    }
    else {
        // handle error
    }
    
}];
```

Create a caller ID for the user by registering their phone number. Normalize the phone number before passing it to the server.

```obj-c
NSString *userPhone = @"(234) 567-8888";
NSString *normalizedPhone = [RSOSUtilsString normalizePhoneNumber:userPhone prefix:@""]; // '12345678888'

RSOSAuthManager *userManager = [RSOSAuthManager sharedInstance];

[userManager requestPinWithPhoneNumber:normalizedPhone callback:^(RSOSResponseStatusDataModel *status) {

    if([status isSuccess]) {
        // handle success
    }
    else {
        // handle error
    }

}];

```

A numeric verification code will be sent to the user's mobile device. Have the user enter this code, and then send it to the server to verify the user's phone number.

```obj-c

NSString *verificationCode = self.codeField.text; // e.g. @"12345"

RSOSAuthManager *userManager = [RSOSAuthManager sharedInstance];

[userManager requestValidatePin:verificationCode forPhoneNumber:phoneNumber callback:^(RSOSResponseStatusDataModel *status) {

    if([status isSuccess]) {
        // handle success
    }
    else {
        // handle error
    }

}];
```

Verifying the caller ID will allow the user to share their Emergency Data with public safety officials in the event of an emergency.

### 3. Data Serialization


Once the user has been logged in and their device has been verified, you will be able to edit their emergency data on their behalf using the RapidSOS Emergency Data API.

Each new user account added via the RSOS Emergency Data API has an empty `UserProfile` object. The `RSOSDataClient` class will allow you to fetch this profile and add or edit fields.

To start editing an authenticated user's emergency data, first fetch the current user's `UserProfile`:
```obj-c

RSOSDataClient *dataClient = [RSOSDataClient defaultClient];
                                     
[dataClient getProfileWithCallback:^(RSOSResponseStatusDataModel * _Nonnull status, RSOSDataUserProfile * _Nonnull profile) {
    
    if([status isSuccess]) {
        NSLog(@"Hello! My name is: %@", profile.fullName.getPrimaryValue);
    }

}];

```

Update properties of the user's profile by editing them, and passing the profile as an argument to 
`-requestUpdateProfile:callback`:

```obj-c

[profile.fullName setPrimaryValue:@"John Doe"];

RSOSDataClient *dataClient = [RSOSDataClient defaultClient];
                                     
[dataClient patchProfile:profile callback:^(RSOSResponseStatusDataModel * _Nonnull status, RSOSDataUserProfile * _Nonnull profile) {

    if([status isSuccess]) {
        NSLog(@"Hello! My name is now: %@", profile.fullName.getPrimaryValue);
    }

}];
```

The `RSOSDataUserProfile` returned in the callback block will contain a complete version of the user's updated profile.

For more complex profile fields, such as a home address, you can edit individual properties on the field, and then save the user profile to update the field. If no object currently exists for the field, you'll need to create one:

```obj-c

RSOSDataAddress *homeAddress = [profile.addresses getPrimaryValue];

if(homeAddress == nil) {

    // Create an address value if none exists:
    
    homeAddress = [[RSOSDataAddress alloc] init];
    [profile.addresses setPrimaryValue:homeAddress];
}
else {
    NSLog(@"My current street address is: %@", profile.addresses.getPrimaryValue.streetAddress);
}

homeAddress.streetAddress = @"234 W 39th Street, 9th Floor";

RSOSDataClient *dataClient = [RSOSDataClient defaultClient];
                                     
[dataClient patchProfile:profile callback:^(RSOSResponseStatusDataModel * _Nonnull status, RSOSDataUserProfile * _Nonnull profile) {

    if([status isSuccess]) {
        NSLog(@"My new street address is: %@", profile.addresses.getPrimaryValue.streetAddress);
    }

}];
```
