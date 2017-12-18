//
//  HomePageVC.m
//  BZWKuaiYun
//
//  Created by Jessey Young on 2017/5/19.
//  Copyright © 2017年 ISU. All rights reserved.
//

#import "HomePageVC.h"
#import "HomePageVC+JXHPDataHandle.h"
#import "HomePageVC+MapSeriver.h"
#import "JXOrderDetailVC.h"
#import "JXHomeModel.h"
#import "JXRegisterPersonInfoVC.h"

static NSString *const kBeginListen = @"开始接单，祝您工作好心情";
static NSString *const kEndListen   = @"结束听单，祝您生活愉快";

NSString *const HomePageLongiString = @"ggg";
NSString *const HomePageLatitString = @"aaa";
NSString *const HomePagemoniNaci = @"moninavi";

NSString *const HomePageNoPass = @"您审核未通过，请重新提交信息！";
NSString *const HomePagePassCheck = @"您已审核通过！";
NSString *const HomePageCoverCount = @"您已被封号，请联系客服！";
NSString *const HomePageComfirmCount = @"您的账号已恢复使用！";
NSString *const HomePageStopCount = @"您已被停止接单，请联系客服！";


@implementation HomePageVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initialized];
    [self setupUI];
    [self addListener];
    [self requestDriverStatus];
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    if ([[kUserDefaults objectForKey:@"是否刷新"] isEqualToString:@"可以刷新"])
    {
        [self requestDriverStatus];
    }
    
}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [kUserDefaults setObject:@"不要刷新" forKey:@"是否刷新"];
    [kUserDefaults synchronize];
}
#pragma mark - 懒加载--地图
- (MAMapView *)mapView
{
    if (_mapView == nil)
    {
        _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height-kNavBarHeight-49)];
        _mapView.delegate = self;
        _mapView.zoomLevel = 16;
        _mapView.showsScale = NO;
        _mapView.showsUserLocation=YES;
        _mapView.userTrackingMode = MAUserTrackingModeFollow;
        _mapView.showsCompass=YES;
        _mapView.logoCenter = CGPointMake(Main_Screen_Width-30, CGRectGetMaxY(_mapView.frame)-20);
        _mapView.compassOrigin = CGPointMake(Main_Screen_Width-40, 5);
    }
    return _mapView;
}

- (void)initialized
{
    self.mainSwitch.on = NO;
    [kNotificationCenter addObserver:self selector:@selector(grabOrderNowClick:) name:@"changePage" object:nil];
    
    [kNotificationCenter addObserver:self selector:@selector(moninavi) name:HomePagemoniNaci object:nil];
    
    [kNotificationCenter addObserver:self selector:@selector(hideFirstView) name:@"gotoTable" object:nil];
    
}
#pragma mark - 懒加载区
- (JXMainTableView *)tableVi
{
    if (!_tableVi)
    {
        _tableVi = [[[NSBundle mainBundle] loadNibNamed:@"JXMainTableView" owner:self options:nil]objectAtIndex:0];
        _tableVi.frame = CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height-kNavBarHeight);
        _tableVi.tableV.delegate = self;
        _tableVi.tableV.dataSource = self;
        _tableVi.tableV.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        _tableVi.tableV.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(reloadNewData)];
    }
    return _tableVi;
}

- (JXMainBottomView *)bottomView
{
    if (!_bottomView)
    {
        _bottomView = [[[NSBundle mainBundle] loadNibNamed:@"JXMainBottomView" owner:self options:nil]objectAtIndex:0];
        _bottomView.doThing = self;
        _bottomView.frame = CGRectMake(0, Main_Screen_Height, Main_Screen_Width, 200);
        
    }
    return _bottomView;
}
- (JXDefineSwitch *)mainSwitch
{
    if (!_mainSwitch)
    {
        JXDefineSwitch *switchButton = [[JXDefineSwitch alloc] initWithFrame:CGRectMake(0, 0, 120, 31)];
        switchButton.backColor = Main_Color;
        switchButton.on = NO;
        switchButton.onText = @"接单";
        switchButton.knobBackColor = white_color;
        switchButton.knobTextColor = Main_Color;
        switchButton.offText = @"下班";
        switchButton.offTextColor = white_color;
        switchButton.delegate = self;
        self.mainSwitch = switchButton;
    }
    return _mainSwitch;
}


