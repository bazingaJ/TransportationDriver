//
//  OrderModel.h
//  BZWKuaiYun
//
//  Created by Jessey Young on 2017/5/22.
//  Copyright © 2017年 ISU. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderModel : NSObject

/**
 @brief 收取金额
 */
@property (nonatomic, strong) NSString *amount;
/**
 @brief 时间
 */
@property (nonatomic, strong) NSString *createTime;
/**
 @brief 终点
 */
@property (nonatomic, strong) NSString *endTitle;
/**
 @brief 订单ID
 */
@property (nonatomic, strong) NSString *orderId;
/**
 @brief 订单编号
 */
@property (nonatomic, strong) NSString *orderNo;
/**
 @brief 订单类型
 */
@property (nonatomic, strong) NSString *orderType;
/**
 @brief 订单类型中文描述
 */
@property (nonatomic, strong) NSString *orderTypeDesc;
/**
 @brief 起点
 */
@property (nonatomic, strong) NSString *startTitle;
/**
 @brief 订单状态
 */
@property (nonatomic, strong) NSString *status;
/**
 @brief 订单状态中文描述
 */
@property (nonatomic, strong) NSString *statusDesc;

@end
