//
//  HomePageVC+MapSeriver.m
//  BZWKuaiYun
//
//  Created by Jessey Young on 2017/7/4.
//  Copyright © 2017年 ISU. All rights reserved.
//

#import "HomePageVC+MapSeriver.h"
#import "JXDriveNaviVC.h"
#import "HomePageVC+JXHPDataHandle.h"

@implementation HomePageVC (MapSeriver)

- (void)initLocationManater
{
    if (self.locationManager == nil)
    {
        self.locationManager = [[AMapLocationManager alloc] init];
        self.locationManager.delegate=self;
        self.locationManager.distanceFilter = 2;
        self.locationManager.allowsBackgroundLocationUpdates=YES;
        self.locationManager.locatingWithReGeocode = YES;
        //   定位超时时间，最低2s，此处设置为2s
        self.locationManager.locationTimeout =2;
        //   逆地理请求超时时间，最低2s，此处设置为2s
        self.locationManager.reGeocodeTimeout = 2;
    }
}

- (void)initDriveManager
{
    if (self.driveManager == nil)
    {
        self.driveManager = [[AMapNaviDriveManager alloc] init];
        [self.driveManager setDelegate:self];
        [self.driveManager screenAlwaysBright];
        [self.driveManager setAllowsBackgroundLocationUpdates:YES];
        [self.driveManager setPausesLocationUpdatesAutomatically:NO];
    }
}

- (void)initSearch
{
    if (self.search == nil)
    {
        self.search = [[AMapSearchAPI alloc] init];
        self.search.delegate = self;
    }
}

- (void)locationOnceTime
{
    [self initLocationManater];
    [self initDriveManager];
    [self initSearch];
    
    [self.locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        if (error)
        {
            JXLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
            if (error.code == AMapLocationErrorLocateFailed)
            {
                return;
            }
        }
        self.cityCode = regeocode.adcode;
        
        [kUserDefaults setObject:self.cityCode forKey:@"cityCode"];
        [kUserDefaults synchronize];
        
        self.isLocOk = YES;
        self.location = location.coordinate;
        
        dispatch_queue_t serviceQueue = dispatch_queue_create("com.jx.www", DISPATCH_QUEUE_CONCURRENT);
        dispatch_async(serviceQueue, ^{
           
            [self queryCurrentCityServiceCompleteWithBlock:^(BOOL isSuccess, NSDictionary *response) {
                if (isSuccess)
                {
                    
                }
            }];
            
        });
    }];
}

#pragma mark - 定位回调方法
- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location reGeocode:(AMapLocationReGeocode *)reGeocode
{
    self.location = CLLocationCoordinate2DMake(location.coordinate.latitude,location.coordinate.longitude);
    JXLog(@"=======location:{lat:%f; lon:%f; accuracy:%f}", self.location.latitude, self.location.longitude, location.horizontalAccuracy);
    if (reGeocode)
    {
        JXLog(@"reGeocode:%@", reGeocode);
        self.isLocOk = YES;
        self.location = location.coordinate;
        
        [kUserDefaults setObject:@(self.location.longitude) forKey:HomePageLongiString];
        [kUserDefaults setObject:@(self.location.latitude) forKey:HomePageLatitString];
        [kUserDefaults synchronize];
        
        
        self.forrmatterAddress = reGeocode.formattedAddress;
        if (self.isBeginUploadLocation)
        {
            [self countingPollingWithLongitued:location.coordinate.longitude latitude:location.coordinate.latitude regionCode:reGeocode.adcode];
        }
        
    }
    else
    {
        self.isLocOk = NO;
    }
}

//设置GCD定时器传入经纬度 调用发送请求的方法
- (void)countingPollingWithLongitued:(CGFloat)longi latitude:(CGFloat)latit regionCode:(NSString *)code
{
    //设置时间间隔
    NSTimeInterval interval = 2.0;
    //创建队列
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //创建定时器
    self.requestTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    dispatch_source_set_timer(self.requestTimer, dispatch_walltime(NULL, 0), interval * NSEC_PER_SEC, 0); //每秒执行
    //设置任务
    dispatch_source_set_event_handler(self.requestTimer, ^{
        //在这里执行事件
        [self sendLocationRequestWithLontitude:longi latitude:latit withRegionCode:code];
    });
    //开始进行定时器
    dispatch_resume(self.requestTimer);
    //定时器销毁
    //    dispatch_source_cancel(_timer);
}