//设置UI区
- (void)setupUI
{
    self.view.backgroundColor = white_color;
    
    self.navigationItem.titleView=self.mainSwitch;
    
    [self.view addSubview:self.tableVi];
    
    self.firstView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height-kNavBarHeight)];
    [self.view addSubview:_firstView];
    
    [self.firstView addSubview:self.mapView];
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(0, 0, 30, 40);
    [leftBtn setImage:JX_IMAGE(@"shouyedingwei") forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(homeLeftBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 30, 40);
    [rightBtn setImage:JX_IMAGE(@"shouyexiaoxi") forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(homeRightBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    
    self.paymentView = [[UIView alloc] init];
    self.paymentView.frame = CGRectMake(0, 0, Main_Screen_Width, 40);
    self.paymentView.backgroundColor = white_color;
    self.paymentView.hidden = YES;
    [self.firstView addSubview:self.paymentView];
    self.paymentView.layer.shadowPath =[UIBezierPath bezierPathWithRect:self.paymentView.layer.bounds].CGPath;
    self.paymentView.layer.shadowColor = [[UIColor grayColor] CGColor];//阴影的颜色
    self.paymentView.layer.shadowOpacity =1.6f;   // 阴影透明度
    self.paymentView.layer.shadowOffset =CGSizeMake(0.0,1.0f); // 阴影的范围
    self.paymentView.layer.shadowRadius =1.0;  // 阴影扩散的范围控制
    
    
    self.noticeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.noticeBtn.frame = CGRectMake((Main_Screen_Width-250)/2, 0, 250, 40);
    [self.noticeBtn setTitle:@"信息审核中，暂不能接单" forState:UIControlStateNormal];
//    [self.noticeBtn setTitle:@"点击缴纳保证金，即享抢单优先权 >" forState:UIControlStateNormal];
    self.noticeBtn.titleLabel.textAlignment =NSTextAlignmentCenter;
    [self.noticeBtn setTitleColor:RGBCOLOR(50, 50, 50) forState:UIControlStateNormal];
    self.noticeBtn.titleLabel.font = F14;
    [self.noticeBtn addTarget:self action:@selector(goPayment:) forControlEvents:UIControlEventTouchUpInside];
    [self.paymentView addSubview:self.noticeBtn];
    
    self.locationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.locationBtn.frame = CGRectMake(5, Main_Screen_Height-167, 50, 50);
    [self.locationBtn addTarget:self action:@selector(locAgain) forControlEvents:UIControlEventTouchUpInside];
    [self.locationBtn setImage:JX_IMAGE(@"shouye-dingwei") forState:UIControlStateNormal];
    [self.firstView addSubview:self.locationBtn];
    
    [self.firstView addSubview:self.bottomView];
}

#pragma mark - 查询司机状态
- (void)requestDriverStatus
{
    [JXOrderRequestTool postDriverStatuscomplete:^(BOOL isSuccess, NSDictionary *respose) {
        if (isSuccess)
        {
            NSDictionary *dic= respose[@"res"];
            self.orderorderID= [NSString stringWithFormat:@"%@",dic[@"orderId"]];
            //审核状态控制
            if ([[NSString stringWithFormat:@"%@",dic[@"checkStatus"]] isEqualToString:@"0"])
            {
                //未认证  待审核
                self.paymentView.hidden = NO;
                [self.noticeBtn setTitle:@"信息审核中，暂不能接单" forState:UIControlStateNormal];
                self.noticeBtn.userInteractionEnabled = NO;
                self.mainSwitch.userInteractionEnabled = NO;
                
            }
            else if ([[NSString stringWithFormat:@"%@",dic[@"checkStatus"]] isEqualToString:@"1"])
            {
                self.paymentView.hidden = YES;
                self.mainSwitch.userInteractionEnabled = YES;
                if ([[NSString stringWithFormat:@"%@",dic[@"status"]] isEqualToString:@"0"])
                {
                    self.mainSwitch.on = NO;
                    [UIView transitionFromView:self.tableVi toView:self.firstView duration:.8f options:UIViewAnimationOptionTransitionCrossDissolve completion:nil];
                }
                else if ([[NSString stringWithFormat:@"%@",dic[@"status"]] isEqualToString:@"1"])
                {
                    [self initLocationManater];
                    self.mainSwitch.on = YES;
                    self.isBeginUploadLocation = YES;
                    [self.locationManager startUpdatingLocation];
                    [UIView transitionFromView:self.firstView toView:self.tableVi duration:.8f options:UIViewAnimationOptionTransitionCrossDissolve completion:^(BOOL finished) {
                        [self reloadNewData];
                    }];
                    
                }
                else if ([[NSString stringWithFormat:@"%@",dic[@"status"]] isEqualToString:@"2"])
                {
                    [self initLocationManater];
                    self.mainSwitch = nil;
                    self.navigationItem.leftBarButtonItem = nil;
                    self.navigationItem.rightBarButtonItem = nil;
                    self.navigationItem.title = @"准备接货";
                    UILabel* tlabel=[[UILabel alloc] initWithFrame:CGRectMake(0,0, 100, 40)];
                    tlabel.text=self.navigationItem.title;
                    tlabel.textAlignment = NSTextAlignmentCenter;
                    tlabel.textColor=black_color;
                    tlabel.font = [UIFont fontWithName:@"Helvetica-Bold" size: 17.0];
                    tlabel.backgroundColor =[UIColor clearColor];
                    tlabel.adjustsFontSizeToFitWidth=YES;
                    
                    self.navigationItem.titleView=tlabel;
                    self.isBeginUploadLocation = YES;
                    [self.locationManager startUpdatingLocation];
                    self.isSend = NO;
                    [self rquestBeingOrderDataNeedOrderId:self.orderorderID];
                    
                }
                else if ([[NSString stringWithFormat:@"%@",dic[@"status"]] isEqualToString:@"3"])
                {
                    [self initLocationManater];
                    self.mainSwitch = nil;
                    self.navigationItem.leftBarButtonItem = nil;
                    self.navigationItem.rightBarButtonItem = nil;
                    self.navigationItem.title = @"开始行程";
                    UILabel* tlabel=[[UILabel alloc] initWithFrame:CGRectMake(0,0, 100, 40)];
                    tlabel.text=self.navigationItem.title;
                    tlabel.textAlignment = NSTextAlignmentCenter;
                    tlabel.textColor=black_color;
                    tlabel.font = [UIFont fontWithName:@"Helvetica-Bold" size: 17.0];
                    tlabel.backgroundColor =[UIColor clearColor];
                    tlabel.adjustsFontSizeToFitWidth=YES;
                    
                    self.navigationItem.titleView=tlabel;
                    [self.bottomView.statusBtn setTitle:@"开始行程" forState:UIControlStateNormal];
                    self.isBeginUploadLocation = YES;
                    [self.locationManager startUpdatingLocation];
                    self.isSend = YES;
                    [self rquestBeingOrderDataNeedOrderId:self.orderorderID];
                }
                if ([[NSString stringWithFormat:@"%@",dic[@"isPay"]] isEqualToString:@"0"])
                {
                    self.paymentView.hidden = NO;
                }
                else
                {
                    self.paymentView.hidden = YES;
                }
            }
            else if ([[NSString stringWithFormat:@"%@",dic[@"checkStatus"]] isEqualToString:@"2"])
            {
                //审核完成
                self.paymentView.hidden = NO;
                [self.noticeBtn setTitle:@"需通过考试才可以接单" forState:UIControlStateNormal];
                self.noticeBtn.userInteractionEnabled = YES;
                self.mainSwitch.userInteractionEnabled = NO;
            }
            else if ([[NSString stringWithFormat:@"%@",dic[@"checkStatus"]] isEqualToString:@"3"])
            {
                //未通过审核
                self.paymentView.hidden = NO;
                [self.noticeBtn setTitle:@"未通过审核，请点击重新提交信息" forState:UIControlStateNormal];
                self.noticeBtn.userInteractionEnabled = YES;
                
                self.mainSwitch.userInteractionEnabled = NO;
            }
            else if ([[NSString stringWithFormat:@"%@",dic[@"checkStatus"]] isEqualToString:@"4"])
            {
                //停止接单
                self.paymentView.hidden = NO;
                [self.noticeBtn setTitle:@"您已被停止接单，请联系客服" forState:UIControlStateNormal];
                self.noticeBtn.userInteractionEnabled = NO;
                
                self.mainSwitch.userInteractionEnabled = NO;
            }
            else if ([[NSString stringWithFormat:@"%@",dic[@"checkStatus"]] isEqualToString:@"-1"])
            {
                JXLoginVC *vc = [[JXLoginVC alloc] init];
                UINavigationController * navc = [[UINavigationController alloc] initWithRootViewController:vc];
                navc.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: black_color};
                navc.navigationBar.barTintColor = white_color;
                [navc.navigationBar setTranslucent:NO];
                [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
                    kWindow.rootViewController = navc;
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // 第一次定位
                [self locationOnceTime];
            });
            
        }
        
        
    }];
}
#pragma mark - 司机工作状态切换
- (void)requestdriverStatusSwitchWithStatus:(NSString *)status completeWithBlock:(void(^)(bool isOK, NSDictionary *respose))block;
{
    
    //设置时间间隔
    NSTimeInterval interval = 0.3;
    //创建队列
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //创建定时器
    _requestTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    dispatch_source_set_timer(_requestTimer, dispatch_walltime(NULL, 0), interval * NSEC_PER_SEC, 0); //每秒执行
    //设置任务
    dispatch_source_set_event_handler(_requestTimer, ^{
        //在这里执行事件
        if (_isLocOk)
        {
            SVSHOW
            if (_requestTimer)
            {
                dispatch_source_cancel(_requestTimer);
            }
            [JXOrderRequestTool postDriverStatusSwitchNeedStatus:status lon:@(self.location.longitude).stringValue lat:@(self.location.latitude).stringValue complete:^(BOOL isSuccess, NSDictionary *respose) {
                if (isSuccess)
                {
                    SVMISS
                    self.isBeginUploadLocation = YES;
                    block(YES,respose);
                }
                else
                {
                    
                    self.isBeginUploadLocation = NO;
                    block(NO,respose);
                }
            }];
        }
    });
    //开始进行定时器
    dispatch_resume(_requestTimer);
    
}
#pragma mark - 下拉刷新新数据
- (void)reloadNewData
{
    
    [JXOrderRequestTool postgrabOrderInfoPageSize:@"10" pageNum:@"1" complete:^(BOOL isSuccess, NSDictionary *respose) {
        if (isSuccess)
        {
            if (self.dataArr)
            {
                [self.dataArr removeAllObjects];
            }
            
            self.dataArr = [NSMutableArray arrayWithArray:[JXHomeModel mj_objectArrayWithKeyValuesArray:respose[@"res"]]];
            
            if (_dataArr.count == 0)
            {
                
                [self.tableVi.tableV.mj_header endRefreshing];
                [self.tableVi.tableV reloadData];
                if (!self.imgView)
                {
                    [self createHolderViewInView:_tableVi];
                }
                self.imgView.hidden = NO;
            }
            else
            {
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    self.imgView.hidden = YES;
                    [self.tableVi.tableV.mj_header endRefreshing];
                    [self.tableVi.tableV reloadData];
                });
            }
        }
        else
        {
            
            [self.tableVi.tableV.mj_header endRefreshing];
        }
    }];
}


