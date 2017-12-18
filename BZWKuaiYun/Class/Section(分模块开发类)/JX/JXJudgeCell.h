//
//  JXJudgeCell.h
//  BZWKuaiYun
//
//  Created by Jessey Young on 2017/6/1.
//  Copyright © 2017年 ISU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JXJudgeCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *headIMG;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *creatTimeLab;
@property (weak, nonatomic) IBOutlet UILabel *judgeContentLab;

@property (weak, nonatomic) IBOutlet UIImageView *xing1;
@property (weak, nonatomic) IBOutlet UIImageView *xing2;
@property (weak, nonatomic) IBOutlet UIImageView *xing3;
@property (weak, nonatomic) IBOutlet UIImageView *xing4;
@property (weak, nonatomic) IBOutlet UIImageView *xing5;


@property (nonatomic, strong) JXMainModel *model;


@end
