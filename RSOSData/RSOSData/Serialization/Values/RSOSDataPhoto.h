//
//  RSOSDataPhoto.h
//  RSOSData
//
//  Created by Chris Lin on 2/22/18.
//  Copyright © 2018 RapidSOS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RSOSDataValue.h"

NS_ASSUME_NONNULL_BEGIN

@interface RSOSDataPhoto : RSOSDataValue

@property (strong, nonatomic) NSString *label;
@property (strong, nonatomic) NSString *note;
@property (strong, nonatomic) NSString *url;

@end

NS_ASSUME_NONNULL_END
