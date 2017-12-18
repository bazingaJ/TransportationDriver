//
//  UserInfo.m
//  BZWKuaiYun
//
//  Created by Jessey Young on 2017/6/8.
//  Copyright © 2017年 ISU. All rights reserved.
//

#import "UserInfo.h"

static UserInfo *user = nil;

@interface UserInfo ()



@end

@implementation UserInfo

+ (instancetype)defaultUserInfo
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
       
        user = [[self alloc] init];
        
    });
    
    return user;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
       
        if (user == nil)
        {
            user = [super allocWithZone:zone];
        }
        
        
    });
    return user;
}

//自定义初始化方法，本例中只有name这一属性
- (instancetype)init
{
    self = [super init];
    if(self)
    {
//        self.name = @"Singleton";
    }
    
    return self;
}

//覆盖该方法主要确保当用户通过copy方法产生对象时对象的唯一性
- (instancetype)copy
{
    return self;
}

//覆盖该方法主要确保当用户通过mutableCopy方法产生对象时对象的唯一性
- (instancetype)mutableCopy
{
    return self;
}

//自定义描述信息，用于log详细打印
- (NSString *)description
{
    return [NSString stringWithFormat:@"memeory address:%p class name %@",self,NSStringFromClass([UserInfo class])];
}

@end
