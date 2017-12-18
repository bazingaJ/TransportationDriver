//
//  WalletHeaderView.m
//  BZWKuaiYun
//
//  Created by Jessey Young on 2017/5/26.
//  Copyright © 2017年 ISU. All rights reserved.
//

#import "WalletHeaderView.h"

@implementation WalletHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        
    }
    return self;
}

- (IBAction)myPoint:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(pointBtnClick)])
    {
        [self.delegate pointBtnClick];
    }
}

- (IBAction)myBalance:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(balanceBtnClick)])
    {
        [self.delegate balanceBtnClick];
    }
}

@end
