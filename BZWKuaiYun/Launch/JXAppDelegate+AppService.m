//
//  JXAppDelegate+AppService.m
//  BZWKuaiYun
//
//  Created by Jessey Young on 2017/5/19.
//  Copyright © 2017年 ISU. All rights reserved.
//

#import "JXAppDelegate+AppService.h"

#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

@interface JXAppDelegate ()<JPUSHRegisterDelegate,AMapLocationManagerDelegate>

@end

@implementation JXAppDelegate (AppService)

- (void)locationNow
{
    self.locationM = [[AMapLocationManager alloc] init];
    self.locationM.delegate=self;
    self.locationM.distanceFilter = 2;
    self.locationM.locatingWithReGeocode = YES;
    // 带逆地理信息的一次定位（返回坐标和地址信息）
    self.locationM.desiredAccuracy=kCLLocationAccuracyHundredMeters;
    //   定位超时时间，最低2s，此处设置为2s
    self.locationM.locationTimeout =5;
    //   逆地理请求超时时间，最低2s，此处设置为2s
    self.locationM.reGeocodeTimeout = 5;
    [self.locationM requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        if (error)
        {
            JXLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
            if (error.code == AMapLocationErrorLocateFailed)
            {
                return;
            }
        }
        
        if (regeocode)
        {
            [kUserDefaults setObject:@(location.coordinate.longitude) forKey:HomePageLongiString];
            [kUserDefaults setObject:@(location.coordinate.latitude) forKey:HomePageLatitString];
            [kUserDefaults synchronize];
        }
    }];
}

//注册高德
- (void)registerGaoDe
{
    [AMapServices sharedServices].apiKey =GDAppKey;
    [self locationNow];
}
//注册友盟
- (void)registerUMShare
{
    [[UMSocialManager defaultManager] openLog:YES];
    [[UMSocialManager defaultManager] setUmSocialAppkey:UMAppKey];
    
    [self configUSharePlatforms];
}
//注册友盟数据统计
- (void)registerUMDataTotal
{
    UMConfigInstance.appKey = UMAppKey;
    UMConfigInstance.channelId = @"App Store";
    
    [MobClick startWithConfigure:UMConfigInstance];
    
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:version];
    
}

//设置分享平台
- (void)configUSharePlatforms
{
    /* 设置微信的appKey和appSecret */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:WetChatAppID appSecret:WetChatAppSecret redirectURL:@"http://mobile.umeng.com/social"];
    
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:QQAppID  appSecret:QQAppKey redirectURL:@"http://mobile.umeng.com/social"];
    
    /* 设置新浪的appKey和appSecret */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:SinaAppID  appSecret:SinaAppSecret redirectURL:@"https://sns.whalecloud.com/sina2/callback"];
    
}

//注册极光推送
- (void)registerJPUSHNeedOption:(NSDictionary *)launchOptions
{
    [JPUSHService setupWithOption:launchOptions appKey:JPUSHKey
                          channel:@"App Store"
                 apsForProduction:YES
            advertisingIdentifier:nil];
    
    [self jpushSetup];
    
    
}

- (void)jpushSetup
{
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0)
    {
        // 可以添加自定义categories
        // NSSet<UNNotificationCategory *> *categories for iOS10 or later
        // NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
        if([[UIDevice currentDevice].systemVersion floatValue]>=10.0)
        {
            [JPUSHService registerForRemoteNotificationTypes:(UNAuthorizationOptionBadge|UNAuthorizationOptionSound|UNAuthorizationOptionAlert) categories:nil];
        }
        else
        {
            [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert) categories:nil];
        }
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    //极光自定义推送消息设置
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self selector:@selector(networkDidReceiveMessage:) name:kJPFNetworkDidReceiveMessageNotification object:nil];
}

//极光API推送自定义消息
- (void)networkDidReceiveMessage:(NSNotification *)notification
{
    NSDictionary * userInfo = [notification userInfo];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"firstGetOrder" object:nil userInfo:userInfo];
    
    JXLog(@"======极光自定义推送消息==%@",userInfo);
    
    NSString *value = userInfo[@"content"];
    NSDictionary *valueDic = [JXAppTool dictionaryWithJsonString:value];
    NSString *voiceStr = valueDic[@"title"];
    if ([valueDic[@"title"] isEqualToString:@"你有一条订单请注意查收"])
    {
        UserInfo *user = [UserInfo defaultUserInfo];
        [user setValue:voiceStr forKey:@"voiceStr"];
    }
    else
    {
        NSDictionary *valueDic = [JXAppTool dictionaryWithJsonString:value];
        NSString *vocieStr = valueDic[@"title"];
        NSString *statusStr = [NSString stringWithFormat:@"%@",valueDic[@"status"]];
        UserInfo *user = [UserInfo defaultUserInfo];
        [user setValue:vocieStr forKey:@"voiceStr"];
        [user setValue:valueDic forKey:@"pushDict"];
        
        if ([statusStr isEqualToString:@"6"])
        {
            if ([[self currentViewController] isKindOfClass:[JXOrderDetailVC class]])
            {
                [kNotificationCenter postNotificationName:@"getmoney" object:nil];
            }
        }
        else if ([statusStr isEqualToString:@"99"])
        {
            [kNotificationCenter postNotificationName:@"gotoTable" object:nil];
        }
        else if ([statusStr isEqualToString:@"9"])
        {
            [kNotificationCenter postNotificationName:@"gotoTable" object:nil];
        }
        else if ([valueDic[@"orderDesc"] isEqualToString:@"预约订单"])
        {
            [kNotificationCenter postNotificationName:@"gotomap" object:nil];
        }
    }

    
}
//获取当前正在显示的视图控制器
- (UIViewController*)currentViewController
{
    //获得当前活动窗口的根视图
    UIViewController* vc = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (1)
    {
        //根据不同的页面切换方式，逐步取得最上层的viewController
        if ([vc isKindOfClass:[UITabBarController class]])
        {
            vc = ((UITabBarController*)vc).selectedViewController;
        }
        if ([vc isKindOfClass:[UINavigationController class]])
        {
            vc = ((UINavigationController*)vc).visibleViewController;
        }
        if (vc.presentedViewController)
        {
            vc = vc.presentedViewController;
        }
        else
        {
            break;
        }
    }
    return vc;
}







@end
