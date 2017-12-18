//
//  JXSettingVC.m
//  BZWKuaiYun
//
//  Created by Jessey Young on 2017/5/27.
//  Copyright © 2017年 ISU. All rights reserved.
//

#import "JXSettingVC.h"
#import "JXSettingCell.h"
#import "JXDriverRulesVC.h"
#import "JXChargeStandardVC.h"
#import "JXCommonQuestionVC.h"
#import "JXFeedbackVC.h"
#import "JXAboutUsVC.h"

@interface JXSettingVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSArray *titles;
@end

@implementation JXSettingVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initialized];
    [self setupUI];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
- (void)initialized
{
    self.titles = @[@[@"司机守则",@"收费标准",@"常见问题",@"意见反馈"],@[@"关于我们"]];
}
- (void)setupUI
{
    self.tableVi.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

//退出登录接口
- (void)requestExitLogin
{
    SVSHOW
    [JXRequestTool postLogoutcomplete:^(BOOL isSuccess, NSDictionary *respose) {
        if (isSuccess)
        {
            SVMISS
            [kUserDefaults setObject:@"已退出" forKey:@"loginStatus"];
            [kUserDefaults synchronize];
            [MobClick profileSignOff];
            JXLoginVC *vc = [[JXLoginVC alloc] init];
            UINavigationController * navc = [[UINavigationController alloc] initWithRootViewController:vc];
            navc.navigationBar.titleTextAttributes=@{NSForegroundColorAttributeName: black_color};
            navc.navigationBar.barTintColor = white_color;
            [navc.navigationBar setTranslucent:NO];
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
            kWindow.rootViewController = navc;
        }
    }];
}

#pragma mark - UITable view Data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 4;
    }
    else if (section == 1)
    {
        return 1;
    }
    else
    {
        return 1;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID1 = @"cellIdentifier1";
    static NSString *cellID2 = @"cellIdentifier2";
    UITableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:cellID1];
    JXSettingCell *cell2 = [tableView dequeueReusableCellWithIdentifier:cellID2];
    if (indexPath.section == 1)
    {
        if (!cell2)
        {
            cell2 = LoadBbundleCell(@"JXSettingCell", 0);
            cell2.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        return cell2;
    }
    else
    {
        if (!cell1)
        {
            cell1 = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID1];
            cell1.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        if (indexPath.section == 0)
        {
            cell1.textLabel.text = _titles[0][indexPath.row];
            cell1.textLabel.textColor = RGBCOLOR(50, 50, 50);
            cell1.textLabel.font = F14;
        }
        else
        {
            cell1.textLabel.text = _titles[1][indexPath.row];
            cell1.textLabel.textColor = RGBCOLOR(50, 50, 50);
            cell1.textLabel.font = F14;
        }
        return cell1;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
#pragma mark - UITable view Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0)
    {
        switch (indexPath.row) {
            case 0:
            {
                [self performSegueWithIdentifier:@"JXDriverRulesVC" sender:nil];
            }
                break;
            case 1:
            {
                [self performSegueWithIdentifier:@"JXChargeStandardVC" sender:nil];
            }
                break;
            case 2:
            {
                [self performSegueWithIdentifier:@"JXCommonQuestionVC" sender:nil];
            }
                break;
            case 3:
            {
                [self performSegueWithIdentifier:@"JXFeedbackVC" sender:nil];
            }
                break;
                
            default:
                break;
        }
    }
    else if (indexPath.section == 2)
    {
        [self performSegueWithIdentifier:@"JXAboutUsVC" sender:nil];
    }
    else
    {
        
    }
    
}
- (IBAction)exitBtnClick:(UIButton *)sender
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"您确定要退出登录吗？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self requestExitLogin];
        
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:action1];
    [alert addAction:action2];
    [self presentViewController:alert animated:YES completion:nil];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
/*
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
}
*/
@end
