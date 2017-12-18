//
//  JXRequestTool.h
//  BZWKuaiYun
//
//  Created by Jessey Young on 2017/6/8.
//  Copyright © 2017年 ISU. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, RequestMethodType)
{
    RequestMethodTypePost = 1,
    RequestMethodTypeGet = 2
};

typedef NS_ENUM(NSInteger, UploadType)
{
    UploadTypePhoto = 1,
    UploadTypeName = 2,
    UploadTypeTelephone = 3
};

@interface JXRequestTool : NSObject

/**
 @brief 公共的发送的请求的方法

 @param methodType 请求类型 GET还是POST
 @param url 请求的url（已经拼接上baseUrl）
 @param params 请求的参数
 @param success 成功的block
 @param failure 失败的block
 */
+ (void)requestWithMethod:(RequestMethodType)methodType
                      url:(NSString*)url
                   params:(NSDictionary*)params
                  success:(void (^)(id response))success
                  failure:(void (^)(NSError* err))failure;

#pragma mark - 4.2.1 图片上传接口
/**
 @brief  图片上传接口

 @param imgBelong 图片所属类型
 @param img 图片
 @param block 回调的block
 */
+ (void)postUploadImgNeedimgBelong:(NSString *)imgBelong
                             Image:(UIImage *)img
                          complete:(void(^)(BOOL isSuccess, NSDictionary *respose))block;

#pragma mark - 4.2.2 短信发送接口
/**
 @brief 短信发送接口

 @param mobile 手机号
 @param type 发送类型 1-注册发送验证码；
                     2-忘记密码发送验证码；
                     3-登录发送验证码
                     4-修改手机号时发送验证码
                     5-提现时发送
 @param block 回调的block
 */
+ (void)postGetMobileCodeNeedMobile:(NSString *)mobile
                               type:(NSString *)type
                           complete:(void(^)(BOOL isSuccess, NSDictionary *respose))block;

#pragma mark - 4.2.3 获取系统参数配置接口
/**
 @brief 获取系统参数配置接口

 @param type 请求类型参数
         LBS表Id：tableid
         特殊规格：specialType
         服务协议：agreementUrl
         阅读资料: dataUrl
         保证金福利：bondWelfare
         保证金注意事项: bondNote
         司机技能(升级服务):skillType
         基本服务：baseServer
         司机守则: rulesUrl
         关于我们:aboutmeUrl
         费用说明：feeExplain
         用户服务协议：userAgreementUrl
         小费：tipType
         取消原因:reasonType
         我的司机说明：myDriverUrl
         客服电话:serverTel
         快递公司:expressName
         快递服务申明：expressUrl
         用户协议:userUrl
         免责申明：disclaimerUrl
         关于我们(用户端):aboutUserUrl
         支付类型:payType

 @param block 回调的block
 */
+ (void)postQuerySysDictNeedType:(NSString *)type
                        complete:(void(^)(BOOL isSuccess, NSDictionary *respose))block;

#pragma mark - 4.2.4 城市查询接口
/**
 @breif 城市查询接口

 @param block 回调的block
 */
+ (void)postQueryCitycomplete:(void(^)(BOOL isSuccess, NSDictionary *respose))block;

#pragma mark - 4.2.5 区县查询接口
/**
 @brief 区县查询接口

 @param cityId 城市ID（请求城市查询接口返回）
 @param block 回调的BLOCK
 */
+ (void)postQueryRegionNeedCityId:(NSString *)cityId
                         complete:(void(^)(BOOL isSuccess, NSDictionary *respose))block;

#pragma mark - 4.2.6 意见反馈接口
/**
 @brief 意见反馈接口

 @param userType 用户类型 2-快运用户端，3-快运司机用户
 @param telephone 联系方式
 @param contents 反馈内容
 @param block 回调的block
 */
+ (void)postFeedBackNeedUserType:(NSString *)userType
                       telephone:(NSString *)telephone
                        contents:(NSString *)contents
                        complete:(void(^)(BOOL isSuccess, NSDictionary *respose))block;

#pragma mark - 4.2.7 忘记密码（重置密码）接口
/**
 @brief 忘记密码（重置密码）接口

 @param password 重置的密码
 @param checkCode 验证码
 @param block 回调的block
 */
+ (void)postResetPwdNeedPassword:(NSString *)password
                       checkCode:(NSString *)checkCode
                      complete:(void(^)(BOOL isSuccess, NSDictionary *respose))block;

#pragma mark - 4.2.8 车辆类型查询接口
/**
 @brief 车辆类型查询接口

 @param autoType 请求车辆类型 为空时请求所有列表 不为空是请求某一总车型列表
 @param block 回调的block
 */
+ (void)postQueryAutoTypeNeedAutoType:(NSString *)autoType
                             complete:(void(^)(BOOL isSuccess, NSDictionary *respose))block;

#pragma mark - 4.2.9 收费标准查询接口
/**
 @brief 收费标准查询接口

 @param cityCode 城市ID
 @param autoType 汽车类型
 @param block 回调的block
 */
