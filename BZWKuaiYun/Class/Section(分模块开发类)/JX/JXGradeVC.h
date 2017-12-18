//
//  JXGradeVC.h
//  BZWKuaiYun
//
//  Created by Jessey Young on 2017/5/25.
//  Copyright © 2017年 ISU. All rights reserved.
//

#import "JXBaseVC.h"

@interface JXGradeVC : JXBaseVC

@property (nonatomic, assign) BOOL isPass;
@property (weak, nonatomic) IBOutlet UILabel *underGrageLab;
@property (weak, nonatomic) IBOutlet UILabel *grageDetailLab;
@property (weak, nonatomic) IBOutlet UIButton *paymentBtn;
@property (weak, nonatomic) IBOutlet UILabel *gradeLab;

- (instancetype)initWithDic:(NSDictionary *)dict;

@end
