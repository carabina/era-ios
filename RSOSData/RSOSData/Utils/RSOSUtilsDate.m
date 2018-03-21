//
//  RSOSUtilsDate.m
//  Emergency Reference Application
//
//  Created by Chris Lin on 12/1/17.
//  Copyright © 2017 RapidSOS. All rights reserved.
//

#import "RSOSUtilsDate.h"
#import "RSOSUtilsString.h"

@implementation RSOSUtilsDate

+ (NSDateComponents *)getComponentsFromDate:(NSDate *)date {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [calendar components:(NSCalendarUnitWeekday | NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitSecond | NSCalendarUnitMinute | NSCalendarUnitHour | NSCalendarUnitWeekOfYear | NSCalendarUnitWeekOfMonth) fromDate:date];
    return components;
}

+ (int)getYearFromDate:(NSDate *)date {
    NSDateComponents *components = [RSOSUtilsDate getComponentsFromDate:date];
    return (int) components.year;
}

+ (int)getMonthFromDate:(NSDate *)date {
    NSDateComponents *components = [RSOSUtilsDate getComponentsFromDate:date];
    return (int) components.month;
}

+ (int)getDayFromDate:(NSDate *)date {
    NSDateComponents *components = [RSOSUtilsDate getComponentsFromDate:date];
    return (int) components.day;
}

+ (int)getWeekdayFromDate:(NSDate *)date {
    NSDateComponents *components = [RSOSUtilsDate getComponentsFromDate:date];
    return (int) components.weekday;
}

+ (NSDate *)getFirstDateOfWeekFromDate:(NSDate *)date {
    NSDateComponents *components = [RSOSUtilsDate getComponentsFromDate:date];
    NSDate *dateFirstDayOfWeek = [date dateByAddingTimeInterval:- (60 * 60 * 24 * (components.weekday - 1))];
    return dateFirstDayOfWeek;
}

+ (NSDate *)getNextDateFromDate:(NSDate *)date {
    NSDate *dateFirstDayOfWeek = [date dateByAddingTimeInterval: (60 * 60 * 24 * 1)];
    return dateFirstDayOfWeek;
}

+ (BOOL)isSameDate:(NSDate *)date1 WithDate:(NSDate *)date2 {
    NSDateComponents *compDate1 = [RSOSUtilsDate getComponentsFromDate:date1];
    NSDateComponents *compDate2 = [RSOSUtilsDate getComponentsFromDate:date2];
    if (compDate1.year == compDate2.year && compDate1.month == compDate2.month && compDate1.day == compDate2.day){
        return YES;
    }
    return NO;
}

+ (NSComparisonResult) compareWeekOfDate: (NSDate *) firstDate SecondDate: (NSDate *) secondDate{
    NSDateComponents *compFirst = [RSOSUtilsDate getComponentsFromDate:firstDate];
    NSDateComponents *compSecond = [RSOSUtilsDate getComponentsFromDate:secondDate];
    if (compFirst.year < compSecond.year){
        return NSOrderedAscending;
    }
    if (compFirst.year > compSecond.year){
        return NSOrderedDescending;
    }
    if (compFirst.weekOfYear < compSecond.weekOfYear) {
        return NSOrderedAscending;
    }
    if (compFirst.weekOfYear > compSecond.weekOfYear) {
        return NSOrderedDescending;
    }
    return NSOrderedSame;
}

+ (NSDate *)generateDateWithYear:(int)year Month:(int)month Day:(int)day {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.year = year;
    components.month = month;
    components.day = day;
    return [calendar dateFromComponents:components];
}

+ (NSDate *)getDateFromString:(NSString *)string {
    string = [RSOSUtilsString refineNSString:string];
    if (string.length == 0) return nil;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *dateFromString = [[NSDate alloc] init];
    dateFromString = [dateFormatter dateFromString:string];
    return dateFromString;
}

+ (NSDate *)getDateTimeFromString:(NSString *)string {
    string = [RSOSUtilsString refineNSString:string];
    if (string.length == 0) return nil;
    
    string = [string stringByReplacingOccurrencesOfString:@"T" withString:@" "];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *dateFromString = [[NSDate alloc] init];
    dateFromString = [dateFormatter dateFromString:string];
    return dateFromString;
}

+ (NSString *)getStringFromDate:(NSDate *)date {
    if (date == nil) return @"";
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *sz = [dateFormatter stringFromDate:date];
    return sz;
}

