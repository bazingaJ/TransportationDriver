//
//  JXMainTabBarC.m
//  BZWKuaiYun
//
//  Created by Jessey Young on 2017/5/23.
//  Copyright © 2017年 ISU. All rights reserved.
//

#import "JXMainTabBarC.h"

@interface JXMainTabBarC ()<UITabBarControllerDelegate>

@end

@implementation JXMainTabBarC

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.delegate = self;
    
    NSMutableDictionary *selectAttri = [NSMutableDictionary dictionary];
    selectAttri[NSForegroundColorAttributeName] = Main_Color;
    
    UITabBarItem *tabbar = [UITabBarItem appearance];
    [tabbar setTitleTextAttributes:selectAttri forState:UIControlStateSelected];
    
    
}

#pragma mark 判断是否消除budge
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    //每次点击都会执行的方法
    //点击tabbarItem时进行一次判断
    if([viewController.tabBarItem.title isEqualToString:@"抢单"])
    {
        viewController.tabBarItem.badgeValue = nil;
    }
    return YES;
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
