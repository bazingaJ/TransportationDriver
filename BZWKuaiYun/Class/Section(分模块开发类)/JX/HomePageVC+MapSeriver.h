//
//  HomePageVC+MapSeriver.h
//  BZWKuaiYun
//
//  Created by Jessey Young on 2017/7/4.
//  Copyright © 2017年 ISU. All rights reserved.
//

#import "HomePageVC.h"

typedef NS_ENUM(NSInteger, NaviType)
{
    NaviTypeGet = 1, // 接货导航
    NaviTypeSend = 2 // 送货导航
};

@interface HomePageVC (MapSeriver)
//页面首次进入的一个单次定位服务
- (void)locationOnceTime;
//初始化定位管理器
- (void)initLocationManater;
//初始化驾车路径规划管理器
- (void)initDriveManager;
//初始化搜索管理器
- (void)initSearch;
//路径规划
- (void)routePlanActionWithType:(NaviType)type;
//开始路径计算规划
- (void)searchRoutePlanningDriveWith:(NaviType)type;
//清除地图上的所有路线
- (void)clear;
@end
