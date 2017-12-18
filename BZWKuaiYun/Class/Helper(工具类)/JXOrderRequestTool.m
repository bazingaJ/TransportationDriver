//
//  JXOrderRequestTool.m
//  BZWKuaiYun
//
//  Created by Jessey Young on 2017/6/28.
//  Copyright © 2017年 ISU. All rights reserved.
//

#import "JXOrderRequestTool.h"

NSString *const JXRequestToolDisconnectString = @"网络连接异常";


@implementation JXOrderRequestTool

#pragma mark - 4.3.7 司机状态查询接口
+ (void)postDriverStatuscomplete:(void(^)(BOOL isSuccess, NSDictionary *respose))block
{
    NSDictionary *params = @{@"token":USERTOKEN,
                          @"driverId":USERID};
    
    [self requestWithMethod:RequestMethodTypePost
                        url:@"driver/driverStatus"
                     params:params
                    success:^(id response) {
                        if([response[@"returnCode"]isEqualToString:@"00"])
                        {
                            JXLog(@"==司机状态查询接口返回成功%@",response);
                            block(YES,response);
                        }
                        else
                        {
                            JXLog(@"==司机状态查询接口返回失败%@",response);
                            SVINFO(response[@"message"], 2);
                        }
                    }
                    failure:^(NSError *err) {
                        SVERROR(JXRequestToolDisconnectString, 2);
                    }];
}

#pragma mark - 4.3.8 司机工作状态切换接口
+ (void)postDriverStatusSwitchNeedStatus:(NSString *)status
                                     lon:(NSString *)lon
                                     lat:(NSString *)lat
                                complete:(void(^)(BOOL isSuccess, NSDictionary *respose))block
{
    NSDictionary *params = @{@"token":USERTOKEN,
                             @"driverId":USERID,
                             @"status":status,
                             @"lon":lon,
                             @"lat":lat};
    
    [self requestWithMethod:RequestMethodTypePost
                        url:@"driver/driverStatusSwitch"
                     params:params
                    success:^(id response) {
                        if([response[@"returnCode"]isEqualToString:@"00"])
                        {
                            JXLog(@"==司机工作状态切换接口返回成功%@",response);
                            block(YES,response);
                        }
                        else
                        {
                            JXLog(@"==司机工作状态切换接口返回失败%@",response);
                            SVINFO(response[@"message"], 2);
                            block(NO,response);
                        }
                    }
                    failure:^(NSError *err) {
                        SVERROR(JXRequestToolDisconnectString, 2);
                    }];
}

#pragma mark - 4.3.9 司机位置信息上传接口（不调后台接口，前端直接通过云图服务更新高德数据）
+ (void)postGaoDeNeedYunId:(NSString *)yunId
                      geox:(NSString *)geox
                      geoy:(NSString *)geoy
                   address:(NSString *)address
                  complete:(void(^)(BOOL isSuccess, NSDictionary *respose))block
{
    NSString *locationStr = [NSString stringWithFormat:@"%@,%@",geox,geoy];
    NSDictionary *dataDic = @{@"_id":yunId,
                              @"_location":locationStr,
                              @"coordtype":@"autonavi",
                              @"_address":address};
    
    NSDictionary *params = @{@"key":GDYUNKEY,
                             @"tableid":GDTABLEID,
                             @"loctype":@"1",
                             @"data":[JXAppTool convertToJsonData:dataDic]};
    [self requestWithMethod:RequestMethodTypePost
                        url:kGDYunUrl
                     params:params
                    success:^(id response) {
                        if([response[@"info"] isEqualToString:@"OK"])
                        {
                            JXLog(@"==司机位置信息上传接口返回成功%@",response);
                            block(YES,response);
                        }
                        else
                        {
                            
                            
                        }
    }
                    failure:^(NSError *err) {
                            SVERROR(JXRequestToolDisconnectString, 2);
    }];
}

#pragma mark - 4.3.11 详情查询接口
+ (void)postOrderInfoDetailNeedOrderId:(NSString *)orderId
                              complete:(void(^)(BOOL isSuccess, NSDictionary *respose))block
{
    NSDictionary *params = @{@"token":USERTOKEN,
                             @"driverId":USERID,
                             @"orderId":orderId};
    [self requestWithMethod:RequestMethodTypePost
                        url:@"driverInfo/orderInfoDetail"
                     params:params
                    success:^(id response) {
                        if([response[@"returnCode"]isEqualToString:@"00"])
                        {
                            JXLog(@"==详情查询接口返回成功%@",response);
                            block(YES,response);
                        }
                        else
                        {
                            JXLog(@"==详情查询接口返回失败%@",response);
                            SVINFO(response[@"message"], 2);
                        }
    }
                    failure:^(NSError *err) {
                            SVERROR(JXRequestToolDisconnectString, 2);
    }];
}

