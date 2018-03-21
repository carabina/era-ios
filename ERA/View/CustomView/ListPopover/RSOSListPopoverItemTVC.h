//
//  RSOSListPopoverItemTVC.h
//  Emergency Reference Application
//
//  Created by Chris Lin on 12/1/17.
//  Copyright © 2017 RapidSOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RSOSListPopoverItemTVC : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *labelTitle;

+ (CGFloat) getPreferredHeight;

@end
