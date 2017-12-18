//
//  JXActivityCell.m
//  BZWKuaiYun
//
//  Created by Jessey Young on 2017/5/27.
//  Copyright © 2017年 ISU. All rights reserved.
//

#import "JXActivityCell.h"

@implementation JXActivityCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
}

- (void)setModel:(JXMainModel *)model
{
    self.titleLab.text = model.title;
    self.detailLab.text = model.eventDesc;
    if (![JXTool verifyIsNullString:model.coverImg])
    {
        [self.activityImage sd_setImageWithURL:[NSURL URLWithString:model.coverImg] placeholderImage:[UIImage imageNamed:@"zhanwei"]];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    
}

@end