#pragma mark - 4.3.12 抢单/接单/拒绝接口
+ (void)postOrderOperateNeedOrderId:(NSString *)orderId
                           operType:(NSString *)operType
                           complete:(void(^)(BOOL isSuccess, NSDictionary *respose))block
{
    NSDictionary *params = @{@"token":USERTOKEN,
                             @"driverId":USERID,
                             @"orderId":orderId,
                             @"operType":operType};
    
    [self requestWithMethod:RequestMethodTypePost
                        url:@"driverOrder/orderOperate"
                     params:params
                    success:^(id response) {
                        if([response[@"returnCode"]isEqualToString:@"00"])
                        {
                            block(YES,response);
                        }
                        else
                        {
                            block(NO,response[@"message"]);
                        }
    }
                    failure:^(NSError *err) {
                        
    }];
}

#pragma mark - 4.3.13 订单状态改变接口
+ (void)postOrderStatusSwitchNeedOrderId:(NSString *)orderId
                                  status:(NSString *)status
                                dateTime:(NSString *)dateTime
                                complete:(void(^)(BOOL isSuccess, NSDictionary *respose))block
{
    NSDictionary *params = @{@"token":USERTOKEN,
                             @"driverId":USERID,
                             @"orderId":orderId,
                             @"status":status,
                             @"dateTime":dateTime};
    [self requestWithMethod:RequestMethodTypePost
                        url:@"driverOrder/orderStatusSwitch"
                     params:params
                    success:^(id response) {
                        if([response[@"returnCode"]isEqualToString:@"00"])
                        {
                            JXLog(@"==订单状态改变接口返回成功%@",response);
                            block(YES,response);
                        }
                        else
                        {
                            JXLog(@"==订单状态改变接口返回失败%@",response);
                            SVINFO(response[@"message"], 2);
                        }
    }
                    failure:^(NSError *err) {
                            SVERROR(JXRequestToolDisconnectString, 2);
    }];
}

#pragma mark - 4.3.14 我的订单列表查询接口
+ (void)postMyOrderInfoNeedOrderStatus:(NSString *)orderStatus
                              pageSize:(NSString *)pageSize
                               pageNum:(NSString *)pageNum
                              complete:(void(^)(BOOL isSuccess, NSDictionary *respose))block
{
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            USERTOKEN,@"token",
                            USERID,@"driverId",
                            orderStatus,@"orderStatus",
                            pageSize,@"pageSize",
                            pageNum,@"pageNum",
                            nil];
    [self requestWithMethod:RequestMethodTypePost
                        url:@"driverInfo/myOrderInfo"
                     params:params
                    success:^(id response) {
                        if([response[@"returnCode"]isEqualToString:@"00"])
                        {
                            JXLog(@"==我的订单列表查询接口返回成功%@",response);
                            block(YES,response);
                        }
                        else
                        {
                            JXLog(@"==我的订单列表查询接口返回失败%@",response);
                            SVINFO(response[@"message"], 2);
                            block(NO,response);
                        }
    }
                    failure:^(NSError *err) {
                        block(NO,nil);
                            SVERROR(JXRequestToolDisconnectString, 2);
    }];
}

#pragma mark - 4.3.15 取消订单接口
+ (void)postCancelOrderNeedOrderId:(NSString *)orderId
                          complete:(void(^)(BOOL isSuccess, NSDictionary *respose))block
{
    NSDictionary *params = @{@"token":USERTOKEN,
                          @"driverId":USERID,
                           @"orderId":orderId};
    
    [self requestWithMethod:RequestMethodTypePost
                        url:@"driverOrder/cancelOrder"
                     params:params
                    success:^(id response) {
                        if([response[@"returnCode"]isEqualToString:@"00"])
                        {
                            JXLog(@"==取消订单接口返回成功%@",response);
                            block(YES,response);
                        }
                        else
                        {
                            JXLog(@"==取消订单接口返回失败%@",response);
                            SVINFO(response[@"message"], 2);
                        }
    }
                    failure:^(NSError *err) {
                            SVERROR(JXRequestToolDisconnectString, 2);
    }];
}

