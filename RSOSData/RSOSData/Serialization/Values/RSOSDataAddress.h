//
//  RSOSDataAddress.h
//  Emergency Reference Application
//
//  Created by Chris Lin on 11/30/17.
//  Copyright © 2017 RapidSOS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RSOSDataValue.h"

NS_ASSUME_NONNULL_BEGIN

@interface RSOSDataAddress : RSOSDataValue

@property (strong, nonatomic) NSString *countryCode;
@property (strong, nonatomic) NSString *label;
@property (assign, atomic) float latitude;
@property (assign, atomic) float longitude;
@property (strong, nonatomic) NSString *locality;
@property (strong, nonatomic) NSString *postalCode;
@property (strong, nonatomic) NSString *region;
@property (strong, nonatomic) NSString *streetAddress;
@property (strong, nonatomic) NSString *note;

@end

NS_ASSUME_NONNULL_END
