//
//  JXPickView.m
//  BZWKuaiYun
//
//  Created by Jessey Young on 2017/5/24.
//  Copyright © 2017年 ISU. All rights reserved.
//

#import "JXPickView.h"
#import "JXCityModel.h"

@interface JXPickView ()<UIPickerViewDelegate,UIPickerViewDataSource>
@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) NSArray *shortCalls;
@property (nonatomic, strong) NSMutableArray *wholeArr;
@property (nonatomic, strong) NSMutableArray *indexArray;
@property (nonatomic, strong) NSArray *letterArr;
@property (nonatomic, strong) NSString *choiceStr;
@property (nonatomic, strong) NSMutableArray *modelArr;
@end

@implementation JXPickView

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
    self.shortCalls = [NSArray arrayWithObjects:@"川",@"鄂",@"甘",@"赣",@"桂",@"贵",@"黑",@"沪",@"吉",@"冀",@"晋",@"津",@"京",@"辽",@"鲁",@"蒙",@"闽",@"宁",@"琼",@"青",@"陕",@"苏",@"湘",@"新",@"豫",@"渝",@"皖",@"粤",@"云",@"藏",@"浙", nil];
    self.letterArr = [NSArray arrayWithObjects:@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z", nil];
    
    
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
    [cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [topVi addSubview:cancelBtn];
    
    UIButton *containBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    containBtn.frame = CGRectMake(Main_Screen_Width-80,0, 80,44);
    [containBtn setTitle:@"确定" forState:UIControlStateNormal];
    [containBtn setTitleColor:Main_Color forState:UIControlStateNormal];
    containBtn.titleLabel.font = F15;
    [containBtn addTarget:self action:@selector(caontainBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [topVi addSubview:containBtn];
    
    UILabel *title = [[UILabel alloc] init];
    title.frame = CGRectMake(self.center.x-75, 0, 150, 44);
    title.text = @"选择车牌所在地";
    title.font = F17;
    title.textColor = RGBCOLOR(100, 100, 100);
    title.textAlignment = NSTextAlignmentCenter;
    [topVi addSubview:title];
    
    self.pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 50, Main_Screen_Width, 200)];
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    self.pickerView.backgroundColor = white_color;
    [self addSubview:_pickerView];
    
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
        return _shortCalls.count;
    }
    else
    {
        return _letterArr.count;
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
        NSString * myDateString = _shortCalls[row];
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:myDateString];
        [attrString addAttribute:NSForegroundColorAttributeName value:RGBCOLOR(100, 100, 100) range:NSMakeRange(0, myDateString.length)];
        return attrString;
        
    }
    else
    {
        NSString *strDateWeek =_letterArr[row];
        
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
        NSString * call = _shortCalls[row];
        
        NSInteger row1=[pickerView selectedRowInComponent:1];
        NSString *alpha =_letterArr[row1];
        
        self.choiceStr=[NSString stringWithFormat:@"%@ %@",call,alpha];
        
    }
    else
    {
        NSInteger row0=[pickerView selectedRowInComponent:0];
        NSString * call = _shortCalls[row0];
        
        NSString *alpha = _letterArr[row];
        self.choiceStr=[NSString stringWithFormat:@"%@ %@",call,alpha];
        
    }
    [kNotificationCenter postNotificationName:@"changePlate" object:self.choiceStr];
}
- (void)cancelBtnClick
{
    if ([self.something respondsToSelector:@selector(cancelButtonClickAfter)])
    {
        [self.something cancelButtonClickAfter];
    }
}
- (void)caontainBtnClick
{
    if ([self.something respondsToSelector:@selector(containButtonClickAfter)])
    {
        [self.something containButtonClickAfter];
    }
}

@end
