//
//  RSOSContactListVC.m
//  Emergency Reference Application
//
//  Created by Chris Lin on 11/29/17.
//  Copyright © 2017 RapidSOS. All rights reserved.
//

#import "RSOSContactListVC.h"
#import "RSOSDataUserManager.h"
#import "RSOSContactListItemTVC.h"
#import "RSOSContactDetailsVC.h"

#import "AppConstants.h"
#import "RSOSUtils.h"
#import "RSOSGlobalController.h"

@interface RSOSContactListVC () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableview;

@property (strong, nonatomic) NSArray<RSOSDataEmergencyContact *> *arrayContacts;

@end

@implementation RSOSContactListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableview.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableview.backgroundColor = [UIColor clearColor];
    
    [self registerTableViewCellFromNib];
    
    [self refreshTableview];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onLocalNotificationReceived:)
                                                 name:nil
                                               object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) registerTableViewCellFromNib{
    [self.tableview registerNib:[UINib nibWithNibName:@"ContactListItemTVC" bundle:nil] forCellReuseIdentifier:@"TVC_CONTACTLISTITEM"];
}

- (void) refreshTableview {
    self.arrayContacts = [RSOSDataUserManager sharedInstance].modelProfile.emergencyContacts.values;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableview reloadData];
    });
}

#pragma mark -Navigation

- (void) gotoContactDetailsVCAtIndex: (int) index {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        RSOSContactDetailsVC *vc = [storyboard instantiateViewControllerWithIdentifier:@"STORYBOARD_CONTACT_DETAILS"];
        vc.indexContact = index;
        [self.navigationController pushViewController:vc animated:YES];
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    });
}

#pragma mark - UITableView Delegate

- (void) configureCell: (RSOSContactListItemTVC *) cell AtIndex: (int) index{
    RSOSDataEmergencyContact *contact = [self.arrayContacts objectAtIndex:index];
    cell.labelName.text = contact.fullName;
    cell.labelEmail.text = contact.emailAddress;
    cell.labelPhone.text = [RSOSUtilsString beautifyPhoneNumber:contact.phoneNumber countryCode:@""];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.arrayContacts count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RSOSContactListItemTVC *cell = [tableView dequeueReusableCellWithIdentifier:@"TVC_CONTACTLISTITEM"];
    [self configureCell:cell AtIndex:(int) indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [RSOSContactListItemTVC getPreferredHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self gotoContactDetailsVCAtIndex:(int) indexPath.row];
}

#pragma mark - UIButton Event Listeners

- (IBAction)onButtonAddClick:(id)sender {
    
    if(self.arrayContacts.count >= 5) {
        [RSOSGlobalController showHudErrorWithMessage:@"You cannot add more than 5 emergency contacts."
                                         DismissAfter:2
                                             Callback:^{
                                                 
                                             }];
        return;
    }
    
    [self gotoContactDetailsVCAtIndex:-1];
}

#pragma mark -NSNotification

- (void) onLocalNotificationReceived:(NSNotification *) notification{
    if ([[notification name] isEqualToString:RSOSLOCALNOTIFICATION_CONTACTLIST_UPDATED]) {
        [self refreshTableview];
    }
}

@end
