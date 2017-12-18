//
//  JXInOutCell.m
//  BZWKuaiYun
//
//  Created by Jessey Young on 2017/6/1.
//  Copyright © 2017年 ISU. All rights reserved.
//

#import "JXInOutCell.h"

@implementation JXInOutCell

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)setModel:(JXMainModel *)model
{
    if (![JXTool verifyIsNullString:model.createTime])
    {
        self.timeLab.text = model.createTime;
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
}

@end
