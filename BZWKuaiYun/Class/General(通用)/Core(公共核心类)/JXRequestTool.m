//
//  JXRequestTool.m
//  BZWKuaiYun
//
//  Created by Jessey Young on 2017/6/8.
//  Copyright © 2017年 ISU. All rights reserved.
//

#import "JXRequestTool.h"

@interface JXRequestTool ()

@end

@implementation JXRequestTool

+ (void)requestWithMethod:(RequestMethodType)methodType
                      url:(NSString*)url
                   params:(NSDictionary*)params
                  success:(void (^)(id response))success
                  failure:(void (^)(NSError* err))failure
{
    NSURL* baseURL = [NSURL URLWithString:kMainUrl];
    AFHTTPSessionManager* mgr = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json",@"text/javascript", @"text/plain", nil];
    mgr.requestSerializer.timeoutInterval = 12.f;
    
    switch (methodType)
    {
        case RequestMethodTypeGet:
        {
            
            [mgr GET:url
          parameters:params
            progress:^(NSProgress * _Nonnull downloadProgress)
            {
                
            }
             success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
            {
                 if (success)
                 {
                     
                     success(responseObject);
                 }
             }
             failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
             {
                 if (failure)
                 {
                     failure(error);
                 }
             }];
            
            
        }
            break;
        case RequestMethodTypePost:
        {
            
            [mgr POST:url
           parameters:params
             progress:^(NSProgress * _Nonnull uploadProgress)
             {
                 
             }
              success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
            {
                  if (success)
                  {
                      success(responseObject);
                  }
              }
              failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
            {
                  if (failure)
                  {
                      failure(error);
                  }
              }];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - 4.2.1 图片上传接口
+ (void)postUploadImgNeedimgBelong:(NSString *)imgBelong
                             Image:(UIImage *)img
                          complete:(void(^)(BOOL isSuccess, NSDictionary *respose))block
{
    NSURL* baseURL = [NSURL URLWithString:kMainUrl];
    AFHTTPSessionManager* mgr = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json",@"text/javascript", @"text/plain", nil];
    mgr.requestSerializer.timeoutInterval = 8.f;
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            imgBelong,@"imgBelong",
                            nil];
    
    [mgr POST:@"common/uploadImg" parameters:params
                   constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
                       NSData *data = UIImageJPEGRepresentation(img, 0.5);
                       NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                       formatter.dateFormat = @"yyyyMMddHHmmss";
                       NSString *str = [formatter stringFromDate:[NSDate date]];
                       NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
                       [formData appendPartWithFileData:data name:@"file" fileName:fileName mimeType:@"image/jpg"];
                       
    }
                                    progress:^(NSProgress * _Nonnull uploadProgress) {
        
    }
                                     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                         if([responseObject[@"returnCode"]isEqualToString:@"00"])
                                         {
                                             JXLog(@"==图片上传接口返回成功%@",responseObject);
                                             block(YES,responseObject);
                                         }
                                         else
                                         {
                                             JXLog(@"==图片上传接口返回失败%@",responseObject);
                                             SVINFO(responseObject[@"message"], 2);
                                         }
    }
                                     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                            SVERROR(JXRequestToolDisconnectString, 2);
    }];
}
#pragma mark - 4.2.2 短信发送接口
+ (void)postGetMobileCodeNeedMobile:(NSString *)mobile type:(NSString *)type complete:(void(^)(BOOL isSuccess, NSDictionary *respose))block
{
    //防止黑客攻击 做好加签验签方法
    NSDate *date = [NSDate date];
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyyMMdd"];
    NSString *str = [NSString stringWithFormat:@"ISU%@%@",[format stringFromDate:date],mobile];
    NSString *MD5password = [JXAppTool MD5EncryptionWithString:str];
    NSString *last = [MD5password substringWithRange:NSMakeRange(9, 16)];
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            mobile,@"mobile",
                            type,@"type",
                            @"3",@"userType",
                            last,@"sign",
                            nil];
    [self requestWithMethod:RequestMethodTypePost
                        url:@"common/getMobileCodeNew"
                     params:params
                    success:^(id response) {
                        if([response[@"returnCode"]isEqualToString:@"00"])
                        {
                            JXLog(@"==短信发送接口返回成功%@",response);
                            block(YES,response);
                        }
                        else
                        {
                            JXLog(@"==短信发送接口返回失败%@",response);
                            SVINFO(response[@"message"], 2);
                        }
    }
                    failure:^(NSError *err) {
                        SVERROR(JXRequestToolDisconnectString, 2);
    }];
}

