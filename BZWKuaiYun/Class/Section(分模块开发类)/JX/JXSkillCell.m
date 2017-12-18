//
//  JXSkillCell.m
//  BZWKuaiYun
//
//  Created by Jessey Young on 2017/5/31.
//  Copyright © 2017年 ISU. All rights reserved.
//

#import "JXSkillCell.h"

@interface JXSkillCell ()

@property (nonatomic, strong) UIView *smallView;

@end

@implementation JXSkillCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
}

- (void)setWholeArr:(NSMutableArray *)wholeArr
{
    _wholeArr = wholeArr;
    
}

- (void)drawRect:(CGRect)rect
{
    for (int i = 0; i < _wholeArr.count; i++)
    {
        JXMainModel *model = _wholeArr[i];
        UIView *vi = [[UIView alloc] init];
        vi.frame = CGRectMake(0+(i%3)*(Main_Screen_Width/3), 35+i/3*30, Main_Screen_Width/3, 30);
        vi.backgroundColor = white_color;
        [self.contentView addSubview:vi];
        
        self.btn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.btn.frame = CGRectMake(10, 0, 30, 30);
        
        NSString *isCheck = [NSString stringWithFormat:@"%@",model.isCheck];
        if ([isCheck isEqualToString:@"0"])
        {
            self.btn.selected = NO;
        }
        else
        {
            self.btn.selected = YES;
            
        }
        [self.btn setImage:[UIImage imageNamed:@"weixuanzhong"] forState:UIControlStateNormal];
        [self.btn setImage:[UIImage imageNamed:@"xuanzhong"] forState:UIControlStateSelected];
        [self.btn addTarget:self action:@selector(buttonClick:) forControlEvents:(UIControlEventTouchUpInside)];
        self.btn.tag = 10*i;
        [vi addSubview:self.btn];
        
        self.contentLab = [[UILabel alloc] init];
        self.contentLab.frame = CGRectMake(CGRectGetMaxX(self.btn.frame), 5, (Main_Screen_Width/3)-40, 20);
        self.contentLab.font = F13;
        self.contentLab.text = model.skillDesc;
        self.contentLab.textColor =RGBCOLOR(144, 144, 144);
        [vi addSubview:self.contentLab];
        
    }
}

- (void)buttonClick:(UIButton *)button
{
    if ([self.delegate respondsToSelector:@selector(selectedButtonClick:)])
    {
        [self.delegate selectedButtonClick:button];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
