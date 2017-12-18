//
//  JXMainBottomView.m
//  BZWKuaiYun
//
//  Created by Jessey Young on 2017/6/1.
//  Copyright © 2017年 ISU. All rights reserved.
//

#import "JXMainBottomView.h"

@implementation JXMainBottomView

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)setModel:(JXHomeModel *)model
{
    if ([[NSString stringWithFormat:@"%@",model.orderType] isEqualToString:@"1"])
    {
        self.headImg.image = JX_IMAGE(@"jishi");
    }
    else if ([[NSString stringWithFormat:@"%@",model.orderType] isEqualToString:@"2"])
    {
        self.headImg.image = JX_IMAGE(@"yuyue");
    }
    else if ([[NSString stringWithFormat:@"%@",model.orderType] isEqualToString:@"3"])
    {
        self.headImg.image = JX_IMAGE(@"zhipai");
    }
    else
    {
        self.headImg.image = JX_IMAGE(@"jishi");
    }
    
    self.timeLab.text = model.bookingTime;
    self.mileLab.text = [NSString stringWithFormat:@"%@公里",model.distance];
    NSArray *arr = model.orderTrip;
    self.starLab.text = [arr firstObject][@"title"];
    self.startDetailLab.text = [arr firstObject][@"address"];
    self.endLab.text = [arr lastObject][@"title"];
    self.endDetailLab.text = [arr lastObject][@"address"];
    self.telStr = model.consignorTel;
    self.reciverStr = model.receiverTel;
    if ([JXTool verifyIsNullString:model.remarks])
    {
        self.remark.text = @"暂无留言";
    }
    else
    {
        self.remark.text = model.remarks;
    }
    
    
}


- (IBAction)telBtnClick:(UIButton *)sender
{
    if ([self.statusBtn.currentTitle isEqualToString:@"准备接货"])
    {
        NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",self.telStr];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }
    else
    {
        NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",self.reciverStr];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }
    
}

- (IBAction)OrderBtnClick:(UIButton *)sender
{
    if ([self.doThing respondsToSelector:@selector(buttonClick:)])
    {
        [self.doThing buttonClick:sender];
    }
    
}

@end
