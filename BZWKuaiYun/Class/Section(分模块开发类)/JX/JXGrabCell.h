//
//  JXGrabCell.h
//  BZWKuaiYun
//
//  Created by Jessey Young on 2017/6/1.
//  Copyright © 2017年 ISU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JXHomeModel.h"

@protocol JXGrabOrderDelegate <NSObject>

- (void)grabOrderNowClick:(UIButton *)btn;
- (void)refuseOrderClick:(UIButton *)btn;
- (void)phoneOrderClick:(UIButton *)btn;

@end

@interface JXGrabCell : UITableViewCell

/**
 cell1
 */

@property (weak, nonatomic) IBOutlet UIView *itemView;
@property (weak, nonatomic) IBOutlet UIImageView *headImg;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *mileLab;
@property (weak, nonatomic) IBOutlet UILabel *startLab;
@property (weak, nonatomic) IBOutlet UILabel *startDetailLab;
@property (weak, nonatomic) IBOutlet UILabel *endLab;
@property (weak, nonatomic) IBOutlet UILabel *endDetailLab;
@property (weak, nonatomic) IBOutlet UILabel *moneyLab;
@property (weak, nonatomic) IBOutlet UILabel *remarkLab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *itemViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *remarkW;


/**
 cell2
 */

@property (weak, nonatomic) IBOutlet UIImageView *headImg1;
@property (weak, nonatomic) IBOutlet UILabel *timeLab1;
@property (weak, nonatomic) IBOutlet UILabel *mileLab1;
@property (weak, nonatomic) IBOutlet UILabel *startLab1;
@property (weak, nonatomic) IBOutlet UILabel *startDetailLab1;
@property (weak, nonatomic) IBOutlet UILabel *endLab1;
@property (weak, nonatomic) IBOutlet UILabel *endDetailLab1;
@property (weak, nonatomic) IBOutlet UILabel *moneyLab1;
@property (weak, nonatomic) IBOutlet UILabel *remarkLab1;
@property (weak, nonatomic) IBOutlet UIView *item1View;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *itemH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *remark1H;


@property (nonatomic, assign) id<JXGrabOrderDelegate>delegate;

@property (nonatomic, strong) JXHomeModel *model;
@property (nonatomic, strong) JXHomeModel *model1;

@end
