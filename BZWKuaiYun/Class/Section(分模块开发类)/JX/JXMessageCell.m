//
//  JXMessageCell.m
//  BZWKuaiYun
//
//  Created by Jessey Young on 2017/5/27.
//  Copyright © 2017年 ISU. All rights reserved.
//

#import "JXMessageCell.h"

@implementation JXMessageCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
}
- (void)setModel:(JXMainModel *)model
{
    if (![JXTool verifyIsNullString:model.title])
    {
        self.titleLab.text = model.title;
    }
    if (![JXTool verifyIsNullString:model.createDate])
    {
        self.timeLab.text = model.createDate;
    }
    if (![JXTool verifyIsNullString:model.contents])
    {
        self.detailLab.text  = model.contents;
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

}

@end
