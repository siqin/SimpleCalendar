//
//  WQDraggableCalendarView.m
//  WQCalendar
//
//  Created by Jason Lee on 14-3-13.
//  Copyright (c) 2014年 Jason Lee. All rights reserved.
//

#import "WQDraggableCalendarView.h"

typedef enum _wqCalendarPanDirection {
    kNonePanDirection = 0,
    kLeft2RightPanDirection,
    kRight2LeftPanDirection,
    kBottom2TopPanDirection,
    kTop2BottomPanDirection,
    kPanDirectionCount
} WQCalendarPanDirection;

@interface WQDraggableCalendarView () <UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;
@property (nonatomic, assign) WQCalendarPanDirection panDirection;

@property (nonatomic, strong) UIView *wrapperView;

@property (nonatomic, assign) BOOL collapsed;

@property (nonatomic, assign) BOOL isAnimating;

@end

@implementation WQDraggableCalendarView

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

- (void)collpase
{
    if (self.collapsed) return ;
}

- (void)expand
{
    if (!self.collapsed) return ;
}

#pragma mark - setter & getter

- (void)setDraggble:(BOOL)draggble
{
    _draggble = draggble;
    
    if (_draggble) {
        [self addPanGesture];
    } else {
        [self removeGestureRecognizer:self.panGesture];
        self.panGesture = nil;
    }
}

#pragma mark - UIGestureRecognizerDelegate

#pragma mark -

- (void)addPanGesture
{
    if (self.panGesture != nil) {
        return ;
    }
    
    if (self.wrapperView == nil) {
        self.wrapperView = [[UIView alloc] initWithFrame:self.gridView.frame];
        [self insertSubview:self.wrapperView belowSubview:self.gridView];
        self.gridView.frame = self.wrapperView.bounds;
        [self.wrapperView addSubview:self.gridView];
        self.wrapperView.clipsToBounds = YES;
    }
    
    self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onDrag:)];
    self.panGesture.delegate = self;
    self.panGesture.maximumNumberOfTouches = 1;
    [self addGestureRecognizer:self.panGesture];
}

- (void)onDrag:(UIPanGestureRecognizer *)panGesture
{
    CGPoint translation = [panGesture translationInView:self];
    CGPoint velocity = [panGesture velocityInView:self];
    
    BOOL isHorizontal = fabsf(translation.x) > fabsf(translation.y);
    if (isHorizontal) {
        if (velocity.x < 0) {
            self.panDirection = kRight2LeftPanDirection;
        } else {
            self.panDirection = kLeft2RightPanDirection;
        }
        return ;
    } else {
        if (velocity.y < 0) {
            self.panDirection = kBottom2TopPanDirection;
        } else {
            self.panDirection = kTop2BottomPanDirection;
        }
    }
    
    UIGestureRecognizerState state = panGesture.state;
    switch (state) {
        case UIGestureRecognizerStateBegan:
            break;
            
        case UIGestureRecognizerStateChanged:
            [self moveWithTraslation:translation];
            break;
            
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded:
            [self judgeWithVelocity:velocity];
            break;
            
        default:
            break;
    }
}

#pragma mark -

static CGFloat lastYOffset = 0;

- (void)moveWithTraslation:(CGPoint)translation
{
    CGFloat yOffset = translation.y - lastYOffset;
    lastYOffset = translation.y;
    
    if (self.wrapperView.frame.size.height <= WQ_CALENDAR_ROW_HEIGHT && yOffset < 0) {
        return ;
    }
    
    NSInteger selectedRow = self.gridView.selectedRow;
    CGFloat separatorY = selectedRow * WQ_CALENDAR_ROW_HEIGHT;
    
    // wrapperView就负责改变高度
    CGRect wrapperRect = self.wrapperView.frame;
    wrapperRect.size.height += yOffset;
    
    CGRect gridRect = self.gridView.frame;
    
    if (yOffset < 0) {
        // 上拉过程：
        // 当选中行还没到达顶部时，gridView上移
        // 当选中行到达顶部时，gridView改变高度
        if (gridRect.origin.y > -separatorY) {
            gridRect.origin.y += yOffset;
        } else {
            gridRect.size.height += yOffset;
        }
    } else {
        // 下拉过程：
        // 当选中行以下行都展开前，gridView改变高度
        // 当选中行以下行都展开后，gridView下移
        if (gridRect.origin.y < 0) {
            gridRect.origin.y += yOffset;
        } else {
            gridRect.size.height += yOffset;
        }
    }
    
    self.wrapperView.frame = wrapperRect;
    self.gridView.frame = gridRect;
}

- (void)judgeWithVelocity:(CGPoint)velocity
{
    lastYOffset = 0;
    
    BOOL needExpand = velocity.y > 0;
    BOOL needCollapse = velocity.y < 0;
    
    self.wrapperView.backgroundColor = [UIColor yellowColor];
    self.gridView.backgroundColor = [UIColor purpleColor];
    
    if (!self.isAnimating) {
        self.isAnimating = YES;
        
        [UIView animateWithDuration:0.4f animations:^{
            CGRect rect1 = self.wrapperView.frame;
            if (needExpand) {
                rect1.size.height = [self.gridView numberOfRows] * WQ_CALENDAR_ROW_HEIGHT;
            } else if (needCollapse) {
                rect1.size.height = WQ_CALENDAR_ROW_HEIGHT;
            }
            self.wrapperView.frame = rect1;
            
            CGRect rect2 = self.gridView.frame;
            if (rect2.origin.y > 0 || needExpand) {
                rect2.origin.y = 0;
            } else if (rect2.origin.y < 0 || needCollapse) {
                rect2.origin.y = -(self.gridView.selectedRow * WQ_CALENDAR_ROW_HEIGHT);
            }
            rect2.size.height = [self.gridView numberOfRows] * WQ_CALENDAR_ROW_HEIGHT;
            self.gridView.frame = rect2;
        } completion:^(BOOL finished) {
            if (needExpand) {
                self.collapsed = NO;
            } else if (needCollapse) {
                self.collapsed = YES;
            }
            
            self.isAnimating = NO;
        }];
    }
}

#pragma mark -

@end
