//
//  WQCalendarLogic.m
//  WQCalendar
//
//  Created by Jason Lee on 14-3-12.
//  Copyright (c) 2014年 Jason Lee. All rights reserved.
//

#import "WQCalendarLogic.h"

@interface WQCalendarLogic () <WQCalendarGridViewDataSource, WQCalendarGridViewDelegate, WQScrollCalendarViewDataSource, WQScrollCalendarViewDelegate>

@property (nonatomic, strong) NSMutableArray *daysInPreviousMonth;
@property (nonatomic, strong) NSMutableArray *daysInCurrentMonth;
@property (nonatomic, strong) NSMutableArray *daysInFollowingMonth;

@property (nonatomic, strong) NSMutableArray *calendarDays; // 当前月份展示的日历天

/* 用户日历上的当天 */
@property (nonatomic, strong) NSDate *currentDate;
@property (nonatomic, strong) WQCalendarDay *currentCalendarDay;

/* 用户点击选中的日历上的某一天 */
@property (nonatomic, strong) NSDate *selectedDate;
@property (nonatomic, strong) WQCalendarDay *selectedCalendarDay;

@property (nonatomic, assign) NSUInteger selectedIndex;

@end

@implementation WQCalendarLogic

#pragma mark - Interface

- (void)reloadCalendarView:(WQCalendarView *)calendarView
{
    [self reloadCalendarView:calendarView withDate:nil];
}

- (void)reloadCalendarView:(WQCalendarView *)calendarView withDate:(NSDate *)date
{
    [self reloadCurrentDate];
    if (date == nil) date = self.currentDate;
    [self reloadGridView:calendarView.gridView withDate:date];
}

- (void)reloadScrollCalendarView:(WQScrollCalendarView *)scrollCalendarView
{
    [self reloadScrollCalendarView:scrollCalendarView withDate:nil];
}

- (void)reloadScrollCalendarView:(WQScrollCalendarView *)scrollCalendarView withDate:(NSDate *)date
{
    [self reloadCurrentDate];
    if (date == nil) date = self.currentDate;
    
    [self reloadCalendarDataWithDate:date];
    
    scrollCalendarView.dataSource = self;
    scrollCalendarView.delegate = self;
    
    [scrollCalendarView reloadData];
}

#pragma mark -

- (void)goToPreviousMonthInCalendarView:(WQCalendarView *)calendarView
{
    self.selectedDate = [self.selectedDate dayInThePreviousMonth];
    [self reloadCalendarView:calendarView withDate:self.selectedDate];
}

- (void)goToNextMonthInCalendarView:(WQCalendarView *)calendarView
{
    self.selectedDate = [self.selectedDate dayInTheFollowingMonth];
    [self reloadCalendarView:calendarView withDate:self.selectedDate];
}

#pragma mark - Private

- (void)reloadGridView:(WQCalendarGridView *)gridView withDate:(NSDate *)date
{
    [self reloadCalendarDataWithDate:date];
    
    gridView.delegate = self;
    gridView.dataSource = self;
    
    [gridView reloadData];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(calendarMonthDidChange)]) {
        [self.delegate calendarMonthDidChange];
    }
}

#pragma mark -

- (void)reloadCurrentDate
{
    self.currentDate = [NSDate date];
    
    NSDateComponents *c = [self.currentDate YMDComponents];
    self.currentCalendarDay = [WQCalendarDay calendarDayWithYear:c.year month:c.month day:c.day];
}

- (void)reloadCalendarDataWithDate:(NSDate *)date
{
    self.selectedDate = date;
    
    NSDateComponents *c = [date YMDComponents];
    self.selectedCalendarDay = [WQCalendarDay calendarDayWithYear:c.year month:c.month day:c.day];
    
    NSUInteger weeksCount = [date numberOfWeeksInCurrentMonth];
    self.calendarDays = [NSMutableArray arrayWithCapacity:weeksCount * 7];
    
    [self calculateDaysInPreviousMonthWithDate:date];
    [self calculateDaysInCurrentMonthWithDate:date];
    [self calculateDaysInFollowingMonthWithDate:date];
}

#pragma mark - method to calculate days in previous, current and the following month.

- (void)calculateDaysInPreviousMonthWithDate:(NSDate *)date
{
    NSUInteger weeklyOrdinality = [[date firstDayOfCurrentMonth] weeklyOrdinality];
    NSDate *dayInThePreviousMonth = [date dayInThePreviousMonth];
    
    NSUInteger daysCount = [dayInThePreviousMonth numberOfDaysInCurrentMonth];
    NSUInteger partialDaysCount = weeklyOrdinality - 1;
    
    NSDateComponents *components = [dayInThePreviousMonth YMDComponents];
    
    self.daysInPreviousMonth = [NSMutableArray arrayWithCapacity:partialDaysCount];
    for (NSUInteger i = daysCount - partialDaysCount + 1; i < daysCount + 1; ++i) {
        WQCalendarDay *calendarDay = [WQCalendarDay calendarDayWithYear:components.year month:components.month day:i];
        [self.daysInPreviousMonth addObject:calendarDay];
        [self.calendarDays addObject:calendarDay];
    }
}

- (void)calculateDaysInCurrentMonthWithDate:(NSDate *)date
{
    NSUInteger daysCount = [date numberOfDaysInCurrentMonth];
    NSDateComponents *components = [date YMDComponents];
    
    self.daysInCurrentMonth = [NSMutableArray arrayWithCapacity:daysCount];
    for (int i = 1; i < daysCount + 1; ++i) {
        WQCalendarDay *calendarDay = [WQCalendarDay calendarDayWithYear:components.year month:components.month day:i];
        [self.daysInCurrentMonth addObject:calendarDay];
        [self.calendarDays addObject:calendarDay];
    }
}

