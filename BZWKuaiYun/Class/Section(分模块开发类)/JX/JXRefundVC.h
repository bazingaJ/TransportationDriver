//
//  JXrefund.h
//  BZWKuaiYun
//
//  Created by Jessey Young on 2017/5/26.
//  Copyright © 2017年 ISU. All rights reserved.
//

#import "JXBaseVC.h"

@interface JXRefundVC : JXBaseVC

@property (nonatomic, assign) BOOL isPay;

@property (weak, nonatomic) IBOutlet UILabel *type;
@property (weak, nonatomic) IBOutlet UILabel *account;
@property (weak, nonatomic) IBOutlet UILabel *time;


@property (nonatomic, strong) NSString *typeStr;
@property (nonatomic, strong) NSString *accountStr;
@property (nonatomic, strong) NSString *timeStr;

@end
