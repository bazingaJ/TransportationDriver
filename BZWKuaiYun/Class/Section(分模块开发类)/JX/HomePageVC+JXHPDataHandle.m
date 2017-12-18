//
//  HomePageVC+JXHPDataHandle.m
//  BZWKuaiYun
//
//  Created by Jessey Young on 2017/6/30.
//  Copyright © 2017年 ISU. All rights reserved.
//

#import "HomePageVC+JXHPDataHandle.h"
#import "HomePageVC+MapSeriver.h"
#import "JXHomeModel.h"
#import "OrderModel.h"

@implementation HomePageVC (JXHPDataHandle)

- (void)addListener
{
    UserInfo *user = [UserInfo defaultUserInfo];
    //语音阅读自定义消息
    [user addObserver:self forKeyPath:@"voiceStr" options:NSKeyValueObservingOptionNew context:nil];
    //全部订单数组
    [user addObserver:self forKeyPath:@"orderArr" options:NSKeyValueObservingOptionNew context:nil];
    //进行中订单model
    [user addObserver:self forKeyPath:@"homeModel" options:NSKeyValueObservingOptionNew context:nil];
    //没有通过审核
    [user addObserver:self forKeyPath:@"driverStatus" options:NSKeyValueObservingOptionNew context:nil];
    
    [user addObserver:self forKeyPath:@"pushDict" options:NSKeyValueObservingOptionNew context:nil];
    
    //通过审核需要考试
//    passcheck
    [kNotificationCenter addObserver:self selector:@selector(changeStatus) name:@"passcheck" object:nil];
    [kNotificationCenter addObserver:self selector:@selector(changeStatus) name:@"coverCount" object:nil];
    [kNotificationCenter addObserver:self selector:@selector(changeStatus) name:@"stopCount" object:nil];
    [kNotificationCenter addObserver:self selector:@selector(changeStatus) name:@"comfirmOk" object:nil];
    //支付完成 退还保证金完成  刷新首页 司机状态
    [kNotificationCenter addObserver:self selector:@selector(changeStatus) name:@"payOK" object:nil];
    
    [kNotificationCenter addObserver:self selector:@selector(changeStatus) name:@"gotomap" object:nil];
    
}

- (void)changeStatus
{
    if ([[self currentViewController] isKindOfClass:[HomePageVC class]])
    {
        if (self.tableVi)
        {
            [UIView transitionFromView:self.tableVi toView:self.firstView duration:.8f options:UIViewAnimationOptionTransitionCrossDissolve completion:nil];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self requestDriverStatus];
        });
    }
    else
    {
        [kUserDefaults setObject:@"可以刷新" forKey:@"是否刷新"];
        [kUserDefaults synchronize];
    }
}


