//
//  JXHomeModel.h
//  BZWKuaiYun
//
//  Created by Jessey Young on 2017/7/4.
//  Copyright © 2017年 ISU. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JXHomeModel : NSObject
/*
"actualAmt": 25000,
"autoType": 6,
"autoTypeDesc": "金杯",
"baseServer": "需要装卸/(司机另议),需带回款/(免费),回单/(免费),电子回单/(免费)",
"bookingTime": "2017-09-09 12:12:12.0",
"consignor": "19099909090",
"consignorTel": "19099909090",
"createTime": "",
"discountAmt": 1000,
"distance": "20",
"orderId": 2,
"orderNo": "",
"orderTrip": [{
    "address": "河定桥附近",
    "lat": "31.956499",
    "lon": "118.822151",
    "title": "江宁金轮",
    "tripSort": 1
}, {
    "address": "江宁大学城",
    "lat": "31.946499",
    "lon": "119.832151",
    "title": "文鼎广场",
    "tripSort": 2
}],
"orderType": 1,
"orderTypeDesc": "即时",
"receiver": "198788887878",
"receiverTel": "198788887878",
"status": "1",
"statusDesc": "待接单",
"tipAmt": 2000,
"totalAmt": 30000,
"upgradeServer": "安装冰箱,安装热水器,安装花洒,安装马桶",
 "remarks":"aaa",
"userId": 1
*/
@property (nonatomic, strong) NSString *actualAmt;
@property (nonatomic, strong) NSString *autoType;
@property (nonatomic, strong) NSString *autoTypeDesc;
@property (nonatomic, strong) NSString *baseServer;
@property (nonatomic, strong) NSString *bookingTime;
@property (nonatomic, strong) NSString *consignor;
@property (nonatomic, strong) NSString *consignorTel;
@property (nonatomic, strong) NSString *createTime;
@property (nonatomic, strong) NSString *discountAmt;
@property (nonatomic, strong) NSString *distance;
@property (nonatomic, strong) NSString *orderId;
@property (nonatomic, strong) NSString *orderNo;
@property (nonatomic, strong) NSArray  *orderTrip;
@property (nonatomic, strong) NSString *orderType;
@property (nonatomic, strong) NSString *orderTypeDesc;
@property (nonatomic, strong) NSString *receiver;
@property (nonatomic, strong) NSString *receiverTel;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *statusDesc;
@property (nonatomic, strong) NSString *tipAmt;
@property (nonatomic, strong) NSString *totalAmt;
@property (nonatomic, strong) NSString *upgradeServer;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *remarks;
@end
