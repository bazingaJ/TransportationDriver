//
//  JXPaymentVC.m
//  BZWKuaiYun
//
//  Created by Jessey Young on 2017/5/25.
//  Copyright © 2017年 ISU. All rights reserved.
//

#import "JXPaymentVC.h"
#import "JXPublicWebVC.h"
#import "WXApi.h"
#import "WXApiObject.h"
#import <CommonCrypto/CommonDigest.h>

@interface JXPaymentVC ()<MLLinkLabelDelegate>

@property (nonatomic, strong) MLLinkLabel *noticeLab;
@property (nonatomic, strong) NSString *baozhengjin;

@end

@implementation JXPaymentVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"缴纳保证金";
    [self overrideBackButton];
    [self setupUI];
    [self requestMoney];
    [self requestPaymentType];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)requestMoney
{
    SVSHOW
    
    [JXRequestTool postQuerySysDictNeedType:@"baozhengjin" complete:^(BOOL isSuccess, NSDictionary *respose) {
        if (isSuccess)
        {
            SVMISS
            NSArray *arr = respose[@"res"];
            if (arr.count == 0)
            {
                SVERROR(AboutUsServiceNoDataTips, 1.5)
            }
            else
            {
                NSDictionary *dictionary = arr[0];
                //应收取的金额
                NSString *before = [NSString stringWithFormat:@"%@",dictionary[@"value"]];
                NSMutableString *starMoney = [NSMutableString stringWithString:before];
                if (before.length >= 3)
                {
                    [starMoney insertString:@"." atIndex:before.length-2];
                    self.moneyLab.text = [NSString stringWithFormat:@"¥%@元",starMoney];
                    self.descStr = [self.descLab.text stringByReplacingOccurrencesOfString:@"500" withString:[NSString stringWithFormat:@"%@",starMoney]];
                    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:self.descStr];
                    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
                    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
                    paraStyle.lineSpacing = 10;
                    [AttributedStr addAttribute:NSParagraphStyleAttributeName value:paraStyle range:NSMakeRange(0, self.descStr.length)];
                    [self.descLab setAttributedText:AttributedStr];
                }
                else if (before.length == 2)
                {
                    self.moneyLab.text = [NSString stringWithFormat:@"¥0.%@元",starMoney];
                    self.descStr = [self.descLab.text stringByReplacingOccurrencesOfString:@"500" withString:[NSString stringWithFormat:@"0.%@",starMoney]];
                    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:self.descStr];
                    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
                    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
                    paraStyle.lineSpacing = 10;
                    [AttributedStr addAttribute:NSParagraphStyleAttributeName value:paraStyle range:NSMakeRange(0, self.descStr.length)];
                    [self.descLab setAttributedText:AttributedStr];
                }
                else if (before.length == 1)
                {
                    self.moneyLab.text = [NSString stringWithFormat:@"¥0.0%@元",starMoney];
                    self.descStr = [self.descLab.text stringByReplacingOccurrencesOfString:@"500" withString:[NSString stringWithFormat:@"0.0%@",starMoney]];
                    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:self.descStr];
                    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
                    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
                    paraStyle.lineSpacing = 10;
                    [AttributedStr addAttribute:NSParagraphStyleAttributeName value:paraStyle range:NSMakeRange(0, self.descStr.length)];
                    [self.descLab setAttributedText:AttributedStr];
                }
                
            }
        }
        
    }];
}

#pragma mark - 查询支付方式
- (void)requestPaymentType
{
    [JXRequestTool postQuerySysDictNeedType:@"driverPayType" complete:^(BOOL isSuccess, NSDictionary *respose) {
        if (isSuccess)
        {
            NSArray *arr = respose[@"res"];
            if (arr.count < 2)
            {
                NSDictionary *dic = [arr firstObject];
                self.img2.hidden = YES;
                self.lab2.hidden = YES;
                self.alipayBtn.hidden = YES;
                self.lineTop.constant = -15;
                if ([dic[@"label"] isEqualToString:@"支付宝"])
                {
                    self.img1.image = [UIImage imageNamed:@"zhifub"];
                    self.lab1.text = @"支付宝";
                    
                }
            }
        }
    }];
}

