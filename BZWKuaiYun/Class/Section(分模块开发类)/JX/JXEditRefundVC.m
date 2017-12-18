//
//  JXEditRefundVC.m
//  BZWKuaiYun
//
//  Created by Jessey Young on 2017/7/24.
//  Copyright © 2017年 ISU. All rights reserved.
//

#import "JXEditRefundVC.h"
#import "JXRefundVC.h"

@interface JXEditRefundVC ()<UITextFieldDelegate>

@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *account;
@property (nonatomic, strong) NSString *time;

@end

@implementation JXEditRefundVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.wechatBtn.selected = YES;
}

//退还保证金
- (void)requestReturnGuaranteeNeedPayment:(NSString *)pay payType:(NSString *)type
{
    SVSHOW
    [JXRequestTool postRefundNeedPayAccount:pay payType:type Complete:^(BOOL isSuccess, NSDictionary *respose) {
        SVMISS
        NSDictionary *dic = respose[@"res"];
        self.type = dic[@"payType"];
        self.account = dic[@"payAcc"];
        self.time = dic[@"resDate"];
        [self performSegueWithIdentifier:@"JXRefundVC" sender:nil];
    }];
    
}
- (IBAction)paymentClick:(UIButton *)sender
{
    self.wechatBtn.selected = NO;
    self.aliBtn.selected = NO;
    sender.selected = YES;
    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == _wechatTF)
    {
        self.wechatBtn.selected = YES;
        self.aliBtn.selected = NO;
    }
    else if (textField == _aliTF)
    {
        self.wechatBtn.selected = NO;
        self.aliBtn.selected = YES;
    }
}

- (IBAction)goPayClick:(UIButton *)sender
{
    if ([_wechatTF.text isEqualToString:@""] && [_aliTF.text isEqualToString:@""])
    {
        SVINFO(@"提现账号不能为空", 2)
    }
    else if (_wechatBtn.selected == YES && [_wechatTF.text isEqualToString:@""])
    {
        SVINFO(@"所选提现账号不能为空", 2)
    }
    else if (_aliBtn.selected == YES && [_aliTF.text isEqualToString:@""])
    {
        SVINFO(@"所选提现账号不能为空", 2)
    }
    else
    {
        if (_wechatBtn.selected)
        {
            [self requestReturnGuaranteeNeedPayment:_wechatTF.text payType:@"1"];
        }
        else
        {
            [self requestReturnGuaranteeNeedPayment:_aliTF.text payType:@"2"];
        }
        
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"JXRefundVC"])
    {
        JXRefundVC *vc = segue.destinationViewController;
        vc.typeStr = [NSString stringWithFormat:@"退款方式：%@",_type];
        vc.accountStr = [NSString stringWithFormat:@"账号信息：%@",_account];
        vc.timeStr = [NSString stringWithFormat:@"退款时间：%@",_time];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}



@end