#pragma mark - 4.3.31 获取推送范围内的待接单订单接口（抢单用）
+ (void)postgrabOrderInfoPageSize:(NSString *)pageSize
                          pageNum:(NSString *)pageNum
                         complete:(void(^)(BOOL isSuccess, NSDictionary *respose))block
{
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            USERID,@"driverId",
                            pageSize,@"pageSize",
                            pageNum,@"pageNum",
                            nil];
    [self requestWithMethod:RequestMethodTypePost
                        url:@"driver/grapOrderInfo"
                     params:params
                    success:^(id response) {
                        if([response[@"returnCode"]isEqualToString:@"00"])
                        {
                            JXLog(@"==获取推送范围内的待接单订单接口返回成功%@",response);
                            block(YES,response);
                        }
                        else
                        {
                            JXLog(@"==获取推送范围内的待接单订单接口返回失败%@",response);
                            SVINFO(response[@"message"], 2);
                            block(NO,response);
                        }
    }
                    failure:^(NSError *err) {
                            block(NO,nil);
                            SVERROR(JXRequestToolDisconnectString, 2);
    }];
}

#pragma mark - 4.3.33 提前结束订单接口
+ (void)postEndOrderNeedOrderId:(NSString *)orderId
                       complete:(void(^)(BOOL isSuccess, NSDictionary *respose))block
{
    NSDictionary *params = @{@"driverId":USERID,
                             @"orderId":orderId,
                             @"token":USERTOKEN};
    [self requestWithMethod:RequestMethodTypePost
                        url:@"driverOrder/endOrder"
                     params:params
                    success:^(id response) {
                        if([response[@"returnCode"]isEqualToString:@"00"])
                        {
                            JXLog(@"==提前结束订单接口返回成功%@",response);
                            block(YES,response);
                        }
                        else
                        {
                            JXLog(@"==提前结束订单接口返回失败%@",response);
                            SVINFO(response[@"message"], 2);
                        }
                    }
                    failure:^(NSError *err) {
                        SVERROR(JXRequestToolDisconnectString, 2);
                    }];
}

#pragma mark - 4.4.1 获取缴纳保障金订单ID接口
+ (void)postGetOrderStringComplete:(void(^)(BOOL isSuccess, NSDictionary *respose))block
{
    NSDictionary *params = @{@"targetId":USERID,
                             @"type":@"2"};
    [self requestWithMethod:RequestMethodTypePost
                        url:@"alipay/orderString"
                     params:params
                    success:^(id response) {
                        if([response[@"returnCode"]isEqualToString:@"00"])
                        {
                            JXLog(@"==获取缴纳保障金订单ID接口返回成功%@",response);
                            block(YES,response);
                        }
                        else
                        {
                            JXLog(@"==获取缴纳保障金订单ID接口返回失败%@",response);
                            SVINFO(response[@"message"], 2);
                        }
    }
                    failure:^(NSError *err) {
                            SVERROR(JXRequestToolDisconnectString, 2);
    }];
}

#pragma mark - 4.4.36 现金支付接口
+ (void)postCashPayImpNeedOrderID:(NSString *)orderId
                           amount:(NSString *)amount
                             type:(NSString *)type
                         complete:(void(^)(BOOL isSuccess, NSDictionary *respose))block
{
    NSDictionary *params = @{@"orderId":orderId,
                             @"amount":amount,
                             @"type":type};
    [self requestWithMethod:RequestMethodTypePost
                        url:@"cashPay/cashPayImp"
                     params:params
                    success:^(id response) {
                        if([response[@"returnCode"]isEqualToString:@"00"])
                        {
                            JXLog(@"==现金支付接口返回成功%@",response);
                            block(YES,response);
                        }
                        else
                        {
                            JXLog(@"==现金支付接口返回失败%@",response);
                            SVINFO(response[@"message"], 2);
                        }
                    }
                    failure:^(NSError *err) {
                        SVERROR(JXRequestToolDisconnectString, 2);
                    }];
}

#pragma mark - 微信支付信息接口
+ (void)postWechatPayInfoComplete:(void(^)(BOOL isSuccess, NSDictionary *respose))block
{
    NSDictionary *params = @{@"targetId":USERID,
                             @"type":@"2"};
    [self requestWithMethod:RequestMethodTypePost
                        url:@"wechat/orderString"
                     params:params
                    success:^(id response) {
                        if([response[@"returnCode"]isEqualToString:@"00"])
                        {
                            block(YES,response);
                        }
                        else
                        {
                            SVINFO(response[@"message"], 2);
                        }
                    }
                    failure:^(NSError *err) {
                        SVERROR(JXRequestToolDisconnectString, 2);
                    }];
}







@end
