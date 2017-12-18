//
//  BZWUserVC.m
//  BZWKuaiYun
//
//  Created by Jessey Young on 2017/6/22.
//  Copyright © 2017年 ISU. All rights reserved.
//

#import "JXBZWUserVC.h"
#import "JXRegisterPersonInfoVC.h"
#import "JXReadVC.h"
#import "JXPublicWebVC.h"

@interface JXBZWUserVC ()<MLLinkLabelDelegate,UITextFieldDelegate>

@property (nonatomic, strong) MLLinkLabel *notiLab;

@end

@implementation JXBZWUserVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"便装网用户登录";
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
    
    self.notiLab = [[MLLinkLabel alloc] init];
    self.notiLab.bounds = CGRectMake(0, 0, 200, 20);
    self.notiLab.center = CGPointMake(self.registerBtn.center.x, MaxY(self.registerBtn)+50);
    self.notiLab.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.notiLab];
    
    self.notiLab.font = [UIFont systemFontOfSize:15.0f];
    self.notiLab.textColor = [UIColor colorWithWhite:0.400 alpha:1.000];
    self.notiLab.attributedText = [self generateAttributedString];
    self.notiLab.delegate = self;
}

//下划线文字
- (NSMutableAttributedString *)generateAttributedString
{
    NSString *text =@"登录即为同意服务协议";
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:text];
    [attString setAttributes:@{NSUnderlineStyleAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleSingle],NSLinkAttributeName:@"1"} range:[text rangeOfString:@"服务协议"]];
    [self.notiLab setBeforeAddLinkBlock:^(MLLink *link) {
        link.linkTextAttributes = @{NSForegroundColorAttributeName:Main_Color};
        link.activeLinkTextAttributes = @{NSForegroundColorAttributeName:RGBCOLOR(50, 50, 50),NSBackgroundColorAttributeName:[UIColor whiteColor]};
    }];
    return attString;
}

#pragma mark - MLLinkLabelDelegate
- (void)didClickLink:(MLLink*)link linkText:(NSString*)linkText linkLabel:(MLLinkLabel*)linkLabel
{
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

#pragma mark - 请求区
//发送登录请求
- (void)requestLogin
{
    [SVProgressHUD show];
    [JXRequestTool postLoginNeedMobile:self.phoneTF.text password:self.passwordTF.text complete:^(BOOL isSuccess, NSDictionary *respose) {
        
        if (isSuccess)
        {
            
            NSDictionary *dic = respose[@"res"];
            [kUserDefaults setObject:dic[@"driverId"] forKey:@"driverId"];
            [kUserDefaults setObject:dic[@"token"] forKey:@"token"];
            [kUserDefaults setObject:self.phoneTF.text forKey:@"telephone"];
            [kUserDefaults setObject:self.passwordTF.text forKey:@"password"];
            [kUserDefaults synchronize];
            
            id ckS = dic[@"ckStatus"];
            NSString *ckStatus = [NSString stringWithFormat:@"%@",ckS];
            if ([ckStatus isEqualToString:@"1"])
            {
                SVMISS
                static NSString *identifier =@"JXMainTabBarC";
                JXMainTabBarC *hvc = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:identifier];
                kWindow.rootViewController=hvc;
            }
            else if ([ckStatus isEqualToString:@"2"])
            {
                SVSUCCESS(@"登录成功,请填写认证信息", 1.5);
                [self loginDataHandle];
            }
            else if ([ckStatus isEqualToString:@"3"])
            {
                SVSUCCESS(@"登录成功,请阅读材料通过考试", 1.5);
                JXReadVC *VC= [[JXReadVC alloc] init];
                [self.navigationController pushViewController:VC animated:YES];
            }
            else
            {
                SVMISS
            }
            
        }
        
    }];
}
//登录数据处理
- (void)loginDataHandle
{
    JXRegisterPersonInfoVC *vc = [[JXRegisterPersonInfoVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (IBAction)registerBtnClick:(id)sender
{
    [self.view endEditing:YES];
    if ([JXTool verifyIsNullString:self.phoneTF.text])
    {
        SVINFO(@"请输入手机号", 2);
    }
    else if (![JXTool verifyMobilePhone:self.phoneTF.text])
    {
        SVINFO(@"手机号码不正确", 2);
    }
    else if ([JXTool verifyIsNullString:self.passwordTF.text])
    {
        SVINFO(@"请输入密码", 2);
    }
    else
    {
        [kUserDefaults setObject:self.phoneTF.text forKey:@"telephone"];
        [kUserDefaults synchronize];
        [self requestLogin];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
