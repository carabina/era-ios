//
//  RSOSListPopoverVC.m
//  Emergency Reference Application
//
//  Created by Chris Lin on 12/1/17.
//  Copyright © 2017 RapidSOS. All rights reserved.
//

#import "RSOSListPopoverVC.h"
#import "RSOSListPopoverItemTVC.h"

@interface RSOSListPopoverVC () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableview;

@end

@implementation RSOSListPopoverVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableview.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self registerTableViewCellFromNib];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) registerTableViewCellFromNib{
    [self.tableview registerNib:[UINib nibWithNibName:@"ListPopoverItemTVC" bundle:nil] forCellReuseIdentifier:@"TVC_POPOVER_LISTITEM"];
}

- (CGSize) calculateBestFrameSize{
    int height = (int) MAX(2, MIN([self.arrItems count] + 1, 8)) * [RSOSListPopoverItemTVC getPreferredHeight];
    return CGSizeMake(240, height);
}

#pragma mark - UITableview Delegate

- (void) configureCell: (RSOSListPopoverItemTVC *) cell AtIndex: (int) index{
    NSString *title = [self.arrItems objectAtIndex:index];
    cell.labelTitle.text = title;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.arrItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RSOSListPopoverItemTVC *cell = [tableView dequeueReusableCellWithIdentifier:@"TVC_POPOVER_LISTITEM"];
    [self configureCell:cell AtIndex:(int) indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [RSOSListPopoverItemTVC getPreferredHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.indexSelected = (int) indexPath.row;
    if (self.delegate){
        [self.delegate popoverListVC:self didListItemSelected:[self.arrItems objectAtIndex:self.indexSelected] AtIndex:self.indexSelected];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == self.indexSelected){
        [cell setSelected:YES];
    }
    else {
        [cell setSelected:NO];
    }
    
    // Remove seperator inset
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    // Prevent the cell from inheriting the Table View's margin settings
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    // Explictly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

@end
