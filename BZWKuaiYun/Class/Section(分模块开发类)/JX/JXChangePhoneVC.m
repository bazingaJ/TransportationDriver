//
//  JXChangePhoneVC.m
//  BZWKuaiYun
//
//  Created by Jessey Young on 2017/5/26.
//  Copyright © 2017年 ISU. All rights reserved.
//

#import "JXChangePhoneVC.h"

@interface JXChangePhoneVC ()

@end

@implementation JXChangePhoneVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}
#pragma mark - 修改手机号请求
- (void)requestChangeMyPhone
{
    SVSHOW
    [JXRequestTool postUpdateMyInfoNeedPhoto:@"" mobile:_phoneTF.text checkCode:_codeTF.text trueName:@"" uploadType:UploadTypeTelephone complete:^(BOOL isSuccess, NSDictionary *respose) {
        if (isSuccess)
        {
            SVSUCCESS(@"修改成功", 1.5)
        }
    }];
}


- (IBAction)codeBtnClick:(JKCountDownButton *)sender
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
        [self requestMessage:sender];
    }
    
}
//获取验证短信
- (void)requestMessage:(JKCountDownButton *)sender
{
    SVSHOW
    [JXRequestTool postGetMobileCodeNeedMobile:self.phoneTF.text type:@"4" complete:^(BOOL isSuccess, NSDictionary *respose) {
        if (isSuccess)
        {
            SVSUCCESS(@"短信发送成功", 2)
            
            [sender startWithSecond:60];
            [sender didChange:^NSString *(JKCountDownButton *countDownButton, int second)
             {
                 NSString *title = [NSString stringWithFormat:@"剩余%d秒",second];
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
- (IBAction)sureBtnClick:(UIButton *)sender
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
    else
    {
        [self requestChangeMyPhone];
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



@end
