//
//  RSOSFadeTransitionDelegate.m
//  Emergency Reference Application
//
//  Created by Chris Lin on 12/17/17.
//  Copyright © 2017 RapidSOS. All rights reserved.
//

#import "RSOSFadeTransitionDelegate.h"
#import "RSOSAnimatedTransitioning.h"

@implementation RSOSFadeTransitionDelegate

//===================================================================
// - UIViewControllerTransitioningDelegate
//===================================================================

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    RSOSAnimatedTransitioning *controller = [[RSOSAnimatedTransitioning alloc]init];
    controller.isPresenting = YES;
    return (id<UIViewControllerAnimatedTransitioning>)controller;
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    //I will fix it later.
    //    AnimatedTransitioning *controller = [[AnimatedTransitioning alloc]init];
    //    controller.isPresenting = NO;
    //    return controller;
    return nil;
}

- (id <UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id <UIViewControllerAnimatedTransitioning>)animator {
    return nil;
}

- (id <UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id <UIViewControllerAnimatedTransitioning>)animator {
    return nil;
}

@end
