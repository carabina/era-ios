//
//  RSOSCalendarDialogVC.m
//  Emergency Reference Application
//
//  Created by Chris Lin on 12/1/17.
//  Copyright © 2017 RapidSOS. All rights reserved.
//

#import "RSOSCalendarDialogVC.h"
#import "AppConstants.h"
#import "UIColor+RSOS.h"
#import "RSOSCalendarWeekItemTVC.h"

#import <RSOSData/RSOSData.h>

// CalendarDayDataModel

@interface RSOSCalendarDayDataModel : NSObject

@property (assign, atomic) int year;
@property (assign, atomic) int month;
@property (assign, atomic) int day;
@property (assign, atomic) BOOL isToday;

- (instancetype) initWithDate: (NSDate *) date;
- (NSDate *) getDate;

@end

@implementation RSOSCalendarDayDataModel

- (instancetype) init{
    self = [super init];
    if (self){
        [self initialize];
    }
    return self;
}

- (instancetype) initWithDate: (NSDate *) date{
    self = [super init];
    if (self){
        self.year = [RSOSUtilsDate getYearFromDate:date];
        self.month = [RSOSUtilsDate getMonthFromDate:date];
        self.day = [RSOSUtilsDate getDayFromDate:date];
        self.isToday = [RSOSUtilsDate isSameDate:date WithDate:[NSDate date]];
        
    }
    return self;
}

- (void) initialize{
    self.year = 2000;
    self.month = 1;
    self.day = 1;
    self.isToday = NO;
}

- (NSDate *) getDate{
    return [RSOSUtilsDate generateDateWithYear:self.year Month:self.month Day:self.day];
}

@end

// CalendarWeekDataModel

@interface RSOSCalendarWeekDataModel : NSObject

@property (strong, nonatomic) NSMutableArray <RSOSCalendarDayDataModel *> *arrayDays;
@property (assign, atomic) BOOL isSelected;

@end

@implementation RSOSCalendarWeekDataModel

- (instancetype) init{
    self = [super init];
    if (self){
        [self initialize];
    }
    return self;
}

- (void) initialize{
    self.arrayDays = [[NSMutableArray alloc] init];
    self.isSelected = NO;
}

@end

@interface RSOSCalendarDialogVC () <UITableViewDelegate, UITableViewDataSource, RSOSCalendarWeekItemCellDelegate>

@property (weak, nonatomic) IBOutlet UIView *viewContent;

@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (weak, nonatomic) IBOutlet UITableView *tableview;

@property (assign, atomic) int nCurrentMonth;
@property (assign, atomic) int nCurrentYear;

@property (strong, nonatomic) NSMutableArray <RSOSCalendarWeekDataModel *> *arrayWeeks;

@end

#define RSOSUICOLOR_CALENDAR_TEXTCOLOR_CURRENTMONTH_NOTSELECTED          [UIColor colorWithRed:(0 / 255.0) green:(155 / 255.0) blue:(255 / 255.0) alpha:1]
#define RSOSUICOLOR_CALENDAR_TEXTCOLOR_OTHERMONTH_NOTSELECTED            [UIColor colorWithRed:(0 / 255.0) green:(155 / 255.0) blue:(255 / 255.0) alpha:0.6]
#define RSOSUICOLOR_CALENDAR_TEXTCOLOR_SELECTED                          [UIColor colorWithRed:(255 / 255.0) green:(255 / 255.0) blue:(255 / 255.0) alpha:1]

@implementation RSOSCalendarDialogVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableview.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self registerTableViewCellFromNib];
    
    [self refreshFields];
    [self refreshViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) refreshViews{
}

- (void) refreshFields{
    // Generate the list
    
    if (self.dateSelected == nil){
        self.dateSelected = [NSDate date];
    }
    
    self.nCurrentYear = [RSOSUtilsDate getYearFromDate:self.dateSelected];
    self.nCurrentMonth = [RSOSUtilsDate getMonthFromDate:self.dateSelected];
    
    [self buildDayItems];
}

- (void) refreshTitle{
    NSArray *arrMonths = @[@"January", @"February", @"March", @"April", @"May", @"June", @"July", @"August", @"September", @"October", @"November", @"December"];
    self.labelTitle.text = [NSString stringWithFormat:@"%@, %d", [arrMonths objectAtIndex:(self.nCurrentMonth - 1)], self.nCurrentYear];
}

- (void) registerTableViewCellFromNib{
    [self.tableview registerNib:[UINib nibWithNibName:@"CalendarWeekItemTVC" bundle:nil] forCellReuseIdentifier:@"TVC_CALENDAR_WEEKITEM"];
}

