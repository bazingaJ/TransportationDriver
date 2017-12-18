//
//  JXShareTool.h
//  BZWKuaiYun
//
//  Created by Jessey Young on 2017/6/30.
//  Copyright © 2017年 ISU. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,UMShareType)
{
    UMShareType_WechatSession      = 1, //微信聊天
    UMShareType_QQ                 = 2, //QQ聊天页面
    UMShareType_WechatTimeLine     = 3, //微信朋友圈
    UMShareType_Sina               = 4, //新浪
    UMShareType_QQZone             = 5, //QQ空间
};

@interface JXShareTool : NSObject

/**
 @biref 友盟分享

 @param viewController 展示视图的控制器
 @param platformType 分享类型
 @param title 分享标题
 @param detail 分享内容
 @param url 分享URL
 @param imgurl 分享的图片URL
 */
+ (void)UMShareInViewController:(UIViewController *)viewController shareType:(UMShareType)platformType needTitle:(NSString *)title detail:(NSString *)detail url:(NSString *)url imgUrl:(NSString *)imgurl;

@end
