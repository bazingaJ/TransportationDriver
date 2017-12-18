//
//  JXOrderRequestTool.h
//  BZWKuaiYun
//
//  Created by Jessey Young on 2017/6/28.
//  Copyright © 2017年 ISU. All rights reserved.
//

#import "JXRequestTool.h"

extern NSString *const JXRequestToolDisconnectString;



/**
 @brief 本类用于 首页和订单模块的请求
 */
@interface JXOrderRequestTool : JXRequestTool

#pragma mark - 4.3.7 司机状态查询接口
/**
 @brief 司机状态查询接口

 @param block 回调的block
 */
+ (void)postDriverStatuscomplete:(void(^)(BOOL isSuccess, NSDictionary *respose))block;

#pragma mark - 4.3.8 司机工作状态切换接口
/**
 @brief 司机工作状态切换接口

 @param status 工作状态
 @param lon 当前经度
 @param lat 当前纬度
 @param block 回调的block
 */
+ (void)postDriverStatusSwitchNeedStatus:(NSString *)status
                                     lon:(NSString *)lon
                                     lat:(NSString *)lat
                                complete:(void(^)(BOOL isSuccess, NSDictionary *respose))block;

#pragma mark - 4.3.9 司机位置信息上传接口（不调后台接口，前端直接通过云图服务更新高德数据）
/**
 @brief 司机位置信息上传接口
 
 param key     客户唯一标识
 param tableid 数据表唯一标识
 param loctype 定位方式 设置是以请求中的经纬度参数（_location）还是地址参数（_address）来计算
               最终的坐标值。
               可选值：
               1：经纬度；格式示例：104.394729,31.125698
               2：地址
 param data    新增的数据(json) data={"_id":"3","_location":"113.484733,37.837432"}，
 
 _id            数据id     必填
 _name          数据名称    可选
 _location      坐标       可选   支持点数据
 规则：经度,纬度，经纬度支持到小数点后6位
 格式示例：104.394729,31.125698
 coordtype      坐标类型    可选   缺省值(autonavi)
 可选值：
 1: gps
 2: autonavi (默认)
 3: baidu
 您可输入coordtype=1,或者autonavi
 
 _address       地址  可选
 
 <customfield1> 用户自定义字段1
 
 <customfield…> 用户自定义字段…
 
 param sig 数字签名
 
 根据规则生成签名：
 签名=MD5(请求参数键值对（按参数名的升序排序）+（+号无需输入）私钥)；
 例如：请求服务为testservice，请求参数分别为a=23，b=12，d=48，f=8，c=67；私钥为bbbbb
 则数字签名：sig=MD5(a=23&b=12&c=67&d=48&f=8bbbbb)
 
 
 @param yunId 云图ID
 @param geox 经度
 @param geoy 纬度
 @param address 文字地址
 @param block 回调的block
 */
+ (void)postGaoDeNeedYunId:(NSString *)yunId
                      geox:(NSString *)geox
                      geoy:(NSString *)geoy
                   address:(NSString *)address
                  complete:(void(^)(BOOL isSuccess, NSDictionary *respose))block;

#pragma mark - 4.3.11 详情查询接口
/**
 @brief 详情查询接口

 @param orderId 订单ID
 @param block 回调的block
 */
+ (void)postOrderInfoDetailNeedOrderId:(NSString *)orderId
                              complete:(void(^)(BOOL isSuccess, NSDictionary *respose))block;

#pragma mark - 4.3.12 抢单/接单/拒绝 接口
/**
 @brief 抢单/接单/拒绝 接口

 @param orderId 订单ID
 @param operType 操作类型 1-接单 2-拒绝 
 @param block 回调的block
 */
+ (void)postOrderOperateNeedOrderId:(NSString *)orderId
                           operType:(NSString *)operType
                           complete:(void(^)(BOOL isSuccess, NSDictionary *respose))block;

#pragma mark - 4.3.13 订单状态改变接口
/**
 @brief 订单状态改变接口

 @param orderId 订单ID
 @param status 操作类型
 @param dateTime 日期时间
 @param block 回调的block
 */
+ (void)postOrderStatusSwitchNeedOrderId:(NSString *)orderId
                                  status:(NSString *)status
                                dateTime:(NSString *)dateTime
                                complete:(void(^)(BOOL isSuccess, NSDictionary *respose))block;

#pragma mark - 4.3.14 我的订单列表查询接口
/**
 @brief 我的订单列表查询接口

 @param orderStatus 订单状态
 @param pageSize 每页条数
 @param pageNum 页数
 @param block 回调的block
 */
+ (void)postMyOrderInfoNeedOrderStatus:(NSString *)orderStatus
                              pageSize:(NSString *)pageSize
                               pageNum:(NSString *)pageNum
                              complete:(void(^)(BOOL isSuccess, NSDictionary *respose))block;

#pragma mark - 4.3.15 取消订单接口
/**
 @brief 取消订单接口
 
 @param orderId 订单ID
 @param block 回调的block
 */
+ (void)postCancelOrderNeedOrderId:(NSString *)orderId
                              complete:(void(^)(BOOL isSuccess, NSDictionary *respose))block;

#pragma mark - 4.3.31 获取推送范围内的待接单订单（抢单用）
/**
 @brief 获取推送范围内的待接单订单（抢单用）

 @param pageSize 每页条数
 @param pageNum 页数
 @param block 回调的block
 */
+ (void)postgrabOrderInfoPageSize:(NSString *)pageSize
                          pageNum:(NSString *)pageNum
                         complete:(void(^)(BOOL isSuccess, NSDictionary *respose))block;

#pragma mark - 4.3.33 提前结束订单接口
/**
 @brief 提前结束订单接口

 @param orderId 订单id
 @param block 回调的block
 */
+ (void)postEndOrderNeedOrderId:(NSString *)orderId
                       complete:(void(^)(BOOL isSuccess, NSDictionary *respose))block;


#pragma mark - 4.4.1 获取缴纳保障金订单ID
/**
 @brief 获取缴纳保障金订单ID

 @param block 回调的block
 */
+ (void)postGetOrderStringComplete:(void(^)(BOOL isSuccess, NSDictionary *respose))block;

#pragma mark - 4.4.36 现金支付接口
/**
 @brief 4.4.36 现金支付接口

 @param orderId 订单ID
 @param amount 金额分为单位
 @param type 操作类型
 @param block 回调的block
 */
+ (void)postCashPayImpNeedOrderID:(NSString *)orderId
                           amount:(NSString *)amount
                             type:(NSString *)type
                         complete:(void(^)(BOOL isSuccess, NSDictionary *respose))block;

#pragma mark - 微信支付信息接口
/**
 @brief 微信支付信息接口

 @param block 回调
 */
+ (void)postWechatPayInfoComplete:(void(^)(BOOL isSuccess, NSDictionary *respose))block;











































































@end
