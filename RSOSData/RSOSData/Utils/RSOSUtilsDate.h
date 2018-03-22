//
//  RSOSUtilsDate.h
//  Emergency Reference Application
//
//  Created by Chris Lin on 12/1/17.
//  Copyright © 2017 RapidSOS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RSOSUtilsDate : NSObject

+ (NSDateComponents *)getComponentsFromDate:(NSDate *)date;
+ (int)getYearFromDate:(NSDate *)date;
+ (int)getMonthFromDate:(NSDate *)date;
+ (int)getDayFromDate:(NSDate *)date;
+ (int)getWeekdayFromDate:(NSDate *)date;

+ (NSDate *)getFirstDateOfWeekFromDate:(NSDate *)date;
+ (NSDate *)getNextDateFromDate:(NSDate *)date;
+ (BOOL)isSameDate:(NSDate *)date1 WithDate:(NSDate *)date2;
+ (NSComparisonResult)compareWeekOfDate:(NSDate *)firstDate SecondDate:(NSDate *)secondDate;

+ (NSDate *)generateDateWithYear:(int)year Month:(int)month Day:(int)day;

+ (NSDate *)getDateFromString:(NSString *)string;
+ (NSDate *)getDateTimeFromString:(NSString *)string;

+ (NSString *)getStringFromDate:(NSDate *)date;
+ (NSString *)getShortStringFromDateTime:(NSDate *)dt;

+ (NSString *)getFormattedDateStringFromDateTime:(NSDate *)dt;
+ (NSString *)getFormattedTimeStringFromDateTime:(NSDate *)dt;

+ (NSString *)getBeautifiedTimeElapsedFromSeconds:(int)seconds;

@end