#pragma mark - 4.2.3 获取系统参数配置接口
+ (void)postQuerySysDictNeedType:(NSString *)type
                        complete:(void(^)(BOOL isSuccess, NSDictionary *respose))block
{
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            type,@"type",
                            nil];
    [self requestWithMethod:RequestMethodTypePost
                        url:@"common/querySysDict"
                     params:params
                    success:^(id response) {
                        if([response[@"returnCode"]isEqualToString:@"00"])
                        {
                            JXLog(@"==获取系统参数配置接口返回成功%@",response);
                            block(YES,response);
                        }
                        else
                        {
                            JXLog(@"==获取系统参数配置接口返回失败%@",response);
                            SVINFO(response[@"message"], 2);
                        }
    }
                    failure:^(NSError *err) {
                            SVERROR(JXRequestToolDisconnectString, 2);
    }];
}

#pragma mark - 4.2.4 城市查询接口
+ (void)postQueryCitycomplete:(void(^)(BOOL isSuccess, NSDictionary *respose))block
{
    [self requestWithMethod:RequestMethodTypePost
                        url:@"common/queryCity"
                     params:nil
                    success:^(id response) {
                        if([response[@"returnCode"]isEqualToString:@"00"])
                        {
                            JXLog(@"==城市查询接口返回成功%@",response);
                            block(YES,response);
                        }
                        else
                        {
                            JXLog(@"==城市查询接口返回失败%@",response);
                            SVINFO(response[@"message"], 2);
                        }
    }
                    failure:^(NSError *err) {
                        SVERROR(JXRequestToolDisconnectString, 2);
    }];
}

#pragma mark - 4.2.5 区县查询接口
+ (void)postQueryRegionNeedCityId:(NSString *)cityId
                         complete:(void(^)(BOOL isSuccess, NSDictionary *respose))block
{
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            cityId,@"cityId",
                            nil];
    [self requestWithMethod:RequestMethodTypePost
                        url:@"common/queryRegion"
                     params:params
                    success:^(id response) {
                        if([response[@"returnCode"]isEqualToString:@"00"])
                        {
                            JXLog(@"==区县查询接口返回成功%@",response);
                            block(YES,response);
                        }
                        else
                        {
                            JXLog(@"==区县查询接口返回失败%@",response);
                            SVINFO(response[@"message"], 2);
                        }
    }
                    failure:^(NSError *err) {
                            SVERROR(JXRequestToolDisconnectString, 2);
    }];
}

#pragma mark - 4.2.6 意见反馈接口
+ (void)postFeedBackNeedUserType:(NSString *)userType
                       telephone:(NSString *)telephone
                        contents:(NSString *)contents
                        complete:(void(^)(BOOL isSuccess, NSDictionary *respose))block
{
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            USERID,@"userId",
                            USERTOKEN,@"token",
                            userType,@"userType",
                            telephone,@"telephone",
                            contents,@"contents",
                            nil];
    [self requestWithMethod:RequestMethodTypePost
                        url:@"common/feedBack"
                     params:params
                    success:^(id response) {
                        if([response[@"returnCode"]isEqualToString:@"00"])
                        {
                            JXLog(@"==意见反馈接口返回成功%@",response);
                            block(YES,response);
                        }
                        else
                        {
                            JXLog(@"==意见反馈接口返回失败%@",response);
                            SVINFO(response[@"message"], 2);
                        }
    }
                    failure:^(NSError *err) {
                            SVERROR(JXRequestToolDisconnectString, 2);
    }];
    
}

#pragma mark - 4.2.7 忘记密码（重置密码）接口
+ (void)postResetPwdNeedPassword:(NSString *)password
                       checkCode:(NSString *)checkCode
                        complete:(void(^)(BOOL isSuccess, NSDictionary *respose))block
{
    NSString *MD5password = [JXAppTool MD5EncryptionWithString:password];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            USERPHONE,@"mobile",
                            MD5password,@"password",
                            checkCode,@"checkCode",
                            @"3",@"userType",
                            nil];
    [self requestWithMethod:RequestMethodTypePost
                        url:@"common/resetPwd"
                     params:params
                    success:^(id response) {
                        if([response[@"returnCode"]isEqualToString:@"00"])
                        {
                            JXLog(@"==忘记密码（重置密码）接口返回成功%@",response);
                            block(YES,response);
                        }
                        else
                        {
                            JXLog(@"==忘记密码（重置密码）接口返回失败%@",response);
                            SVINFO(response[@"message"], 2);
                        }
    }
                    failure:^(NSError *err) {
                            SVERROR(JXRequestToolDisconnectString, 2);
    }];
    
}

