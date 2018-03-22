//
//  RSOSDataLanguage.h
//  RSOSData
//
//  Created by Gabe Mahoney on 2/14/18.
//  Copyright © 2018 RapidSOS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RSOSDataValue.h"

NS_ASSUME_NONNULL_BEGIN

@interface RSOSDataLanguage : RSOSDataValue

@property (strong, nonatomic) NSString *languageCode;
@property (assign, atomic) int preference;

@end

NS_ASSUME_NONNULL_END
