//
//  WQCalendarGridView.h
//  WQCalendar
//
//  Created by Jason Lee on 14-3-4.
//  Copyright (c) 2014年 Jason Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WQCalendarTileView.h"

@class WQCalendarGridView;

@protocol WQCalendarGridViewDataSource <NSObject>

@required

- (NSUInteger)numberOfRowsInGridView:(WQCalendarGridView *)gridView;

- (WQCalendarTileView *)gridView:(WQCalendarGridView *)gridView tileViewForRow:(NSUInteger)row column:(NSUInteger)column;

@optional

- (CGFloat)heightForRowInGridView:(WQCalendarGridView *)gridView;

@end

@protocol WQCalendarGridViewDelegate <NSObject>

- (void)gridView:(WQCalendarGridView *)gridView didSelectAtRow:(NSUInteger)row column:(NSUInteger)column;

@end

/* ***** */

@interface WQCalendarGridView : UIView

@property (nonatomic, weak) id<WQCalendarGridViewDataSource> dataSource;
@property (nonatomic, weak) id<WQCalendarGridViewDelegate> delegate;

@property (nonatomic, assign) BOOL autoResize; /* 自动根据行数调整高度 */

@property (nonatomic, readonly) BOOL isCollapsed;

@property (nonatomic, readonly) NSInteger selectedRow;
@property (nonatomic, readonly) NSInteger selectedColumn;

- (void)reloadData;

- (WQCalendarTileView *)tileForRow:(NSUInteger)row column:(NSUInteger)column;
- (NSUInteger)numberOfRows;

@end
