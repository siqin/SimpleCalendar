//
//  ViewController.m
//  SimpleCalendar
//
//  Created by Jason Lee on 14-3-3.
//  Copyright (c) 2014年 Jason Lee. All rights reserved.
//

#import "ViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "WQCalendarLogic.h"
#import "WQDraggableCalendarView.h"
#import "WQScrollCalendarWrapperView.h"

@interface ViewController () <UIPickerViewDelegate, UIPickerViewDataSource, WQScrollCalendarWrapperViewDelegate>

@property (nonatomic, strong) UILabel *monthLabel;

@property (nonatomic, strong) WQDraggableCalendarView *calendarView;
@property (nonatomic, strong) WQCalendarLogic *calendarLogic;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.calendarLogic = [[WQCalendarLogic alloc] init];
    
    [self showCalendar];
    
    UIButton *preBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    preBtn.frame = (CGRect){25, 15, 60, 44};
    [preBtn addTarget:self action:@selector(goToPreviousMonth) forControlEvents:UIControlEventTouchUpInside];
    [preBtn setTitle:@"上一月" forState:UIControlStateNormal];
    [self.view addSubview:preBtn];
    
    UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    nextBtn.frame = (CGRect){235, 15, 60, 44};
    [nextBtn addTarget:self action:@selector(goToNextMonth) forControlEvents:UIControlEventTouchUpInside];
    [nextBtn setTitle:@"下一月" forState:UIControlStateNormal];
    [self.view addSubview:nextBtn];
    
    CGRect labelRect = (CGRect){110, 15, 100, 44};
    self.monthLabel = [[UILabel alloc] initWithFrame:labelRect];
    self.monthLabel.textAlignment = NSTextAlignmentCenter;
    self.monthLabel.text = [NSString stringWithFormat:@"%d年%d月", self.calendarLogic.selectedCalendarDay.year, self.calendarLogic.selectedCalendarDay.month];
    self.monthLabel.textColor = [UIColor blackColor];
    [self.view addSubview:self.monthLabel];
    
//    CGRect pickerRect = (CGRect){0, 270, 0, 0};
//    UIPickerView *timePicker = [[UIPickerView alloc] initWithFrame:pickerRect];
//    [self.view addSubview:timePicker];
//    timePicker.delegate = self;
//    timePicker.dataSource = self;
//    timePicker.backgroundColor = [UIColor purpleColor];
}

- (void)showCalendar
{
    CGRect calendarRect = self.view.bounds;
    calendarRect.origin.y += 52, calendarRect.size.height -= 52;
    self.calendarView = [[WQDraggableCalendarView alloc] initWithFrame:calendarRect];
    self.calendarView.draggble = YES;
    [self.view addSubview:self.calendarView];
    self.calendarView.backgroundColor = [UIColor lightGrayColor];
    [self.calendarLogic reloadCalendarView:self.calendarView];
    
    CGRect scrollRect = self.view.bounds;
    scrollRect.origin.y = 400;
    scrollRect.size.height = 40;
    WQScrollCalendarWrapperView *scrollCalendarView = [[WQScrollCalendarWrapperView alloc] initWithFrame:scrollRect];
    scrollCalendarView.backgroundColor = [UIColor greenColor];
    scrollCalendarView.delegate = self;
    [self.view addSubview:scrollCalendarView];
    [scrollCalendarView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 

- (void)goToNextMonth
{
    [self.calendarLogic goToNextMonthInCalendarView:self.calendarView];
    self.monthLabel.text = [NSString stringWithFormat:@"%d年%d月", self.calendarLogic.selectedCalendarDay.year, self.calendarLogic.selectedCalendarDay.month];
}

- (void)goToPreviousMonth
{
    [self.calendarLogic goToPreviousMonthInCalendarView:self.calendarView];
    self.monthLabel.text = [NSString stringWithFormat:@"%d年%d月", self.calendarLogic.selectedCalendarDay.year, self.calendarLogic.selectedCalendarDay.month];
}

#pragma mark - WQScrollCalendarWrapperViewDelegate

- (void)monthDidChangeFrom:(NSInteger)fromMonth to:(NSInteger)toMonth
{
    if (fromMonth == 12 && toMonth == 1) {
        [self goToNextMonth];
    } else if (toMonth < fromMonth || (fromMonth == 1 && toMonth == 12)) {
        [self goToPreviousMonth];
    } else {
        [self goToNextMonth];
    }
}

#pragma mark - UIPickerViewDelegate

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 44;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return 100;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *title = nil;
    
    switch (component) {
        case 0:
            title = [NSString stringWithFormat:@"%d 时", row];
            break;
            
        case 1:
            title = [NSString stringWithFormat:@"%d 分", row];
            break;
            
        default:
            break;
    }
    
    return title;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    ;
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    // http://stackoverflow.com/questions/214441/how-do-you-make-an-uipickerview-component-wrap-around
    
    NSInteger rows = 0;
    
    switch (component) {
        case 0:
            rows = 24;
            break;
            
        case 1:
            rows = 60;
            break;
            
        default:
            break;
    }
    
    return rows;
}

#pragma mark -

@end
