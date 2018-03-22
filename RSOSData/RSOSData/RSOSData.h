//
//  RSOSData.h
//  RSOSData
//
//  Created by Gabe Mahoney on 2/8/18.
//  Copyright © 2018 RapidSOS. All rights reserved.
//

#import <Foundation/Foundation.h>

//! Project version number for RSOSData.
FOUNDATION_EXPORT double RSOSDataVersionNumber;

//! Project version string for RSOSData.
FOUNDATION_EXPORT const unsigned char RSOSDataVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <RSOSData/PublicHeader.h>


#ifndef RSOSData_h
#define RSOSData_h

// Data Client

#import <RSOSData/RSOSDataClient.h>

// Serialization

#import <RSOSData/RSOSDataUserProfile.h>
#import <RSOSData/RSOSDataSavedLocation.h>

#import <RSOSData/RSOSDataSerialization.h>

#import <RSOSData/RSOSDataObject.h>
#import <RSOSData/RSOSDataValue.h>



// Authentication

#import <RSOSData/RSOSAuthManager.h>
#import <RSOSData/RSOSAccessTokenDataModel.h>
#import <RSOSData/RSOSUserAccessTokenDataModel.h>
#import <RSOSData/RSOSResponseStatusDataModel.h>


// Util

#import <RSOSData/RSOSUtils.h>

#endif /* RSOSData_h */