#pragma mark - UITable view Data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JXHomeModel *model = _dataArr[indexPath.row];
    NSString *str = model.baseServer;
    NSString *str1 = model.upgradeServer;
    
    if (![JXTool verifyIsNullString:str])
    {
        if (![JXTool verifyIsNullString:str1])
        {
            NSArray *separaArr = [str componentsSeparatedByString:@","];
            NSArray *separaArr1 = [str1 componentsSeparatedByString:@","];
            self.itemArr = [NSMutableArray arrayWithArray:separaArr];
            for (int i = 0 ; i < separaArr1.count; i++)
            {
                [self.itemArr addObject:separaArr1[i]];
            }
        }
        else
        {
            self.itemArr = [NSMutableArray arrayWithArray:[str componentsSeparatedByString:@","]];
        }
    }
    else
    {
        if (![JXTool verifyIsNullString:str1])
        {
            self.itemArr = [NSMutableArray arrayWithArray:[str1 componentsSeparatedByString:@","]];
        }
        else
        {
            self.itemArr = [NSMutableArray array];
        }
    }
    
    NSString *remark = model.remarks;
    if ([JXTool verifyIsNullString:remark])
    {
        remark = @"暂无留言";
    }
    CGFloat itemH = [JXAppTool setupLeaveItem:self.itemArr];
    CGFloat remarkH = [JXTool getLabelHeightWithString:remark needWidth:200];
    CGFloat cellH = 230+itemH+remarkH;
    return cellH;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellID = @"cell1";
    static NSString *cellID2 = @"cell3";
    JXGrabCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    JXGrabCell *cell1 = [tableView dequeueReusableCellWithIdentifier:cellID2];
    
    JXHomeModel *model = _dataArr[indexPath.row];
    NSString *str = model.orderType;
    if ([str isEqualToString:@"1"] || [str isEqualToString:@"2"])
    {
        if (!cell)
        {
            cell = LoadBbundleCell(@"JXGrabCell", 0);
            
        }
        cell.model = model;
        cell.delegate = self;
        return cell;
    }
    else
    {
        if (!cell1)
        {
            cell1 = LoadBbundleCell(@"JXGrabCell", 1);
            
        }
        cell1.model1 = model;
        cell1.delegate = self;
        return cell1;
    }
    
}
#pragma mark - UITable view Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    JXHomeModel *model = _dataArr[indexPath.row];
    NSString *str = model.orderType;
    if ([str isEqualToString:@"1"] || [str isEqualToString:@"2"])
    {
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        JXHomeModel *model = _dataArr[indexPath.row];
        JXOrderDetailVC *firstVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"JXOrderDetailVC"];
        firstVC.orderId = [NSString stringWithFormat:@"%@",model.orderId];
        
        [kUserDefaults setObject:@"4" forKey:@"orderStyle"];
        [kUserDefaults synchronize];
        
        [self.navigationController pushViewController:firstVC animated:YES];
    }
    else
    {
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        JXHomeModel *model = _dataArr[indexPath.row];
        JXOrderDetailVC *firstVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"JXOrderDetailVC"];
        firstVC.orderId = [NSString stringWithFormat:@"%@",model.orderId];
        
        
        [kUserDefaults setObject:@"5" forKey:@"orderStyle"];
        [kUserDefaults synchronize];
        
        [self.navigationController pushViewController:firstVC animated:YES];
    }
}

