//
//  JXBalanceVC.m
//  BZWKuaiYun
//
//  Created by Jessey Young on 2017/5/26.
//  Copyright © 2017年 ISU. All rights reserved.
//

#import "JXBalanceVC.h"
#import "JXWithdrawVC.h"

@interface JXBalanceVC ()
@property (nonatomic, strong) NSDictionary *dataDic;
@end

@implementation JXBalanceVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupUI];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self requestMyBalance];
}

- (void)setupUI
{
    UIView *rightView = [[UIView alloc] init];
    rightView.frame = CGRectMake(0, 0, 60, 40);
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 70, 40);
    [rightBtn setTitle:@"余额明细" forState:UIControlStateNormal];
    rightBtn.titleLabel.font = F16;
    [rightBtn setTitleColor:RGBCOLOR(100, 100, 100) forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(balanceDetail) forControlEvents:UIControlEventTouchUpInside];
    [rightView addSubview:rightBtn];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightView];
    
    self.balanceLab.text = [self.myBalance stringByReplacingOccurrencesOfString:@".00" withString:@""];
}

- (void)requestMyBalance
{
    SVSHOW
    [JXRequestTool postMyBalanceComplete:^(BOOL isSuccess, NSDictionary *respose) {
        if (isSuccess)
        {
            SVMISS
            self.dataDic = respose[@"res"];
            
            NSString *monthStr =[NSString stringWithFormat:@"%@元",[JXAppTool transforMoneyGetPenny:[NSString stringWithFormat:@"%@",_dataDic[@"monthIncome"]]]];
            self.monthLab.text = [monthStr stringByReplacingOccurrencesOfString:@".00" withString:@""];
            
            
            NSString *wholeStr = [NSString stringWithFormat:@"%@元",[JXAppTool transforMoneyGetPenny:[NSString stringWithFormat:@"%@",_dataDic[@"totalIncome"]]]];
            self.wholeLab.text = [wholeStr stringByReplacingOccurrencesOfString:@".00" withString:@""];
        }
    }];
}


- (void)balanceDetail
{
    [self performSegueWithIdentifier:@"JXBalanceDetailVC" sender:nil];
}
- (IBAction)withdrawBtn:(UIButton *)sender
{
    [self performSegueWithIdentifier:@"JXWithdrawVC" sender:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"JXWithdrawVC"])
    {
        JXWithdrawVC *vc = segue.destinationViewController;
        vc.leftMoney = self.myBalance;
    }
    
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}



@end
