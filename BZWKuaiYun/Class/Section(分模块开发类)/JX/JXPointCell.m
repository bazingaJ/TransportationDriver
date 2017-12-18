//
//  JXPointCell.m
//  BZWKuaiYun
//
//  Created by Jessey Young on 2017/5/26.
//  Copyright © 2017年 ISU. All rights reserved.
//

#import "JXPointCell.h"

@implementation JXPointCell

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)setModel:(JXMainModel *)model
{
    self.titleLab.text = model.note;
    self.creatTimeLab.text = model.createTime;
    id type = model.type;
    if ([[NSString stringWithFormat:@"%@",type] isEqualToString:@"1"])//---收入
    {
        id cost = model.cost;
        self.pointLab.text = [NSString stringWithFormat:@"+%@",cost];
    }
    else//--------支出
    {
        id cost = model.cost;
        self.pointLab.text = [NSString stringWithFormat:@"-%@",cost];
        self.pointLab.textColor = Main_Color;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

}

@end
