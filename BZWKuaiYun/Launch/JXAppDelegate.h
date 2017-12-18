//
//  JXAppDelegate.h
//  BZWKuaiYun
//
//  Created by Jessey Young on 2017/5/18.
//  Copyright © 2017年 ISU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface JXAppDelegate : UIResponder<UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong,nonatomic)UIViewController * viewController;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;



//应客户要求 在启动APP的时候就 获取权限的弹窗
//设置局部变量 弹窗会过一段时间消失 所以要设置成全部变量
@property (nonatomic, strong) AMapLocationManager *locationM;


@end