#pragma mark - 上传司机位置信息到高德云图服务
//发送经纬度请求的方法
- (void)sendLocationRequestWithLontitude:(CGFloat)lon latitude:(CGFloat)lat withRegionCode:(NSString *)code
{
    [JXOrderRequestTool postGaoDeNeedYunId:USERYUNID geox:@(lon).stringValue geoy:@(lat).stringValue address:self.forrmatterAddress complete:^(BOOL isSuccess, NSDictionary *respose) {
        
    }];
}


#pragma mark - Actions  路径规划

//要去导航的路径规划
- (void)routePlanActionWithType:(NaviType)type
{
    if (self.location.longitude == 0)
    {
        SVINFO(@"未获取到位置信息，请重试", 2)
        return;
    }
    //定位当前的位置
    AMapNaviPoint *startPoint = [AMapNaviPoint locationWithLatitude:self.location.latitude longitude:self.location.longitude];
    
    if (type == NaviTypeGet)
    {
        //获取终点的位置
        NSString *log = [NSString stringWithFormat:@"%f",self.startingPoint.longitude];
        NSString *lat = [NSString stringWithFormat:@"%f",self.startingPoint.latitude];
        AMapNaviPoint *endPoint = [AMapNaviPoint locationWithLatitude:[lat floatValue]
                                                            longitude:[log floatValue]];
        
        
        [self.driveManager calculateDriveRouteWithStartPoints:@[startPoint]
                                                    endPoints:@[endPoint]
                                                    wayPoints:self.addressArr
                                              drivingStrategy:AMapNaviDrivingStrategySingleAvoidHighwayAndCostAndCongestion];
    }
    else
    {
        //获取终点的位置
        NSString *log = [NSString stringWithFormat:@"%f",self.destination.longitude];
        NSString *lat = [NSString stringWithFormat:@"%f",self.destination.latitude];
        AMapNaviPoint *endPoint = [AMapNaviPoint locationWithLatitude:[lat floatValue]
                                                            longitude:[log floatValue]];
        
        
        [self.driveManager calculateDriveRouteWithStartPoints:@[startPoint]
                                                    endPoints:@[endPoint]
                                                    wayPoints:self.addressArr
                                              drivingStrategy:AMapNaviDrivingStrategySingleAvoidHighwayAndCostAndCongestion];
    }
    
}


#pragma mark - AMapNaviDriveManager Delegate

- (void)driveManager:(AMapNaviDriveManager *)driveManager error:(NSError *)error
{
    JXLog(@"error:{%ld - %@}", (long)error.code, error.localizedDescription);
}

- (void)driveManagerOnCalculateRouteSuccess:(AMapNaviDriveManager *)driveManager
{
    JXLog(@"================onCalculateRouteSuccess");
    
    JXDriveNaviVC *driveVC = [[JXDriveNaviVC alloc] init];
    [driveVC setDelegate:self];
    driveVC.orderIdd = self.orderorderID;
    if (self.isSend == NO)
    {
        driveVC.isSend = self.isSend;
    }
    else
    {
        driveVC.isSend = YES;
    }
    driveVC.hidesBottomBarWhenPushed = YES;
    driveVC.sendBlock = ^(BOOL isSend) {
        if (isSend == YES)
        {
            [self searchRoutePlanningDriveWith:NaviTypeSend];
            [self moninavi];
        }
    };
    //将driveView添加为导航数据的Representative，使其可以接收到导航诱导数据
    [self.driveManager addDataRepresentative:driveVC.driveView];
    
    [self.navigationController pushViewController:driveVC animated:NO];
    
    //真实GPS导航
    [self.driveManager startGPSNavi];
    
    
    //模拟导航
//    [self.driveManager setEmulatorNaviSpeed:120];
//    [self.driveManager startEmulatorNavi];
    
}

- (void)driveManager:(AMapNaviDriveManager *)driveManager onCalculateRouteFailure:(NSError *)error
{
    JXLog(@"onCalculateRouteFailure:{%ld - %@}", (long)error.code, error.localizedDescription);
}

- (void)driveManager:(AMapNaviDriveManager *)driveManager didStartNavi:(AMapNaviMode)naviMode
{
    JXLog(@"didStartNaviwithNaviMode%ld",(long)naviMode);
}

- (void)driveManagerNeedRecalculateRouteForYaw:(AMapNaviDriveManager *)driveManager
{
    JXLog(@"导航路径出现偏差重新规划needRecalculateRouteForYaw");
}

- (void)driveManagerNeedRecalculateRouteForTrafficJam:(AMapNaviDriveManager *)driveManager
{
    JXLog(@"前方遇到拥堵需要重新计算路径时的回调函数needRecalculateRouteForTrafficJam");
}

