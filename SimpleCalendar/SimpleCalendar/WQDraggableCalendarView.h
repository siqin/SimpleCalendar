//
//  WQDraggableCalendarView.h
//  WQCalendar
//
//  Created by Jason Lee on 14-3-13.
//  Copyright (c) 2014年 Jason Lee. All rights reserved.
//

#import "WQCalendarView.h"

#define DRAGGABLE_CALENDAR_VIEW_FOOTER_HEIGHT       20.0f

@interface WQDraggableCalendarView : WQCalendarView

@property (nonatomic, assign) BOOL draggble;

- (void)collpase;
- (void)expand;

@end
