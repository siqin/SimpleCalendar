//
//  WQCalendarTileView.m
//  WQCalendar
//
//  Created by Jason Lee on 14-3-4.
//  Copyright (c) 2014年 Jason Lee. All rights reserved.
//

#import "WQCalendarTileView.h"

@implementation WQCalendarTileView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithStyle:(WQCalendarTileStyle)style
{
    self = [super init];
    if (self) {
        [self layoutWithStyle:style];
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

- (void)layoutWithStyle:(WQCalendarTileStyle)style
{
    switch (style) {
        case kDefaultCalendarTileStyle:
            [self layoutWithDefaultStyle];
            break;
            
        default:
            break;
    }
}

- (void)layoutWithDefaultStyle
{
    self.backgroundColor = [UIColor whiteColor];
    
    self.label = [[UILabel alloc] init];
    [self addSubview:self.label];
    
    self.label.textAlignment = NSTextAlignmentCenter;
    self.label.backgroundColor = self.backgroundColor;
}

#pragma mark -

- (void)setSelected:(BOOL)selected
{
    static UIColor *selectedColor = nil;
    if (selectedColor == nil) {
        selectedColor = [UIColor colorWithRed:70/255.0f green:171/255.0f blue:179/255.0f alpha:1];
    }
    
    if (selected) {
        self.label.backgroundColor = selectedColor;
    } else {
        self.label.backgroundColor = [UIColor whiteColor];
    }
    
    _selected = selected;
}

@end