/**
 *  监听属性值发生改变时回调
 */
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"voiceStr"])
    {
        //语音控制从没有赋值 默认是打开的
        if ([JXTool verifyIsNullString:USERVOICECONTROL])
        {
            [[JXSoundPlayer defaultSoundPlayer]play:change[@"new"]];
        }
        else
        {
            //语音控制 设置的是关闭
            if ([USERVOICECONTROL isEqualToString:@"0"])
            {
                //用户设置好了 声音控制为关闭状态 - 故这里不允许播报语音
            }
            //语音控制 设置的是开启
            else if ([USERVOICECONTROL isEqualToString:@"1"])
            {
                [[JXSoundPlayer defaultSoundPlayer]play:change[@"new"]];
            }
        }
        
        [self reloadNewData];
    }
    
    //判断是否是确认现金的推送
    if ([keyPath isEqualToString:@"pushDict"])
    {
        if ([change[@"new"][@"title"] isEqualToString:@"你有一个订单，用户选择现金支付，请确认"])
        {
            NSString *money = [NSString stringWithFormat:@"%@",change[@"new"][@"amount"]];
            NSString *orderId = [NSString stringWithFormat:@"%@",change[@"new"][@"orderId"]];
            NSMutableString *starMoney = [NSMutableString stringWithString:money];
            NSString *alertStr = nil;
            if (money.length >= 3)
            {
                [starMoney insertString:@"." atIndex:money.length-2];
                alertStr = [NSString stringWithFormat:@"%@",starMoney];
            }
            else if (money.length == 2)
            {
                alertStr = [NSString stringWithFormat:@"0.%@",starMoney];
            }
            else if (money.length == 1)
            {
                alertStr = [NSString stringWithFormat:@"0.0%@",starMoney];
            }
            
            NSString *moneyStr = [alertStr stringByReplacingOccurrencesOfString:@".00" withString:@""];
            
            NSString * str = [NSString stringWithFormat:@"您收到一笔现金付款 %@ 元，请确认是否到账",moneyStr];
            
            UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:str preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"已收到" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                
                [JXOrderRequestTool postCashPayImpNeedOrderID:orderId amount:money type:@"2" complete:^(BOOL isSuccess, NSDictionary *respose) {
                    if (isSuccess)
                    {
                        SVINFO(@"确认成功", 2)
                    }
                }];
                
                
            }];
            UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"没收到" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alertC addAction:action1];
            [alertC addAction:action2];
            
            UIViewController *rootVc=[UIApplication sharedApplication].keyWindow.rootViewController;
            [rootVc presentViewController:alertC animated:YES completion:nil];
        }
        else if ([change[@"new"][@"title"] isEqualToString:@"用户同意结束订单"])
        {
            if ([[self currentViewController] isKindOfClass:[JXDriveNaviVC class]])
            {
                UIViewController *vc = [self currentViewController];
                [vc.navigationController popViewControllerAnimated:YES];
            }
            [UIView animateWithDuration:.5 delay:0 usingSpringWithDamping:.5f initialSpringVelocity:10.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
                //改变地图的高度以适应整个屏幕
                self.mapView.frame = CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height-64);
                self.bottomView.transform = CGAffineTransformIdentity;
                [self clear];
                [self.bottomView.statusBtn setTitle:@"准备接货" forState:UIControlStateNormal];
                //停止语音
                [[JXSoundPlayer defaultSoundPlayer]play:@""];
                [self.driveManager stopNavi];
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
                firstVC.orderId = self.orderorderID;
                
                [kUserDefaults setObject:@"2" forKey:@"orderStyle"];
                [kUserDefaults synchronize];
                [self.navigationController pushViewController:firstVC animated:YES];
                
            }];
        }
        else if ([change[@"new"][@"title"] isEqualToString:@"用户拒绝结束订单"])
        {
            SVINFO(@"货主不同意提前到达目的地，请稍后与货主联系", 2)
        }
        
        
    }
    
    if ([keyPath isEqualToString:@"orderArr"])
    {
        NSArray * arr = (NSArray *)change[@"new"];
        self.dataArr = [NSMutableArray arrayWithArray:arr];
        if (self.dataArr.count == 0)
        {
            
        }
        else
        {
            SVMISS
            [self.tableVi.tableV reloadData];
            
        }
    }
    if ([keyPath isEqualToString:@"driverStatus"])
    {
        if ([[self currentViewController] isKindOfClass:[HomePageVC class]])
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self requestDriverStatus];
            });
        }
        else
        {
            [kUserDefaults setObject:@"可以刷新" forKey:@"是否刷新"];
            [kUserDefaults synchronize];
        }
        
    }
}

#pragma mark - 立即抢单
- (void)requestGrabOrderNowNeedOrderId:(NSString *)order operType:(NSString *)type complete:(void(^)(BOOL isSuccess, NSDictionary *respose))block
{
    [JXOrderRequestTool postOrderOperateNeedOrderId:order operType:type complete:^(BOOL isSuccess, NSDictionary *respose) {
        if (isSuccess)
        {
            block(YES,respose);
        }
        else
        {
            block(NO,respose);
        }
    }];
}

