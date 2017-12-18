//
//  JXAppDelegate.m
//  BZWKuaiYun
//
//  Created by Jessey Young on 2017/5/18.
//  Copyright © 2017年 ISU. All rights reserved.
//

#import "JXAppDelegate.h"
#import "JXAppDelegate+RootController.h"

#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

@implementation JXAppDelegate

+ (UINavigationController *)rootNavigationController
{
    JXAppDelegate *app = (JXAppDelegate *)[UIApplication sharedApplication].delegate;
    return (UINavigationController *)app.window.rootViewController;
    
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self setAppWindows];
    
    [self setRootViewController];
    
    [self registerJPUSHNeedOption:launchOptions];
    
    [self registerUMShare];
    
    [self registerUMDataTotal];
    
    [self registerGaoDe];
    
     [[UINavigationBar appearance] setTintColor:Main_Color];
    
    //启动APP不影响后台播放音乐
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryAmbient error:nil];
    
    return YES;
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
    completionHandler(UNNotificationPresentationOptionSound | UNNotificationPresentationOptionAlert);
    
    NSDictionary *dic = userInfo[@"aps"];
    NSString * voiceStr = dic[@"alert"];
    UserInfo *user = [UserInfo defaultUserInfo];
    if ([voiceStr isEqualToString:HomePageNoPass])
    {
        //状态为 3 不通过审核
        [user setValue:voiceStr forKey:@"driverStatus"];
    }
    if ([voiceStr isEqualToString:HomePagePassCheck])
    {
        //状态为 2 通过审核
        [kNotificationCenter postNotificationName:@"passcheck" object:nil];
    }
    if ([voiceStr isEqualToString:HomePageCoverCount])
    {
        //状态为 -1 账号被封号
        [kNotificationCenter postNotificationName:@"coverCount" object:nil];
    }
    if ([voiceStr isEqualToString:HomePageStopCount])
    {
        //状态为 4 账号停止听单
        [kNotificationCenter postNotificationName:@"stopCount" object:nil];
    }
    if ([voiceStr isEqualToString:HomePageComfirmCount])
    {
        //状态为 1 认证成功（解封操作）
        [kNotificationCenter postNotificationName:@"comfirmOk" object:nil];
    }
    // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
}

// iOS 10 Support 用手点的时候
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


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    if (application.applicationState == UIApplicationStateActive)
    {
        JXLog(@"%s",__func__);
    }
    else
    {
        
        [JPUSHService handleRemoteNotification:userInfo];
    }
    
    //    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    JXLog(@"%s",__func__);
    // Required,For systems with less than or equal to iOS6
    [JPUSHService handleRemoteNotification:userInfo];
}





















#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer {
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"BZWKuaiYun"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                     */
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    
    return _persistentContainer;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}
@end