#pragma mark - 4.2.8 车辆类型查询接口
+ (void)postQueryAutoTypeNeedAutoType:(NSString *)autoType
                             complete:(void(^)(BOOL isSuccess, NSDictionary *respose))block
{
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            autoType,@"autoTypeName",
                            nil];
    [self requestWithMethod:RequestMethodTypePost
                        url:@"common/queryAutoType"
                     params:params
                    success:^(id response) {
                        if([response[@"returnCode"]isEqualToString:@"00"])
                        {
                            JXLog(@"==车辆类型查询接口返回成功%@",response);
                            block(YES,response);
                        }
                        else
                        {
                            JXLog(@"==车辆类型查询接口返回失败%@",response);
                            SVINFO(response[@"message"], 2);
                        }
    }
                    failure:^(NSError *err) {
                            SVERROR(JXRequestToolDisconnectString, 2);
    }];
}

#pragma mark - 4.2.9 收费标准查询接口
+ (void)postQueryChargeStandardNeedCityCode:(NSString *)cityCode
                                 autoType:(NSString *)autoType
                                 complete:(void(^)(BOOL isSuccess, NSDictionary *respose))block
{
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            USERID,@"driverId",
                            USERTOKEN,@"token",
                            cityCode,@"cityCode",
                            autoType,@"autoType",
                            nil];
    [self requestWithMethod:RequestMethodTypePost
                        url:@"common/queryChargeStandard"
                     params:params
                    success:^(id response) {
                        if([response[@"returnCode"]isEqualToString:@"00"])
                        {
                            JXLog(@"==收费标准查询接口返回成功%@",response);
                            block(YES,response);
                        }
                        else
                        {
                            JXLog(@"==收费标准查询接口返回失败%@",response);
                            SVINFO(response[@"message"], 2);
                        }
    }
                    failure:^(NSError *err) {
                            SVERROR(JXRequestToolDisconnectString, 2);
    }];
}

#pragma mark - 4.2.10 常见问题列表查询接口
+ (void)postQueryQuestionListComplete:(void(^)(BOOL isSuccess, NSDictionary *respose))block
{
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            USERID,@"driverId",
                            USERTOKEN,@"token",
                            nil];
    [self requestWithMethod:RequestMethodTypePost
                        url:@"common/queryQuestionList"
                     params:params
                    success:^(id response) {
                        if([response[@"returnCode"]isEqualToString:@"00"])
                        {
                            JXLog(@"==常见问题列表查询接口返回成功%@",response);
                            block(YES,response);
                        }
                        else
                        {
                            JXLog(@"==常见问题列表查询接口返回失败%@",response);
                            SVINFO(response[@"message"], 2);
                        }
                    }
                    failure:^(NSError *err) {
                        SVERROR(JXRequestToolDisconnectString, 2);
                    }];
}

#pragma mark - 4.2.11 问题详细信息查询接口
+ (void)postQueryQuestionDetailNeedQuestionId:(NSString *)questionId
                                     complete:(void(^)(BOOL isSuccess, NSDictionary *respose))block
{
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            USERID,@"driverId",
                            USERTOKEN,@"token",
                            questionId,@"questionId",
                            nil];
    [self requestWithMethod:RequestMethodTypePost
                        url:@"common/queryQuestionDetail"
                     params:params
                    success:^(id response) {
                        if([response[@"returnCode"]isEqualToString:@"00"])
                        {
                            JXLog(@"==问题详细信息查询接口返回成功%@",response);
                            block(YES,response);
                        }
                        else
                        {
                            JXLog(@"==问题详细信息查询接口返回失败%@",response);
                            SVINFO(response[@"message"], 2);
                        }
                    }
                    failure:^(NSError *err) {
                        SVERROR(JXRequestToolDisconnectString, 2);
                    }];
}

#pragma mark - 4.3.1 登录
+ (void)postLoginNeedMobile:(NSString *)mobile password:(NSString *)password complete:(void(^)(BOOL isSuccess, NSDictionary *respose))block
{
    NSString *MD5password = [JXAppTool MD5EncryptionWithString:password];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            mobile,@"mobile",
                            MD5password,@"password",
                            nil];
    [self requestWithMethod:RequestMethodTypePost
                        url:@"driver/login"
                     params:params
                    success:^(id response) {
                        if([response[@"returnCode"]isEqualToString:@"00"])
                        {
                            JXLog(@"==登录接口返回成功%@",response);
                            block(YES,response);
                        }
                        else
                        {
                            JXLog(@"==登录接口返回失败%@",response);
                            SVINFO(response[@"message"], 2);
                        }
    }
                    failure:^(NSError *err) {
                        SVERROR(JXRequestToolDisconnectString, 2);
    } ];
}