- (void)setupUI
{
    //因为主导航界面透明度设置不一样 所以要重新设置不同的约束
    if (_isRegPart)
    {
        UIView *rightView = [[UIView alloc] init];
        rightView.frame = CGRectMake(0, 0, 60, 40);
        
        UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        rightBtn.frame = CGRectMake(15, 5, 60, 30);
        [rightBtn setTitle:@"跳过" forState:UIControlStateNormal];
        rightBtn.titleLabel.font = F16;
        [rightBtn setTitleColor:RGBCOLOR(100, 100, 100) forState:UIControlStateNormal];
        [rightBtn addTarget:self action:@selector(jumpBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [rightView addSubview:rightBtn];
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightView];
    }
    else
    {
        if (_isHomePage)
        {
            self.topViewToTop.constant = 0;
        }
        else
        {
            self.topViewToTop.constant = 64;
        }
        
    }
    UIView *bottomVi = [[UIView alloc] init];
    if (_isRegPart)
    {
        bottomVi.frame = CGRectMake(0, Main_Screen_Height-149, Main_Screen_Width, 40);
    }
    else
    {
        if (_isHomePage)
        {
            bottomVi.frame = CGRectMake(0, Main_Screen_Height-149, Main_Screen_Width, 40);
        }
        else
        {
            bottomVi.frame = CGRectMake(0, Main_Screen_Height-85, Main_Screen_Width, 40);
        }
        
    }
    
    bottomVi.backgroundColor = white_color;
    [self.view addSubview:bottomVi];
    
    self.noticeLab = [[MLLinkLabel alloc] init];
    self.noticeLab.frame = CGRectMake((Main_Screen_Width-250)/2, 0, 250, 40);
    self.noticeLab.textAlignment = NSTextAlignmentCenter;
    self.noticeLab.font = F14;
    self.noticeLab.textColor = RGBCOLOR(50, 50, 50);
    self.noticeLab.attributedText = [self generateAttributedString];
    self.noticeLab.delegate = self;
    [bottomVi addSubview:self.noticeLab];
    
    
}
- (NSMutableAttributedString *)generateAttributedString
{
    NSString *text =@"点击支付保证金，即同意服务协议";
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
    SVSHOW
    //下划线
    [JXRequestTool postQuerySysDictNeedType:@"bondNote" complete:^(BOOL isSuccess, NSDictionary *respose) {
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
- (void)jumpBtnClick
{
    [kUserDefaults setObject:@"已登录" forKey:@"loginStatus"];
    [kUserDefaults synchronize];
    static NSString *identifier =@"JXMainTabBarC";
    JXMainTabBarC *hvc = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:identifier];
    kWindow.rootViewController=hvc;
    
}

- (IBAction)paymentBtnClick:(UIButton *)sender
{
    if ([self.lab1.text isEqualToString:@"支付宝"])
    {
        SVSTATUS(@"正在获取订单信息");
        [JXOrderRequestTool postGetOrderStringComplete:^(BOOL isSuccess, NSDictionary *respose) {
            if (isSuccess)
            {
                SVMISS
                NSDictionary *dic = respose[@"res"];
                [self AliPayNeedOrderString:dic[@"orderString"]];
            }
        }];
    }
    else
    {
        if (self.wechatBtn.selected)
        {
            if([[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:@"weixin://"]])
            {
                [self queryWeChatPayInfomation];
            }
            else
            {
                SVINFO(@"您的设备未安装微信", 2);
            }
            
        }
        else if (self.alipayBtn.selected)
        {
            SVSTATUS(@"正在获取订单信息");
            [JXOrderRequestTool postGetOrderStringComplete:^(BOOL isSuccess, NSDictionary *respose) {
                if (isSuccess)
                {
                    SVMISS
                    NSDictionary *dic = respose[@"res"];
                    [self AliPayNeedOrderString:dic[@"orderString"]];
                }
            }];
            
        }
    }
}

- (void)queryWeChatPayInfomation
{
    SVSTATUS(@"正在获取订单信息");
    [JXOrderRequestTool postWechatPayInfoComplete:^(BOOL isSuccess, NSDictionary *respose) {
        if (isSuccess)
        {
            SVMISS
            NSDictionary *dic = respose[@"res"];
            PayReq* req = [[PayReq alloc] init];
            req.partnerId=dic[@"partnerid"];
            req.prepayId=dic[@"prepayid"];
            req.nonceStr = dic[@"noncestr"];
            req.timeStamp = [dic[@"timestamp"] intValue];
            req.package = dic[@"package"];
            req.sign = dic[@"sign"];
            [WXApi sendReq:req];
        }
    }];
}
- (void)onResp:(BaseResp*)resp;
{
    [self afterPayOption];
}
- (IBAction)thirdPaymentBtn:(UIButton *)sender
{
    self.wechatBtn.selected = NO;
    self.alipayBtn.selected = NO;
    sender.selected = YES;
}

- (void)AliPayNeedOrderString:(NSString *)orderString
{
    //应用注册scheme,在AliSDKDemo-Info.plist定义URL types
    NSString *appScheme = @"kuaiyunDriver";
    
    // NOTE: 将签名成功字符串格式化为订单字符串,请严格按照该格式
    if ([orderString isKindOfClass:[NSString class]] && orderString.length > 0)
    {
        // NOTE: 调用支付结果开始支付
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic)
         {
             JXLog(@"代码中reslut = %@",resultDic);
             NSString *resultStatus = [NSString stringWithFormat:@"%@",resultDic[@"resultStatus"]];
             if ([resultStatus isEqualToString:@"9000"])
             {
                 SVSUCCESS(@"支付完成", 1.5)
                 [self afterPayOption];
             }
             else if ([resultStatus isEqualToString:@"4000"])
             {
                 SVERROR(@"订单支付失败", 1.5)
             }
             else if ([resultStatus isEqualToString:@"5000"])
             {
                 SVERROR(@"重复请求", 1.5)
             }
             else if ([resultStatus isEqualToString:@"6001"])
             {
                 SVERROR(@"支付取消", 1.5)
             }
             else if ([resultStatus isEqualToString:@"6002"])
             {
                 SVERROR(@"网络连接出错", 1.5)
             }
             else
             {
                 SVERROR(@"支付失败", 1.5)
             }
         }];
        
    }
}

- (void)afterPayOption
{
    if (self.payment)
    {
        self.payment(YES);
    }
    __weak typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        switch (weakSelf.type)
        {
            case BeforeViewControllerTypeGrade:
            {
                [kUserDefaults setObject:@"已登录" forKey:@"loginStatus"];
                [kUserDefaults synchronize];
                static NSString *identifier =@"JXMainTabBarC";
                JXMainTabBarC *hvc = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:identifier];
                kWindow.rootViewController=hvc;
            }
                break;
            case BeforeViewControllerTypeHome:
            {
                
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }
                break;
            case BeforeViewControllerTypeWallet:
            {
                //支付完成 刷新首页状态
                [kNotificationCenter postNotificationName:@"payOK" object:nil];
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }
                break;
                
            default:
                break;
        }
        
    });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}



@end
