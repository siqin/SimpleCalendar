//
//  WQCalendarLogic.h
//  WQCalendar
//
//  Created by Jason Lee on 14-3-12.
//  Copyright (c) 2014年 Jason Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSDate+WQCalendarLogic.h"
#import "WQCalendarDay.h"
#import "WQCalendarView.h"
#import "WQScrollCalendarView.h"

@protocol WQCalendarLogicDelegate;

@interface WQCalendarLogic : NSObject

@property (nonatomic, weak) id<WQCalendarLogicDelegate> delegate;
@property (nonatomic, readonly) WQCalendarDay *selectedCalendarDay;

- (void)reloadCalendarView:(WQCalendarView *)calendarView;
- (void)reloadCalendarView:(WQCalendarView *)calendarView withDate:(NSDate *)date;

- (void)reloadScrollCalendarView:(WQScrollCalendarView *)scrollCalendarView;
- (void)reloadScrollCalendarView:(WQScrollCalendarView *)scrollCalendarView withDate:(NSDate *)date;

// 日历月份切换动画可以考虑用3个calendarView来模拟
- (void)goToPreviousMonthInCalendarView:(WQCalendarView *)calendarView;
- (void)goToNextMonthInCalendarView:(WQCalendarView *)calendarView;

@end

@protocol WQCalendarLogicDelegate <NSObject>

- (void)calendarMonthDidChange;

@end