- (void)driveManager:(AMapNaviDriveManager *)driveManager onArrivedWayPoint:(int)wayPointIndex
{
    NSString * soundString = [NSString stringWithFormat:@"到达途经点%d",wayPointIndex];
    [[JXSoundPlayer defaultSoundPlayer]play:soundString];
    JXLog(@"导航到达某个途经点的回调函数onArrivedWayPoint:%d", wayPointIndex);
}

- (BOOL)driveManagerIsNaviSoundPlaying:(AMapNaviDriveManager *)driveManager
{
    return [[JXSoundPlayer defaultSoundPlayer]isPlaying];
}

- (void)driveManager:(AMapNaviDriveManager *)driveManager playNaviSoundString:(NSString *)soundString soundStringType:(AMapNaviSoundType)soundStringType
{
    JXLog(@"playNaviSoundString:{%ld:%@}", (long)soundStringType, soundString);
    
    [[JXSoundPlayer defaultSoundPlayer]play:soundString];
}

- (void)driveManagerDidEndEmulatorNavi:(AMapNaviDriveManager *)driveManager
{
    if (self.isSend == NO)
    {
        [self requestChangeOrderStatusNeedOrderId:self.orderorderID status:@"3" complete:^(BOOL isSuccess, NSDictionary *respose) {
            if (isSuccess)
            {
                [self naviArriveDestination];
                [self.bottomView.statusBtn setTitle:@"开始行程" forState:UIControlStateNormal];
                if ([[self currentViewController] isKindOfClass:[JXDriveNaviVC class]])
                {
                    UIViewController *vc = [self currentViewController];
                    [vc.navigationController popViewControllerAnimated:YES];
                }
            }
        }];
        
    }
    else
    {
        [self naviArriveDestination];
        [self.bottomView.statusBtn setTitle:@"到达目的地" forState:UIControlStateNormal];
        if ([[self currentViewController] isKindOfClass:[JXDriveNaviVC class]])
        {
            UIViewController *vc = [self currentViewController];
            [vc.navigationController popViewControllerAnimated:YES];
        }
    }
    
    JXLog(@"模拟导航到达目的地停止导航后的回调函数didEndEmulatorNavi");
}

- (void)driveManagerOnArrivedDestination:(AMapNaviDriveManager *)driveManager
{
    if (self.isSend == NO)
    {
        self.isSend = YES;
        [self naviArriveDestination];
        [self.bottomView.statusBtn setTitle:@"开始行程" forState:UIControlStateNormal];
        if ([[self currentViewController] isKindOfClass:[JXDriveNaviVC class]])
        {
            UIViewController *vc = [self currentViewController];
            [vc.navigationController popViewControllerAnimated:YES];
        }
        JXLog(@"导航到达目的地后的回调函数onArrivedDestination");
    }
    else
    {
        self.isSend = NO;
        [self naviArriveDestination];
        [self.bottomView.statusBtn setTitle:@"到达目的地" forState:UIControlStateNormal];
        if ([[self currentViewController] isKindOfClass:[JXDriveNaviVC class]])
        {
            UIViewController *vc = [self currentViewController];
            [vc.navigationController popViewControllerAnimated:YES];
        }
        JXLog(@"导航到达目的地后的回调函数onArrivedDestination");
    }
    
    
}

#pragma mark - LocationManager Delegate

- (void)amapLocationManager:(AMapLocationManager *)manager didFailWithError:(NSError *)error
{
    JXLog(@"didFailWithError: %@", error);
}

//设置起始点大头针
- (void)addDefaultAnnotationsWith:(NaviType)type
{
    MAPointAnnotation *startAnnotation = [[MAPointAnnotation alloc] init];
    startAnnotation.coordinate = self.location;
    startAnnotation.title      = @"起点";
    self.startAnnotation = startAnnotation;
    
    if (type == NaviTypeGet)
    {
        MAPointAnnotation *destinationAnnotation = [[MAPointAnnotation alloc] init];
        destinationAnnotation.coordinate = self.startingPoint;
        destinationAnnotation.title      = @"终点";
        self.destinationAnnotation = destinationAnnotation;
        
        [self.mapView addAnnotation:startAnnotation];
        [self.mapView addAnnotation:destinationAnnotation];
        self.annotations = [NSMutableArray arrayWithArray:@[self.startAnnotation,self.destinationAnnotation]];
        [self.mapView showAnnotations:self.annotations animated:YES];
    }
    else
    {
        MAPointAnnotation *destinationAnnotation = [[MAPointAnnotation alloc] init];
        destinationAnnotation.coordinate = self.destination;
        destinationAnnotation.title      = @"终点";
        self.destinationAnnotation = destinationAnnotation;
        
        [self.mapView addAnnotation:startAnnotation];
        [self.mapView addAnnotation:destinationAnnotation];
        self.annotations = [NSMutableArray arrayWithArray:@[self.startAnnotation,self.destinationAnnotation]];
        [self.mapView showAnnotations:self.annotations animated:YES];
    }
}

