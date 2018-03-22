//
//  RSOSDatePickerDialogVC.h
//  EmergencyReferenceApp
//
//  Created by Gabe Mahoney on 1/24/18.
//  Copyright © 2018 rapidsos. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RSOSDatePickerDialogVC;

@protocol RSOSDatePickerDelegate <NSObject>

@optional

- (void)datePickerController:(RSOSDatePickerDialogVC *)controller didSelectDate:(NSDate *)date;

@end

@interface RSOSDatePickerDialogVC : UIViewController

@property (nonatomic,weak) NSObject<RSOSDatePickerDelegate> *delegate;

@property (nonatomic) IBOutlet UIDatePicker *datePicker;

@end
