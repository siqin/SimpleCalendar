//
//  WQScrollCalendarView.h
//  WQCalendar
//
//  Created by Jason Lee on 14-3-13.
//  Copyright (c) 2014年 Jason Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WQCalendarTileView.h"

@protocol WQScrollCalendarViewDataSource;
@protocol WQScrollCalendarViewDelegate;

@interface WQScrollCalendarView : UIView

@property (nonatomic, weak) id<WQScrollCalendarViewDataSource> dataSource;
@property (nonatomic, weak) id<WQScrollCalendarViewDelegate> delegate;

- (void)reloadData;

- (NSUInteger)numberOfWeeks;

@end

@protocol WQScrollCalendarViewDataSource <NSObject>

- (NSUInteger)numberOfRowsInCalendarScrollView:(WQScrollCalendarView *)scrollCalendarView;

- (WQCalendarTileView *)scrollCalendarView:(WQScrollCalendarView *)scrollCalendarView
                            tileViewForRow:(NSUInteger)row
                                    column:(NSUInteger)column;

@end

@protocol WQScrollCalendarViewDelegate <NSObject>

- (void)scrollCalendarView:(WQScrollCalendarView *)scrollCalendarView didSelectAtRow:(NSUInteger)row column:(NSUInteger)column;

@end
