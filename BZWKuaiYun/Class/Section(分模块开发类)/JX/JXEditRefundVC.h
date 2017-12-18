//
//  JXEditRefundVC.h
//  BZWKuaiYun
//
//  Created by Jessey Young on 2017/7/24.
//  Copyright © 2017年 ISU. All rights reserved.
//

#import "JXBaseVC.h"

@interface JXEditRefundVC : JXBaseVC
@property (weak, nonatomic) IBOutlet UITextField *wechatTF;
@property (weak, nonatomic) IBOutlet UITextField *aliTF;

@property (weak, nonatomic) IBOutlet UIButton *wechatBtn;
@property (weak, nonatomic) IBOutlet UIButton *aliBtn;

@property (weak, nonatomic) IBOutlet UIButton *sureBtn;

@end
