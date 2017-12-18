//
//  MineVC.m
//  BZWKuaiYun
//
//  Created by Jessey Young on 2017/5/21.
//  Copyright © 2017年 ISU. All rights reserved.
//

#import "MineVC.h"
#import "MineHeaderView.h"
#import "JXPersonInfoVC.h"
#import "JXMyWalletVC.h"
#import "JXSkillCompleteVC.h"
#import "JXInviteFriendVC.h"
#import "JXMessageCenterVC.h"
#import "JXFavorableActivityVC.h"
#import "JXMyTotalVC.h"
#import "JXSettingVC.h"

@interface MineVC ()<JXHeaderViewDelegate>
@property (nonatomic, strong) MineHeaderView *headerView;
@end

@implementation MineVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupUI];
    
    [kNotificationCenter addObserver:self selector:@selector(changeHeadImage:) name:@"changeHeadImage" object:nil];
    
}

- (void)setupUI
{
    self.tableView.contentInset = UIEdgeInsetsMake(-64, 0, 0, 0);
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
    self.navigationController.navigationBar.translucent = YES;
    
    [self requestPersonalInfo];
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setTintColor:white_color];
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
}

- (MineHeaderView *)headerView
{
    if (!_headerView)
    {
        _headerView = [[[NSBundle mainBundle] loadNibNamed:@"MineHeaderView" owner:self options:nil]objectAtIndex:0];
        _headerView.delegate = self;
        _headerView.frame = CGRectMake(0, 0, Main_Screen_Width, 200);
        
        UserInfo *info = [UserInfo defaultUserInfo];
        if (![JXTool verifyIsNullString:info.photo])
        {
            [_headerView.headImg sd_setImageWithURL:[NSURL URLWithString:info.photo] placeholderImage:JX_IMAGE(@"head2")];
        }
        if (![JXTool verifyIsNullString:info.trueName])
        {
            _headerView.userNameLab.text = info.trueName;
        }
        if (![JXTool verifyIsNullString:info.ontimeRate])
        {
            _headerView.onTimeLab.text = info.ontimeRate;
        }
        if (![JXTool verifyIsNullString:info.refuseRate])
        {
            _headerView.refuseLab.text = info.refuseRate;
        }
        if (![JXTool verifyIsNullString:info.starLevel])
        {
            _headerView.grageLab.text = info.starLevel;
        }
    }
    return _headerView;
}

//异步获取个人信息
- (void)requestPersonalInfo
{
    [JXRequestTool postMyInfoNeedComplete:^(BOOL isSuccess, NSDictionary *respose) {
        if (isSuccess)
        {
            NSDictionary *dic = respose[@"res"];
            UserInfo *user = [UserInfo defaultUserInfo];
            user.tel = dic[@"mobile"];
            user.photo = dic[@"photo"];
            user.trueName = dic[@"trueName"];
            user.ontimeRate = dic[@"ontimeRate"];
            user.refuseRate = dic[@"refuseRate"];
            user.carCheckStatus = [NSString stringWithFormat:@"%@",dic[@"carCheckStatus"]];
            id scoreStr = dic[@"starLevel"];
            
            if ([JXTool verifyIsNullString:[NSString stringWithFormat:@"%@",scoreStr]])
            {
                user.starLevel = @"5";
            }
            else
            {
                user.starLevel = [NSString stringWithFormat:@"%@",scoreStr];
            }
            
            
            [_headerView.headImg sd_setImageWithURL:[NSURL URLWithString:user.photo] placeholderImage:JX_IMAGE(@"head2")];
            
            if (![JXTool verifyIsNullString:user.trueName])
            {
                _headerView.userNameLab.text = user.trueName;
            }
            else
            {
                _headerView.userNameLab.text = @"";
            }
            if (![JXTool verifyIsNullString:user.ontimeRate])
            {
                _headerView.onTimeLab.text = user.ontimeRate;
            }
            if (![JXTool verifyIsNullString:user.refuseRate])
            {
                _headerView.refuseLab.text = user.refuseRate;
            }
            if (![JXTool verifyIsNullString:user.starLevel])
            {
                _headerView.grageLab.text = user.starLevel;
            }
        }
    }];
}



- (void)changeHeadImage:(NSNotification *)noti
{
    NSDictionary *dic =noti.userInfo;
    [_headerView.headImg setImage:dic[@"headImg"]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *vi = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 200)];
    [vi addSubview:self.headerView];
    return vi;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 200;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:
        {
            
            [self performSegueWithIdentifier:@"JXMyWalletVC" sender:nil];
        }
            break;
        case 1:
        {
            [self performSegueWithIdentifier:@"JXSkillCompleteVC" sender:nil];
        }
            break;
        case 2:
        {
            [self performSegueWithIdentifier:@"JXInviteFriendVC" sender:nil];
        }
            break;
        case 3:
        {
            [self performSegueWithIdentifier:@"JXMessageCenterVC" sender:nil];
        }
            break;
        case 4:
        {
            [self performSegueWithIdentifier:@"JXFavorableActivityVC" sender:nil];
        }
            break;
        case 5:
        {
            [self performSegueWithIdentifier:@"JXMyTotalVC" sender:nil];
        }
            break;
        case 6:
        {
            [self performSegueWithIdentifier:@"JXSettingVC" sender:nil];
        }
            break;
            
        default:
            break;
    }
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
}


- (void)headViewClick
{
    
    [self performSegueWithIdentifier:@"JXPersonInfoVC" sender:nil];
    
}

- (void)dealloc
{
    [kNotificationCenter removeObserver:self name:@"changeHeadImage" object:nil];
}

@end
