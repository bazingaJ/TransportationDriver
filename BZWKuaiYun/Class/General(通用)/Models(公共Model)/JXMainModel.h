//
//  JXMainModel.h
//  BZWKuaiYun
//
//  Created by Jessey Young on 2017/6/23.
//  Copyright © 2017年 ISU. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JXMainModel : NSObject<NSCopying>

/**
 我的积分
 */
@property (nonatomic, strong) NSString *cost;
@property (nonatomic, strong) NSString *createTime;
@property (nonatomic, strong) NSString *note;
@property (nonatomic, strong) NSString *type;

/**
 余额明细
 */
@property (nonatomic, strong) NSString *operDesc;
@property (nonatomic, strong) NSString *amount;
//@property (nonatomic, strong) NSString *cost;
//@property (nonatomic, strong) NSString *createTime;
//@property (nonatomic, strong) NSString *note;
//@property (nonatomic, strong) NSString *type;


/**
 我的技能
 */
@property (nonatomic, strong) NSString *isCheck;
@property (nonatomic, strong) NSString *skillDesc;
@property (nonatomic, strong) NSString *skillId;

/**
 我的消息
 */

@property (nonatomic, strong) NSString *contents;
@property (nonatomic, strong) NSString *createDate;
@property (nonatomic, strong) NSString *messageId;
@property (nonatomic, strong) NSString *messageType;


/**
 优惠活动
 */
@property (nonatomic, strong) NSString *coverImg;
@property (nonatomic, strong) NSString *eventDesc;
@property (nonatomic, strong) NSString *eventId;
@property (nonatomic, strong) NSString *eventUrl;
@property (nonatomic, strong) NSString *title;

/**
 我的统计-评价
 */
@property (nonatomic, strong) NSString *comment;
//@property (nonatomic, strong) NSString *createTime;
@property (nonatomic, strong) NSString *photo;
@property (nonatomic, strong) NSString *starLevel;
@property (nonatomic, strong) NSString *userName;


/**
 我的统计-收支
 */
//@property (nonatomic, strong) NSString *amount;
//@property (nonatomic, strong) NSString *createTime;
//@property (nonatomic, strong) NSString *note;
//@property (nonatomic, strong) NSString *operDesc;


@end
