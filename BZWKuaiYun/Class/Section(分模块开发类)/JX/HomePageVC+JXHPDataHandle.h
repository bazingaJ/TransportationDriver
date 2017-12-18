//
//  HomePageVC+JXHPDataHandle.h
//  BZWKuaiYun
//
//  Created by Jessey Young on 2017/6/30.
//  Copyright © 2017年 ISU. All rights reserved.
//

#import "HomePageVC.h"

@interface HomePageVC (JXHPDataHandle)

- (void)addListener;



//开始抢单
- (void)requestGrabOrderNowNeedOrderId:(NSString *)order operType:(NSString *)type complete:(void(^)(BOOL isSuccess, NSDictionary *respose))block;

//查询进行中的订单数据
- (void)rquestBeingOrderDataNeedOrderId:(NSString *)orderid;


/**
 @brief 改变订单中状态接口

 @param orderID 订单ID
 @param status 操作类型
 @param block 回调的block
 */
- (void)requestChangeOrderStatusNeedOrderId:(NSString *)orderID
                                     status:(NSString *)status
                                   complete:(void(^)(BOOL isSuccess, NSDictionary *respose))block;
// 强求阅读材料
- (void)requestReadFileComplete:(void(^)(BOOL isSuccess, NSString *readUrl))block;


//获取当前城市是否开通服务功能
- (void)queryCurrentCityServiceCompleteWithBlock:(void(^)(BOOL isSuccess, NSDictionary *response))block;

- (UIViewController*)currentViewController;

@end
