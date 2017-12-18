//
//  HomePageVC.h
//  BZWKuaiYun
//
//  Created by Jessey Young on 2017/5/19.
//  Copyright © 2017年 ISU. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "JXSelectCity.h"
#import "JXMainTableView.h"
#import "JXGrabCell.h"
#import "JXMainBottomView.h"
#import "JXDefineSwitch.h"
#import "JXDriveNaviVC.h"
#import "JXReadVC.h"

#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import <AMapNaviKit/AMapNaviKit.h>
#import <MAMapKit/MAMapKit.h>
#import "MANaviRoute.h"
#import "CommonUtility.h"


extern NSString *const HomePageLongiString;
extern NSString *const HomePageLatitString;
extern NSString *const HomePagemoniNaci;
extern NSString *const HomePageNoPass;
extern NSString *const HomePagePassCheck;
extern NSString *const HomePageCoverCount;
extern NSString *const HomePageComfirmCount;
extern NSString *const HomePageStopCount;

@interface HomePageVC : UIViewController < UITableViewDataSource,
                                            UITableViewDelegate,
                                            JXGrabOrderDelegate,
                                            JXHomePageBottomDelegate,
                                            JXSwitchDelegate,
                                            AMapLocationManagerDelegate,
                                            MAMapViewDelegate,
                                            AMapNaviDriveManagerDelegate,
                                            AMapSearchDelegate,
                                            AMapGeoFenceManagerDelegate,
                                            JXDriveNaviViewControllerDelegate>

//控制器第一个界面self.view 加的第一个view
@property (nonatomic, strong) UIView *firstView;
//fistview 的自视图
@property (nonatomic, strong) MAMapView *mapView;
//第二个视图 表视图
@property (nonatomic, strong) JXMainTableView *tableVi;

// 保证金view
@property (nonatomic, strong) UIView *paymentView;
//首页定位自己按钮
@property (nonatomic, strong) UIButton *locationBtn;
//首页跳转保证金按钮
@property (nonatomic, strong) UIButton *noticeBtn;

//设置一个bool 值 来判断定位是否返回需要参数
@property (nonatomic, assign) BOOL isLocOk;
//设置一个bool值 来判断是否可以开始轮询上传司机位置
@property (nonatomic, assign) BOOL isBeginUploadLocation;
@property (nonatomic, strong) JXMainBottomView *bottomView;
@property (nonatomic, strong) JXDefineSwitch *mainSwitch;

@property (nonatomic, strong) NSMutableArray *dataArr;

@property (nonatomic, strong) NSMutableArray *itemArr;

//途经点数组
@property (nonatomic, strong) NSMutableArray *addressArr;

//定时器每两秒上传司机位置
@property (nonatomic, strong) dispatch_source_t requestTimer;

//======================定位================\\

@property (nonatomic, strong) AMapLocationManager *locationManager;
@property (nonatomic, assign) CLLocationCoordinate2D location;
//定位格式化地址
@property (nonatomic, strong) NSString *forrmatterAddress;

//驾车路径导航
@property (nonatomic, strong) AMapNaviDriveManager *driveManager;
@property (nonatomic, strong) AMapSearchAPI *search;

@property (nonatomic, strong) NSString *orderorderID;

@property (nonatomic, assign)BOOL isNaviRoutePlan;

//点标准的数组
@property (nonatomic, strong) NSMutableArray *annotations;
@property (nonatomic, assign) CLLocationCoordinate2D startingPoint;
@property (nonatomic, assign) CLLocationCoordinate2D destination;

@property (nonatomic, strong) MAPointAnnotation *startAnnotation;

@property (nonatomic, strong) MAPointAnnotation *destinationAnnotation;
// 是否是送货中
@property (nonatomic, assign) BOOL isSend;

/* 用于显示当前路线方案. */
@property (nonatomic) MANaviRoute * naviRoute;
@property (nonatomic, strong) AMapRoute *route;


//城市代码
@property (nonatomic, strong) NSString *cityCode;
// 无数据占位图
@property (nonatomic, strong) UIImageView *imgView;
//重新加载新数据
- (void)reloadNewData;

//地图页上弹的信息框
- (void)delayLoad;

//导航到达目的地的时候回调的方法
- (void)naviArriveDestination;

//定位当前按钮点击事件
- (void)locAgain;

#pragma mark - 查询司机状态
- (void)requestDriverStatus;

- (void)moninavi;

@end
