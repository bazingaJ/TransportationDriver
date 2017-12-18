//
//  JXJudgeCell.m
//  BZWKuaiYun
//
//  Created by Jessey Young on 2017/6/1.
//  Copyright © 2017年 ISU. All rights reserved.
//

#import "JXJudgeCell.h"

@implementation JXJudgeCell

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)setModel:(JXMainModel *)model
{
    if (![JXTool verifyIsNullString:model.photo])
    {
        [self.headIMG sd_setImageWithURL:[NSURL URLWithString:model.photo] placeholderImage:[UIImage imageNamed:@"head2"]];
    }
    
    if (![JXTool verifyIsNullString:model.userName])
    {
        self.nameLab.text = model.userName;
    }
    else
    {
        self.nameLab.text = @"服务器没有给姓名";
    }
    if (![JXTool verifyIsNullString:model.createTime])
    {
        self.creatTimeLab.text = model.createTime;
    }
    if (![JXTool verifyIsNullString:model.comment])
    {
        self.judgeContentLab.text = model.comment;
    }
    id xingStr = model.starLevel;
    NSString *xing =[NSString stringWithFormat:@"%@",xingStr];
    if (![JXTool verifyIsNullString:xing])
    {
        switch ([xing integerValue]) {
            case 1:
            {
                self.xing2.hidden = YES;
                self.xing3.hidden = YES;
                self.xing4.hidden = YES;
                self.xing5.hidden = YES;
            }
                break;
            case 2:
            {
                self.xing3.hidden = YES;
                self.xing4.hidden = YES;
                self.xing5.hidden = YES;
            }
                break;
                
            case 3:
            {
                self.xing4.hidden = YES;
                self.xing5.hidden = YES;
            }
                break;
                
            case 4:
            {
                self.xing5.hidden = YES;
            }
                break;
                
            case 5:
            {
                
            }
                break;
                
            default:
            {
                
            }
                break;
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
}

@end
