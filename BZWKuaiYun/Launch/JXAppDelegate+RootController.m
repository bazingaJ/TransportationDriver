//
//  JXAppDelegate+RootController.m
//  BZWKuaiYun
//
//  Created by Jessey Young on 2017/5/19.
//  Copyright © 2017年 ISU. All rights reserved.
//

#import "JXAppDelegate+RootController.h"


@interface JXAppDelegate () <UIScrollViewDelegate,
                             UITabBarControllerDelegate>

@end

@implementation JXAppDelegate (RootController)

- (void)setAppWindows
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = white_color;
}


- (void)setRootViewController
{
    
    if ([JXAppTool isSameVersion])
    {
        [self setRoot];
        
    }
    else
    {
        
        UIViewController *emptyView = [[UIViewController alloc] init];
        emptyView.view.backgroundColor = white_color;
        self.window.rootViewController = emptyView;
        [self createLoadingScrollView];
    }
}

- (void)setRoot
{
    if ([LOGINSTATUS isEqualToString:@"已登录"])
    {
        [self requestPersonalInfo];
        [MobClick profileSignInWithPUID:USERPHONE];
        
        static NSString *identifier =@"JXMainTabBarC";
        JXMainTabBarC *hvc = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:identifier];
        self.window.rootViewController=hvc;
    }
    else
    {
        JXLoginVC *vc = [[JXLoginVC alloc] init];
        UINavigationController * navc = [[UINavigationController alloc] initWithRootViewController:vc];
        navc.navigationBar.titleTextAttributes=@{NSForegroundColorAttributeName: black_color};
        navc.navigationBar.barTintColor = white_color;
        [navc.navigationBar setTranslucent:NO];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        self.window.rootViewController = navc;
    }
    
}

//异步获取个人信息
- (void)requestPersonalInfo
{
    [JXRequestTool postMyInfoNeedComplete:^(BOOL isSuccess, NSDictionary *respose) {
        if (isSuccess)
        {
            NSDictionary *dic = respose[@"res"];
            UserInfo *user = [UserInfo defaultUserInfo];
            user.photo = dic[@"photo"];
            user.trueName = dic[@"trueName"];
            user.ontimeRate = dic[@"ontimeRate"];
            user.refuseRate = dic[@"refuseRate"];
            id scoreStr = dic[@"starLevel"];
            user.starLevel = [NSString stringWithFormat:@"%@",scoreStr];
        }
    }];
}

#pragma mark - 引导页
- (void)createLoadingScrollView;
{
    //引导页
    UIScrollView *sc = [[UIScrollView alloc]initWithFrame:self.window.bounds];
    sc.pagingEnabled = YES;
    sc.delegate = self;
    sc.bounces = NO;
    sc.showsHorizontalScrollIndicator = NO;
    sc.showsVerticalScrollIndicator = NO;
    [self.window.rootViewController.view addSubview:sc];
    
    NSArray *arr = @[@"guide1.jpg",@"guide2.jpg",@"guide3.jpg"];
    for (NSInteger i = 0; i<arr.count; i++)
    {
        UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(Main_Screen_Width*i, 0, Main_Screen_Width, Main_Screen_Height)];
        img.image = JX_IMAGE(arr[i]);
        [sc addSubview:img];
        img.userInteractionEnabled = YES;
        if (i == arr.count - 1)
        {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            btn.frame = CGRectMake(50, Main_Screen_Height-180, Main_Screen_Width-100, 150);
            btn.backgroundColor = clear_color;
            
            [btn addTarget:self action:@selector(goToMain) forControlEvents:UIControlEventTouchUpInside];
            [img addSubview:btn];
        }
    }
    sc.contentSize = CGSizeMake(Main_Screen_Width*arr.count, Main_Screen_Height);
}

- (void)goToMain
{
    NSString *nowVersion = [[NSBundle mainBundle].infoDictionary objectForKey:@"CFBundleShortVersionString"];
    [kUserDefaults setObject:nowVersion forKey:@"versionCode"];
    [kUserDefaults synchronize];
    [self setRoot];
}

@end
