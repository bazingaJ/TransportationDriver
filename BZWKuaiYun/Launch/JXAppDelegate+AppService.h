//
//  JXAppDelegate+AppService.h
//  BZWKuaiYun
//
//  Created by Jessey Young on 2017/5/19.
//  Copyright © 2017年 ISU. All rights reserved.
//

#import "JXAppDelegate.h"

@interface JXAppDelegate (AppService)

/**
 *  注册高德
 */
- (void)registerGaoDe;
/**
 注册极光
 */
- (void)registerJPUSHNeedOption:(NSDictionary *)launchOptions;

/**
 注册友盟分享
 */
- (void)registerUMShare;


/**
 注册友盟数据统计
 */
- (void)registerUMDataTotal;

@end
