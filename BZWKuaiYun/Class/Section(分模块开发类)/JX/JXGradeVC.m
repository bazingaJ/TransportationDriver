//
//  JXGradeVC.m
//  BZWKuaiYun
//
//  Created by Jessey Young on 2017/5/25.
//  Copyright © 2017年 ISU. All rights reserved.
//

#import "JXGradeVC.h"
#import "JXPaymentVC.h"

@interface JXGradeVC ()

@property (nonatomic, strong) NSDictionary *dataDic;

@end

@implementation JXGradeVC

- (instancetype)initWithDic:(NSDictionary *)dict
{
    if (self = [super init])
    {
        self.dataDic = dict;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"考试成绩";
    [self overrideBackButton];
    [self setupUI];
}
- (void)setupUI
{
    self.gradeLab.text = [NSString stringWithFormat:@"%@",_dataDic[@"score"]];
    if (!_isPass)
    {
        self.underGrageLab.text = @"很遗憾您没有通过考试!";
        self.grageDetailLab.text = @"很遗憾您没有通过考试，请点击下方按钮重新进行考核!";
        [self.paymentBtn setTitle:@"重新阅读材料并答题" forState:UIControlStateNormal];
    }
}
- (IBAction)paymentBtn:(UIButton *)sender
{
    if (_isPass)
    {
        //客户多需求 增加控制缴纳保证金管控 0-不需要缴纳保证金可接单 1-需要缴纳保证金才可接单
        NSString *isNeedPay = [NSString stringWithFormat:@"%@",_dataDic[@"isMargin"]];
        if ([isNeedPay isEqualToString:@"0"])
        {
            [kUserDefaults setObject:@"已登录" forKey:@"loginStatus"];
            [kUserDefaults synchronize];
            static NSString *identifier =@"JXMainTabBarC";
            JXMainTabBarC *hvc = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:identifier];
            kWindow.rootViewController=hvc;
        }
        else
        {
            JXPaymentVC *vc = [[JXPaymentVC alloc] init];
            vc.isRegPart = YES;
            vc.type = BeforeViewControllerTypeGrade;
            [self.navigationController pushViewController:vc animated:YES];
        }
        
    }
    else
    {
        int index = (int)[self.navigationController.viewControllers indexOfObject:self];
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:(index-2)] animated:YES];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}



@end