#pragma mark - 立即抢单按钮点击
- (void)grabOrderNowClick:(UIButton *)btn
{
    JXGrabCell *cell = (JXGrabCell *)btn.superview.superview;
    NSIndexPath *index = [self.tableVi.tableV indexPathForCell:cell];
    
    JXHomeModel *model = _dataArr[index.row];
    //预约单
    if ([[NSString stringWithFormat:@"%@",model.orderType] isEqualToString:@"2"])
    {
        self.isSend = NO;
        
        [self requestGrabOrderNowNeedOrderId:[NSString stringWithFormat:@"%@",model.orderId] operType:@"1" complete:^(BOOL isSuccess, NSDictionary *respose) {
            if (isSuccess)
            {
                
                UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                
                JXOrderDetailVC *firstVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"JXOrderDetailVC"];
                firstVC.orderId = [NSString stringWithFormat:@"%@",model.orderId];
                
                [kUserDefaults setObject:@"1" forKey:@"orderStyle"];
                [kUserDefaults synchronize];
                
                [self.navigationController pushViewController:firstVC animated:YES];
                
                [self.dataArr removeObjectAtIndex:index.row];
                [self.tableVi.tableV reloadData];
            }
            else
            {
                SVINFO(@"您手慢了，下次快点哦", 2)
                [self reloadNewData];
                [self.tableVi.tableV reloadData];
            }
        }];
        
    }
    else
    {
        
        [self requestGrabOrderNowNeedOrderId:[NSString stringWithFormat:@"%@",model.orderId] operType:@"1" complete:^(BOOL isSuccess, NSDictionary *respose) {
            if (isSuccess)
            {
                self.isSend = NO;
                
                //把导航的titleview和左边右边的item置为空
                self.mainSwitch = nil;
                self.navigationItem.leftBarButtonItem = nil;
                self.navigationItem.rightBarButtonItem = nil;
                self.orderorderID = model.orderId;
                
                [self.dataArr removeObjectAtIndex:index.row];
                [self.tableVi.tableV reloadData];
                
                //重新设置导航的标题
                self.navigationItem.title = @"准备接货";
                UILabel* tlabel=[[UILabel alloc] initWithFrame:CGRectMake(0,0, 100, 40)];
                tlabel.text=self.navigationItem.title;
                tlabel.textAlignment = NSTextAlignmentCenter;
                tlabel.textColor=black_color;
                tlabel.font = [UIFont fontWithName:@"Helvetica-Bold" size: 17.0];
                tlabel.backgroundColor =[UIColor clearColor];
                tlabel.adjustsFontSizeToFitWidth=YES;
                
                self.navigationItem.titleView=tlabel;
                
                //转场动画
                [UIView transitionFromView:self.tableVi toView:self.firstView duration:0.5 options:UIViewAnimationOptionTransitionCrossDissolve completion:nil];
                
                //改变地图的高度以适应整个屏幕
                self.mapView.frame = CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height-64-240);
                //设置地图视图的model以及赋值操作
                self.bottomView.model = model;
                NSArray *arr = model.orderTrip;
                
                // 获取起始地
                NSDictionary *beginDic = [arr firstObject];
                self.startingPoint = CLLocationCoordinate2DMake([beginDic[@"lat"] doubleValue], [beginDic[@"lon"] doubleValue]);
                
                // 获取目的地
                NSDictionary *dic = [arr lastObject];
                self.destination = CLLocationCoordinate2DMake([dic[@"lat"] doubleValue], [dic[@"lon"] doubleValue]);
                
                //途经点数据添加数组
                [self.addressArr removeAllObjects];
                self.addressArr = [NSMutableArray array];
                for (int i = 0 ; i < arr.count-1; i++)
                {
                    if (i != 0 )
                    {
                        NSDictionary *dic = arr[i];
                        AMapNaviPoint *locPoint = [AMapNaviPoint locationWithLatitude:[dic[@"lat"] floatValue] longitude:[dic[@"lon"] doubleValue]];
                        [self.addressArr addObject:locPoint];
                    }
                }
                
                [self searchRoutePlanningDriveWith:NaviTypeGet];
                [self performSelector:@selector(delayLoad) withObject:nil afterDelay:.5f];
            }
            else
            {
                SVINFO(@"您手慢了，下次快点哦", 2)
                [self reloadNewData];
                [self.tableVi.tableV reloadData];
            }
        }];
    }
    
    
}
#pragma mark - 创建占位图
- (void)createHolderViewInView:(UIView *)view
{
    self.imgView = [[UIImageView alloc] initWithImage:JX_IMAGE(@"waitOrder")];
    self.imgView.frame = view.bounds;
    self.imgView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(refreshData)];
    [self.imgView addGestureRecognizer:tap];
    [view addSubview:self.imgView];
    
    UILabel *lab = [[UILabel alloc] init];
    lab.frame = CGRectMake(0, 260, Main_Screen_Width, 40);
    lab.textAlignment = NSTextAlignmentCenter;
    lab.font = F20;
    lab.text = @"等待接单中...";
    lab.tag = 6;
    lab.textColor = Main_Color;
    [self.imgView addSubview:lab];
    
}
#pragma mark - 点击占位图重新加载数据
- (void)refreshData
{
    self.imgView.hidden = YES;
    [self reloadNewData];
}
#pragma mark - 立即拒绝点击
- (void)refuseOrderClick:(UIButton *)btn
{
    JXGrabCell *cell = (JXGrabCell *)btn.superview.superview;
    NSIndexPath *index = [self.tableVi.tableV indexPathForCell:cell];
    
    JXHomeModel *model = _dataArr[index.row];
    SVSHOW
    __block typeof(self) weakSelf = self;
    [self requestGrabOrderNowNeedOrderId:[NSString stringWithFormat:@"%@",model.orderId] operType:@"2" complete:^(BOOL isSuccess, NSDictionary *respose) {
        if (isSuccess)
        {
            SVSUCCESS(@"拒单成功", 1.5)
            [weakSelf.dataArr removeObjectAtIndex:index.row];
            [weakSelf.tableVi.tableV reloadData];
        }
    }];
}
#pragma mark - 立即订单列表打电话
- (void)phoneOrderClick:(UIButton *)btn
{
    JXGrabCell *cell = (JXGrabCell *)btn.superview.superview;
    NSIndexPath *index = [self.tableVi.tableV indexPathForCell:cell];
    
    JXHomeModel *model = _dataArr[index.row];
    NSString *phoneStr = model.consignorTel;
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",phoneStr];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

#pragma mark - 延迟加载底部接单信息view的出现
- (void)delayLoad
{
    [UIView animateWithDuration:.5 delay:0 usingSpringWithDamping:.5f initialSpringVelocity:10.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.bottomView.transform = CGAffineTransformMakeTranslation(0, -310);
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark - 设置导航中间视图
- (void)setupTitleView
{
    UILabel* tlabel=[[UILabel alloc] initWithFrame:CGRectMake(0,0, 100, 40)];
    tlabel.text=self.navigationItem.title;
    tlabel.textAlignment = NSTextAlignmentCenter;
    tlabel.textColor=black_color;
    tlabel.font = [UIFont fontWithName:@"Helvetica-Bold" size: 17.0];
    tlabel.backgroundColor =[UIColor clearColor];
    tlabel.adjustsFontSizeToFitWidth=YES;
    self.navigationItem.titleView=tlabel;
}


#pragma mark - 订单状态改变
- (void)buttonClick:(UIButton *)btn
{
    if ([btn.currentTitle isEqualToString:@"准备接货"])
    {
        [btn setTitle:@"接货完成" forState:UIControlStateNormal];
        self.navigationItem.title = @"接货完成";
        [self setupTitleView];
        [self routePlanActionWithType:NaviTypeGet];
        
    }
    else if ([btn.currentTitle isEqualToString:@"接货完成"])
    {
        [[JXSoundPlayer defaultSoundPlayer]play:@"接货完成"];
        [btn setTitle:@"开始行程" forState:UIControlStateNormal];
        self.navigationItem.title = @"开始行程";
        [self setupTitleView];
        
        
    }
    else if ([btn.currentTitle isEqualToString:@"开始行程"])
    {
        
        [self requestChangeOrderStatusNeedOrderId:_orderorderID status:@"4" complete:^(BOOL isSuccess, NSDictionary *respose) {
            if (isSuccess)
            {
                [[JXSoundPlayer defaultSoundPlayer]play:@"开始行程"];
                [self routePlanActionWithType:NaviTypeSend];
            }
        }];
        
        
    }
    else if ([btn.currentTitle isEqualToString:@"到达目的地"])
    {
        SVSHOW
        [self requestChangeOrderStatusNeedOrderId:_orderorderID status:@"5" complete:^(BOOL isSuccess, NSDictionary *respose) {
            if (isSuccess)
            {
                UserInfo *user = [UserInfo defaultUserInfo];
                [user setValue:_orderorderID forKey:@"orderID"];
                
                [[JXSoundPlayer defaultSoundPlayer]play:@"到达目的地"];
                
                [UIView animateWithDuration:.5 delay:0 usingSpringWithDamping:.5f initialSpringVelocity:10.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
                    //改变地图的高度以适应整个屏幕
                    self.mapView.frame = CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height-64);
                    self.bottomView.transform = CGAffineTransformIdentity;
                    [self clear];
                    [btn setTitle:@"准备接货" forState:UIControlStateNormal];
                    
                } completion:^(BOOL finished) {
                    
                    //设置导航相关项
                    self.navigationItem.title = @"";
                    self.mainSwitch.on = YES;
                    self.navigationItem.titleView=self.mainSwitch;
                    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                    leftBtn.frame = CGRectMake(0, 0, 30, 40);
                    [leftBtn setImage:JX_IMAGE(@"shouyedingwei") forState:UIControlStateNormal];
                    [leftBtn addTarget:self action:@selector(homeLeftBtnClick) forControlEvents:UIControlEventTouchUpInside];
                    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
                    
                    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                    rightBtn.frame = CGRectMake(0, 0, 30, 40);
                    [rightBtn setImage:JX_IMAGE(@"shouyexiaoxi") forState:UIControlStateNormal];
                    [rightBtn addTarget:self action:@selector(homeRightBtnClick) forControlEvents:UIControlEventTouchUpInside];
                    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
                    
                    
                    SVMISS
                    //返回接单界面
                    [UIView transitionFromView:self.firstView toView:self.tableVi duration:0.5 options:UIViewAnimationOptionTransitionCrossDissolve completion:^(BOOL finished) {
                        [self reloadNewData];
                    }];
                    
                    //跳转订单详情界面
                    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                    JXOrderDetailVC *firstVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"JXOrderDetailVC"];
                    firstVC.orderId = _orderorderID;
                    
                    [kUserDefaults setObject:@"2" forKey:@"orderStyle"];
                    [kUserDefaults synchronize];
                    [self.navigationController pushViewController:firstVC animated:YES];
                    
                }];
            }
        }];
    }
}
#pragma mark - 定位到当前位置
// 定位当前位置的按钮点击事件是开启一次单次定位
- (void)locAgain
{
    if (self.location.longitude)
    {
        [self.mapView setCenterCoordinate:self.location animated:YES];
        __weak typeof(self) weakSelf = self;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [weakSelf.mapView setZoomLevel:16 atPivot:self.mapView.center animated:YES];
        });
        
        
    }
    else
    {
        [self.locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
            if (error)
            {
                JXLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
                if (error.code == AMapLocationErrorLocateFailed)
                {
                    return;
                }
            }
            [self.mapView setCenterCoordinate:location.coordinate animated:YES];
            __weak typeof(self) weakSelf = self;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [weakSelf.mapView setZoomLevel:16 atPivot:self.mapView.center animated:YES];
            });
        }];
    }
}



