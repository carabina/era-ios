//
//  UIColor+RSOS.m
//  Emergency Reference Application
//
//  Created by Chris Lin on 11/29/17.
//  Copyright © 2017 RapidSOS. All rights reserved.
//

#import "UIColor+RSOS.h"

@implementation UIColor (RSOS)

+ (UIColor *) RSOSMainColor {
    return [UIColor colorWithRed:0 / 255.0 green:155 / 255.0 blue:255 / 255.0 alpha:1];
}

+ (UIColor *) RSOSLightBlue {
    return [UIColor colorWithRed:0 / 255.0 green:155 / 255.0 blue:255 / 255.0 alpha:0.6];
}

+ (UIColor *) RSOSLightGray {
    return [UIColor colorWithRed:202 / 255.0 green:212 / 255.0 blue:222 / 255.0 alpha:0.4];
}

+ (UIColor *) RSOSTextfieldPlaceholderColorWhite {
    return [UIColor whiteColor];
}

@end
