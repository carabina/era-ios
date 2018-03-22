//
//  RSOSAnimatedTransitioning.h
//  Emergency Reference Application
//
//  Created by Chris Lin on 12/17/17.
//  Copyright © 2017 RapidSOS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface RSOSAnimatedTransitioning : NSObject <UIViewControllerTransitioningDelegate>

@property (nonatomic, assign) BOOL isPresenting;

@end
