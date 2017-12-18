//
//  JXMyOrderCell.h
//  BZWKuaiYun
//
//  Created by Jessey Young on 2017/5/22.
//  Copyright © 2017年 ISU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderModel.h"

@protocol JXMyOrderDelegate <NSObject>
@required
- (void)checkOrderBtnClick:(UIButton *)btn;

@optional
- (void)cancelOrderBtnClick:(UIButton *)btn;

@end

@interface JXMyOrderCell : UITableViewCell

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lookBtnTrailing;

@property (weak, nonatomic) IBOutlet UILabel *orderStatusLab;
//订单时间
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
//订单起点
@property (weak, nonatomic) IBOutlet UILabel *startLocLab;
//订单终点
@property (weak, nonatomic) IBOutlet UILabel *endLocLab;
@property (weak, nonatomic) IBOutlet UILabel *orderMoneyLab;
//查看订单
@property (weak, nonatomic) IBOutlet UIButton *lookOrder;
//取消订单
@property (weak, nonatomic) IBOutlet UIButton *cancelOrder;
//订单状态图片
@property (weak, nonatomic) IBOutlet UIImageView *statusImg;

@property (nonatomic, assign) id<JXMyOrderDelegate>delegate;

@property (nonatomic, strong) OrderModel *model;

@end
