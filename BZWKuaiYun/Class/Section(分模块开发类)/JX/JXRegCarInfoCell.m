//
//  JXRegCarInfoCell.m
//  BZWKuaiYun
//
//  Created by Jessey Young on 2017/5/23.
//  Copyright © 2017年 ISU. All rights reserved.
//

#import "JXRegCarInfoCell.h"

@implementation JXRegCarInfoCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self.palteBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -25, 0, 0)];
    [self.palteBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 45, 0, 0)];
    [self.palteBtn addTarget:self action:@selector(palteBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self.oneSingleBtn1 addTarget:self action:@selector(oneSingleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.oneSingleBtn2 addTarget:self action:@selector(oneSingleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.oneSingleBtn3 addTarget:self action:@selector(oneSingleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setSpecialString:(NSString *)specialString
{
    _specialString = specialString;
    // 设置特殊规格
    NSArray *arr = [specialString componentsSeparatedByString:@","];
    [self.oneSingleBtn1 setImage:JX_IMAGE(@"guigeweixuan") forState:UIControlStateNormal];
    [self.oneSingleBtn2 setImage:JX_IMAGE(@"guigeweixuan") forState:UIControlStateNormal];
    [self.oneSingleBtn3 setImage:JX_IMAGE(@"guigeweixuan") forState:UIControlStateNormal];
    for (NSString *str in arr)
    {
        if ([str isEqualToString:@"开顶"])
        {
            self.oneSingleBtn1.selected = YES;
        }
        if ([str isEqualToString:@"双排座"])
        {
            self.oneSingleBtn2.selected = YES;
        }
        if ([str isEqualToString:@"带尾板"])
        {
            self.oneSingleBtn3.selected = YES;
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    
}

- (void)palteBtnClick
{
    if ([self.delegate respondsToSelector:@selector(plateBtnClick)])
    {
        [self.delegate plateBtnClick];
    }
}
- (void)oneSingleBtnClick:(UIButton *)btn
{
    btn.selected = !btn.selected;
}
@end