#pragma mark - 4.3.3 注册接口
+ (void)postRegisterNeedMobile:(NSString *)mobile
                      password:(NSString *)password
                     checkCode:(NSString *)checkCode
                      complete:(void(^)(BOOL isSuccess, NSDictionary *respose))block
{
    NSString *MD5password = [JXAppTool MD5EncryptionWithString:password];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            mobile,@"mobile",
                            MD5password,@"password",
                            checkCode,@"checkCode",
                            nil];
    [self requestWithMethod:RequestMethodTypePost
                        url:@"driver/register"
                     params:params
                    success:^(id response) {
                        if([response[@"returnCode"]isEqualToString:@"00"])
                        {
                            JXLog(@"==注册接口返回成功%@",response);
                            block(YES,response);
                        }
                        else
                        {
                            JXLog(@"==注册接口返回失败%@",response);
                            SVINFO(response[@"message"], 2);
                        }
    }
                    failure:^(NSError *err) {
                        SVERROR(JXRequestToolDisconnectString, 2);
    }];
}

#pragma mark - 4.3.4 完善司机信息接口
+ (void)postImproveDriverInfoNeedTrueName:(NSString *)trueName
                                   cardNo:(NSString *)cardNo
                                   cityId:(NSString *)cityId
                                 cityName:(NSString *)cityName
                                   areaId:(NSString *)areaId
                                 areaName:(NSString *)areaName
                                      lon:(NSString *)lon
                                      lat:(NSString *)lat
                              contactName:(NSString *)contactName
                               contactTel:(NSString *)contactTel
                                  autoNum:(NSString *)autoNum
                                 autoType:(NSString *)autoType
                                  special:(NSString *)special
                                  cardImg:(NSString *)cardImg
                            travelCardImg:(NSString *)travelCardImg
                         driverLicenseImg:(NSString *)driverLicenseImg
                                  autoImg:(NSString *)autoImg
                                 complete:(void(^)(BOOL isSuccess, NSDictionary *respose))block
{
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            USERID,@"driverId",
                            trueName,@"trueName",
                            cardNo,@"cardNo",
                            cityId,@"cityId",
                            cityName,@"cityName",
                            areaId,@"areaId",
                            areaName,@"areaName",
                            lon,@"lon",
                            lat,@"lat",
                            contactName,@"contactName",
                            contactTel,@"contactTel",
                            autoNum,@"autoNum",
                            autoType,@"autoType",
                            special,@"special",
                            cardImg,@"cardImg",
                            travelCardImg,@"travelCardImg",
                            driverLicenseImg,@"driverLicenseImg",
                            autoImg,@"autoImg",
                            nil];
    [self requestWithMethod:RequestMethodTypePost
                        url:@"driver/improveDriverInfo"
                     params:params
                    success:^(id response) {
                        if([response[@"returnCode"]isEqualToString:@"00"])
                        {
                            JXLog(@"==完善司机信息接口返回成功%@",response);
                            block(YES,response);
                        }
                        else
                        {
                            JXLog(@"==完善司机信息接口返回失败%@",response);
                            SVINFO(response[@"message"], 2);
                        }
    }
                    failure:^(NSError *err) {
                            SVERROR(JXRequestToolDisconnectString, 2);
    }];
}

#pragma mark - 4.3.5 试题信息查询接口
+ (void)postExamInfoNeedComplete:(void(^)(BOOL isSuccess, NSDictionary *respose))block
{
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            USERID,@"driverId",
                            nil];
    [self requestWithMethod:RequestMethodTypePost
                        url:@"driver/examInfo"
                     params:params
                    success:^(id response) {
                        if([response[@"returnCode"]isEqualToString:@"00"])
                        {
                            JXLog(@"==试题信息查询接接口返回成功%@",response);
                            block(YES,response);
                        }
                        else
                        {
                            JXLog(@"==试题信息查询接接口返回失败%@",response);
                            SVINFO(response[@"message"], 2);
                        }
                    }
                    failure:^(NSError *err) {
                        SVERROR(JXRequestToolDisconnectString, 2);
                    }];
}

#pragma mark - 4.3.6 考试提交接口
+ (void)postExamCommitNeedContents:(NSMutableString *)contents complete:(void(^)(BOOL isSuccess, NSDictionary *respose))block
{
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            USERID,@"driverId",
                            contents,@"contents",
                            nil];
    [self requestWithMethod:RequestMethodTypePost
                        url:@"driver/examCommit"
                     params:params
                    success:^(id response) {
                        if([response[@"returnCode"]isEqualToString:@"00"])
                        {
                            JXLog(@"==考试提交接口返回成功%@",response);
                            block(YES,response);
                        }
                        else
                        {
                            JXLog(@"==考试提交接口返回失败%@",response);
                            SVINFO(response[@"message"], 2);
                        }
    }
                    failure:^(NSError *err) {
                            SVERROR(JXRequestToolDisconnectString, 2);
    }];
}

