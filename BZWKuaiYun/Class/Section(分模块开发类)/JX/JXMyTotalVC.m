//
//  JXMyTotalVC.m
//  BZWKuaiYun
//
//  Created by Jessey Young on 2017/5/27.
//  Copyright © 2017年 ISU. All rights reserved.
//

#import "JXMyTotalVC.h"
#import "JXJudgementVC.h"
#import "JXIncomeVC.h"
#import "JXExpendVC.h"

@interface JXMyTotalVC ()

@end

@implementation JXMyTotalVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupUI];
    [self requestAllData];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = NO;
}
- (void)setupUI
{
    NSArray *titleArray =   @[@"评价",@"收入",@"支出"];
    NSArray *vcsArray = @[@"JXJudgementVC",@"JXIncomeVC",@"JXExpendVC"];
    
    NinaPagerView *nina = [[NinaPagerView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height-kNavBarHeight) WithTitles:titleArray WithVCs:vcsArray];
    nina.selectTitleColor = Main_Color;
    nina.underlineColor = Main_Color;
    nina.selectBottomLinePer = .5f;
    [self.view addSubview:nina];
    
}

//异步请求全部数据
- (void)requestAllData
{
    //请求评价里面的数据
    SVSHOW
    [JXRequestTool postMyCommentNeedPageSize:@"10" pageNum:@"1" complete:^(BOOL isSuccess, NSDictionary *respose) {
        if (isSuccess)
        {
            
            NSDictionary *dic = respose[@"res"];
            [kNotificationCenter postNotificationName:@"evaluate" object:nil userInfo:dic];
        }
    }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}


@end
