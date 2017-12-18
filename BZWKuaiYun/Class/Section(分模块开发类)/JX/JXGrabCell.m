//
//  JXGrabCell.m
//  BZWKuaiYun
//
//  Created by Jessey Young on 2017/6/1.
//  Copyright © 2017年 ISU. All rights reserved.
//

#import "JXGrabCell.h"

@interface JXGrabCell ()
@property (nonatomic, strong) NSMutableArray *dataArr;
@end

@implementation JXGrabCell

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
    self.startLab.text = [arr firstObject][@"title"];
    self.startDetailLab.text = [arr firstObject][@"address"];
    self.endLab.text = [arr lastObject][@"title"];
    self.endDetailLab.text = [arr lastObject][@"address"];
    //应收取的金额
    NSString *before = [NSString stringWithFormat:@"¥%@",model.actualAmt];
    NSMutableString *starMoney = [NSMutableString stringWithString:before];
    if (before.length>= 3)
    {
        [starMoney insertString:@"." atIndex:before.length-2];
        self.moneyLab.text = [NSString stringWithFormat:@"%@",starMoney];
    }
    else if (before.length == 2)
    {
        self.moneyLab.text = [NSString stringWithFormat:@"0.%@",starMoney];
    }
    else if (before.length == 1)
    {
        self.moneyLab.text = [NSString stringWithFormat:@"0.0%@",starMoney];
    }
    NSString *str = model.baseServer;
    NSString *str1 = model.upgradeServer;

    if (![JXTool verifyIsNullString:str])
    {
        if (![JXTool verifyIsNullString:str1])
        {
            NSArray *separaArr = [str componentsSeparatedByString:@","];
            NSArray *separaArr1 = [str1 componentsSeparatedByString:@","];
            self.dataArr = [NSMutableArray arrayWithArray:separaArr];
            for (int i = 0 ; i < separaArr1.count; i++)
            {
                [self.dataArr addObject:separaArr1[i]];
            }
        }
        else
        {
            self.dataArr = [NSMutableArray arrayWithArray:[str componentsSeparatedByString:@","]];
        }
    }
    else
    {
        if (![JXTool verifyIsNullString:str1])
        {
            self.dataArr = [NSMutableArray arrayWithArray:[str1 componentsSeparatedByString:@","]];
        }
        else
        {
            self.dataArr = [NSMutableArray array];
        }
    }
    
    
    [self setupLeaveItem:_dataArr];
    
    if ([JXTool verifyIsNullString:model.remarks])
    {
        self.remarkLab.text = @"暂无留言";
    }
    else
    {
        self.remarkLab.text = model.remarks;
    }
    
    
}

- (void)setModel1:(JXHomeModel *)model1
{
    if ([[NSString stringWithFormat:@"%@",model1.orderType] isEqualToString:@"1"])
    {
        self.headImg1.image = JX_IMAGE(@"jishi");
    }
    else if ([[NSString stringWithFormat:@"%@",model1.orderType] isEqualToString:@"2"])
    {
        self.headImg1.image = JX_IMAGE(@"yuyue");
    }
    else if ([[NSString stringWithFormat:@"%@",model1.orderType] isEqualToString:@"3"])
    {
        self.headImg1.image = JX_IMAGE(@"zhipai");
    }
    else
    {
        self.headImg1.image = JX_IMAGE(@"jishi");
    }
    
    self.timeLab1.text = model1.bookingTime;
    self.mileLab1.text = [NSString stringWithFormat:@"%@公里",model1.distance];
    NSArray *arr = model1.orderTrip;
    self.startLab1.text = [arr firstObject][@"title"];
    self.startDetailLab1.text = [arr firstObject][@"address"];
    self.endLab1.text = [arr lastObject][@"title"];
    self.endDetailLab1.text = [arr lastObject][@"address"];
    //应收取的金额
    NSString *before = [NSString stringWithFormat:@"¥%@",model1.actualAmt];
    NSMutableString *starMoney = [NSMutableString stringWithString:before];
    if (before.length>= 3)
    {
        [starMoney insertString:@"." atIndex:before.length-2];
        self.moneyLab1.text = [NSString stringWithFormat:@"%@",starMoney];
    }
    else if (before.length == 2)
    {
        self.moneyLab.text = [NSString stringWithFormat:@"0.%@",starMoney];
    }
    else if (before.length == 1)
    {
        self.moneyLab.text = [NSString stringWithFormat:@"0.0%@",starMoney];
    }
    NSString *str = model1.baseServer;
    NSString *str1 = model1.upgradeServer;
    
    if (![JXTool verifyIsNullString:str])
    {
        if (![JXTool verifyIsNullString:str1])
        {
            NSArray *separaArr = [str componentsSeparatedByString:@","];
            NSArray *separaArr1 = [str1 componentsSeparatedByString:@","];
            self.dataArr = [NSMutableArray arrayWithArray:separaArr];
            for (int i = 0 ; i < separaArr1.count; i++)
            {
                [self.dataArr addObject:separaArr1[i]];
            }
        }
        else
        {
            self.dataArr = [NSMutableArray arrayWithArray:[str componentsSeparatedByString:@","]];
        }
    }
    else
    {
        if (![JXTool verifyIsNullString:str1])
        {
            self.dataArr = [NSMutableArray arrayWithArray:[str1 componentsSeparatedByString:@","]];
        }
        else
        {
            self.dataArr = [NSMutableArray array];
        }
    }
    
    
    [self setupLeaveItem1:_dataArr];
    
    if ([JXTool verifyIsNullString:model1.remarks])
    {
        self.remarkLab1.text = @"暂无留言";
    }
    else
    {
        self.remarkLab1.text = model1.remarks;
    }
}

