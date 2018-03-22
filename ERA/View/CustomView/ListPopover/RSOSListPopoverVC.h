//
//  RSOSListPopoverVC.h
//  Emergency Reference Application
//
//  Created by Chris Lin on 12/1/17.
//  Copyright © 2017 RapidSOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RSOSListPopoverVC;

@protocol RSOSListPopoverVCDelegate <NSObject>

- (void) popoverListVC:(RSOSListPopoverVC *) vc didListItemSelected:(NSString *) title AtIndex:(int) index;

@end

@interface RSOSListPopoverVC : UIViewController

@property (strong, nonatomic) NSArray *arrItems;
@property (weak, nonatomic) id<RSOSListPopoverVCDelegate> delegate;

@property (assign, atomic) int indexSelected;

- (CGSize) calculateBestFrameSize;

@end
