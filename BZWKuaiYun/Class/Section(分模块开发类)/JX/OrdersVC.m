//
//  OrdersVC.m
//  BZWKuaiYun
//
//  Created by Jessey Young on 2017/5/19.
//  Copyright © 2017年 ISU. All rights reserved.
//

#import "OrdersVC.h"

@interface OrdersVC ()

@end

@implementation OrdersVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupUI];
//    [self setupNavigation];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
- (void)setupNavigation
{
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 30, 40);
    [rightBtn setImage:JX_IMAGE(@"dingdanguanlifangdaj") forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(homeRightBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
}
- (void)setupUI
{
    NSArray *titleArray =   @[@"进行中",@"已完成",@"已取消"];
    NSArray *vcsArray = @[@"JXInServiceVC",@"JXCompletedVC",@"JXCanceledVC"];
    
    NinaPagerView *nina = [[NinaPagerView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height-kBottomBarHeight-kNavBarHeight) WithTitles:titleArray WithVCs:vcsArray];
    nina.selectTitleColor = Main_Color;
    nina.underlineColor = Main_Color;
    nina.selectBottomLinePer = .5f;
    [self.view addSubview:nina];
}

- (void)homeRightBtnClick
{
    SVINFO(@"开始搜索", 2);
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
