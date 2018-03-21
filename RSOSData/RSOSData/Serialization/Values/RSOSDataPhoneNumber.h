//
//  RSOSDataPhoneNumber.h
//  Emergency Reference Application
//
//  Created by Chris Lin on 11/30/17.
//  Copyright © 2017 RapidSOS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RSOSDataValue.h"

NS_ASSUME_NONNULL_BEGIN

@interface RSOSDataPhoneNumber : RSOSDataValue

@property (strong, nonatomic) NSString *label;
@property (strong, nonatomic) NSString *note;
@property (strong, nonatomic) NSString *phoneNumber;

@end

NS_ASSUME_NONNULL_END
