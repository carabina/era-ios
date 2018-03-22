//
//  RSOSSplashVC.m
//  Emergency Reference Application
//
//  Created by Chris Lin on 12/24/17.
//  Copyright © 2017 rapidsos. All rights reserved.
//

#import "RSOSSplashVC.h"
#import "RSOSGlobalController.h"

@interface RSOSSplashVC ()

@end

@implementation RSOSSplashVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

- (void) gotoLoginVC {
    [RSOSGlobalController gotoLoginVC];
}

- (void) gotoRegisterVC {
    [RSOSGlobalController gotoSignupVC];
}

#pragma mark - UIButton Event Listeners

- (IBAction)onButtonLoginClick:(id)sender {
    [self gotoLoginVC];
}

- (IBAction)onButtonSignupClick:(id)sender {
    [self gotoRegisterVC];
}

@end
