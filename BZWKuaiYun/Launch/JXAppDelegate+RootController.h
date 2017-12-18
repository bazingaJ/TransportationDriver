//
//  JXAppDelegate+RootController.h
//  BZWKuaiYun
//
//  Created by Jessey Young on 2017/5/19.
//  Copyright © 2017年 ISU. All rights reserved.
//

#import "JXAppDelegate.h"

@interface JXAppDelegate (RootController)
/**
 *  首次启动轮播图
 */
- (void)createLoadingScrollView;
/**
 *  tabbar实例
 */
//- (void)setTabbarController;

/**
 *  window实例
 */
- (void)setAppWindows;

/**
 *  根视图
 */
- (void)setRootViewController;
@end
