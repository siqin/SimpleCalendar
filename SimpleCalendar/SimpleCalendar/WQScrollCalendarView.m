//
//  WQScrollCalendarView.m
//  WQCalendar
//
//  Created by Jason Lee on 14-3-13.
//  Copyright (c) 2014年 Jason Lee. All rights reserved.
//

#import "WQScrollCalendarView.h"

@interface WQScrollCalendarView ()

@property (nonatomic, assign) NSUInteger rows;

@property (nonatomic, strong) NSMutableArray *weekViews;
@property (nonatomic, strong) NSMutableArray *tiles;

@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;

@end

@implementation WQScrollCalendarView

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
    if (self.dataSource == nil) {
        return ;
    }
    
    self.clipsToBounds = YES;
    
    self.rows = [self.dataSource numberOfRowsInCalendarScrollView:self];
    
    for (UIView *weekView in self.weekViews) {
        [weekView removeFromSuperview];
    }
    [self.weekViews removeAllObjects];
    self.weekViews = [NSMutableArray arrayWithCapacity:self.rows];
    
    for (WQCalendarTileView *tile in self.tiles) {
        tile.selected = NO;
        [tile removeFromSuperview];
    }
    [self.tiles removeAllObjects];
    self.tiles = [NSMutableArray arrayWithCapacity:self.rows * 7];
    
    CGRect weekViewRect = self.bounds;
    CGFloat rowHeight = self.bounds.size.height;
    CGFloat columnWidth = self.bounds.size.width / 7;
    
    for (int i = 0; i < self.rows; ++i) {
        weekViewRect.origin.x = i * self.bounds.size.width;
        UIView *weekView = [[UIView alloc] initWithFrame:weekViewRect];
        [self.weekViews addObject:weekView];
        [self addSubview:weekView];
        
        for (int j = 0; j < 7; ++j) {
            CGFloat x = j * columnWidth;
            
            WQCalendarTileView *tileView = [self.dataSource scrollCalendarView:self tileViewForRow:i column:j];
            tileView.frame = (CGRect){x, 0, columnWidth, rowHeight};
            tileView.label.frame = tileView.bounds;
            [weekView addSubview:tileView];
            [self.tiles addObject:tileView];
            
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tileViewDidTap:)];
            [tileView addGestureRecognizer:tapGesture];
        }
    }
}

- (NSUInteger)numberOfWeeks
{
    return self.rows;
}

#pragma mark -

- (void)tileViewDidTap:(UITapGestureRecognizer *)tapGesture
{
    ;
}

#pragma mark -

@end
