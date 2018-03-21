//
//  RSOSCalendarWeekItemTVC.m
//  Emergency Reference Application
//
//  Created by Chris Lin on 12/1/17.
//  Copyright © 2017 RapidSOS. All rights reserved.
//

#import "RSOSCalendarWeekItemTVC.h"

@implementation RSOSCalendarWeekItemTVC

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (CGFloat) getPreferredHeight {
    return 40;
}

#pragma mark - UIButton Event Listeners

- (IBAction)onButtonDayClick:(id)sender {
    UIButton *button = sender;
    int tag = (int) button.tag;
    if (self.delegate && [self.delegate respondsToSelector:@selector(didDateSelectAtWeek:Day:)] == YES) {
        [self.delegate didDateSelectAtWeek:self.indexWeek Day:tag];
    }
}

@end
