//
//  WQScrollCalendarWrapperView.h
//  WQCalendar
//
//  Created by Jason Lee on 14-3-14.
//  Copyright (c) 2014年 Jason Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WQCalendarDay;

@protocol WQScrollCalendarWrapperViewDelegate;

@interface WQScrollCalendarWrapperView : UIView

@property (nonatomic, weak) id<WQScrollCalendarWrapperViewDelegate> delegate;

@property (nonatomic, readonly) NSUInteger currentYear;
@property (nonatomic, readonly) NSUInteger currentMonth;
@property (nonatomic, readonly) NSUInteger currentWeek; // 当前可见周，即在当前月的第几周

- (void)reloadData;
- (void)moveToDate:(NSDate *)date;

@end

@protocol WQScrollCalendarWrapperViewDelegate <NSObject>

- (void)calendarViewDidScroll;
- (void)monthDidChangeFrom:(NSInteger)fromMonth to:(NSInteger)toMonth;

@end
