//
//  JXJpushTools.m
//  BZWKuaiYun
//
//  Created by Jessey Young on 2017/6/8.
//  Copyright © 2017年 ISU. All rights reserved.
//

#import "JXJpushTools.h"
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

@interface JXJpushTools ()<JPUSHRegisterDelegate>

@end

@implementation JXJpushTools


+ (void)setupWithOptions:(NSDictionary *)launchOptions
{
    // ios8之后可以自定义category
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
    
    // Required
    [JPUSHService setupWithOption:launchOptions
                           appKey:JPUSHKey
                          channel:@"App Store"
                 apsForProduction:NO
            advertisingIdentifier:nil];
    return;
}

//极光API推送自定义消息
//{content : 686a443a5b3340ffad92f051b3cd25f0={"msg":"您的账号于2017-06-07 11:45:59在另一台设备上登录，如非本人操作，则短信验证码可能泄露，建议联系管理员。"}}
- (void)networkDidReceiveMessage:(NSNotification *)notification
{
    NSDictionary * userInfo = [notification userInfo];
    JXLog(@"监听返回的数据是========%@",userInfo);
    [[NSNotificationCenter defaultCenter]postNotificationName:@"firstGetOrder" object:nil userInfo:userInfo];
//    NSString *extras = [userInfo valueForKey:@"alert"];
    //    NSString *customizeField1 = [extras valueForKey:@"customizeField1"];
    //服务端传递的Extras附加字段，key是自己定义的
    
}

+ (void)registerDeviceToken:(NSData *)deviceToken {
    [JPUSHService registerDeviceToken:deviceToken];
    return;
}

+ (void)handleRemoteNotification:(NSDictionary *)userInfo completion:(void (^)(UIBackgroundFetchResult))completion {
    [JPUSHService handleRemoteNotification:userInfo];
    
    if (completion) {
        completion(UIBackgroundFetchResultNewData);
    }
    return;
}

#pragma mark- JPUSHRegisterDelegate
//-------->推送接受的方法
// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler
{
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    JXLog(@"%s---%@",__func__,userInfo);
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]])
    {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler
{
    
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    JXLog(@"%s===%@",__func__,userInfo);
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]])
    {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler();  // 系统要求执行这个方法
}

+ (void)showLocalNotificationAtFront:(UILocalNotification *)notification
{
//    [JPUSHService showLocalNotificationAtFront:notification identifierKey:nil];
//    return;
}

@end
