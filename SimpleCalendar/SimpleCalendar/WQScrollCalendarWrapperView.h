//
//  WQScrollCalendarWrapperView.h
//  SimpleCalendar
//
//  Created by Jason Lee on 14-3-14.
//  Copyright (c) 2014年 Jason Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WQCalendarDay;

@protocol WQScrollCalendarWrapperViewDelegate;

@interface WQScrollCalendarWrapperView : UIView

@property (nonatomic, weak) id<WQScrollCalendarWrapperViewDelegate> delegate;

- (void)reloadData;

@end

@protocol WQScrollCalendarWrapperViewDelegate <NSObject>

- (void)monthDidChangeFrom:(NSInteger)fromMonth to:(NSInteger)toMonth;

@end
