//
//  WQCalendarDay.h
//  WQCalendar
//
//  Created by Jason Lee on 14-3-4.
//  Copyright (c) 2014年 Jason Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WQCalendarDay : NSObject

@property (nonatomic, assign) NSUInteger day;
@property (nonatomic, assign) NSUInteger month;
@property (nonatomic, assign) NSUInteger year;

+ (WQCalendarDay *)calendarDayWithYear:(NSUInteger)year month:(NSUInteger)month day:(NSUInteger)day;

- (BOOL)isEqualTo:(WQCalendarDay *)day;

- (NSDate *)date;

@end
