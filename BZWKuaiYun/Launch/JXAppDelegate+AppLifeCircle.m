//
//  JXAppDelegate+AppLifeCircle.m
//  BZWKuaiYun
//
//  Created by Jessey Young on 2017/6/8.
//  Copyright © 2017年 ISU. All rights reserved.
//

#import "JXAppDelegate+AppLifeCircle.h"

@implementation JXAppDelegate (AppLifeCircle)

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString *myToken = [[[[deviceToken description]stringByReplacingOccurrencesOfString:@"<" withString:@""]stringByReplacingOccurrencesOfString:@">" withString:@""]                           stringByReplacingOccurrencesOfString:@" " withString:@""];
    JXLog(@" the token is %@",myToken);
    /// Required - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
}


-(void)applicationDidEnterBackground:(UIApplication *)application
{
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:1];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}


- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    //收到本地通知
    //[VTJpushTools showLocalNotificationAtFront:notification];
    application.applicationIconBadgeNumber = 0;
    
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    JXLog(@"通知推送错误为: %@", error);
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_7_0
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
//    [JXJpushTools handleRemoteNotification:userInfo completion:completionHandler];
//    [kNotificationCenter postNotificationName:@"GETNotifation" object:nil];
//    [kUserDefaults setBool:YES forKey:@"GETNotifation"];
//    [kUserDefaults synchronize];
    
//    NSString *flag = [userInfo valueForKey:@"flag"];
//    NSString *url = [userInfo valueForKey:@"url"];
//    RDVTabBarController *tabbar = (RDVTabBarController *)self.viewController;
    
    if (application.applicationState == UIApplicationStateActive)
    {
        
    }
    else
    {
        
        [JPUSHService handleRemoteNotification:userInfo];
    }
    return;
}
#endif


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    //6.0收到通知
//    [JXJpushTools handleRemoteNotification:userInfo completion:nil];
//    application.applicationIconBadgeNumber = 0;
    
}

- (void)application:(UIApplication *)application
didRegisterUserNotificationSettings:
(UIUserNotificationSettings *)notificationSettings
{
    [application registerForRemoteNotifications];
}

- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{//禁止横屏
    return UIInterfaceOrientationMaskPortrait;
}
#pragma mark - App挑选回调
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    if ([url.description hasPrefix:@""]) {
        //课程分享出去的链接打开应用
        return YES;
        
    }else{
//        return  [UMSocialSnsService handleOpenURL:url];
        return YES;
    }
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    
    //如果极简 SDK 不可用,会跳转支付宝钱包进行支付,需要将支付宝钱包的支付结果回传给 SDK
    if ([url.host isEqualToString:@"safepay"])
    {
        
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            JXLog(@"支付result = %@",resultDic);
            
        }];
        
        // 授权跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic)
        {
            JXLog(@"result = %@",resultDic);
            // 解析 auth code
            NSString *result = resultDic[@"result"];
            NSString *authCode = nil;
            if (result.length>0)
            {
                NSArray *resultArr = [result componentsSeparatedByString:@"&"];
                for (NSString *subResult in resultArr)
                {
                    if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="])
                    {
                        authCode = [subResult substringFromIndex:10];
                        break;
                    }
                }
            }
            JXLog(@"授权结果 authCode = %@", authCode?:@"");
        }];
        
    }
    
    
    if([url.host isEqualToString:@"alipayclient"])
    {
        //支付宝钱包快登授权返回 authCode
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            JXLog(@"支付result = %@",resultDic);
            
        }];
    }
    
    
    
    if ([url.description hasPrefix:@"mingsi:"]) {
        
        NSString * courseId = [[url.description componentsSeparatedByString:@"id="] lastObject];
        
        //课程分享出去的链接打开应用并跳转到课程详情页面
//        RDVTabBarController *tabbar = (RDVTabBarController *)self.viewController;
//        tabbar.selectedIndex = 3;
//        如果程序没有启动,界面是接收不到通知的,从而无法跳转
        [kUserDefaults setObject:@{@"courseId":courseId} forKey:@"sharedCourseID"];
        [kUserDefaults synchronize];
        
        //如果程序启动,而且在后台(页面不会走viewWillAppear方法),发送通知
        [kNotificationCenter postNotificationName:@"shareCourse" object:@{@"courseId":courseId}];
    }else{
//        return  [UMSocialSnsService handleOpenURL:url];
    }
    
    return YES;
    
}
// NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options
{
    if ([url.host isEqualToString:@"safepay"])
    {
        // 支付跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            JXLog(@"9.0以后使用新API接口result = %@",resultDic);
            NSString *resultStatus = [NSString stringWithFormat:@"%@",resultDic[@"resultStatus"]];
            if ([resultStatus isEqualToString:@"9000"])
            {
                SVSUCCESS(@"支付完成", 1.5)
            }
        }];
        
        // 授权跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic)
         {
            JXLog(@"result = %@",resultDic);
            // 解析 auth code
            NSString *result = resultDic[@"result"];
            NSString *authCode = nil;
            if (result.length>0)
            {
                NSArray *resultArr = [result componentsSeparatedByString:@"&"];
                for (NSString *subResult in resultArr)
                {
                    if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="])
                    {
                        authCode = [subResult substringFromIndex:10];
                        break;
                    }
                }
            }
            JXLog(@"授权结果 authCode = %@", authCode?:@"");
        }];
    }
    return YES;
}

























@end
