//
//  JXInOutView.m
//  BZWKuaiYun
//
//  Created by Jessey Young on 2017/6/1.
//  Copyright © 2017年 ISU. All rights reserved.
//

#import "JXInOutView.h"

@implementation JXInOutView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    [self.yearBtn setTitle:[NSString stringWithFormat:@"%ld年 ▼",(long)[JXAppTool getNowYearStr]] forState:UIControlStateNormal];
    [self.monthBtn setTitle:[NSString stringWithFormat:@"%02ld月 ▼",(long)[JXAppTool getNowMonthStr]] forState:UIControlStateNormal];
}

- (IBAction)yearBtnClick:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(yearButtonClick)])
    {
        [self.delegate yearButtonClick];
    }
}
- (IBAction)monthBtnClick:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(monthButtonClick)])
    {
        [self.delegate monthButtonClick];
    }
}

@end
