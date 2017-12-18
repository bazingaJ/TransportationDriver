//
//  JXBalanceDetailCell.m
//  BZWKuaiYun
//
//  Created by Jessey Young on 2017/5/26.
//  Copyright © 2017年 ISU. All rights reserved.
//

#import "JXBalanceDetailCell.h"

@implementation JXBalanceDetailCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
}

- (void)setModel:(JXMainModel *)model
{
    self.titleLab.text = model.operDesc;
    self.timeLab.text = model.createTime;
    self.contentLab.text = model.note;
    id money = model.amount;
    id type = model.type;
    if ([[NSString stringWithFormat:@"%@",type] isEqualToString:@"1"])//--收入
    {
        self.moneyLab.text = [NSString stringWithFormat:@"+%@",[JXAppTool transforMoneyGetPenny:[NSString stringWithFormat:@"%@",money]]];
        self.moneyLab.textColor = RGBCOLOR(39, 191, 160);
    }
    else//---支出
    {
        self.moneyLab.text = [NSString stringWithFormat:@"-%@",[JXAppTool transforMoneyGetPenny:[NSString stringWithFormat:@"%@",money]]];
        self.moneyLab.textColor = Main_Color;
    }
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    
}

@end