// 设置留言款项的布局
- (void)setupLeaveItem:(NSArray *)arr
{
    CGFloat sumWidth = 0.0f;
    int row = 0;
    CGFloat maxY = .0f;
    
    BOOL isChange = NO;
    if (![JXTool verifyIsNullString:[arr firstObject]])
    {
        for (int i = 0 ; i < arr.count; i++)
        {
            if (sumWidth < Main_Screen_Width)
            {
                UILabel *txtLab = [[UILabel alloc] init];
                CGSize size =  [arr[i] sizeWithAttributes:@{NSFontAttributeName:F13}];
                if (i == 0)//确定第一个位置
                {
                    txtLab.frame = CGRectMake(25, 10, size.width+10, 25);
                    maxY = CGRectGetMaxY(txtLab.frame)+10;
                }
                else
                {
                    if (i == arr.count - 1) //确定最后的maxY
                    {
                        if (sumWidth + size.width + 10 + 25 <= Main_Screen_Width)
                        {
                            txtLab.frame = CGRectMake(sumWidth, row * 25 + 10 * (row + 1), size.width+10, 25);
                            maxY = CGRectGetMaxY(txtLab.frame)+10;
                        }
                        else
                        {
                            row = row + 1;
                            txtLab.frame = CGRectMake(25, row * 25 + 10 * (row + 1), size.width+10, 25);
                            maxY = CGRectGetMaxY(txtLab.frame)+10;
                        }
                    }
                    else //非最后的
                    {
                        if (sumWidth + size.width + 10 + 25 <= Main_Screen_Width)
                        {
                            txtLab.frame = CGRectMake(sumWidth, row * 25 + 10 * (row + 1), size.width+10, 25);
                        }
                        else
                        {
                            row = row + 1;
                            isChange = YES;
                            txtLab.frame = CGRectMake(25, row * 25 + 10 * (row + 1), size.width+10, 25);
                        }
                    }
                    
                }
                
                txtLab.text = arr[i];
                txtLab.font = F13;
                txtLab.textColor = RGBCOLOR(90, 90, 90);
                txtLab.textAlignment = NSTextAlignmentCenter;
                ViewBorderRadius(txtLab,  3, 0.5, RGBCOLOR(140, 140, 140));
                [self.itemView addSubview:txtLab];
                sumWidth= CGRectGetMaxX(txtLab.frame) + 10;
            }
            self.itemViewHeight.constant = maxY;
        }
    }
    else
    {
        self.itemViewHeight.constant = 0;
    }
}


// 设置留言款项的布局
- (void)setupLeaveItem1:(NSArray *)arr
{
    CGFloat sumWidth = 0.0f;
    int row = 0;
    CGFloat maxY = .0f;
    
    BOOL isChange = NO;
    if (![JXTool verifyIsNullString:[arr firstObject]])
    {
        for (int i = 0 ; i < arr.count; i++)
        {
            if (sumWidth < Main_Screen_Width)
            {
                UILabel *txtLab = [[UILabel alloc] init];
                CGSize size =  [arr[i] sizeWithAttributes:@{NSFontAttributeName:F13}];
                if (i == 0)//确定第一个位置
                {
                    txtLab.frame = CGRectMake(25, 10, size.width+10, 25);
                    maxY = CGRectGetMaxY(txtLab.frame)+10;
                }
                else
                {
                    if (i == arr.count - 1) //确定最后的maxY
                    {
                        if (sumWidth + size.width + 10 + 25 <= Main_Screen_Width)
                        {
                            txtLab.frame = CGRectMake(sumWidth, row * 25 + 10 * (row + 1), size.width+10, 25);
                            maxY = CGRectGetMaxY(txtLab.frame)+10;
                        }
                        else
                        {
                            row = row + 1;
                            txtLab.frame = CGRectMake(25, row * 25 + 10 * (row + 1), size.width+10, 25);
                            maxY = CGRectGetMaxY(txtLab.frame)+10;
                        }
                    }
                    else //非最后的
                    {
                        if (sumWidth + size.width + 10 + 25 <= Main_Screen_Width)
                        {
                            txtLab.frame = CGRectMake(sumWidth, row * 25 + 10 * (row + 1), size.width+10, 25);
                        }
                        else
                        {
                            row = row + 1;
                            isChange = YES;
                            txtLab.frame = CGRectMake(25, row * 25 + 10 * (row + 1), size.width+10, 25);
                        }
                    }
                    
                }
                
                txtLab.text = arr[i];
                txtLab.font = F13;
                txtLab.textColor = RGBCOLOR(90, 90, 90);
                txtLab.textAlignment = NSTextAlignmentCenter;
                ViewBorderRadius(txtLab,  3, 0.5, RGBCOLOR(140, 140, 140));
                [self.item1View addSubview:txtLab];
                sumWidth= CGRectGetMaxX(txtLab.frame) + 10;
            }
            self.itemH.constant = maxY;
        }
    }
    else
    {
        self.itemH.constant = 0;
    }
}

- (IBAction)grabNowBtnClick:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(grabOrderNowClick:)])
    {
        [self.delegate grabOrderNowClick:sender];
    }
}
- (IBAction)agreeBtnClick:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(grabOrderNowClick:)])
    {
        [self.delegate grabOrderNowClick:sender];
    }
}

- (IBAction)refuseBtnClick:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(refuseOrderClick:)])
    {
        [self.delegate refuseOrderClick:sender];
    }
}

- (IBAction)phoBtnClick:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(phoneOrderClick:)])
    {
        [self.delegate phoneOrderClick:sender];
    }
}

- (IBAction)cell2PhoneClick:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(phoneOrderClick:)])
    {
        [self.delegate phoneOrderClick:sender];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
}

@end
