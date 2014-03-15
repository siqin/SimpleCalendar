//
//  WQScrollCalendarWrapperView.m
//  WQCalendar
//
//  Created by Jason Lee on 14-3-14.
//  Copyright (c) 2014年 Jason Lee. All rights reserved.
//

#import "WQScrollCalendarWrapperView.h"
#import "WQCalendarLogic.h"
#import "WQScrollCalendarView.h"

@interface WQScrollCalendarWrapperView ()

@property (nonatomic, strong) WQCalendarLogic *logic4PreMonth;
@property (nonatomic, strong) WQScrollCalendarView *scrollCalendarView4PreMonth;

@property (nonatomic, strong) WQCalendarLogic *logic4CurrentMonth;
@property (nonatomic, strong) WQScrollCalendarView *scrollCalendarView4CurrentMonth;

@property (nonatomic, strong) WQCalendarLogic *logic4NextMonth;
@property (nonatomic, strong) WQScrollCalendarView *scrollCalendarView4NextMonth;

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, assign) BOOL isAnimating;

@property (nonatomic, assign) NSUInteger weeksInPreMonth;
@property (nonatomic, assign) NSUInteger weeksInCurrentMonth;
@property (nonatomic, assign) NSUInteger weeksInNextMonth;
@property (nonatomic, assign) NSUInteger totalWeekIndex; // 在前后3个月里周数目总和的序列，用来判断滚动过程是否发生月份变化

@property (nonatomic, strong) WQCalendarDay *selectedCalendarDay;

@property (nonatomic, assign) NSUInteger currentYear;
@property (nonatomic, assign) NSUInteger currentMonth;
@property (nonatomic, assign) NSUInteger currentWeek; // 当前可见周，即在当前月的第几周

@end

@implementation WQScrollCalendarWrapperView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

#pragma mark -

- (void)reloadData
{
    [self reloadDataWithDate:nil];
}

- (void)reloadDataWithDate:(NSDate *)date
{
    if (date == nil) date = [NSDate date];
    
    [self initData];
    
    [self.logic4PreMonth reloadScrollCalendarView:self.scrollCalendarView4PreMonth withDate:[date dayInThePreviousMonth]];
    [self.logic4CurrentMonth reloadScrollCalendarView:self.scrollCalendarView4CurrentMonth withDate:date];
    [self.logic4NextMonth reloadScrollCalendarView:self.scrollCalendarView4NextMonth withDate:[date dayInTheFollowingMonth]];
    
    [self addAllScrollCalendarViewOntoContentView];
    
    [self moveToDate:date];
}

#pragma mark -

- (void)moveToDate:(NSDate *)date
{
    NSDateComponents *c = [date YMDComponents];
    
    if (c.year != self.currentYear || c.month != self.currentMonth) {
        self.currentYear = c.year;
        self.currentMonth = c.month;
        self.currentWeek = [date weekNumberInCurrentMonth];
        [self reloadDataWithDate:date];
    } else {
        self.currentWeek = [date weekNumberInCurrentMonth];
        [self scrollToWeek:self.currentWeek];
    }
}

- (void)scrollToWeek:(NSUInteger)weekIndex animated:(BOOL)animated
{
    if (!animated) {
        CGRect rect = self.contentView.frame;
        rect.origin.x -= weekIndex * self.bounds.size.width;
        self.contentView.frame = rect;
        self.totalWeekIndex = self.weeksInPreMonth + weekIndex;
    } else {
        CGRect rect = self.contentView.frame;
        rect.origin.x -= weekIndex * self.bounds.size.width;
        
        [UIView animateWithDuration:0.4f animations:^{
            self.contentView.frame = rect;
        } completion:^(BOOL finished) {
            self.totalWeekIndex = self.weeksInPreMonth + weekIndex;
        }];
    }
}

- (void)scrollToWeek:(NSUInteger)weekIndex
{
    [self scrollToWeek:weekIndex animated:NO];
}

#pragma mark -

