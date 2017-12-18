//
//  JXDatePickerView.m
//  BZWKuaiYun
//
//  Created by Jessey Young on 2017/6/27.
//  Copyright © 2017年 ISU. All rights reserved.
//

#import "JXDatePickerView.h"

@interface JXDatePickerView ()<UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic, strong) UIPickerView *pickerView;

@property (nonatomic, strong) NSArray *yearArr;
@property (nonatomic, strong) NSArray *monthArr;

@property (nonatomic, strong) NSMutableArray *wholeArr;
@property (nonatomic, strong) NSMutableArray *indexArray;

@property (nonatomic, strong) NSString *choiceStr;
@property (nonatomic, strong) NSMutableArray *modelArr;

@end
@implementation JXDatePickerView


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self initialized];
        [self setupUI];
        self.backgroundColor = white_color;
    }
    return self;
}

- (void)initialized
{
    NSInteger nowYear = [JXAppTool getNowYearStr];
    self.yearArr = [NSArray arrayWithObjects:[NSString stringWithFormat:@"%ld",nowYear-1],[NSString stringWithFormat:@"%ld",nowYear], nil];
    
    self.monthArr = [NSArray arrayWithObjects:@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12", nil];
    
    
}
- (void)setupUI
{
    UIView *topVi = [[UIView alloc] init];
    topVi.frame = CGRectMake(0, 0, Main_Screen_Width, 44);
    topVi.backgroundColor = white_color;
    [self addSubview:topVi];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(0, 0, 80, 44);
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:RGBCOLOR(100, 100, 100) forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = F15;
    [cancelBtn addTarget:self action:@selector(cancelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [topVi addSubview:cancelBtn];
    
    UIButton *containBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    containBtn.frame = CGRectMake(Main_Screen_Width-80,0, 80,44);
    [containBtn setTitle:@"确定" forState:UIControlStateNormal];
    [containBtn setTitleColor:Main_Color forState:UIControlStateNormal];
    containBtn.titleLabel.font = F15;
    [containBtn addTarget:self action:@selector(caontainBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [topVi addSubview:containBtn];
    
    UILabel *title = [[UILabel alloc] init];
    title.center = CGPointMake(self.center.x, containBtn.center.y);
    title.bounds = CGRectMake(0, 0, 200, 44);
    title.text = @"请选择要查询的日期";
    title.font = F17;
    title.textColor = RGBCOLOR(100, 100, 100);
    title.textAlignment = NSTextAlignmentCenter;
    [topVi addSubview:title];
    
    self.pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 45, Main_Screen_Width, 180)];
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    self.pickerView.backgroundColor = white_color;
    [self addSubview:_pickerView];
    
    
    [self.pickerView selectRow:_yearArr.count-1 inComponent:0 animated:YES];
    [self.pickerView selectRow:[JXAppTool getNowMonthStr]-1 inComponent:1 animated:YES];
}

#pragma mark- UIPicker View DataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component==0)
    {
        return _yearArr.count;
    }
    else
    {
        return _monthArr.count;
    }
    
    
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 40;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    if (component==0) return 125;
    if (component==1) return 100;
    return 0;
}
- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component==0)
    {
        NSString * myDateString = _yearArr[row];
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:myDateString];
        [attrString addAttribute:NSForegroundColorAttributeName value:RGBCOLOR(100, 100, 100) range:NSMakeRange(0, myDateString.length)];
        return attrString;
        
    }
    else
    {
        NSString *strDateWeek =_monthArr[row];
        
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:strDateWeek];
        [attrString addAttribute:NSForegroundColorAttributeName value:RGBCOLOR(100, 100, 100) range:NSMakeRange(0, strDateWeek.length)];
        return attrString;
    }
}
#pragma mark- UIPicker View Delegate
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component==0)
    {
        NSInteger row1   = [pickerView selectedRowInComponent:1];
        if ([_yearArr[row] integerValue] == [JXAppTool getNowYearStr])
        {
            if ((row1+1) > [JXAppTool getNowMonthStr])
            {
                [self.pickerView selectRow:[JXAppTool getNowMonthStr]-1 inComponent:1 animated:YES];
                NSString * call = _yearArr[row];
                NSString * alpha = _monthArr[[JXAppTool getNowMonthStr]-1];
                self.choiceStr=[NSString stringWithFormat:@"%@ %@",call,alpha];
            }
            else
            {
                NSString * call = _yearArr[row];
                NSString * alpha = _monthArr[row1];
                self.choiceStr=[NSString stringWithFormat:@"%@ %@",call,alpha];
            }
        }
        else
        {
            NSString * call = _yearArr[row];
            NSString * alpha = _monthArr[row1];
            self.choiceStr=[NSString stringWithFormat:@"%@ %@",call,alpha];
        }
        
    }
    else
    {
        NSInteger row0=[pickerView selectedRowInComponent:0];
        if ([_yearArr[row0] integerValue] == [JXAppTool getNowYearStr])
        {
            if ((row+1) > [JXAppTool getNowMonthStr])
            {
                [self.pickerView selectRow:[JXAppTool getNowMonthStr]-1 inComponent:1 animated:YES];
                NSString * call  = _yearArr[row0];
                NSString * alpha = _monthArr[[JXAppTool getNowMonthStr]-1];
                self.choiceStr=[NSString stringWithFormat:@"%@ %@",call,alpha];
            }
            else
            {
                NSString * call  = _yearArr[row0];
                NSString * alpha = _monthArr[row];
                self.choiceStr=[NSString stringWithFormat:@"%@ %@",call,alpha];
            }
        }
        else
        {
            NSString * call  = _yearArr[row0];
            NSString * alpha = _monthArr[row];
            self.choiceStr=[NSString stringWithFormat:@"%@ %@",call,alpha];
        }
        
    }
    
}
- (void)cancelBtnClick:(NSString *)str
{
    if ([self.delegate respondsToSelector:@selector(cancelButtonClickAfter:)])
    {
        [self.delegate cancelButtonClickAfter:_choiceStr];
    }
}
- (void)caontainBtnClick:(NSString *)str
{
    if ([self.delegate respondsToSelector:@selector(containButtonClickAfter:)])
    {
        [self.delegate containButtonClickAfter:_choiceStr];
    }
}
@end