- (void)calculateDaysInFollowingMonthWithDate:(NSDate *)date
{
    NSUInteger weeklyOrdinality = [[date lastDayOfCurrentMonth] weeklyOrdinality];
    if (weeklyOrdinality == 7) return ;
    
    NSUInteger partialDaysCount = 7 - weeklyOrdinality;
    NSDateComponents *components = [[date dayInTheFollowingMonth] YMDComponents];
    
    self.daysInFollowingMonth = [NSMutableArray arrayWithCapacity:partialDaysCount];
    for (int i = 1; i < partialDaysCount + 1; ++i) {
        WQCalendarDay *calendarDay = [WQCalendarDay calendarDayWithYear:components.year month:components.month day:i];
        [self.daysInFollowingMonth addObject:calendarDay];
        [self.calendarDays addObject:calendarDay];
    }
}

#pragma mark - WQCalendarGridViewDataSource

- (NSUInteger)numberOfRowsInGridView:(WQCalendarGridView *)gridView
{
    return [self.selectedDate numberOfWeeksInCurrentMonth];
}

- (CGFloat)heightForRowInGridView:(WQCalendarGridView *)gridView
{
    return WQ_CALENDAR_ROW_HEIGHT;
}

- (WQCalendarTileView *)gridView:(WQCalendarGridView *)gridView tileViewForRow:(NSUInteger)row column:(NSUInteger)column
{
    WQCalendarTileView *tileView = nil;
    if (tileView == nil) {
        tileView = [[WQCalendarTileView alloc] initWithStyle:kDefaultCalendarTileStyle];
    }
    
    WQCalendarDay *calendarDay = self.calendarDays[row * 7 + column];
    [self configureTileView:tileView withCalendarDay:calendarDay];
    
    if (tileView.selected) self.selectedIndex = row * 7 + column;
    
    return tileView;
}

- (void)configureTileView:(WQCalendarTileView *)tileView withCalendarDay:(WQCalendarDay *)calendarDay
{
    tileView.label.text = [NSString stringWithFormat:@"%lu", (unsigned long)calendarDay.day];
    
    if (calendarDay.month != self.selectedCalendarDay.month) {
        tileView.label.backgroundColor = [UIColor colorWithRed:241/255.0f green:241/255.0f blue:241/255.0f alpha:0.8f];
        tileView.label.textColor = [UIColor grayColor];
    }
    
    if ([calendarDay isEqualTo:self.selectedCalendarDay]) {
        tileView.selected = YES;
    } else {
        tileView.selected = NO;
    }
    
    if ([calendarDay isEqualTo:self.currentCalendarDay]) {
        tileView.label.textColor = [UIColor colorWithRed:249.0/255 green:75.0/255 blue:0 alpha:1];
    }
}

#pragma mark - WQCalendarGridViewDelegate

- (void)gridView:(WQCalendarGridView *)gridView didSelectAtRow:(NSUInteger)row column:(NSUInteger)column
{
    WQCalendarDay *calendarDay = self.calendarDays[row * 7 + column];
    
    BOOL sameMonth = calendarDay.month == self.selectedCalendarDay.month;
    
    self.selectedIndex = row * 7 + column;
    self.selectedCalendarDay = calendarDay;
    self.selectedDate = [self.selectedCalendarDay date];
    
    if (!sameMonth) {
        [self reloadGridView:gridView withDate:self.selectedDate];
    }
}

#pragma mark - WQScrollCalendarViewDataSource

- (NSUInteger)numberOfRowsInCalendarScrollView:(WQScrollCalendarView *)calendarScrollView
{
    return [self.selectedDate numberOfWeeksInCurrentMonth];
}

- (WQCalendarTileView *)scrollCalendarView:(WQScrollCalendarView *)scrollCalendarView tileViewForRow:(NSUInteger)row column:(NSUInteger)column
{
    WQCalendarTileView *tileView = nil;
    if (tileView == nil) {
        tileView = [[WQCalendarTileView alloc] initWithStyle:kDefaultCalendarTileStyle];
    }
    
    WQCalendarDay *calendarDay = self.calendarDays[row * 7 + column];
    tileView.label.text = [NSString stringWithFormat:@"%lu", (unsigned long)calendarDay.day];
    
    if (calendarDay.month != self.selectedCalendarDay.month) {
        tileView.label.backgroundColor = [UIColor colorWithRed:241/255.0f green:241/255.0f blue:241/255.0f alpha:0.8f];
        tileView.label.textColor = [UIColor grayColor];
    }
    
    return tileView;
}

#pragma mark - WQScrollCalendarViewDelegate

- (void)scrollCalendarView:(WQScrollCalendarView *)scrollCalendarView didSelectAtRow:(NSUInteger)row column:(NSUInteger)column
{
    WQCalendarDay *calendarDay = self.calendarDays[row * 7 + column];
    
    BOOL sameMonth = calendarDay.month == self.selectedCalendarDay.month;
    
    self.selectedIndex = row * 7 + column;
    self.selectedCalendarDay = calendarDay;
    self.selectedDate = [self.selectedCalendarDay date];
    
    if (!sameMonth) {
        [self reloadScrollCalendarView:scrollCalendarView withDate:self.selectedDate];
    }
}

#pragma mark -

@end
