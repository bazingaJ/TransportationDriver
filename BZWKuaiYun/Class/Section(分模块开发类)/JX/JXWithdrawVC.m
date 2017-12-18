//
//  JXWithdrawVC.m
//  BZWKuaiYun
//
//  Created by Jessey Young on 2017/5/26.
//  Copyright © 2017年 ISU. All rights reserved.
//

#import "JXWithdrawVC.h"

@interface JXWithdrawVC ()<UITextFieldDelegate>

@end

@implementation JXWithdrawVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupUI];
    
}

- (void)setupUI
{
    self.alipayBtn.selected = YES;
    NSString * str = [USERPHONE stringByReplacingOccurrencesOfString:[USERPHONE substringWithRange:NSMakeRange(3,4)]withString:@"****"];
    self.bindingLab.text = [NSString stringWithFormat:@"绑定手机号：%@",str];
}

- (IBAction)countDownXibTouched:(JKCountDownButton*)sender
{
    SVSHOW
    [JXRequestTool postGetMobileCodeNeedMobile:USERPHONE type:@"2" complete:^(BOOL isSuccess, NSDictionary *respose) {
        if (isSuccess)
        {
            
            SVSUCCESS(@"短信发送成功", 2)
            NSDictionary *dic = respose[@"res"];
            //获取到的验证短信
            self.codetxt = dic[@"code"];
            [sender startWithSecond:60];
            [sender didChange:^NSString *(JKCountDownButton *countDownButton, int second)
             {
                 NSString *title = [NSString stringWithFormat:@"%d秒后重新获取",second];
                 sender.enabled=NO;
                 return title;
             }];
            [sender didFinished:^NSString *(JKCountDownButton *countDownButton, int second) {
                sender.enabled=YES;
                return @"重新获取";
            }];
        }
    }];
}

- (IBAction)thirdPayment:(UIButton *)sender
{
    self.wechatBtn.selected = NO;
    self.alipayBtn.selected = NO;
    sender.selected = YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == _wechatTF)
    {
        self.wechatBtn.selected = YES;
        self.alipayBtn.selected = NO;
    }
    if (textField == _aliTF)
    {
        self.wechatBtn.selected = NO;
        self.alipayBtn.selected = YES;
    }
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField  == self.moneyTF)
    {
        NSString *str  = [NSString stringWithFormat:@"%f",[self.moneyTF.text floatValue]*100];
        NSArray *arr = [str componentsSeparatedByString:@"."];
        self.uploadMoney = [arr firstObject];
    }
}

- (IBAction)applyMoney:(UIButton *)sender
{
    if ([self verifyPaymentTypeText])
    {
        if ([self verifyCode])
        {
            NSString *paytype = self.wechatBtn.selected==YES ? @"1" : @"2";
            NSString *payacc = self.wechatBtn.selected==YES ? _wechatTF.text : _aliTF.text;
            
            
            NSString *str  = [NSString stringWithFormat:@"%f",[self.moneyTF.text floatValue]*100];
            NSArray *arr = [str componentsSeparatedByString:@"."];
            self.uploadMoney = [arr firstObject];
            
            SVSHOW
            [JXRequestTool postWithdrawNeedPayType:paytype payAcc:payacc amount:_uploadMoney checkCode:_codeTF.text Complete:^(BOOL isSuccess, NSDictionary *respose) {
                if (isSuccess)
                {
                    SVSUCCESS(@"提现成功", 2)
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }];
        }
    }
    
}

- (BOOL)verifyCode
{
    if ([self.codeTF.text isEqualToString:@""])
    {
        SVINFO(@"请输入验证码", 2)
        return NO;
    }
    else if (self.codeTF.text.length != 6)
    {
        SVINFO(@"请输入正确的验证码", 2)
        return NO;
    }
    else if ([self.codetxt isEqualToString:self.codeTF.text])
    {
        return YES;
    }
    else
    {
        SVINFO(@"验证码错误", 2)
        return NO;
    }
}

- (BOOL)verifyPaymentTypeText
{
    NSString *before = [self.leftMoney stringByReplacingOccurrencesOfString:@"."withString:@""];
    if ([_wechatTF.text isEqualToString:@""] && [_aliTF.text isEqualToString:@""])
    {
        SVINFO(@"请输入提现账号", 2)
        return NO;
    }
    else if ([_moneyTF.text isEqualToString:@""])
    {
        SVINFO(@"请输入提现金额", 2)
        return NO;
    }
    else if ([_uploadMoney compare:before options:NSNumericSearch] == NSOrderedDescending)
    {
        SVINFO(@"提现金额不能大于余额", 2)
        return NO;
    }
    else
    {
        return YES;
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
