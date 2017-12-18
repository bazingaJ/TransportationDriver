//
//  JXBaseNavVC.m
//  BZWKuaiYun
//
//  Created by Jessey Young on 2017/5/19.
//  Copyright © 2017年 ISU. All rights reserved.
//

#import "JXBaseNavVC.h"

@interface JXBaseNavVC ()

@end

@implementation JXBaseNavVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self backBtnRewrite];
    
}

- (void)backBtnRewrite
{
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 30, 40);
    [backBtn setImage:JX_IMAGE(@"fanhuijiantou") forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(homeBaseBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
}
- (void)homeBaseBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
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