- (void)addAllScrollCalendarViewOntoContentView
{
    // 在scrollCalendarView reloadData之后，再调整其宽度
    
    CGFloat totalWidth = 0.0f;
    
    self.weeksInPreMonth = [self.scrollCalendarView4PreMonth numberOfWeeks];
    self.weeksInCurrentMonth = [self.scrollCalendarView4CurrentMonth numberOfWeeks];
    self.weeksInNextMonth = [self.scrollCalendarView4NextMonth numberOfWeeks];
    
    CGRect rect = self.bounds;
    rect.size.width = rect.size.width * self.weeksInPreMonth;
    rect.origin.x -= rect.size.width;
    self.scrollCalendarView4PreMonth.frame = rect;
    totalWidth += rect.size.width;
    
    rect = self.bounds;
    rect.size.width = rect.size.width * self.weeksInCurrentMonth;
    rect.origin.x = 0;
    self.scrollCalendarView4CurrentMonth.frame = rect;
    totalWidth += rect.size.width;
    
    rect = self.bounds;
    rect.size.width = rect.size.width * self.weeksInNextMonth;
    rect.origin.x += self.scrollCalendarView4CurrentMonth.frame.size.width;
    self.scrollCalendarView4NextMonth.frame = rect;
    totalWidth += rect.size.width;
    
    // 调整完3个scrollCalendarView的宽度后，再设置contentView的宽度为3个的总宽，用来承载3个scrollCalendarView
    rect = self.bounds;
    rect.size.width = totalWidth;
    self.contentView.frame = rect;
    
    [self.contentView addSubview:self.scrollCalendarView4PreMonth];
    [self.contentView addSubview:self.scrollCalendarView4CurrentMonth];
    [self.contentView addSubview:self.scrollCalendarView4NextMonth];
}

#pragma mark -

- (void)initData
{
    if (self.logic4PreMonth == nil) self.logic4PreMonth = [[WQCalendarLogic alloc] init];
    if (self.logic4CurrentMonth == nil) self.logic4CurrentMonth = [[WQCalendarLogic alloc] init];
    if (self.logic4NextMonth == nil) self.logic4NextMonth = [[WQCalendarLogic alloc] init];
    
    if (self.scrollCalendarView4PreMonth == nil) self.scrollCalendarView4PreMonth = [[WQScrollCalendarView alloc] init];
    if (self.scrollCalendarView4CurrentMonth == nil) self.scrollCalendarView4CurrentMonth = [[WQScrollCalendarView alloc] init];
    if (self.scrollCalendarView4NextMonth == nil) self.scrollCalendarView4NextMonth = [[WQScrollCalendarView alloc] init];
    
    self.scrollCalendarView4PreMonth.frame
    = self.scrollCalendarView4CurrentMonth.frame
    = self.scrollCalendarView4NextMonth.frame
    = self.bounds;
    
    if (self.contentView == nil) {
        self.contentView = [[UIView alloc] initWithFrame:self.bounds];
        [self addSubview:self.contentView];
        
        UISwipeGestureRecognizer *leftSwipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipe:)];
        leftSwipeGesture.direction = UISwipeGestureRecognizerDirectionLeft;
        [self addGestureRecognizer:leftSwipeGesture];
        
        UISwipeGestureRecognizer *rightSwipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipe:)];
        rightSwipeGesture.direction = UISwipeGestureRecognizerDirectionRight;
        [self addGestureRecognizer:rightSwipeGesture];
    }
}

