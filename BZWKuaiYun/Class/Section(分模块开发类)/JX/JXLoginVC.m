//
//  JXLoginVC.m
//  BZWKuaiYun
//
//  Created by Jessey Young on 2017/5/23.
//  Copyright © 2017年 ISU. All rights reserved.
//

#import "JXLoginVC.h"
#import "JXForgetCodeVC.h"
#import "JXRegisterVC.h"
#import "JXMainTabBarC.h"
#import "JXRegisterPersonInfoVC.h"
#import "JXBZWUserVC.h"
#import "JXReadVC.h"
#import "JXRegPhotoVC.h"

@interface JXLoginVC ()<UITextFieldDelegate>

@end

@implementation JXLoginVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupUI];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
}
- (void)setupUI
{
    
    NSString *tel = USERPHONE;
    NSString *pass = USERPASSWORD;
    if (![JXTool verifyIsNullString:tel])
    {
        self.mobileTF.text = tel;
    }
    if (![JXTool verifyIsNullString:pass])
    {
        self.passwordTF.text = pass;
    }

}
#pragma mark - 设置极光推送别名
//发送登录请求
- (void)requestLogin
{
    SVSHOW
    [JXRequestTool postLoginNeedMobile:self.mobileTF.text password:self.passwordTF.text complete:^(BOOL isSuccess, NSDictionary *respose) {
        
        if (isSuccess)
        {
            SVSUCCESS(@"登录成功", 2);
            NSDictionary *dic = respose[@"res"];
            
            [JPUSHService setTags:[NSSet setWithObject:@"driver"] alias:[NSString stringWithFormat:@"D%@",dic[@"driverId"]] fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
                JXLog(@"极光推送设置别名标签成功的回调iResCode==%d iTags==%@ iAlias== %@",iResCode,iTags,iAlias);
            }];
            
            
            id ckS = dic[@"ckStatus"];
            NSString *ckStatus = [NSString stringWithFormat:@"%@",ckS];
            
            if ([ckStatus isEqualToString:@"2"])
            {
                SVSUCCESS(@"登录成功,请填写认证信息", 1.5);
                [kUserDefaults setObject:dic[@"driverId"] forKey:@"driverId"];
                [kUserDefaults setObject:dic[@"token"] forKey:@"token"];
                [kUserDefaults synchronize];
                JXRegisterPersonInfoVC *vc = [[JXRegisterPersonInfoVC alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
            }
            else
            {
                SVMISS
                [kUserDefaults setObject:dic[@"driverId"] forKey:@"driverId"];
                [kUserDefaults setObject:dic[@"token"] forKey:@"token"];
                [kUserDefaults setObject:@"已登录" forKey:@"loginStatus"];
                id yunStr = dic[@"yunId"];
                [kUserDefaults setObject:[NSString stringWithFormat:@"%@",yunStr] forKey:@"yunId"];
                [kUserDefaults synchronize];
                [self loginDataHandle];
                [self requestPersonalInfo];
                
            }
            
        }
        
    }];
}
//登录数据处理
- (void)loginDataHandle
{
    [kUserDefaults setObject:self.mobileTF.text forKey:@"telephone"];
    [kUserDefaults setObject:self.passwordTF.text forKey:@"password"];
    [kUserDefaults synchronize];
    
    [MobClick profileSignInWithPUID:self.mobileTF.text];
    
    static NSString *identifier =@"JXMainTabBarC";
    JXMainTabBarC *hvc = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:identifier];
    kWindow.rootViewController=hvc;
    
}

//异步获取个人信息
- (void)requestPersonalInfo
{
    [JXRequestTool postMyInfoNeedComplete:^(BOOL isSuccess, NSDictionary *respose) {
        if (isSuccess)
        {
            NSDictionary *dic = respose[@"res"];
            UserInfo *user = [UserInfo defaultUserInfo];
            user.photo = dic[@"photo"];
            user.trueName = dic[@"trueName"];
            user.ontimeRate = dic[@"ontimeRate"];
            user.refuseRate = dic[@"refuseRate"];
            id scoreStr = dic[@"starLevel"];
            user.starLevel = [NSString stringWithFormat:@"%@",scoreStr];
        }
    }];
}

#pragma mark 加载 storyboard 控制器的公共方法
- (IBAction)loginBtnClick:(UIButton *)sender
{
    [self.view endEditing:YES];
    if ([JXTool verifyIsNullString:self.mobileTF.text])
    {
        SVINFO(@"请输入手机号", 2);
    }
    else if (![JXTool verifyMobilePhone:self.mobileTF.text])
    {
        SVINFO(@"手机号码不正确", 2);
    }
    else if ([JXTool verifyIsNullString:self.passwordTF.text])
    {
        SVINFO(@"请输入密码", 2);
    }
    else
    {
        [kUserDefaults setObject:self.mobileTF.text forKey:@"telephone"];
        [kUserDefaults synchronize];
        [self requestLogin];
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
    return YES;
}

//忘记密码
- (IBAction)forgetBtnClick:(UIButton *)sender
{
    JXForgetCodeVC *vc = [[JXForgetCodeVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    
}

//注册
- (IBAction)registerBtn:(id)sender
{
    JXRegisterVC *vc = [[JXRegisterVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

//便装网用户
- (IBAction)BZWUserClick:(UIButton *)sender
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否成为便装网司机" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        JXBZWUserVC *vc = [[JXBZWUserVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:action1];
    [alert addAction:action2];
    [self presentViewController:alert animated:YES completion:nil];
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
