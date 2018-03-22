//
//  RSOSCallFlowAPIManager.h
//  Emergency Reference Application
//
//  Created by Chris Lin on 11/30/17.
//  Copyright © 2017 RapidSOS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RSOSResponseStatusDataModel.h"

extern NSString * const RSOSCallFlowSample;

@interface RSOSCallFlowAPIManager : NSObject

#pragma mark - Request

/**
 * @abstract Trigger the specified callFlow using the RapidSOS CallFlow API.
 * @param callFlow String name of the callFlow being triggered. e.g. 'my_company_callFlow'
 * @param variables Dictionary of information passed to the callFlow.
 * See https://rec-dev.rapidsos.com/flows/manage for more details.
 * @param callback A block which executes after the request completes. This block has no return value, and
 * takes a single argument: a RSOSResponseStatusDataModel object that indicates whether the request succeeded
 */

+ (void)requestTriggerCallWithCallFlow:(NSString *)callFlow variables:(NSDictionary *)variables callback:(void (^)(RSOSResponseStatusDataModel *status))callback;

@end
