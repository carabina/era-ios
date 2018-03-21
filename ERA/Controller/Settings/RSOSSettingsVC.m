//
//  RSOSSettingsVC.m
//  Emergency Reference Application
//
//  Created by Chris Lin on 11/29/17.
//  Copyright © 2017 RapidSOS. All rights reserved.
//

#import "RSOSSettingsVC.h"
#import "RSOSUtils.h"
#import "RSOSGlobalController.h"
#import "RSOSAppManager.h"
#import "RSOSDataUserManager.h"
#import "RSOSFailSafeManager.h"

@interface RSOSSettingsVC ()

@property (weak, nonatomic) IBOutlet UILabel *labelVersion;
@property (weak, nonatomic) IBOutlet UISwitch *switchWidgetLock;
@property (weak, nonatomic) IBOutlet UISwitch *switchFailSafe;

@end

@implementation RSOSSettingsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.switchFailSafe addTarget:self action:@selector(handleFailSafeSwitch:) forControlEvents:UIControlEventValueChanged];
    
    [self refreshFields];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) refreshFields {
    self.labelVersion.text = [NSString stringWithFormat:@"%@ (%@)", [RSOSUtils getAppVersionString], [RSOSUtils getAppBuildString]];
    
    self.switchFailSafe.enabled = [RSOSFailSafeManager sharedInstance].isEnabled;
}

#pragma mark - Action

- (void) doLogout {
    [RSOSGlobalController promptWithVC:self Title:@"Confirmation" Message:@"Are you sure you want to log out?" ButtonYes:@"Yes" ButtonNo:@"No" CallbackYes:^{
        [[RSOSAppManager sharedInstance] initializeManagersAfterLogout];
        [RSOSGlobalController logout];
    } CallbackNo:nil];
}

- (void) doTriggerFlow {
    [RSOSGlobalController promptWithVC:self Title:@"Confirmation" Message:@"Are you sure you want to trigger a 911 call?" ButtonYes:@"Yes" ButtonNo:@"No" CallbackYes:^{
        [RSOSGlobalController showHudProgressWithMessage:@"Please wait..."];
        [[RSOSDataUserManager sharedInstance] requestTriggerCallWithCallback:^(RSOSResponseStatusDataModel *status) {
            if ([status isSuccess] == YES) {
                [RSOSGlobalController showHudSuccessWithMessage:@"You will be connected to 911 very soon" DismissAfter:-1 Callback:nil];
            }
            else {
                [RSOSGlobalController showHudErrorWithMessage:status.message DismissAfter:-1 Callback:nil];
            }
        }];
    } CallbackNo:nil];
}

- (void)handleFailSafeSwitch:(id)sender {
    
    [RSOSFailSafeManager sharedInstance].enabled = self.switchFailSafe.isOn;
}

#pragma mark - UIButton Event Listeners

- (IBAction)onButtonLogoutClick:(id)sender {
    [self doLogout];
}

- (IBAction)onButtonTriggerFlowClick:(id)sender {
    [self doTriggerFlow];
    
}

@end