- (void)didSwipe:(UISwipeGestureRecognizer *)swipeGesture
{
    CGRect targetRect = self.contentView.frame;
    NSInteger weekIncrement = 0;
    
    UISwipeGestureRecognizerDirection direction = swipeGesture.direction;
    if (direction == UISwipeGestureRecognizerDirectionLeft) {
        targetRect.origin.x -= self.bounds.size.width;
        weekIncrement = 1;
    } else if (direction == UISwipeGestureRecognizerDirectionRight) {
        targetRect.origin.x += self.bounds.size.width;
        weekIncrement = -1;
    }
    
    if (!self.isAnimating) {
        self.isAnimating = YES;
        
        [UIView animateWithDuration:0.4 animations:^{
            self.contentView.frame = targetRect;
        } completion:^(BOOL finished) {
            self.isAnimating = NO;
            self.totalWeekIndex += weekIncrement;
            self.currentWeek += weekIncrement;
            
            if (self.totalWeekIndex < self.weeksInPreMonth) {
                // 滚到上一个月了
                [self didScrollToPreviousMonth];
            } else if (self.totalWeekIndex >= (self.weeksInPreMonth + self.weeksInCurrentMonth)) {
                // 滚到下一个月了
                [self didScrollToNextMonth];
            } else {
                ;
            }
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(calendarViewDidScroll)]) {
                [self.delegate calendarViewDidScroll];
            }
        }];
    }
}

#pragma mark - 滚动导致月份发生变化

- (void)didScrollToPreviousMonth
{
    WQScrollCalendarView *tempScrollCalendarView = self.scrollCalendarView4CurrentMonth;
    self.scrollCalendarView4CurrentMonth = self.scrollCalendarView4PreMonth;
    self.scrollCalendarView4PreMonth = self.scrollCalendarView4NextMonth;
    self.scrollCalendarView4NextMonth = tempScrollCalendarView;
    
    WQCalendarLogic *tempLogic = self.logic4CurrentMonth;
    self.logic4CurrentMonth = self.logic4PreMonth;
    self.logic4PreMonth = self.logic4NextMonth;
    self.logic4NextMonth = tempLogic;
    
    NSUInteger oldMonth = self.currentMonth;
    self.currentWeek = [self.scrollCalendarView4CurrentMonth numberOfWeeks] - 1;
    if (self.currentMonth == 1) { // 滑到上一年
        self.currentMonth = 12;
        self.currentYear -= 1;
    } else {
        self.currentMonth -= 1;
    }
    
    WQCalendarDay *day = [WQCalendarDay calendarDayWithYear:self.currentYear month:self.currentMonth day:1];
    self.scrollCalendarView4PreMonth.frame = self.bounds; // 记得重设下这里
    [self.logic4PreMonth reloadScrollCalendarView:self.scrollCalendarView4PreMonth withDate:[[day date] dayInThePreviousMonth]];
    
    [self addAllScrollCalendarViewOntoContentView];
    [self scrollToWeek:self.currentWeek];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(monthDidChangeFrom:to:)]) {
        [self.delegate monthDidChangeFrom:oldMonth to:self.currentMonth];
    }
}

- (void)didScrollToNextMonth
{
    WQScrollCalendarView *tempScrollCalendarView = self.scrollCalendarView4CurrentMonth;
    self.scrollCalendarView4CurrentMonth = self.scrollCalendarView4NextMonth;
    self.scrollCalendarView4NextMonth = self.scrollCalendarView4PreMonth;
    self.scrollCalendarView4PreMonth = tempScrollCalendarView;
    
    WQCalendarLogic *tempLogic = self.logic4CurrentMonth;
    self.logic4CurrentMonth = self.logic4NextMonth;
    self.logic4NextMonth = self.logic4PreMonth;
    self.logic4PreMonth = tempLogic;
    
    NSUInteger oldMonth = self.currentMonth;
    self.currentWeek = 0;
    if (self.currentMonth == 12) { // 滑到下一年
        self.currentMonth = 1;
        self.currentYear += 1;
    } else {
        self.currentMonth += 1;
    }
    
    WQCalendarDay *day = [WQCalendarDay calendarDayWithYear:self.currentYear month:self.currentMonth day:1];
    self.scrollCalendarView4NextMonth.frame = self.bounds; // 记得重设下这里
    [self.logic4NextMonth reloadScrollCalendarView:self.scrollCalendarView4NextMonth withDate:[[day date] dayInTheFollowingMonth]];
    
    [self addAllScrollCalendarViewOntoContentView];
    [self scrollToWeek:self.currentWeek];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(monthDidChangeFrom:to:)]) {
        [self.delegate monthDidChangeFrom:oldMonth to:self.currentMonth];
    }
}

#pragma mark -

@end
