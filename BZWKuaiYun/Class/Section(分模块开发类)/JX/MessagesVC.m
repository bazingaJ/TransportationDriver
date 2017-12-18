//
//  MessagesVC.m
//  BZWKuaiYun
//
//  Created by Jessey Young on 2017/5/21.
//  Copyright © 2017年 ISU. All rights reserved.
//

#import "MessagesVC.h"

@interface MessagesVC ()

@end

@implementation MessagesVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"消息中心";
    [self overrideBackButton];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
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