#pragma mark - 4.3.16 个人信息查询接口
+ (void)postMyInfoNeedComplete:(void(^)(BOOL isSuccess, NSDictionary *respose))block
{
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            USERID,@"driverId",
                            USERTOKEN,@"token",
                            nil];
    [self requestWithMethod:RequestMethodTypePost
                        url:@"driver/myInfo"
                     params:params
                    success:^(id response) {
                        if([response[@"returnCode"]isEqualToString:@"00"])
                        {
                            JXLog(@"==个人信息查询接口返回成功%@",response);
                            block(YES,response);
                        }
                        else
                        {
                            JXLog(@"==个人信息查询接口返回失败%@",response);
                            SVINFO(response[@"message"], 2);
                        }
    }
                    failure:^(NSError *err) {
                            SVERROR(JXRequestToolDisconnectString, 2);
    }];
}

#pragma mark - 4.3.17 个人信息修改接口
+ (void)postUpdateMyInfoNeedPhoto:(NSString *)photo
                           mobile:(NSString *)mobile
                        checkCode:(NSString *)checkCode
                         trueName:(NSString *)trueName
                       uploadType:(UploadType)uploadType
                         complete:(void(^)(BOOL isSuccess, NSDictionary *respose))block
{
    NSDictionary *params = nil;
    switch (uploadType)
    {
        case UploadTypePhoto:
        {
            params = [NSDictionary dictionaryWithObjectsAndKeys:
                                    USERID,@"driverId",
                                    USERTOKEN,@"token",
                                    photo,@"photo",
                                    nil];
        }
            break;
        case UploadTypeName:
        {
            params = [NSDictionary dictionaryWithObjectsAndKeys:
                                    USERID,@"driverId",
                                    USERTOKEN,@"token",
                                    trueName,@"trueName",
                                    nil];
        }
            break;
        case UploadTypeTelephone:
        {
            params = [NSDictionary dictionaryWithObjectsAndKeys:
                                    USERID,@"driverId",
                                    USERTOKEN,@"token",
                                    mobile,@"mobile",
                                    checkCode,@"checkCode",
                                    nil];
        }
            break;
            
        default:
            break;
    }
    [self requestWithMethod:RequestMethodTypePost
                        url:@"driver/updateMyInfo"
                     params:params
                    success:^(id response) {
                        if([response[@"returnCode"]isEqualToString:@"00"])
                        {
                            JXLog(@"==个人信息修改接口返回成功%@",response);
                            block(YES,response);
                        }
                        else
                        {
                            JXLog(@"==个人信息修改接口返回失败%@",response);
                            SVINFO(response[@"message"], 2);
                        }
    }
                    failure:^(NSError *err) {
                            SVERROR(JXRequestToolDisconnectString, 2);
    }];
}

#pragma mark - 4.3.18 我的钱包查询接口
+ (void)postmyEwalletInfoComplete:(void(^)(BOOL isSuccess, NSDictionary *respose))block
{
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            USERID,@"driverId",
                            USERTOKEN,@"token",
                            nil];
    [self requestWithMethod:RequestMethodTypePost
                        url:@"driverInfo/myEwalletInfo"
                     params:params
                    success:^(id response) {
                        if([response[@"returnCode"]isEqualToString:@"00"])
                        {
                            JXLog(@"==我的钱包查询接口返回成功%@",response);
                            block(YES,response);
                        }
                        else
                        {
                            JXLog(@"==我的钱包查询接口返回失败%@",response);
                            SVINFO(response[@"message"], 2);
                        }
    }
                    failure:^(NSError *err) {
                            SVERROR(JXRequestToolDisconnectString, 2);
    }];
}

#pragma mark - 4.3.19 我的积分查询接口
+ (void)postMyPointNeedPageSize:(NSString *)pageSize
                        pageNum:(NSString *)pageNum
                       complete:(void(^)(BOOL isSuccess, NSDictionary *respose))block
{
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            USERID,@"driverId",
                            USERTOKEN,@"token",
                            pageSize,@"pageSize",
                            pageNum,@"pageNum",
                            nil];
    [self requestWithMethod:RequestMethodTypePost
                        url:@"driverInfo/myPoint"
                     params:params
                    success:^(id response) {
                        if([response[@"returnCode"]isEqualToString:@"00"])
                        {
                            JXLog(@"==我的积分查询接口返回成功%@",response);
                            block(YES,response);
                        }
                        else
                        {
                            JXLog(@"==我的积分查询接口返回失败%@",response);
                            SVINFO(response[@"message"], 2);
                        }
    }
                    failure:^(NSError *err) {
                            SVERROR(JXRequestToolDisconnectString, 2);
    }];
}

