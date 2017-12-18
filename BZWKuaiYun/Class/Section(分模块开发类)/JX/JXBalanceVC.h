//
//  JXBalanceVC.h
//  BZWKuaiYun
//
//  Created by Jessey Young on 2017/5/26.
//  Copyright © 2017年 ISU. All rights reserved.
//

#import "JXBaseVC.h"

@interface JXBalanceVC : JXBaseVC

@property (nonatomic, strong) NSString *myBalance;
@property (weak, nonatomic) IBOutlet UILabel *balanceLab;
@property (weak, nonatomic) IBOutlet UILabel *monthLab;
@property (weak, nonatomic) IBOutlet UILabel *wholeLab;

@end
