//
//  RSOSDeviceListItemTVC.m
//  Emergency Reference Application
//
//  Created by Chris Lin on 11/29/17.
//  Copyright © 2017 RapidSOS. All rights reserved.
//

#import "RSOSDeviceListItemTVC.h"

@implementation RSOSDeviceListItemTVC

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setupViews {
    self.viewContainer.layer.cornerRadius = 3;
    self.viewContainer.clipsToBounds = YES;
}

+ (CGFloat) getPreferredHeight {
    return 70.0f;
}

@end
