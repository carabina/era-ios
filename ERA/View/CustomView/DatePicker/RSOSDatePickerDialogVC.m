//
//  RSOSDatePickerDialogVC.m
//  EmergencyReferenceApp
//
//  Created by Gabe Mahoney on 1/24/18.
//  Copyright © 2018 rapidsos. All rights reserved.
//

#import "RSOSDatePickerDialogVC.h"

#import "AppConstants.h"

@interface RSOSDatePickerDialogVC ()

@property (nonatomic,weak) IBOutlet UIToolbar *toolbar;
@property (nonatomic) NSDate *date;
@end

@implementation RSOSDatePickerDialogVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    for (UIBarButtonItem *item in self.toolbar.items) {
        item.tintColor = [UIColor blackColor];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)handleDoneButton:(id)sender {
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(datePickerController:didSelectDate:)]) {
        [self.delegate datePickerController:self didSelectDate:self.datePicker.date];
    }
    
    [self dismiss];
}

- (IBAction)handleCancelButton:(id)sender {
    
    [self dismiss];
}

- (void)dismiss {
    [UIView animateWithDuration:TRANSITION_FADEOUT_DURATION animations:^{
        self.view.alpha = 0;
    } completion:^(BOOL b){
        [self dismissViewControllerAnimated:NO completion:nil];
    }];
}

@end
