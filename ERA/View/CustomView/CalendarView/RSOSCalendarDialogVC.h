//
//  RSOSCalendarDialogVC.h
//  Emergency Reference Application
//
//  Created by Chris Lin on 12/1/17.
//  Copyright © 2017 RapidSOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RSOSCalendarDialogVC;

@protocol RSOSCalendarDialogDelegate <NSObject>

@optional

- (void) calendarDialog:(RSOSCalendarDialogVC *) vc didDateSelected:(NSDate *) date;

@end

@interface RSOSCalendarDialogVC : UIViewController

@property (strong, nonatomic) NSDate *dateSelected;
@property (weak, nonatomic) id<RSOSCalendarDialogDelegate> delegate;

- (void) refreshFields;

@end