#pragma mark - 4.3.20 我的余额查询接口
+ (void)postMyBalanceComplete:(void(^)(BOOL isSuccess, NSDictionary *respose))block
{
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            USERID,@"driverId",
                            USERTOKEN,@"token",
                            nil];
    [self requestWithMethod:RequestMethodTypePost
                        url:@"driverInfo/myBalance"
                     params:params
                    success:^(id response) {
                        if([response[@"returnCode"]isEqualToString:@"00"])
                        {
                            JXLog(@"==我的余额查询接口返回成功%@",response);
                            block(YES,response);
                        }
                        else
                        {
                            JXLog(@"==我的余额查询接口返回失败%@",response);
                            SVINFO(response[@"message"], 2);
                        }
    }
                    failure:^(NSError *err) {
                            SVERROR(JXRequestToolDisconnectString, 2);
    }];
}

#pragma mark - 4.3.21 余额明细查询接口
+ (void)postMyBalanceInfoNeedPageSize:(NSString *)pageSize
                              pageNum:(NSString *)pageNum
                             complete:(void(^)(BOOL isSuccess, NSDictionary *respose))block
{
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            USERID,@"driverId",
                            USERTOKEN,@"token",
                            pageSize,@"pageSize",
                            pageNum,@"pageNum",
                            nil];
    [self requestWithMethod:RequestMethodTypePost
                        url:@"driverInfo/myBalanceInfo"
                     params:params
                    success:^(id response) {
                        if([response[@"returnCode"]isEqualToString:@"00"])
                        {
                            JXLog(@"==余额明细查询接口返回成功%@",response);
                            block(YES,response);
                        }
                        else
                        {
                            JXLog(@"==余额明细查询接口返回失败%@",response);
                            SVINFO(response[@"message"], 2);
                        }
                    }
                    failure:^(NSError *err) {
                        SVERROR(JXRequestToolDisconnectString, 2);
    }];
}

#pragma mark - 4.3.22 我的技能查询接口
+ (void)postMySkillInfoComplete:(void(^)(BOOL isSuccess, NSDictionary *respose))block
{
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            USERID,@"driverId",
                            USERTOKEN,@"token",
                            nil];
    [self requestWithMethod:RequestMethodTypePost
                        url:@"driverInfo/mySkillInfo"
                     params:params
                    success:^(id response) {
                        if([response[@"returnCode"]isEqualToString:@"00"])
                        {
                            JXLog(@"==我的技能查询接口返回成功%@",response);
                            block(YES,response);
                        }
                        else
                        {
                            JXLog(@"==我的技能查询接口返回失败%@",response);
                            SVINFO(response[@"message"], 2);
                        }
                    }
                    failure:^(NSError *err) {
                        SVERROR(JXRequestToolDisconnectString, 2);
                    }];
}

#pragma mark - 4.3.23 技能完善接口
+ (void)postMySkillImproveNeedSkillSet:(NSString *)skillSet
                              complete:(void(^)(BOOL isSuccess, NSDictionary *respose))block
{
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            USERID,@"driverId",
                            USERTOKEN,@"token",
                            skillSet,@"skillSet",
                            nil];
    [self requestWithMethod:RequestMethodTypePost
                        url:@"driverInfo/mySkillImprove"
                     params:params
                    success:^(id response) {
                        if([response[@"returnCode"]isEqualToString:@"00"])
                        {
                            JXLog(@"==技能完善接口返回成功%@",response);
                            block(YES,response);
                        }
                        else
                        {
                            JXLog(@"==技能完善接口返回失败%@",response);
                            SVINFO(response[@"message"], 2);
                        }
                    }
                    failure:^(NSError *err) {
                        SVERROR(JXRequestToolDisconnectString, 2);
                    }];
}

#pragma mark - 4.3.24 我的消息查询接口
+ (void)postDriverInfoNeedPageSize:(NSString *)pageSize
                           pageNum:(NSString *)pageNum
                          complete:(void(^)(BOOL isSuccess, NSDictionary *respose))block
{
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            USERID,@"driverId",
                            USERTOKEN,@"token",
                            pageSize,@"pageSize",
                            pageNum,@"pageNum",
                            nil];
    [self requestWithMethod:RequestMethodTypePost
                        url:@"driverInfo/messageInfo"
                     params:params
                    success:^(id response) {
                        if([response[@"returnCode"]isEqualToString:@"00"])
                        {
                            JXLog(@"==我的消息查询接口返回成功%@",response);
                            block(YES,response);
                        }
                        else
                        {
                            JXLog(@"==我的消息查询接口返回失败%@",response);
                            SVINFO(response[@"message"], 2);
                        }
                    }
                    failure:^(NSError *err) {
                        SVERROR(JXRequestToolDisconnectString, 2);
                    }];
}

