//
//  NotificationMacros.h
//  BZWKuaiYun
//
//  Created by Jessey Young on 2017/5/19.
//  Copyright © 2017年 ISU. All rights reserved.
//

#ifndef NotificationMacros_h
#define NotificationMacros_h

/**
 *  本类放一些通知的宏定义
 */


#define USERPHONE            [kUserDefaults objectForKey:@"telephone"]
#define USERPASSWORD         [kUserDefaults objectForKey:@"password"]
#define USERID               [kUserDefaults objectForKey:@"driverId"]
#define USERTOKEN            [kUserDefaults objectForKey:@"token"]
#define USERYUNID            [kUserDefaults objectForKey:@"yunId"]
#define USERVOICECONTROL     [kUserDefaults objectForKey:@"voiceControl"]
#define LOGINSTATUS          [kUserDefaults objectForKey:@"loginStatus"]
#define CITYCODE             [kUserDefaults objectForKey:@"cityCode"]


#endif /* NotificationMacros_h */
