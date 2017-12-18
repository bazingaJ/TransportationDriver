//
//  JXExamCell.m
//  BZWKuaiYun
//
//  Created by Jessey Young on 2017/5/25.
//  Copyright © 2017年 ISU. All rights reserved.
//

#import "JXExamCell.h"

@implementation JXExamCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
}
- (IBAction)selectBtnClick:(UIButton *)sender
{
    self.btnA.selected = NO;
    self.btnB.selected = NO;
    self.btnC.selected = NO;
    sender.selected = YES;
    if ([self.delegate respondsToSelector:@selector(optionButtonClick:)])
    {
        [self.delegate optionButtonClick:sender];
    }
    
}

- (void)setModel:(JXExamModel *)model
{
    self.option1Lab.text = model.option1;
    self.option2Lab.text = model.option2;
    self.option3Lab.text = model.option3;
}

- (void)setBtnStatus:(NSString *)btnStatus
{
    NSInteger status = [btnStatus integerValue];
    switch (status)
    {
        case 1:
        {
            self.btnA.selected = YES;
            self.btnB.selected = NO;
            self.btnC.selected = NO;
        }
            break;
        case 2:
        {
            self.btnA.selected = NO;
            self.btnB.selected = YES;
            self.btnC.selected = NO;
        }
            break;
        case 3:
        {
            self.btnA.selected = NO;
            self.btnB.selected = NO;
            self.btnC.selected = YES;
        }
            break;
            
        default:
            break;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    
}

@end
