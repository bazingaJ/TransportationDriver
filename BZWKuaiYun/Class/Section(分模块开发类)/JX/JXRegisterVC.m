//
//  JXRegisterVC.m
//  BZWKuaiYun
//
//  Created by Jessey Young on 2017/5/23.
//  Copyright © 2017年 ISU. All rights reserved.
//

#import "JXRegisterVC.h"
#import "JXRegisterPersonInfoVC.h"
#import "JXPublicWebVC.h"

@interface JXRegisterVC ()<MLLinkLabelDelegate,UITextFieldDelegate>

@property (nonatomic, strong) MLLinkLabel *noticeLab;

@end

@implementation JXRegisterVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"注册";
    [self setupUI];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
}
- (void)setupUI
{
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(0, 0, 30, 40);
    [leftBtn setTitle:@"" forState:UIControlStateNormal];
    [leftBtn setImage:JX_IMAGE(@"fanhuijiantou") forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
    leftBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -16, 0, 0);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    
    self.noticeLab = [[MLLinkLabel alloc] init];
    self.noticeLab.bounds = CGRectMake(0, 0, 200, 20);
    self.noticeLab.center = CGPointMake(self.registerBtn.center.x, MaxY(self.registerBtn)+30);
    self.noticeLab.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.noticeLab];
    
    self.noticeLab.font = [UIFont systemFontOfSize:15.0f];
    self.noticeLab.textColor = [UIColor colorWithWhite:0.400 alpha:1.000];
    self.noticeLab.attributedText = [self generateAttributedString];
    self.noticeLab.delegate = self;
}

//获取验证短信
- (void)requestMsg:(JKCountDownButton *)sender
{
    SVSHOW
    [JXRequestTool postGetMobileCodeNeedMobile:self.mobileTF.text type:@"1" complete:^(BOOL isSuccess, NSDictionary *respose) {
        if (isSuccess)
        {
            SVSUCCESS(@"短信发送成功", 2)
            
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

//发送注册请求
- (void)requestRegister
{
    SVSHOW
    [JXRequestTool postRegisterNeedMobile:self.mobileTF.text password:self.passwordTF.text checkCode:self.codeTF.text complete:^(BOOL isSuccess, NSDictionary *respose) {
        if (isSuccess)
        {
            SVMISS
            
            NSDictionary *dataDic = respose[@"res"];
            
            NSString *driverId = dataDic[@"driverId"];
            NSString *token = dataDic[@"token"];
            
            [JPUSHService setTags:[NSSet setWithObject:@"driver"] alias:[NSString stringWithFormat:@"D%@",dataDic[@"driverId"]] fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
                JXLog(@"极光推送设置别名标签成功的回调iResCode==%d iTags==%@ iAlias== %@",iResCode,iTags,iAlias);
            }];
            
            
            [kUserDefaults setObject:driverId forKey:@"driverId"];
            [kUserDefaults setObject:token forKey:@"token"];
            [kUserDefaults setObject:self.mobileTF.text forKey:@"telephone"];
            [kUserDefaults synchronize];
            
            JXRegisterPersonInfoVC *vc = [[JXRegisterPersonInfoVC alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }];
}

//下划线文字
- (NSMutableAttributedString *)generateAttributedString
{
    NSString *text =@"注册即为同意服务协议";
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:text];
    [attString setAttributes:@{NSUnderlineStyleAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleSingle],NSLinkAttributeName:@"1"} range:[text rangeOfString:@"服务协议"]];
    [self.noticeLab setBeforeAddLinkBlock:^(MLLink *link) {
        link.linkTextAttributes = @{NSForegroundColorAttributeName:Main_Color};
        link.activeLinkTextAttributes = @{NSForegroundColorAttributeName:RGBCOLOR(50, 50, 50),NSBackgroundColorAttributeName:[UIColor whiteColor]};
    }];
    return attString;
}

#pragma mark - MLLinkLabelDelegate
- (void)didClickLink:(MLLink*)link linkText:(NSString*)linkText linkLabel:(MLLinkLabel*)linkLabel
{
    //下划线
    SVSHOW
    //下划线
    [JXRequestTool postQuerySysDictNeedType:@"agreementUrl" complete:^(BOOL isSuccess, NSDictionary *respose) {
        if (isSuccess)
        {
            NSArray *arr = respose[@"res"];
            if (arr.count == 0)
            {
                SVERROR(AboutUsServiceNoDataTips, 1.5)
            }
            else
            {
                SVMISS
                NSDictionary *dictionary = arr[0];
                JXPublicWebVC *vc = [[JXPublicWebVC alloc] init];
                vc.title = @"服务协议";
                vc.urlTxt = dictionary[@"value"];
                [self.navigationController pushViewController:vc animated:YES];
            }
            
        }
    }];
}

//获取验证码
- (IBAction)countDownXibTouched:(JKCountDownButton*)sender
{
    [self.view endEditing:YES];
    //先判断输入的手机号是否合法
    if ([JXTool verifyIsNullString:self.mobileTF.text])
    {
        SVINFO(@"请输入手机号", 2)
        
    }
    else if (![JXTool verifyMobilePhone:self.mobileTF.text])
    {
        SVINFO(@"输入正确的手机号", 2)
    }
    else
    {
        [self requestMsg:sender];
    }
}

//注册信息
- (IBAction)regBtnClick:(UIButton *)sender
{
    [self.view endEditing:YES];
    //先判断输入的手机号是否合法
    if ([JXTool verifyIsNullString:self.mobileTF.text])
    {
        SVINFO(@"请输入手机号", 2)
    }
    else if (![JXTool verifyMobilePhone:self.mobileTF.text])
    {
        SVINFO(@"输入正确的手机号", 2)
    }
    else if (![[JXTool verifyIslegelFromIndex:6 ToIndex:12 string:self.passwordTF.text] isEqualToString:@""])
    {
        NSString *alertString = [JXTool verifyIslegelFromIndex:6 ToIndex:12 string:self.passwordTF.text];
        SVINFO(alertString, 2)
    }
    else if ([JXTool verifyIsNullString:self.codeTF.text])
    {
        SVINFO(@"请输入验证码", 2)
    }
    else
    {
        [self requestRegister];
    }
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string   
{
    if (textField == _mobileTF)
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
    else if (textField == _passwordTF)
    {
        NSInteger loc =range.location;
        if (loc < 12)
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

- (void)backButtonClick
{
    [self.navigationController popViewControllerAnimated:YES];
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