+ (void)postQueryChargeStandardNeedCityCode:(NSString *)cityCode
                                   autoType:(NSString *)autoType
                                   complete:(void(^)(BOOL isSuccess, NSDictionary *respose))block;


#pragma mark - 4.2.10 常见问题列表查询接口
/**
 @brief 常见问题列表查询接口

 @param block 回调的block
 */
+ (void)postQueryQuestionListComplete:(void(^)(BOOL isSuccess, NSDictionary *respose))block;

#pragma mark - 4.2.11 问题详细信息查询接口
/**
 @brief 问题详细信息查询接口

 @param questionId 问题ID
 @param block 回调的block
 */
+ (void)postQueryQuestionDetailNeedQuestionId:(NSString *)questionId
                                     complete:(void(^)(BOOL isSuccess, NSDictionary *respose))block;

#pragma mark - 4.3.1 登录接口
/**
 @brief 登录

 @param mobile 手机号
 @param password 密码
 @param block 回调的block
 */
+ (void)postLoginNeedMobile:(NSString *)mobile
                   password:(NSString *)password
                   complete:(void(^)(BOOL isSuccess, NSDictionary *respose))block;


#pragma mark - 4.3.3 注册接口
/**
 @brief 注册接口

 @param mobile 手机号
 @param password 密码
 @param checkCode 验证码
 @param block 回调的block
 */
+ (void)postRegisterNeedMobile:(NSString *)mobile
                      password:(NSString *)password
                     checkCode:(NSString *)checkCode
                      complete:(void(^)(BOOL isSuccess, NSDictionary *respose))block;

#pragma mark - 4.3.4 完善司机信息接口
/**
 @brief 完善司机信息接口

 @param trueName 真实姓名
 @param cardNo 身份证号码
 @param cityId 所属城市ID
 @param cityName 所属城市中文描述
 @param areaId 所属区县ID
 @param areaName 所属区县中文描述
 @param lon 当前经度
 @param lat 当前纬度
 @param contactName 紧急联系人姓名
 @param contactTel 紧急联系人电话
 @param autoNum 车牌号码
 @param autoType 车辆类型
 @param special 特殊规格
 @param cardImg 身份证照片
 @param travelCardImg 行驶证照片
 @param driverLicenseImg 驾驶证照片
 @param autoImg 车辆45°照片
 @param block 回调的block
 */
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
                                 complete:(void(^)(BOOL isSuccess, NSDictionary *respose))block;

#pragma mark - 4.3.5 试题信息查询接口
/**
 @brief 试题信息查询接口

 @param block 回调的block
 */
+ (void)postExamInfoNeedComplete:(void(^)(BOOL isSuccess, NSDictionary *respose))block;

#pragma mark - 4.3.6 考试提交接口 20题目，每题5分 60分及格
/**
 @brief 考试提交接口

 @param contents 试题答案字符串
 @param block 回调的block
 */
+ (void)postExamCommitNeedContents:(NSMutableString *)contents complete:(void(^)(BOOL isSuccess, NSDictionary *respose))block;

#pragma mark - 4.3.16 个人信息查询接口
/**
 @brief 个人信息查询接口

 @param block 回调的block
 */
+ (void)postMyInfoNeedComplete:(void(^)(BOOL isSuccess, NSDictionary *respose))block;

#pragma mark - 4.3.17 个人信息修改接口
/**
 @brief 个人信息修改接口

 @param photo 头像URL
 @param mobile 手机号
 @param checkCode 验证码
 @param trueName 真实姓名
 @param uploadType 上传类型 (详情参见：本来最上面的枚举类型)
 @param block 回调的block
 */
+ (void)postUpdateMyInfoNeedPhoto:(NSString *)photo
                           mobile:(NSString *)mobile
                        checkCode:(NSString *)checkCode
                         trueName:(NSString *)trueName
                       uploadType:(UploadType)uploadType
                         complete:(void(^)(BOOL isSuccess, NSDictionary *respose))block;

#pragma mark - 4.3.18 我的钱包查询接口
/**
 @breif 我的钱包查询接口

 @param block 回调的block
 */
+ (void)postmyEwalletInfoComplete:(void(^)(BOOL isSuccess, NSDictionary *respose))block;

#pragma mark - 4.3.19 我的积分查询接口
/**
 @brief 我的积分查询接口

 @param pageSize 每页条数
 @param pageNum 当前页数
 @param block 回调的block
 */
+ (void)postMyPointNeedPageSize:(NSString *)pageSize
                        pageNum:(NSString *)pageNum
                       complete:(void(^)(BOOL isSuccess, NSDictionary *respose))block;

#pragma mark - 4.3.20 我的余额查询接口
/**
 @brief 我的余额查询接口

 @param block 回调的block
 */
+ (void)postMyBalanceComplete:(void(^)(BOOL isSuccess, NSDictionary *respose))block;

#pragma mark - 4.3.21 余额明细查询接口

