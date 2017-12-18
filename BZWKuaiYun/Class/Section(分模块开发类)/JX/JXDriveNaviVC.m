//
//  JXDriveNaviVC.m
//  BZWKuaiYun
//
//  Created by Jessey Young on 2017/7/4.
//  Copyright © 2017年 ISU. All rights reserved.
//

#import "JXDriveNaviVC.h"

@interface JXDriveNaviVC ()<AMapNaviDriveViewDelegate>

@end

@implementation JXDriveNaviVC

- (instancetype)init
{
    if (self = [super init])
    {
        [self initDriveView];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.driveView setFrame:self.view.bounds];
    [self.view addSubview:self.driveView];
    
    [self setupUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
    self.navigationController.toolbarHidden = YES;
    
//    __weak typeof(self) weakSelf = self;
//
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        
//        [kNotificationCenter postNotificationName:HomePagemoniNaci object:nil];
//        [weakSelf.navigationController popViewControllerAnimated:NO];
//        
//    });
}

- (void)setupUI
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(15, Main_Screen_Height-110, 110, 35);
    [btn setBackgroundColor:Main_Color];
    if (self.isSend == NO)
    {
        [btn setTitle:@"接货完成" forState:UIControlStateNormal];
    }
    else
    {
        [btn setTitle:@"到达目的地" forState:UIControlStateNormal];
    }
    
    [btn setTitleColor:white_color forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(requestBeforeOver) forControlEvents:UIControlEventTouchUpInside];
    ViewRadius(btn, 5)
    [self.view addSubview:btn];
}


- (void)initDriveView
{
    if (self.driveView == nil)
    {
        self.driveView = [[AMapNaviDriveView alloc] init];
        self.driveView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        self.driveView.showMoreButton = NO;
        
        self.driveView.trackingMode = AMapNaviViewTrackingModeCarNorth;
        [self.driveView setDelegate:self];
    }
}

- (void)viewWillLayoutSubviews
{
    UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (UIInterfaceOrientationIsPortrait(interfaceOrientation))
    {
        [self.driveView setIsLandscape:NO];
    }
    else if (UIInterfaceOrientationIsLandscape(interfaceOrientation))
    {
        [self.driveView setIsLandscape:YES];
    }
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

#pragma mark - DriveView Delegate

- (void)driveViewCloseButtonClicked:(AMapNaviDriveView *)driveView
{
    //停止语音
    [[JXSoundPlayer defaultSoundPlayer]play:@""];
    
    [self.navigationController popViewControllerAnimated:NO];
    if (self.delegate && [self.delegate respondsToSelector:@selector(driveNaviViewCloseButtonClicked)])
    {
        [self.delegate driveNaviViewCloseButtonClicked];
    }
}

- (void)driveViewMoreButtonClicked:(AMapNaviDriveView *)driveView
{
    //配置MoreMenu状态
    [driveView setTrackingMode:AMapNaviViewTrackingModeCarNorth];
    
}

- (void)driveViewTrunIndicatorViewTapped:(AMapNaviDriveView *)driveView
{ 
    if (self.driveView.showMode == AMapNaviDriveViewShowModeCarPositionLocked)
    {
        [self.driveView setShowMode:AMapNaviDriveViewShowModeNormal];
    }
    else if (self.driveView.showMode == AMapNaviDriveViewShowModeNormal)
    {
        [self.driveView setShowMode:AMapNaviDriveViewShowModeOverview];
    }
    else if (self.driveView.showMode == AMapNaviDriveViewShowModeOverview)
    {
        [self.driveView setShowMode:AMapNaviDriveViewShowModeCarPositionLocked];
    }
}

- (void)requestBeforeOver
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"您确定要提前到达吗？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        if (self.isSend == NO)
        {
            SVSHOW
            NSString *time = [JXAppTool getWholeStrYMDHMS];
            [JXOrderRequestTool postOrderStatusSwitchNeedOrderId:self.orderIdd status:@"3" dateTime:time complete:^(BOOL isSuccess, NSDictionary *respose) {
                if (isSuccess)
                {
                    SVMISS
                    if (self.sendBlock)
                    {
                        self.sendBlock(YES);
                    }
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }];
        }
        else
        {
            [JXOrderRequestTool postEndOrderNeedOrderId:self.orderIdd complete:^(BOOL isSuccess, NSDictionary *respose) {
                if (isSuccess)
                {
                    SVSUCCESS(@"已提交申请，请等待货主确认", 2.5)
                }
            }];
        }
        
    }];
    [alert addAction:action1];
    [alert addAction:action2];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}



@end