#pragma mark - 4.3.25 优惠活动查询接口
+ (void)postEventInfoNeedPageSize:(NSString *)pageSize
                          pageNum:(NSString *)pageNum
                         complete:(void(^)(BOOL isSuccess, NSDictionary *respose))block
{
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            USERID,@"driverId",
                            USERTOKEN,@"token",
                            pageSize,@"pageSize",
                            pageNum,@"pageNum",
                            nil];
    [self requestWithMethod:RequestMethodTypePost
                        url:@"driverInfo/eventInfo"
                     params:params
                    success:^(id response) {
                        if([response[@"returnCode"]isEqualToString:@"00"])
                        {
                            JXLog(@"==优惠活动查询接口返回成功%@",response);
                            block(YES,response);
                        }
                        else
                        {
                            JXLog(@"==优惠活动查询接口返回失败%@",response);
                            block(NO,response);
                            SVINFO(response[@"message"], 2);
                        }
                    }
                    failure:^(NSError *err) {
                        SVERROR(JXRequestToolDisconnectString, 2);
                    }];
}

#pragma mark - 4.3.26 我的统计 - 评价查询接口
+ (void)postMyCommentNeedPageSize:(NSString *)pageSize
                          pageNum:(NSString *)pageNum
                         complete:(void(^)(BOOL isSuccess, NSDictionary *respose))block
{
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            USERID,@"driverId",
                            USERTOKEN,@"token",
                            pageSize,@"pageSize",
                            pageNum,@"pageNum",
                            nil];
    [self requestWithMethod:RequestMethodTypePost
                        url:@"driverInfo/myComment"
                     params:params
                    success:^(id response) {
                        if([response[@"returnCode"]isEqualToString:@"00"])
                        {
                            JXLog(@"==我的统计 - 评价查询接口返回成功%@",response);
                            block(YES,response);
                        }
                        else
                        {
                            JXLog(@"==我的统计 - 评价查询接口返回失败%@",response);
                            SVINFO(response[@"message"], 2);
                        }
                    }
                    failure:^(NSError *err) {
                        SVERROR(JXRequestToolDisconnectString, 2);
                    }];
}

#pragma mark - 4.3.27 我的统计 - 收支查询接口
+ (void)postMyInOutComeNeedPageSize:(NSString *)pageSize
                            pageNum:(NSString *)pageNum
                          queryDate:(NSString *)queryDate
                               type:(NSString *)type
                           complete:(void(^)(BOOL isSuccess, NSDictionary *respose))block
{
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            USERID,@"driverId",
                            USERTOKEN,@"token",
                            pageSize,@"pageSize",
                            pageNum,@"pageNum",
                            queryDate,@"queryDate",
                            type,@"type",
                            nil];
    [self requestWithMethod:RequestMethodTypePost
                        url:@"driverInfo/myInOutCome"
                     params:params
                    success:^(id response) {
                        if([response[@"returnCode"]isEqualToString:@"00"])
                        {
                            JXLog(@"==我的统计 - 收支查询接口返回成功%@",response);
                            block(YES,response);
                        }
                        else
                        {
                            JXLog(@"==我的统计 - 收支查询接口返回失败%@",response);
                            SVINFO(response[@"message"], 2);
                        }
                    }
                    failure:^(NSError *err) {
                        SVERROR(JXRequestToolDisconnectString, 2);
                    }];
}

#pragma mark - 4.3.28 退出登录接口
+ (void)postLogoutcomplete:(void(^)(BOOL isSuccess, NSDictionary *respose))block
{
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            USERID,@"driverId",
                            nil];
    [self requestWithMethod:RequestMethodTypePost
                        url:@"driver/logout"
                     params:params
                    success:^(id response) {
                        if([response[@"returnCode"]isEqualToString:@"00"])
                        {
                            JXLog(@"==退出登录接口返回成功%@",response);
                            block(YES,response);
                        }
                        else
                        {
                            JXLog(@"==退出登录接口返回失败%@",response);
                            SVINFO(response[@"message"], 2);
                        }
                    }
                    failure:^(NSError *err) {
                        SVERROR(JXRequestToolDisconnectString, 2);
                    }];
}

