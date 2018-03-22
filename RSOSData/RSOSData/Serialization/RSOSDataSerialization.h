//
//  RSOSDataSerialization.h
//  EmergencyReferenceApp
//
//  Created by Gabe Mahoney on 2/7/18.
//  Copyright © 2018 RapidSOS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RSOSDataSerialization : NSObject

+ (NSArray *)deserializeValuesArray:(NSArray *)valuesArray objectType:(NSString *)type;
+ (NSArray *)serializeValuesArray:(NSArray *)valuesArray objectType:(NSString *)type;

@end
