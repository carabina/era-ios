//
//  RSOSDataVideoFeed.h
//  RSOSData
//
//  Created by Chris Lin on 2/23/18.
//  Copyright © 2018 RapidSOS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RSOSDataValue.h"

NS_ASSUME_NONNULL_BEGIN

@interface RSOSDataVideoFeed : RSOSDataValue

@property (strong, nonatomic) NSString *label;
@property (strong, nonatomic) NSString *url;
@property (strong, nonatomic) NSString *format;
@property (assign, atomic) float latitude;
@property (assign, atomic) float longitude;
@property (strong, nonatomic) NSString *note;

@end

NS_ASSUME_NONNULL_END
