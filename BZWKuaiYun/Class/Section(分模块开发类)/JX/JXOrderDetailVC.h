//
//  JXOrderDetailVC.h
//  BZWKuaiYun
//
//  Created by Jessey Young on 2017/6/1.
//  Copyright © 2017年 ISU. All rights reserved.
//

#import "JXBaseVC.h"

@interface JXOrderDetailVC : JXBaseVC

@property (nonatomic, strong) NSString *orderId;

//订单类型 图片
@property (weak, nonatomic) IBOutlet UIImageView *orderStatusPic;
//订单编号
@property (weak, nonatomic) IBOutlet UILabel *orderNoLab;
//公里数
@property (weak, nonatomic) IBOutlet UILabel *kilometreLab;
//订单时间
@property (weak, nonatomic) IBOutlet UILabel *timeLab;

@property (weak, nonatomic) IBOutlet UILabel *orderTime;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *locViewTop;

//拨打电话按钮
@property (weak, nonatomic) IBOutlet UIButton *telBtn;
//起点主标题
@property (weak, nonatomic) IBOutlet UILabel *startTitleLab;
//起点副标题
@property (weak, nonatomic) IBOutlet UILabel *startDetailLab;
//终点主标题
@property (weak, nonatomic) IBOutlet UILabel *endTitleLab;
//终点副标题
@property (weak, nonatomic) IBOutlet UILabel *endDetailLab;
//留言label
@property (weak, nonatomic) IBOutlet UILabel *leaveWordLab;
//订单金额
@property (weak, nonatomic) IBOutlet UILabel *moneyLab;
//拒绝按钮
@property (weak, nonatomic) IBOutlet UIButton *refueseBtn;
//同意按钮
@property (weak, nonatomic) IBOutlet UIButton *agreeBtn;
//底层大按钮
@property (weak, nonatomic) IBOutlet UIButton *bottomBtn;
//很多地址的view
@property (weak, nonatomic) IBOutlet UIView *addressView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addressHeight;

//留言款项
@property (weak, nonatomic) IBOutlet UIView *flowView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *flowHeight;


@end
