//
//  JXBalanceDetailCell.h
//  BZWKuaiYun
//
//  Created by Jessey Young on 2017/5/26.
//  Copyright © 2017年 ISU. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface JXBalanceDetailCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *titleLab;
@property (nonatomic, weak) IBOutlet UILabel *timeLab;
@property (nonatomic, weak) IBOutlet UILabel *contentLab;
@property (nonatomic, weak) IBOutlet UILabel *moneyLab;

@property (nonatomic, strong) JXMainModel *model;

@end
