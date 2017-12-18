//
//  JXMyOrderCell.m
//  BZWKuaiYun
//
//  Created by Jessey Young on 2017/5/22.
//  Copyright © 2017年 ISU. All rights reserved.
//

#import "JXMyOrderCell.h"

@implementation JXMyOrderCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.lookOrder.layer.borderColor = Main_Color.CGColor;
    self.cancelOrder.layer.borderColor = Main_Color.CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    
}

- (void)setModel:(OrderModel *)model
{
    NSString *orderType = [NSString stringWithFormat:@"%@",model.orderType];
    if ([orderType isEqualToString:@"1"])
    {
        self.statusImg.image = JX_IMAGE(@"jishi");
    }
    else if ([orderType isEqualToString:@"2"])
    {
        self.statusImg.image = JX_IMAGE(@"yuyue");
    }
    else if ([orderType isEqualToString:@"3"])
    {
        self.statusImg.image = JX_IMAGE(@"zhipai");
    }
    else
    {
        self.statusImg.image = JX_IMAGE(@"jishi");
    }
    
    self.timeLab.text = model.createTime;
    self.orderStatusLab.text = model.statusDesc;
    self.startLocLab.text = model.startTitle;
    self.endLocLab.text = model.endTitle;
    //应收取的金额
    NSString *before = [NSString stringWithFormat:@"%@",model.amount];
    NSMutableString *starMoney = [NSMutableString stringWithString:before];
    if (before.length>= 3)
    {
        [starMoney insertString:@"." atIndex:before.length-2];
        self.orderMoneyLab.text = [NSString stringWithFormat:@"¥ %@",starMoney];
    }
    else if (before.length == 2)
    {
        self.orderMoneyLab.text = [NSString stringWithFormat:@"¥ 0.%@",starMoney];
    }
    else if (before.length == 1)
    {
        self.orderMoneyLab.text = [NSString stringWithFormat:@"¥ 0.0%@",starMoney];
    }
    
}
- (IBAction)checkBtnClick:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(checkOrderBtnClick:)])
    {
        [self.delegate checkOrderBtnClick:sender];
    }
}

- (IBAction)cancelBtnClick:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(cancelOrderBtnClick:)])
    {
        [self.delegate cancelOrderBtnClick:sender];
    }
}

@end
