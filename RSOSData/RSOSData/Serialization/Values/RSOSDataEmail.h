//
//  RSOSDataEmail.h
//  Emergency Reference Application
//
//  Created by Chris Lin on 11/30/17.
//  Copyright © 2017 RapidSOS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RSOSDataValue.h"

NS_ASSUME_NONNULL_BEGIN

@interface RSOSDataEmail : RSOSDataValue

@property (strong, nonatomic) NSString *emailAddress;
@property (strong, nonatomic) NSString *label;
@property (strong, nonatomic) NSString *note;

@end

NS_ASSUME_NONNULL_END