#pragma mark - 路径规划开始搜索路线
- (void)searchRoutePlanningDriveWith:(NaviType)type
{
    self.startAnnotation.coordinate = self.location;
    
    if (type == NaviTypeGet)
    {
        self.destinationAnnotation.coordinate = self.startingPoint;
    }
    else
    {
        self.destinationAnnotation.coordinate = self.destination;
    }
    
    
    AMapDrivingRouteSearchRequest *navi = [[AMapDrivingRouteSearchRequest alloc] init];
    
    navi.requireExtension = YES;
    navi.strategy = 5;
    /* 出发点. */
    navi.origin = [AMapGeoPoint locationWithLatitude:self.location.latitude
                                           longitude:self.location.longitude];
    if (type == NaviTypeGet)
    {
        /* 目的地. */
        navi.destination = [AMapGeoPoint locationWithLatitude:self.startingPoint.latitude
                       longitude:self.startingPoint.longitude];
        [self addDefaultAnnotationsWith:NaviTypeGet];
        [self.search AMapDrivingRouteSearch:navi];
    }
    else
    {
        /* 目的地. */
        navi.destination = [AMapGeoPoint locationWithLatitude:self.destination.latitude
                                                longitude:self.destination.longitude];
        [self addDefaultAnnotationsWith:NaviTypeSend];
        [self.search AMapDrivingRouteSearch:navi];
    }
    
}
#pragma mark - 路径规划开始搜索路线Delegate
- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error
{
    JXLog(@"Error: %@ - ", error);
}

/* 路径规划搜索回调. */
- (void)onRouteSearchDone:(AMapRouteSearchBaseRequest *)request response:(AMapRouteSearchResponse *)response
{
    if (response.route == nil)
    {
        return;
    }
    
    self.route = response.route;
    
    if (response.count > 0)
    {
        [self presentCurrentCourse];
    }
}
#pragma mark - 路径展示

- (void)presentCurrentCourse
{
    MANaviAnnotationType type = MANaviAnnotationTypeDrive;
    self.naviRoute = [MANaviRoute naviRouteForPath:self.route.paths[0] withNaviType:type showTraffic:YES startPoint:[AMapGeoPoint locationWithLatitude:self.startAnnotation.coordinate.latitude longitude:self.startAnnotation.coordinate.longitude] endPoint:[AMapGeoPoint locationWithLatitude:self.destinationAnnotation.coordinate.latitude longitude:self.destinationAnnotation.coordinate.longitude]];
    
    
    [self.naviRoute addToMapView:self.mapView];
    
    // 缩放地图使其适应polylines的展示.
    [self.mapView setVisibleMapRect:[CommonUtility mapRectForOverlays:self.naviRoute.routePolylines] edgePadding:UIEdgeInsetsMake(20, 20, 20, 20) animated:YES];
}

#pragma mark - MAMapViewDelegate

- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id<MAOverlay>)overlay
{
    
    if ([overlay isKindOfClass:[MAMultiPolyline class]])
    {
        MAPolylineRenderer *polylineView = [[MAPolylineRenderer alloc] initWithPolyline:(id)overlay];
        
        polylineView.lineWidth = 16.f;
        polylineView.strokeImage = JX_IMAGE(@"custtexture");
        return polylineView;
    }
    return nil;
}

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *routePlanningCellIdentifier = @"RoutePlanningCellIdentifier";
        
        MAAnnotationView *poiAnnotationView = (MAAnnotationView*)[self.mapView dequeueReusableAnnotationViewWithIdentifier:routePlanningCellIdentifier];
        if (poiAnnotationView == nil)
        {
            poiAnnotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation
                                                             reuseIdentifier:routePlanningCellIdentifier];
        }
        /* 起点. */
        if ([[annotation title] isEqualToString:@"起点"])
        {
            poiAnnotationView.image = JX_IMAGE(@"startPoint");
        }
        /* 终点. */
        else if([[annotation title] isEqualToString:@"终点"])
        {
            poiAnnotationView.image = JX_IMAGE(@"endPoint");
        }
        
        return poiAnnotationView;
    }
    
    return nil;
}

/* 清空地图上已有的路线. */
- (void)clear
{
    [self.naviRoute removeFromMapView];
    
    [self.mapView removeAnnotations:self.annotations];
    [self.annotations removeAllObjects];
    [self locAgain];
//    [self.mapView ];
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