#pragma mark - 导航左边按钮点击
- (void)homeLeftBtnClick
{
    JXSelectCity *vc = [[JXSelectCity alloc] init];
    vc.hidesBottomBarWhenPushed=YES;
    vc.isMinePart = YES;
    vc.cityInfo = ^(NSString *city, NSString *cityCode) {
        CLGeocoder *myGeocoder = [[CLGeocoder alloc] init];
        [myGeocoder geocodeAddressString:city completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
            CLPlacemark *firstPlacemark = [placemarks objectAtIndex:0];
            CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(firstPlacemark.location.coordinate.latitude, firstPlacemark.location.coordinate.longitude);
            [self.mapView setCenterCoordinate:coordinate animated:YES];
            __weak typeof(self) weakSelf = self;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [weakSelf.mapView setZoomLevel:16 atPivot:self.mapView.center animated:YES];
            });
        }];
    };
    
    
    
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - 导航右边按钮点击
- (void)homeRightBtnClick
{
    [self performSegueWithIdentifier:@"JXMessageVC" sender:nil];
}

#pragma mark - 去支付保证金
- (void)goPayment:(UIButton *)sender
{
    if ([sender.currentTitle isEqualToString:@"未通过审核，请点击重新提交信息"])
    {
        JXRegisterPersonInfoVC *vc = [[JXRegisterPersonInfoVC alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ([sender.currentTitle isEqualToString:@"需通过考试才可以接单"])
    {
        SVSHOW
        [self requestReadFileComplete:^(BOOL isSuccess, NSString *readUrl) {
            if (isSuccess)
            {
                SVMISS
                JXReadVC *vc = [[JXReadVC alloc] initWithRequestUrl:readUrl];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }];
    }
    else if ([sender.currentTitle isEqualToString:@"您已被停止接单，请联系客服"])
    {
        
    }
    else
    {
        JXPaymentVC *vc = [[JXPaymentVC alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.isRegPart = NO;
        vc.isHomePage = YES;
        vc.type = BeforeViewControllerTypeHome;
        vc.payment = ^(BOOL isHidden) {
            if (isHidden)
            {
                self.paymentView.hidden = YES;
            }
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}


#pragma mark - 导航开关点击切换
- (void)bottonViewClick
{
    JCAlertStyle *style = [JCAlertStyle styleWithType:JCAlertTypeNormal];
    style.alertView.cornerRadius = 5;
    style.background.canDismiss = NO;
    
    style.title.textColor = RGBCOLOR(100, 100, 100);
    style.title.font = F15;
    style.title.insets = UIEdgeInsetsMake(15, 20, 5, 20);
    
    style.content.textColor = RGBCOLOR(144, 144, 144);
    style.content.font = F14;
    style.content.insets = UIEdgeInsetsMake(10, 20, 20, 20);
    style.content.minHeight = 100;
    
    style.buttonNormal.textColor = Main_Color;
    style.buttonCancel.textColor = RGBCOLOR(144, 144, 144);
    
    if (!self.mainSwitch.being)
    {
        JCAlertController *alert = [JCAlertController alertWithTitle:@"提示" message:@"确定切换到接单状态" type:JCAlertTypeNormal];
        [alert addButtonWithTitle:@"取消" type:JCButtonTypeCancel clicked:^{
            self.mainSwitch.on = NO;
        }];
        [alert addButtonWithTitle:@"确定" type:JCButtonTypeNormal clicked:^{
            [self.locationManager startUpdatingLocation];
            
            [self requestdriverStatusSwitchWithStatus:@(1).stringValue completeWithBlock:^(bool isOK, NSDictionary *respose) {
                if (isOK)
                {
                    if ([JXTool verifyIsNullString:USERVOICECONTROL])
                    {
                        //开始听单
                        [[JXSoundPlayer defaultSoundPlayer]play:kBeginListen];
                    }
                    else
                    {
                        if ([USERVOICECONTROL isEqualToString:@"1"])
                        {
                            //开始听单
                            [[JXSoundPlayer defaultSoundPlayer]play:kBeginListen];
                        }
                    }
                    
                    [UIView transitionFromView:self.firstView toView:self.tableVi duration:.8f options:UIViewAnimationOptionTransitionCrossDissolve completion:^(BOOL finished) {
                        [self reloadNewData];
                    }];
                }
                else
                {
                    self.mainSwitch.on = NO;
//                    [self goPayment:self.noticeBtn];
                }
            }];
            
        }];
        
        [self jc_presentViewController:alert presentType:JCPresentTypeFIFO presentCompletion:nil dismissCompletion:nil];
        
    }
    else
    {
        JCAlertController *alert = [JCAlertController alertWithTitle:@"提示" message:@"确定切换到下班状态" type:JCAlertTypeNormal];
        [alert addButtonWithTitle:@"取消" type:JCButtonTypeCancel clicked:^{
            self.mainSwitch.on = YES;
        }];
        [alert addButtonWithTitle:@"确定" type:JCButtonTypeNormal clicked:^{
            [self requestdriverStatusSwitchWithStatus:@(0).stringValue completeWithBlock:^(bool isOK, NSDictionary *respose) {
                if (isOK)
                {
                    if (_requestTimer)
                    {
                        dispatch_source_cancel(_requestTimer);
                    }
                    [self.locationManager stopUpdatingLocation];
                    if ([JXTool verifyIsNullString:USERVOICECONTROL])
                    {
                        //结束听单
                        [[JXSoundPlayer defaultSoundPlayer]play:kEndListen];
                    }
                    else
                    {
                        if ([USERVOICECONTROL isEqualToString:@"1"])
                        {
                            //结束听单
                            [[JXSoundPlayer defaultSoundPlayer]play:kEndListen];
                        }
                    }
                    
                    [UIView transitionFromView:self.tableVi toView:self.firstView duration:.8f options:UIViewAnimationOptionTransitionCrossDissolve completion:nil];
                }
                else
                {
                    self.mainSwitch.on = YES;
                }
            }];
            
        }];
        
        [self jc_presentViewController:alert presentType:JCPresentTypeFIFO presentCompletion:nil dismissCompletion:nil];
        
    }
    
}
//导航开关滑动切换
- (void)swtichSwipeEvent
{
    JCAlertStyle *style = [JCAlertStyle styleWithType:JCAlertTypeNormal];
    style.alertView.cornerRadius = 5;
    style.background.canDismiss = NO;
//    style.background.blur = YES;
    style.background.alpha = 0.3;
    
    style.title.textColor = RGBCOLOR(100, 100, 100);
    style.title.font = F15;
    style.title.insets = UIEdgeInsetsMake(15, 20, 5, 20);
    
    style.content.textColor = RGBCOLOR(144, 144, 144);
    style.content.font = F14;
    style.content.insets = UIEdgeInsetsMake(10, 20, 20, 20);
    style.content.minHeight = 100;
    
    style.buttonNormal.textColor = Main_Color;
    style.buttonCancel.textColor = RGBCOLOR(144, 144, 144);
    
    if (!self.mainSwitch.being)
    {
        JCAlertController *alert = [JCAlertController alertWithTitle:@"提示" message:@"确定切换到接单状态" type:JCAlertTypeNormal];
        [alert addButtonWithTitle:@"取消" type:JCButtonTypeCancel clicked:^{
            self.mainSwitch.on = NO;
        }];
        [alert addButtonWithTitle:@"确定" type:JCButtonTypeNormal clicked:^{
            [self.locationManager startUpdatingLocation];
            
            [self requestdriverStatusSwitchWithStatus:@(1).stringValue completeWithBlock:^(bool isOK, NSDictionary *respose) {
                if (isOK)
                {
                    if ([JXTool verifyIsNullString:USERVOICECONTROL])
                    {
                        //开始听单
                        [[JXSoundPlayer defaultSoundPlayer]play:kBeginListen];
                    }
                    else
                    {
                        if ([USERVOICECONTROL isEqualToString:@"1"])
                        {
                            //开始听单
                            [[JXSoundPlayer defaultSoundPlayer]play:kBeginListen];
                        }
                    }
                    
                    [UIView transitionFromView:self.firstView toView:self.tableVi duration:.8f options:UIViewAnimationOptionTransitionCrossDissolve completion:^(BOOL finished) {
                        [self reloadNewData];
                    }];
                }
                else
                {
                    self.mainSwitch.on = NO;
//                    [self goPayment:self.noticeBtn];
                }
            }];
        }];
        
        [self jc_presentViewController:alert presentType:JCPresentTypeFIFO presentCompletion:nil dismissCompletion:nil];
        
    }
    else
    {
        JCAlertController *alert = [JCAlertController alertWithTitle:@"提示" message:@"确定切换到下班状态" type:JCAlertTypeNormal];
        [alert addButtonWithTitle:@"取消" type:JCButtonTypeCancel clicked:^{
            self.mainSwitch.on = YES;
        }];
        [alert addButtonWithTitle:@"确定" type:JCButtonTypeNormal clicked:^{
            [self requestdriverStatusSwitchWithStatus:@(0).stringValue completeWithBlock:^(bool isOK, NSDictionary *respose) {
                if (isOK)
                {
                    if ([JXTool verifyIsNullString:USERVOICECONTROL])
                    {
                        //结束听单
                        [[JXSoundPlayer defaultSoundPlayer]play:kEndListen];
                    }
                    else
                    {
                        if ([USERVOICECONTROL isEqualToString:@"1"])
                        {
                            //结束听单
                            [[JXSoundPlayer defaultSoundPlayer]play:kEndListen];
                        }
                    }
                    
                    [UIView transitionFromView:self.tableVi toView:self.firstView duration:.8f options:UIViewAnimationOptionTransitionCrossDissolve completion:nil];
                }
                else
                {
                    self.mainSwitch.on = YES;
                }
            }];
        }];
        
        [self jc_presentViewController:alert presentType:JCPresentTypeFIFO presentCompletion:nil dismissCompletion:nil];
        
    }
}


#pragma mark - DriveNaviView Delegate

- (void)driveNaviViewCloseButtonClicked
{
    //停止导航
    [self.driveManager stopNavi];
    //暂停导航
//    [self.driveManager pauseNavi];
//    [self.bottomView.statusBtn setTitle:@"继续导航" forState:UIControlStateNormal];
}
//模拟导航关闭
- (void)moninavi
{
    //停止语音
    [[JXSoundPlayer defaultSoundPlayer]play:@""];
    [self.driveManager stopNavi];
    [self naviArriveDestination];
}
- (void)naviArriveDestination
{
    [[JXSoundPlayer defaultSoundPlayer]play:@""];
    [self.driveManager stopNavi];
    dispatch_async(dispatch_get_main_queue(), ^{
        // 通知主线程刷新
        if (self.isSend == NO)
        {
            self.navigationItem.title = @"开始行程";
            [self.bottomView.statusBtn setTitle:@"开始行程" forState:UIControlStateNormal];
            [self searchRoutePlanningDriveWith:NaviTypeSend];
            self.isSend = YES;
        }
        else
        {
            self.navigationItem.title = @"到达目的地";
            [self.bottomView.statusBtn setTitle:@"到达目的地" forState:UIControlStateNormal];
        }
        
        UILabel* tlabel=[[UILabel alloc] initWithFrame:CGRectMake(0,0, 100, 40)];
        tlabel.text=self.navigationItem.title;
        tlabel.textAlignment = NSTextAlignmentCenter;
        tlabel.textColor=black_color;
        tlabel.font = [UIFont fontWithName:@"Helvetica-Bold" size: 17.0];
        tlabel.backgroundColor =[UIColor clearColor];
        tlabel.adjustsFontSizeToFitWidth=YES;
        
        self.navigationItem.titleView=tlabel;
        
    });
    
}

#pragma mark - 乘客取消订单
- (void)hideFirstView
{
    
    [UIView animateWithDuration:.5 delay:0 usingSpringWithDamping:.5f initialSpringVelocity:10.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        [self clear];
        if ([[self currentViewController] isKindOfClass:[JXDriveNaviVC class]])
        {
            UIViewController *vc = [self currentViewController];
            [vc.navigationController popViewControllerAnimated:YES];
        }
        
        //改变地图的高度以适应整个屏幕
        self.mapView.frame = CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height-64);
        self.bottomView.transform = CGAffineTransformIdentity;
        [self.bottomView.statusBtn setTitle:@"准备接货" forState:UIControlStateNormal];
        
    } completion:^(BOOL finished) {
        
        //设置导航相关项
        self.navigationItem.title = @"";
        self.mainSwitch.on = YES;
        self.navigationItem.titleView=self.mainSwitch;
        UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        leftBtn.frame = CGRectMake(0, 0, 30, 40);
        [leftBtn setImage:JX_IMAGE(@"shouyedingwei") forState:UIControlStateNormal];
        [leftBtn addTarget:self action:@selector(homeLeftBtnClick) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
        
        UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        rightBtn.frame = CGRectMake(0, 0, 30, 40);
        [rightBtn setImage:JX_IMAGE(@"shouyexiaoxi") forState:UIControlStateNormal];
        [rightBtn addTarget:self action:@selector(homeRightBtnClick) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
        
        SVMISS
        //返回接单界面
        [UIView transitionFromView:self.firstView toView:self.tableVi duration:0.5 options:UIViewAnimationOptionTransitionCrossDissolve completion:^(BOOL finished) {
            [self reloadNewData];
        }];
    }];

}

//销毁 监听器
- (void)dealloc
{
    [kNotificationCenter removeObserver:self name:@"gotoTable" object:nil];
    [kNotificationCenter removeObserver:self name:@"changePage" object:nil];
    [kNotificationCenter removeObserver:self name:HomePagemoniNaci object:nil];
    [kNotificationCenter removeObserver:self name:@"passcheck" object:nil];
    [kNotificationCenter removeObserver:self name:@"coverCount" object:nil];
    [kNotificationCenter removeObserver:self name:@"stopCount" object:nil];
    [kNotificationCenter removeObserver:self name:@"comfirmOk" object:nil];
    [kNotificationCenter removeObserver:self name:@"payOK" object:nil];
    [kNotificationCenter removeObserver:self name:@"gotomap" object:nil];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
@end
