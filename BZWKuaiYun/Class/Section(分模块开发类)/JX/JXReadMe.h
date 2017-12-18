//
//  JXReadMe.h
//  BZWKuaiYun
//
//  Created by Jessey Young on 2017/7/5.
//  Copyright © 2017年 ISU. All rights reserved.
//

#ifndef JXReadMe_h
#define JXReadMe_h

后台的OrderStatus
1-等待接单，2-等待接货，3-已接货，4-行程开始，5-待支付，6-待评价，7-已评价，98-被司机拒绝，99-已取消

后台返回的DriverStatus
0-下班, 1-上班（未接单）,2-上班（已接单-去接货中）,3-上班（已接单-接到货去送货中）,

UI按钮对应后台返回的DriverStatus 
2-上班（已接单-去接货中）,===============> 准备接货
3-上班（已接单-去送货中）,===============> 开始行程


#endif /* JXReadMe_h */
