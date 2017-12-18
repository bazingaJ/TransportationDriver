//
//  JXPointCell.h
//  BZWKuaiYun
//
//  Created by Jessey Young on 2017/5/26.
//  Copyright © 2017年 ISU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JXMainModel.h"

@interface JXPointCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *creatTimeLab;
@property (weak, nonatomic) IBOutlet UILabel *pointLab;
@property (nonatomic, strong) JXMainModel *model;

@end