+ (NSString *)getShortStringFromDateTime:(NSDate *)dt {
    if (dt == nil)
        return @"";
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *compDateTime = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth
                                                           | NSCalendarUnitDay | NSCalendarUnitHour
                                                           | NSCalendarUnitMinute
                                                           | NSCalendarUnitSecond) fromDate:dt];
    
    NSString *szYear = [NSString stringWithFormat:@"%d", (int) compDateTime.year - 2000];
    NSString *szMonth = [NSString stringWithFormat:@"%d", (int) compDateTime.month];
    NSString *szDay = [NSString stringWithFormat:@"%d", (int) compDateTime.day];
    
    if (szYear.length < 2) szYear = [NSString stringWithFormat:@"0%@", szYear];
    if (szMonth.length < 2) szMonth = [NSString stringWithFormat:@"0%@", szMonth];
    if (szDay.length < 2) szDay = [NSString stringWithFormat:@"0%@", szDay];
    
    NSString *szDate = [NSString stringWithFormat: @"%@. %@. %@", szMonth, szDay, szYear];
    return szDate;
}

+ (NSString *)getFormattedDateStringFromDateTime:(NSDate *)dt {
    // Today
    // Yesterday
    // Tomorrow
    // Apr 15, 2016
    
    if (dt == nil)
        return @"";
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *compDateTime = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth
                                                           | NSCalendarUnitDay | NSCalendarUnitHour
                                                           | NSCalendarUnitMinute
                                                           | NSCalendarUnitSecond) fromDate:dt];
    
    NSDateComponents *compTemp = [calendar components:(NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:dt];
    
    NSDate *aDate = [calendar dateFromComponents:compTemp];
    
    compTemp = [calendar components:(NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:[NSDate date]];
    NSDate *today = [calendar dateFromComponents:compTemp];
    
    compTemp = [calendar components:(NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:[NSDate dateWithTimeIntervalSinceNow:-(60 * 60 * 24)]];
    NSDate *yesterday = [calendar dateFromComponents:compTemp];
    
    compTemp = [calendar components:(NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:[NSDate dateWithTimeIntervalSinceNow:(60 * 60 * 24)]];
    NSDate *tomorrow = [calendar dateFromComponents:compTemp];
    
    NSString *szDate;
    NSArray *arrMonth = @[@"Jan", @"Feb", @"Mar", @"Apr", @"May", @"Jun", @"Jul", @"Aug", @"Sep", @"Oct", @"Nov", @"Dec"];
    
    if ([aDate isEqualToDate:today]){
        szDate = @"Today";
    }
    else if ([aDate isEqualToDate:yesterday]){
        szDate = @"Yesterday";
    }
    else if ([aDate isEqualToDate:tomorrow]){
        szDate = @"Tomorrow";
    }
    else{
        szDate = [NSString stringWithFormat: @"%@ %02d, %d", [arrMonth objectAtIndex:(int)[compDateTime month] - 1], (int)[compDateTime day], (int)[compDateTime year]];
    }
    return szDate;
}

+ (NSString *)getFormattedTimeStringFromDateTime:(NSDate *)dt {
    // 08:50 PM
    // 11:05 AM
    // 12:05 AM
    
    if (dt == nil)
        return @"";
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *compDateTime = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth
                                                           | NSCalendarUnitDay | NSCalendarUnitHour
                                                           | NSCalendarUnitMinute
                                                           | NSCalendarUnitSecond) fromDate:dt];
    NSString *szTime;
    int h = (int) [compDateTime hour];
    int m = (int) [compDateTime minute];
    NSString *szAMPM = @"AM";
    
    if (h == 0) {
        h = 12;
    }
    else if (h >= 12){
        szAMPM = @"PM";
        if (h > 12)
            h = h - 12;
    }
    szTime = [NSString stringWithFormat:@"%02d:%02d %@", h, m, szAMPM];
    
    return szTime;
}

+ (NSString *)getBeautifiedTimeElapsedFromSeconds:(int)seconds {
    int hours = seconds / 3600;
    int mins = (seconds % 3600) / 60;
    int secs = seconds % 60;
    NSString *timeElapsed = @"";
    
    if (hours > 0) {
        if (hours <= 9) {
            timeElapsed = [NSString stringWithFormat:@"0%d:", hours];
        }
        else {
            timeElapsed = [NSString stringWithFormat:@"%d", hours];
        }
    }
    if (mins <= 9) {
        timeElapsed = [NSString stringWithFormat:@"%@0%d:", timeElapsed, mins];
    }
    else {
        timeElapsed = [NSString stringWithFormat:@"%@%d:", timeElapsed, mins];
    }
    if (secs <= 9) {
        timeElapsed = [NSString stringWithFormat:@"%@0%d", timeElapsed, secs];
    }
    else {
        timeElapsed = [NSString stringWithFormat:@"%@%d", timeElapsed, secs];
    }
    return timeElapsed;
}

@end
