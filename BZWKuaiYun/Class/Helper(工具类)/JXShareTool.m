//
//  JXShareTool.m
//  BZWKuaiYun
//
//  Created by Jessey Young on 2017/6/30.
//  Copyright © 2017年 ISU. All rights reserved.
//

#import "JXShareTool.h"
#import <UMSocialCore/UMSocialCore.h>

@implementation JXShareTool

+ (void)UMShareInViewController:(UIViewController *)viewController shareType:(UMShareType)platformType needTitle:(NSString *)title detail:(NSString *)detail url:(NSString *)url imgUrl:(NSString *)imgurl
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //创建网页内容对象
    //NSString* thumbURL =  @"https://mobile.umeng.com/images/pic/home/social/img-1.png";
    UIImage * img = [UIImage imageNamed:@"icon"];
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:title descr:detail thumImage:img];
    //设置网页地址
    shareObject.webpageUrl = url;
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    int i = 0;
    switch (platformType)
    {
        case UMShareType_WechatSession:
        {
            i = 1;
        }
            break;
        case UMShareType_QQ:
        {
            i = 4;
        }
            break;
        case UMShareType_WechatTimeLine:
        {
            i = 2;
        }
            break;
        case UMShareType_Sina:
        {
            i = 0;
        }
            break;
        case UMShareType_QQZone:
        {
            i = 5;
        }
            break;
        default:
            break;
    }
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:i messageObject:messageObject currentViewController:viewController completion:^(id data, NSError *error)
     {
         if (error)
         {
             SVERROR(@"分享失败", 2)
         }
         else
         {
             if ([data isKindOfClass:[UMSocialShareResponse class]])
             {
                 UMSocialShareResponse *resp = data;
                 //分享结果消息
                 UMSocialLogInfo(@"response message is %@",resp.message);
                 //第三方原始返回的数据
                 UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                 SVSUCCESS(@"分享成功", 2)
             }
             else
             {
                 UMSocialLogInfo(@"response data is %@",data);
             }
         }
         //                [self alertWithError:error];
     }];
}

@end
