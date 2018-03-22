//
//  RSOSDataURL.h
//  RSOSData
//
//  Created by Gabe Mahoney on 2/14/18.
//  Copyright © 2018 RapidSOS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RSOSDataValue.h"


NS_ASSUME_NONNULL_BEGIN

@interface RSOSDataURL : RSOSDataValue

@property (strong, nonatomic) NSString *label;
@property (strong, nonatomic) NSString *url;
@property (strong, nonatomic) NSString *note;

@end

NS_ASSUME_NONNULL_END
