//
//  JXWithdrawVC.h
//  BZWKuaiYun
//
//  Created by Jessey Young on 2017/5/26.
//  Copyright © 2017年 ISU. All rights reserved.
//

#import "JXBaseVC.h"
#import "JKCountDownButton.h"

@interface JXWithdrawVC : JXBaseVC
@property (weak, nonatomic) IBOutlet UIButton *wechatBtn;
@property (weak, nonatomic) IBOutlet UIButton *alipayBtn;
@property (weak, nonatomic) IBOutlet UITextField *wechatTF;
@property (weak, nonatomic) IBOutlet UITextField *aliTF;
@property (weak, nonatomic) IBOutlet UITextField *moneyTF;
@property (weak, nonatomic) IBOutlet UITextField *codeTF;
@property (weak, nonatomic) IBOutlet UILabel *bindingLab;
@property (nonatomic, strong) NSString *codetxt;
@property (nonatomic, strong) NSString *leftMoney;

@property (nonatomic, strong) NSString *uploadMoney;


@property (weak, nonatomic) IBOutlet JKCountDownButton *codeBtn;
- (IBAction)countDownXibTouched:(JKCountDownButton*)sender;
@end
