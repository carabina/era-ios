//
//  RSOSDeviceListItemTVC.h
//  Emergency Reference Application
//
//  Created by Chris Lin on 11/29/17.
//  Copyright © 2017 RapidSOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RSOSDeviceListItemTVC : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *viewContainer;
@property (weak, nonatomic) IBOutlet UILabel *labelName;
@property (weak, nonatomic) IBOutlet UILabel *labelUDID;

+ (CGFloat) getPreferredHeight;
@end
