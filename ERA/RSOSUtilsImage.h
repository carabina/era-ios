//
//  RSOSUtilsImage.h
//  Emergency Reference Application
//
//  Created by Chris Lin on 12/20/17.
//  Copyright © 2017 RapidSOS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface RSOSUtilsImage : NSObject

+ (UIImage *)scaleAndRotateImage:(UIImage *)image maxResolution:(int)maxResolution;

@end
