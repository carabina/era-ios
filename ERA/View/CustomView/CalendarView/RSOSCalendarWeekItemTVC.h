//
//  RSOSCalendarWeekItemTVC.h
//  Emergency Reference Application
//
//  Created by Chris Lin on 12/1/17.
//  Copyright © 2017 RapidSOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RSOSCalendarWeekItemCellDelegate <NSObject>

@optional

- (void) didDateSelectAtWeek: (int) indexWeek Day: (int) indexDay;

@end

@interface RSOSCalendarWeekItemTVC : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *buttonDay0;
@property (weak, nonatomic) IBOutlet UIButton *buttonDay1;
@property (weak, nonatomic) IBOutlet UIButton *buttonDay2;
@property (weak, nonatomic) IBOutlet UIButton *buttonDay3;
@property (weak, nonatomic) IBOutlet UIButton *buttonDay4;
@property (weak, nonatomic) IBOutlet UIButton *buttonDay5;
@property (weak, nonatomic) IBOutlet UIButton *buttonDay6;

@property (assign, atomic) int indexWeek;
@property (weak, nonatomic) id<RSOSCalendarWeekItemCellDelegate> delegate;

+ (CGFloat) getPreferredHeight;

@end
