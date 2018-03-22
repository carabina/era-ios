//
//  AppConstants_h
//  Emergency Reference Application
//
//  Created by Chris Lin on 11/30/17.
//  Copyright © 2017 RapidSOS. All rights reserved.
//

#import <RSOSData/RSOSData.h>

#ifndef AppConstants_h
#define AppConstants_h

#define TRANSITION_FADEOUT_DURATION             0.25f

#define RSOS_BASE_URL                           RSOSDataAPIHostSandbox

#warning Add your Client ID and Client Secret

#define ERA_BACKEND_URL                         @"https://api-dev.rapidsos.com"

#define RSOS_CONSTANTS_CLIENTID                 @"<YOUR CLIENT ID>"
#define RSOS_CONSTANTS_CLIENTSECRET             @"<YOUR CLIENT SECRET>"

#define CONSTANTS_COMPANYNAME                   @"RapidSOS"

/**
 *  This is the phone number that will be opened by the native Phone app
 *  in the event that a problem occurs with the call flow.
 *
 *  In the production version of your apps, this number should be changed
 *  to 911 in order to prompt the user to call 911:
 *
 *  #define RSOS_CONSTANTS_FAILSAFE_NUMBER          @"911"
 *
 *  (Note that as of iOS 10.3, users will be prompted to call 911
 *   with an alert. Opening the native Phone app and calling a number
     directly has been disabled by Apple for security reasons.)
 */

#define RSOS_CONSTANTS_FAILSAFE_NUMBER          @"411"

#define RSOSLOCALNOTIFICATION_CONTACTLIST_UPDATED                @"RSOSLOCALNOTIFICATION_CONTACTLIST_UPDATED"

#endif /* Global_h */