/**
 @brief 余额明细查询接口

 @param pageSize 每页条数
 @param pageNum 当前页数
 @param block 回调的block
 */
+ (void)postMyBalanceInfoNeedPageSize:(NSString *)pageSize
                              pageNum:(NSString *)pageNum
                             complete:(void(^)(BOOL isSuccess, NSDictionary *respose))block;

#pragma mark - 4.3.22 我的技能查询接口
/**
 @brief 我的技能查询接口
 
 @param block 回调的block
 */
+ (void)postMySkillInfoComplete:(void(^)(BOOL isSuccess, NSDictionary *respose))block;

#pragma mark - 4.3.23 技能完善接口
/**
 @brief 技能完善接口

 @param skillSet 技能中文描述 多个用逗号隔开
 @param block 回调的block
 */
+ (void)postMySkillImproveNeedSkillSet:(NSString *)skillSet
                              complete:(void(^)(BOOL isSuccess, NSDictionary *respose))block;

#pragma mark - 4.3.24 我的消息查询接口
/**
 @brief 我的消息查询接口

 @param pageSize 每页条数
 @param pageNum 当前页数
 @param block 回调的block
 */
+ (void)postDriverInfoNeedPageSize:(NSString *)pageSize
                           pageNum:(NSString *)pageNum
                          complete:(void(^)(BOOL isSuccess, NSDictionary *respose))block;

#pragma mark - 4.3.25 优惠活动查询接口
/**
 优惠活动查询接口

 @param pageSize 每页条数
 @param pageNum 当前页数
 @param block 回调的block
 */
+ (void)postEventInfoNeedPageSize:(NSString *)pageSize
                          pageNum:(NSString *)pageNum
                         complete:(void(^)(BOOL isSuccess, NSDictionary *respose))block;

#pragma mark - 4.3.26 我的统计 - 评价查询接口
/**
 @brief 我的统计 - 评价查询接口

 @param pageSize 每页条数
 @param pageNum 当前页数
 @param block 回调的block
 */
+ (void)postMyCommentNeedPageSize:(NSString *)pageSize
                          pageNum:(NSString *)pageNum
                         complete:(void(^)(BOOL isSuccess, NSDictionary *respose))block;

#pragma mark - 4.3.27 我的统计 - 收支查询接口
/**
 @brief 我的统计 - 收支查询接口

 @param pageSize 每页条数
 @param pageNum 当前页数
 @param queryDate 查询日期
 @param type 查询类型 1-收入 2-支出
 @param block 回调的block
 */
+ (void)postMyInOutComeNeedPageSize:(NSString *)pageSize
                            pageNum:(NSString *)pageNum
                          queryDate:(NSString *)queryDate
                               type:(NSString *)type
                           complete:(void(^)(BOOL isSuccess, NSDictionary *respose))block;

#pragma mark - 4.3.28 退出登录接口
/**
 @brief 退出登录接口

 @param block 回调的block
 */
+ (void)postLogoutcomplete:(void(^)(BOOL isSuccess, NSDictionary *respose))block;

#pragma mark - 4.3.29 保证金退还接口
/**
 @brief 保证金退还接口

 @param account 提现账号
 @param block 回调的block
 */
+ (void)postRefundNeedPayAccount:(NSString *)account payType:(NSString *)type Complete:(void(^)(BOOL isSuccess, NSDictionary *respose))block;

#pragma mark - 4.3.30 司机提现接口
/**
 @brief 司机提现接口

 @param payType 提现方式
 @param payAcc 提现账号
 @param amount 提现金额
 @param checkCode 验证码
 @param block 回调的block
 */
+ (void)postWithdrawNeedPayType:(NSString *)payType
                         payAcc:(NSString *)payAcc
                         amount:(NSString *)amount
                      checkCode:(NSString *)checkCode
                       Complete:(void(^)(BOOL isSuccess, NSDictionary *respose))block;

#pragma mark - 4.3.32 车辆认证查询接口
/**
 @brief 车辆认证查询接口

 @param block 回调的block
 */
+ (void)postcarCheckOutComplete:(void(^)(BOOL isSuccess, NSDictionary *respose))block;

#pragma mark - 4.3.33 查询当前城市是否开通服务功能接口
/**
 @brief 查询当前城市是否开通服务功能接口

 @param cityId 城市id
 @param block 回调的block
 */
+ (void)postCheckOpenCityNeedCityId:(NSString *)cityId Complete:(void(^)(BOOL isSuccess, NSDictionary *respose))block;

#pragma mark - 4.3.34 车辆信息修改接口
/**
 @brief 车辆信息修改接口

 @param autoNum 车牌号
 @param autoType 车型
 @param special 特殊规格
 @param block 回调
 */
+ (void)postUpdateAutoInfoNeedAutoNum:(NSString *)autoNum
                             autoType:(NSString *)autoType
                              special:(NSString *)special
                             complete:(void(^)(BOOL isSuccess, NSDictionary *respose))block;







@end