- (void) buildDayItems{
    NSDate *dateFirstDayOfMonth = [RSOSUtilsDate generateDateWithYear:self.nCurrentYear Month:self.nCurrentMonth Day:1];
    NSDate *dateFirstDayOfWeek = [RSOSUtilsDate getFirstDateOfWeekFromDate:dateFirstDayOfMonth];
    NSDate *dateCurrent = dateFirstDayOfWeek;
    int nWeeks = 0;
    self.arrayWeeks = [[NSMutableArray alloc] init];
    while (nWeeks < 6){
        RSOSCalendarWeekDataModel *week = [[RSOSCalendarWeekDataModel alloc] init];
        for (int i = 0; i < 7; i++){
            RSOSCalendarDayDataModel *day = [[RSOSCalendarDayDataModel alloc] initWithDate:dateCurrent];
            [week.arrayDays addObject:day];
            dateCurrent = [RSOSUtilsDate getNextDateFromDate:dateCurrent];
        }
        [self.arrayWeeks addObject:week];
        nWeeks++;
    }
    [self refreshTitle];
    [self.tableview reloadData];
}

- (void) closeDialog{
    [UIView animateWithDuration:TRANSITION_FADEOUT_DURATION animations:^{
        self.view.alpha = 0;
    } completion:^(BOOL b){
        [self dismissViewControllerAnimated:NO completion:nil];
    }];
}

#pragma mark - UIButton Delegate

- (IBAction)onButtonPrevMonthClick:(id)sender {
    self.nCurrentMonth--;
    if (self.nCurrentMonth <= 0){
        self.nCurrentYear--;
        self.nCurrentMonth = 12;
    }
    [self buildDayItems];
}

- (IBAction)onButtonNextMonthClick:(id)sender {
    self.nCurrentMonth++;
    if (self.nCurrentMonth > 12){
        self.nCurrentYear++;
        self.nCurrentMonth = 1;
    }
    [self buildDayItems];
}

- (IBAction)onButtonWrapperClick:(id)sender {
    [self.view endEditing:YES];
    [self closeDialog];
}

#pragma mark - UITableview Delegate

- (void) configureCell: (RSOSCalendarWeekItemTVC *) cell AtIndex: (int) index{
    RSOSCalendarWeekDataModel *week = [self.arrayWeeks objectAtIndex:index];
    NSArray *arrayButtons = @[cell.buttonDay0, cell.buttonDay1, cell.buttonDay2, cell.buttonDay3, cell.buttonDay4, cell.buttonDay5, cell.buttonDay6];
    
    for (int i = 0; i < (int) [arrayButtons count]; i++){
        UIButton *button = [arrayButtons objectAtIndex:i];
        RSOSCalendarDayDataModel *day = [week.arrayDays objectAtIndex:i];
        [button setTitle:[NSString stringWithFormat:@"%d", day.day] forState:UIControlStateNormal];
        
        if ([RSOSUtilsDate isSameDate:[day getDate] WithDate:self.dateSelected] == YES){
            // Selected Date, show selector
            button.layer.backgroundColor = [UIColor RSOSMainColor].CGColor;
            [button setTitleColor:RSOSUICOLOR_CALENDAR_TEXTCOLOR_SELECTED forState:UIControlStateNormal];
        }
        else if (day.isToday == YES){
            // Today, show selector
            button.layer.backgroundColor = [UIColor RSOSMainColor].CGColor;
            [button setTitleColor:RSOSUICOLOR_CALENDAR_TEXTCOLOR_SELECTED forState:UIControlStateNormal];
        }
        else if (day.month == self.nCurrentMonth && day.year == self.nCurrentYear){
            // Current Month, show in White Text
            button.layer.backgroundColor = [UIColor clearColor].CGColor;
            [button setTitleColor:RSOSUICOLOR_CALENDAR_TEXTCOLOR_CURRENTMONTH_NOTSELECTED forState:UIControlStateNormal];
        }
        else {
            // Show in Gray Text
            button.layer.backgroundColor = [UIColor clearColor].CGColor;
            [button setTitleColor:RSOSUICOLOR_CALENDAR_TEXTCOLOR_OTHERMONTH_NOTSELECTED forState:UIControlStateNormal];
        }
        
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.indexWeek = index;
    cell.delegate = self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.arrayWeeks count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RSOSCalendarWeekItemTVC *cell = [tableView dequeueReusableCellWithIdentifier:@"TVC_CALENDAR_WEEKITEM"];
    [self configureCell:cell AtIndex:(int) indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [RSOSCalendarWeekItemTVC getPreferredHeight];
}

#pragma mark - SNSCalendarWeekItem Delegate

- (void)didDateSelectAtWeek:(int)indexWeek Day:(int)indexDay{
    RSOSCalendarWeekDataModel *week = [self.arrayWeeks objectAtIndex:indexWeek];
    RSOSCalendarDayDataModel *day = [week.arrayDays objectAtIndex:indexDay];
    self.dateSelected = [day getDate];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableview reloadData];
        if (self.delegate && [self.delegate respondsToSelector:@selector(calendarDialog:didDateSelected:)] == YES) {
            [self.delegate calendarDialog:self didDateSelected:self.dateSelected];
        }
        
        [self closeDialog];
    });
}

@end
