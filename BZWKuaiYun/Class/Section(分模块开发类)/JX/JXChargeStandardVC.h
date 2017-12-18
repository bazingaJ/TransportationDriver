//
//  JXChargeStandardVC.h
//  BZWKuaiYun
//
//  Created by Jessey Young on 2017/5/27.
//  Copyright © 2017年 ISU. All rights reserved.
//

#import "JXBaseVC.h"

@interface JXChargeStandardVC : JXBaseVC

@property (weak, nonatomic) IBOutlet UIScrollView *scr;
@property (weak, nonatomic) IBOutlet UILabel *carTypeLab;
@property (weak, nonatomic) IBOutlet UILabel *firstRoundLab;
@property (weak, nonatomic) IBOutlet UILabel *secondRoundLab;

@property (weak, nonatomic) IBOutlet UILabel *carLoadLab;
@property (weak, nonatomic) IBOutlet UILabel *carOutsideLab;

//包含费用说明的带边框的label 主要用于适应文字高度 做动态适配
@property (weak, nonatomic) IBOutlet UILabel *bigLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bigLabelHeight;
//费用说明下面文字说明Label
@property (nonatomic, weak) IBOutlet UILabel *detailLab;
//费用说明 是一个label
@property (nonatomic, weak) IBOutlet UILabel *wordLab;

@property (nonatomic, weak) IBOutlet UILabel *underLab;

@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomHeight;

@property (weak, nonatomic) IBOutlet UILabel *leftLab;
@property (weak, nonatomic) IBOutlet UILabel *rightLab;

@end
