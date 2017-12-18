//
//  JXMyWalletVC.m
//  BZWKuaiYun
//
//  Created by Jessey Young on 2017/5/26.
//  Copyright © 2017年 ISU. All rights reserved.
//

#import "JXMyWalletVC.h"
#import "WalletHeaderView.h"
#import "JXRefundVC.h"
#import "JXBalanceVC.h"
#import "JXMyPointVC.h"
#import "JXPaymentVC.h"
#import "JXEditRefundVC.h"

@interface JXMyWalletVC ()<JXWalletHeaderDelegate>
@property (nonatomic, strong) WalletHeaderView *headerView;
@property (nonatomic, strong) NSDictionary *dataDic;
//支付保证金状态
@property (nonatomic, assign) BOOL isPay;
@end

@implementation JXMyWalletVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupUI];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self requestMyWallet];
}
- (void)setupUI
{
    self.tableVi.tableFooterView = [UIView new];
    self.tableVi.tableHeaderView = self.headerView;
}
- (WalletHeaderView *)headerView
{
    if (!_headerView)
    {
        _headerView = [[[NSBundle mainBundle] loadNibNamed:@"WalletHeaderView" owner:self options:nil]objectAtIndex:0];
        _headerView.delegate = self;
        _headerView.frame = CGRectMake(0, 0, Main_Screen_Width, 152);
    }
    return _headerView;
}

- (void)requestMyWallet
{
    [JXRequestTool postmyEwalletInfoComplete:^(BOOL isSuccess, NSDictionary *respose) {
        if (isSuccess)
        {
            self.dataDic = respose[@"res"];
            id point = self.dataDic[@"point"];
            id balance = self.dataDic[@"balance"];
            
            NSString *pointStr = [NSString stringWithFormat:@"%@",point];
            self.headerView.pointLab.text = [pointStr stringByReplacingOccurrencesOfString:@".00" withString:@""];
            
            NSString *balanceStr = [JXAppTool transforMoneyGetPenny:[NSString stringWithFormat:@"%@",balance]];
            self.headerView.balanceLab.text = [balanceStr stringByReplacingOccurrencesOfString:@".00" withString:@""];
            
            id ispay = self.dataDic[@"isPay"];
            self.isPay = [[NSString stringWithFormat:@"%@",ispay] boolValue];

            [self.tableVi reloadData];
        }
    }];
}



#pragma mark - UITable view Data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.textLabel.text = @"保证金";
    cell.textLabel.textColor = RGBCOLOR(50, 50, 50);
    cell.textLabel.font = F14;
    
    cell.detailTextLabel.text = _dataDic[@"isPayDesc"];
    cell.detailTextLabel.textColor = RGBCOLOR(144, 144, 144);
    cell.detailTextLabel.font = F13;
    
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *vi = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 152)];
    vi.backgroundColor = RGBCOLOR(240, 240, 240);
    return vi;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

#pragma mark - UITable view Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_isPay)
    {
        [self performSegueWithIdentifier:@"JXEditRefundVC" sender:nil];
        
    }
    else
    {
        JXPaymentVC *vc = [[JXPaymentVC alloc] init];
        vc.isRegPart = NO;
        vc.isHomePage = NO;
        vc.type = BeforeViewControllerTypeWallet;
        vc.payment = ^(BOOL isHidden) {
            if (isHidden)
            {
                [self requestMyWallet];
            }
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

- (void)pointBtnClick
{
    [self performSegueWithIdentifier:@"JXMyPointVC" sender:nil];
}

- (void)balanceBtnClick
{
    [self performSegueWithIdentifier:@"JXBalanceVC" sender:nil];
}

- (void)showAlertView
{
    JCAlertStyle *style = [JCAlertStyle styleWithType:JCAlertTypeNormal];
    style.alertView.cornerRadius = 5;
    style.background.canDismiss = NO;
    
    style.title.textColor = RGBCOLOR(100, 100, 100);
    style.title.font = F15;
    style.title.insets = UIEdgeInsetsMake(15, 20, 5, 20);
    
    style.content.textColor = RGBCOLOR(144, 144, 144);
    style.content.font = F14;
    style.content.insets = UIEdgeInsetsMake(10, 20, 20, 20);
    style.content.minHeight = 100;
    
    style.buttonNormal.textColor = Main_Color;
    style.buttonCancel.textColor = RGBCOLOR(144, 144, 144);
    
        JCAlertController *alert = [JCAlertController alertWithTitle:@"提示" message:@"确定要退还保证金吗" type:JCAlertTypeNormal];
        [alert addButtonWithTitle:@"取消" type:JCButtonTypeCancel clicked:^{
            
        }];
        [alert addButtonWithTitle:@"确定" type:JCButtonTypeNormal clicked:^{
//            [self requestReturnGuarantee];
        }];
        
    [self jc_presentViewController:alert presentType:JCPresentTypeFIFO presentCompletion:nil dismissCompletion:nil];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}


#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"JXRefundVC"])
    {
        JXRefundVC *vc = segue.destinationViewController;
        vc.isPay = self.isPay;
    }
    if ([segue.identifier isEqualToString:@"JXMyPointVC"])
    {
        id point = self.dataDic[@"point"];
        JXMyPointVC *vc = segue.destinationViewController;
        vc.myPoint = [NSString stringWithFormat:@"%@",point];
    }
    if ([segue.identifier isEqualToString:@"JXBalanceVC"])
    {
        id balance = self.dataDic[@"balance"];
        JXBalanceVC *vc = segue.destinationViewController;
        vc.myBalance = [JXAppTool transforMoneyGetPenny:[NSString stringWithFormat:@"%@",balance]];
    }
}


@end
