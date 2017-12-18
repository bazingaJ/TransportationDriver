//
//  JXForgetCodeVC.m
//  BZWKuaiYun
//
//  Created by Jessey Young on 2017/5/23.
//  Copyright © 2017年 ISU. All rights reserved.
//

#import "JXForgetCodeVC.h"
#import "JXConfirmVC.h"

@interface JXForgetCodeVC ()<UITextFieldDelegate>
@property (nonatomic, strong) NSString *codeStr;
@end

@implementation JXForgetCodeVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"忘记密码";
    [self overrideBackButton];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
    
}


//获取验证码
- (IBAction)countDownXibTouched:(JKCountDownButton*)sender
{
    [self.view endEditing:YES];
    //先判断输入的手机号是否合法
    if ([JXTool verifyIsNullString:self.phoneTF.text])
    {
        SVINFO(@"请输入手机号", 2)
        
    }
    else if (![JXTool verifyMobilePhone:self.phoneTF.text])
    {
        SVINFO(@"输入正确的手机号", 2)
    }
    else
    {
        [self requestMsg:sender];
    }
}

//获取验证短信
- (void)requestMsg:(JKCountDownButton *)sender
{
    SVSHOW
    [JXRequestTool postGetMobileCodeNeedMobile:self.phoneTF.text type:@"2" complete:^(BOOL isSuccess, NSDictionary *respose) {
        if (isSuccess)
        {
            [kUserDefaults setObject:_phoneTF.text forKey:@"telephone"];
            [kUserDefaults synchronize];
            
            SVSUCCESS(@"短信发送成功", 2)
            NSDictionary *dic = respose[@"res"];
            self.codeStr = dic[@"code"];
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


- (IBAction)nextBtnClick:(id)sender
{
    [self.view endEditing:YES];
    //先判断输入的手机号是否合法
    if ([JXTool verifyIsNullString:self.phoneTF.text])
    {
        SVINFO(@"请输入手机号", 2)
    }
    else if (![JXTool verifyMobilePhone:self.phoneTF.text])
    {
        SVINFO(@"输入正确的手机号", 2)
    }
    else if ([JXTool verifyIsNullString:self.codeTF.text])
    {
        SVINFO(@"请输入验证码", 2)
    }
    else if (![self.codeTF.text isEqualToString:self.codeStr])
    {
        SVERROR(@"请输入正确的验证码", 2)
    }
    else
    {
        JXConfirmVC *vc = [[JXConfirmVC alloc] init];
        vc.codeStr = self.codeStr;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == _phoneTF)
    {
        NSInteger loc =range.location;
        if (loc < 11)
        {
            return YES;
        }
        else
        {
            return NO;
        }
    }
    else if (textField == _codeTF)
    {
        NSInteger loc =range.location;
        if (loc < 6)
        {
            return YES;
        }
        else
        {
            return NO;
        }
    }
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}



@end
