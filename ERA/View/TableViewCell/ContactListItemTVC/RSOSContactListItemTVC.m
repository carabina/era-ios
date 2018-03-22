//
//  RSOSContactListItemTVC.m
//  Emergency Reference Application
//
//  Created by Chris Lin on 11/29/17.
//  Copyright © 2017 RapidSOS. All rights reserved.
//

#import "RSOSContactListItemTVC.h"

@implementation RSOSContactListItemTVC

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self setupViews];
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
    return 93.0f;
}

@end