#pragma mark - 4.3.29 保证金退还接口
+ (void)postRefundNeedPayAccount:(NSString *)account payType:(NSString *)type Complete:(void(^)(BOOL isSuccess, NSDictionary *respose))block
{
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            USERID,@"driverId",
                            USERTOKEN,@"token",
                            account,@"payAcc",
                            type,@"payType",
                            nil];
    [self requestWithMethod:RequestMethodTypePost
                        url:@"driverInfo/refund"
                     params:params
                    success:^(id response) {
                        if([response[@"returnCode"]isEqualToString:@"00"])
                        {
                            JXLog(@"==保证金退还接口返回成功%@",response);
                            block(YES,response);
                        }
                        else
                        {
                            JXLog(@"==保证金退还接口返回失败%@",response);
                            SVINFO(response[@"message"], 2);
                        }
    }
                    failure:^(NSError *err) {
                            SVERROR(JXRequestToolDisconnectString, 2);
    }];
}

#pragma mark - 4.3.30 司机提现接口
+ (void)postWithdrawNeedPayType:(NSString *)payType
                         payAcc:(NSString *)payAcc
                         amount:(NSString *)amount
                      checkCode:(NSString *)checkCode
                       Complete:(void(^)(BOOL isSuccess, NSDictionary *respose))block
{
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            USERTOKEN,@"token",
                            USERID,@"driverId",
                            USERPHONE,@"mobile",
                            payType,@"payType",
                            payAcc,@"payAcc",
                            amount,@"amount",
                            checkCode,@"checkCode",
                            nil];
    [self requestWithMethod:RequestMethodTypePost
                        url:@"driverInfo/withdraw"
                     params:params
                    success:^(id response) {
                        if([response[@"returnCode"]isEqualToString:@"00"])
                        {
                            JXLog(@"==司机提现接口返回成功%@",response);
                            block(YES,response);
                        }
                        else
                        {
                            JXLog(@"==司机提现接口返回失败%@",response);
                            SVINFO(response[@"message"], 2);
                        }
    }
                    failure:^(NSError *err) {
                            SVERROR(JXRequestToolDisconnectString, 2);
    }];
}

#pragma mark - 4.3.32 车辆认证查询接口
+ (void)postcarCheckOutComplete:(void(^)(BOOL isSuccess, NSDictionary *respose))block
{
    NSDictionary *params = @{@"driverId":USERID,
                             @"token":USERTOKEN,
                             @"carCheckStatus":@"1"};
    [self requestWithMethod:RequestMethodTypePost
                        url:@"driverInfo/carCheckOut"
                     params:params
                    success:^(id response) {
                        if([response[@"returnCode"]isEqualToString:@"00"])
                        {
                            JXLog(@"==车辆认证查询接口返回成功%@",response);
                            block(YES,response);
                        }
                        else
                        {
                            JXLog(@"==车辆认证查询接口返回失败%@",response);
                            SVINFO(response[@"message"], 2);
                        }
    }
                    failure:^(NSError *err) {
                            SVERROR(JXRequestToolDisconnectString, 2);
    }];
}

#pragma mark - 4.3.33 查询当前城市是否开通服务功能接口

+ (void)postCheckOpenCityNeedCityId:(NSString *)cityId Complete:(void(^)(BOOL isSuccess, NSDictionary *respose))block
{
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            cityId,@"cityCode",
                            nil];
    [self requestWithMethod:RequestMethodTypePost
                        url:@"common/checkOpenCity"
                     params:params
                    success:^(id response) {
                        if([response[@"returnCode"]isEqualToString:@"00"])
                        {
                            JXLog(@"==当前城市是否开通服务接口返回成功%@",response);
                            block(YES,response);
                        }
                        else
                        {
                            JXLog(@"==当前城市是否开通服务接口返回失败%@",response);
                            SVINFO(response[@"message"], 4);
                        }
                    }
                    failure:^(NSError *err) {
                        SVERROR(JXRequestToolDisconnectString, 2);
                    }];
}

#pragma mark - 4.3.34 车辆信息修改接口
+ (void)postUpdateAutoInfoNeedAutoNum:(NSString *)autoNum
                             autoType:(NSString *)autoType
                              special:(NSString *)special
                             complete:(void(^)(BOOL isSuccess, NSDictionary *respose))block
{
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            USERID,@"driverId",
                            USERTOKEN,@"token",
                            autoNum,@"autoNum",
                            autoType,@"autoType",
                            special,@"special",
                            nil];
    [self requestWithMethod:RequestMethodTypePost
                        url:@"driver/updateAutoInfo"
                     params:params
                    success:^(id response) {
                        if([response[@"returnCode"]isEqualToString:@"00"])
                        {
                            block(YES,response);
                        }
                        else
                        {
                            SVINFO(response[@"message"], 4);
                        }
                    }
                    failure:^(NSError *err) {
                        SVERROR(JXRequestToolDisconnectString, 2);
                    }];
}




@end