#pragma mark - 查询进行中的订单数据
- (void)rquestBeingOrderDataNeedOrderId:(NSString *)orderid
{
    SVSTATUS(@"正在查询订单信息")
    [JXOrderRequestTool postOrderInfoDetailNeedOrderId:orderid complete:^(BOOL isSuccess, NSDictionary *respose) {
        if (isSuccess)
        {
            NSDictionary *dic = respose[@"res"];
            
            if ([[NSString stringWithFormat:@"%@",dic[@"orderType"]] isEqualToString:@"1"])
            {
                self.bottomView.headImg.image = JX_IMAGE(@"jishi");
            }
            else if ([[NSString stringWithFormat:@"%@",dic[@"orderType"]] isEqualToString:@"2"])
            {
                self.bottomView.headImg.image = JX_IMAGE(@"yuyue");
            }
            else if ([[NSString stringWithFormat:@"%@",dic[@"orderType"]] isEqualToString:@"3"])
            {
                self.bottomView.headImg.image = JX_IMAGE(@"zhipai");
            }
            else
            {
                self.bottomView.headImg.image = JX_IMAGE(@"jishi");
            }
            
            self.bottomView.timeLab.text = dic[@"bookingTime"];
            self.bottomView.mileLab.text = [NSString stringWithFormat:@"%@公里",dic[@"distance"]];
                NSArray *arr = dic[@"orderTrip"];
            NSDictionary *smallDic = [arr firstObject];
            self.bottomView.starLab.text = smallDic[@"title"];
            self.bottomView.startDetailLab.text = smallDic[@"address"];
            NSDictionary *smallDic1 = [arr lastObject];
            self.bottomView.endLab.text = smallDic1[@"title"];
            self.bottomView.endDetailLab.text = smallDic1[@"address"];
            
            self.bottomView.telStr = dic[@"consignorTel"];
            
            if ([JXTool verifyIsNullString:dic[@"remarks"]])
            {
                self.bottomView.remark.text = @"暂无留言";
            }
            else
            {
                self.bottomView.remark.text = dic[@"remarks"];
            }
            self.startingPoint = CLLocationCoordinate2DMake([smallDic[@"lat"] doubleValue], [smallDic[@"lon"] doubleValue]);
            self.destination = CLLocationCoordinate2DMake([smallDic1[@"lat"] doubleValue], [smallDic1[@"lon"] doubleValue]);
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
            //设置时间间隔
            NSTimeInterval interval = 0.3;
            //创建队列
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            //创建定时器
            dispatch_source_t waitLocTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
            
            dispatch_source_set_timer(waitLocTimer, dispatch_walltime(NULL, 0), interval * NSEC_PER_SEC, 0); //每秒执行
            //设置任务
            dispatch_source_set_event_handler(waitLocTimer, ^{
                //在这里执行事件
                if (self.isLocOk)
                {
                    
                    if (waitLocTimer)
                    {
                        dispatch_source_cancel(waitLocTimer);
                    }
                    __weak typeof(self) weakSelf = self;
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        self.mapView.frame = CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height-64-240);
                        if (weakSelf.isSend == NO)
                        {
                            [weakSelf searchRoutePlanningDriveWith:NaviTypeGet];
                        }
                        else
                        {
                            [weakSelf searchRoutePlanningDriveWith:NaviTypeSend];
                        }
                        
                    });
                    
                }
            });
            //开始进行定时器
            dispatch_resume(waitLocTimer);
            
            [self performSelector:@selector(upBottpmView) withObject:nil afterDelay:.5f];
        }
    }];
   
}

- (void)upBottpmView
{
    SVMISS
    
    [self delayLoad];
}
#pragma mark - 改变订单状态接口
- (void)requestChangeOrderStatusNeedOrderId:(NSString *)orderID status:(NSString *)status complete:(void(^)(BOOL isSuccess, NSDictionary *respose))block
{
    SVSHOW
    NSString *time = [JXAppTool getWholeStrYMDHMS];
    [JXOrderRequestTool postOrderStatusSwitchNeedOrderId:orderID status:status dateTime:time complete:^(BOOL isSuccess, NSDictionary *respose) {
        if (isSuccess)
        {
            SVMISS
            block(YES,respose);
        }
    }];
}

#pragma mark - 为下一个界面阅读资料做准备
- (void)requestReadFileComplete:(void(^)(BOOL isSuccess, NSString *readUrl))block
{
    [JXRequestTool postQuerySysDictNeedType:@"dataUrl" complete:^(BOOL isSuccess, NSDictionary *respose) {
        if (isSuccess)
        {
            NSArray *array = respose[@"res"];
            NSDictionary *dictionary = array[0];
            NSString *readurl = dictionary[@"value"];
            block(YES,readurl);
            
        }
    }];
}



#pragma mark - 获取当前正在显示的视图控制器
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

#pragma mark - 获取当前城市是否开通服务功能
- (void)queryCurrentCityServiceCompleteWithBlock:(void(^)(BOOL isSuccess, NSDictionary *response))block
{
    [JXRequestTool postCheckOpenCityNeedCityId:CITYCODE Complete:^(BOOL isSuccess, NSDictionary *respose) {
        if (isSuccess)
        {
            
        }
    }];
}


@end
