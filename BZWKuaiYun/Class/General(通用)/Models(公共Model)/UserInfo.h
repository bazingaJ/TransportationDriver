//
//  UserInfo.h
//  BZWKuaiYun
//
//  Created by Jessey Young on 2017/6/8.
//  Copyright © 2017年 ISU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JXHomeModel.h"

@interface UserInfo : NSObject

@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *tel;
@property (nonatomic, strong) NSString *password;

//准点率
@property (nonatomic, strong) NSString *ontimeRate;
//拒单率
@property (nonatomic, strong) NSString *refuseRate;
//评分
@property (nonatomic, strong) NSString *starLevel;
//真实姓名
@property (nonatomic, strong) NSString *trueName;
//头像地址
@property (nonatomic, strong) NSString *photo;
//车辆认证状态
@property (nonatomic, strong) NSString *carCheckStatus;
//语音内容
@property (nonatomic, strong) NSString *voiceStr;
//听单中的数组
@property (nonatomic, strong) NSMutableArray *orderArr;
//监听司机审核状态改变
@property (nonatomic, strong) NSString *driverStatus;
//监听司机审核状态改变
@property (nonatomic, strong) NSString *driverPass;
//进行中订单ID
@property (nonatomic, strong) NSString *orderID;
//进行中的模型
@property (nonatomic, strong) JXHomeModel *homeModel;
//推送json解析之后的字典
@property (nonatomic, strong) NSDictionary *pushDict;

+(instancetype)defaultUserInfo;

@end
