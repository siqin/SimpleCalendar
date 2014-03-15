//
//  WQCalendarGridView.m
//  WQCalendar
//
//  Created by Jason Lee on 14-3-4.
//  Copyright (c) 2014年 Jason Lee. All rights reserved.
//

#import "WQCalendarGridView.h"

@interface WQCalendarGridView ()

@property (nonatomic, assign) NSUInteger rows;
@property (nonatomic, assign) CGFloat rowHeight;
@property (nonatomic, assign) CGFloat columnWidth;

@property (nonatomic, strong) NSMutableArray *tiles;

@property (nonatomic, readwrite) BOOL isCollapsed;

@property (nonatomic, readwrite) NSInteger selectedRow;
@property (nonatomic, readwrite) NSInteger selectedColumn;
@property (nonatomic, strong) WQCalendarTileView *selectedTileView;

@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;

@end

@implementation WQCalendarGridView

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
    self.backgroundColor = [UIColor orangeColor];
    
    self.rows = [self.dataSource numberOfRowsInGridView:self];
    
    self.rowHeight = 46.0f;
    if ([self.dataSource respondsToSelector:@selector(heightForRowInGridView:)]) {
        self.rowHeight = [self.dataSource heightForRowInGridView:self];
    }
    self.columnWidth = self.bounds.size.width / 7;
    
    for (WQCalendarTileView *tile in self.tiles) {
        tile.selected = NO;
        [tile removeFromSuperview];
    }
    [self.tiles removeAllObjects];
    self.tiles = [NSMutableArray arrayWithCapacity:self.rows * 7];
    
    for (int i = 0; i < self.rows; ++i) {
        CGFloat y = i * self.rowHeight;
        for (int j = 0; j < 7; ++j) {
            CGFloat x = j * self.columnWidth;
            
            WQCalendarTileView *tileView = [self.dataSource gridView:self tileViewForRow:i column:j];
            tileView.frame = (CGRect){x, y, self.columnWidth, self.rowHeight};
            tileView.label.frame = tileView.bounds;
            [self addSubview:tileView];
            [self.tiles addObject:tileView];
            
            if (tileView.selected) {
                self.selectedRow = i;
                self.selectedColumn = j;
                self.selectedTileView = tileView;
            }
        }
    }
    
    if (self.autoResize) {
        CGRect frame = self.frame;
        frame.size.height = self.rowHeight * self.rows;
        self.frame = frame;
    }
    
    if (self.tapGesture == nil) {
        self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tileViewDidTap:)];
        [self addGestureRecognizer:self.tapGesture];
    }
}

- (WQCalendarTileView *)tileForRow:(NSUInteger)row column:(NSUInteger)column
{
    NSUInteger index = row * 7 + column;
    if (index > self.tiles.count) return nil;
    return self.tiles[index];
}

- (NSUInteger)numberOfRows
{
    return self.rows;
}

#pragma mark - Private

- (void)tileViewDidTap:(UITapGestureRecognizer *)tapGesture
{
    CGPoint point = [tapGesture locationInView:self];
    int row = point.y / self.rowHeight;
    int column = point.x / self.columnWidth;
    
    WQCalendarTileView *selectedTileView = [self tileForRow:row column:column];
    if (selectedTileView == nil) return ;
    
    self.selectedTileView.selected = NO;
    self.selectedTileView = selectedTileView;
    self.selectedTileView.selected = YES;
    
    self.selectedRow = row;
    self.selectedColumn = column;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(gridView:didSelectAtRow:column:)]) {
        [self.delegate gridView:self didSelectAtRow:row column:column];
    }
}

@end
