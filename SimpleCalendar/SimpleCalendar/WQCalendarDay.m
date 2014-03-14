//
//  WQCalendarDay.m
//  WQCalendar
//
//  Created by Jason Lee on 14-3-4.
//  Copyright (c) 2014年 Jason Lee. All rights reserved.
//

#import "WQCalendarDay.h"

@implementation WQCalendarDay

+ (WQCalendarDay *)calendarDayWithYear:(NSUInteger)year month:(NSUInteger)month day:(NSUInteger)day
{
    WQCalendarDay *calendarDay = [[WQCalendarDay alloc] init];
    calendarDay.year = year;
    calendarDay.month = month;
    calendarDay.day = day;
    return calendarDay;
}

- (BOOL)isEqualTo:(WQCalendarDay *)day
{
    BOOL isEqual = (self.year == day.year) && (self.month == day.month) && (self.day == day.day);
    return isEqual;
}

- (NSDate *)date
{
    NSDateComponents *c = [[NSDateComponents alloc] init];
    c.year = self.year;
    c.month = self.month;
    c.day = self.day;
    return [[NSCalendar currentCalendar] dateFromComponents:c];
}

@end
