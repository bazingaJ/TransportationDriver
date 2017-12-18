//
//  JXTool.h
//  BZWKuaiYun
//
//  Created by Jessey Young on 2017/6/8.
//  Copyright © 2017年 ISU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface JXTool : NSObject

+ (CGSize)boundingRectWithSize:(CGSize)size  font:(CGFloat)font text:(NSString *)text;
+ (UIColor *)colorWithHex:(NSString *)hexColor;
+ (UIImage *)imageCompressForWidth:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth;
+ (BOOL)judgePushSwitch;

+ (NSString *)getCurrentDevice;

+ (NSString*)base64forData:(NSData*)theData;

/**
 *  各种字符串判断
 *
 *  @param str f
 *
 *  @return a
 */
+ (Boolean)isNumberCharaterString:(NSString *)str;
+ (BOOL)verifyIsNullString:(NSString *)str;
+ (Boolean)isCharaterString:(NSString *)str;
+ (Boolean)isNumberString:(NSString *)str;
+ (Boolean)hasillegalString:(NSString *)str;
+ (Boolean)isValidSmsString:(NSString *)str;
+ (BOOL)verifyEmail:(NSString*)email;
//+ (BOOL)verifyPhone:(NSString*)phone;
+ (BOOL)verifyMobilePhone:(NSString*)phone;
+ (NSString *)getTimeString:(NSInteger)duration; //通过时长获取时分秒的字符串
+ (NSString *)cleanPhone:(NSString *)beforeClean;

/**
 @brief 输入的车牌号验证

 @param string 车牌号
 @return 返回的车牌号
 */
+ (BOOL)verifyPlateNum:(NSString *)string;

/**
 @brief 输入的字符是否身份证

 @param IDCardNumber 身份证号
 @return 返回bool类型结果
 */
+ (BOOL)verifyIdentityCard:(NSString *)IDCardNumber;
/**
 @brief 验证密码的输入是否符合标准

 @param before 字符串最小长度限制
 @param end 字符串最大长度限制
 @param str 字符串本身
 @return 返回的警示语
 */
+ (NSString *)verifyIslegelFromIndex:(NSUInteger)before ToIndex:(NSUInteger)end string:(NSString *)str;

/**
 *  把color变成image
 *
 *  @param color 传来的color
 *
 *  @return 返回iamge
 */
+ (UIImage *)createImageWithColor:(UIColor *)color;
/**
 *  检查非法字符和中文
 *
 *  @param str a
 *
 *  @return a
 */
+ (BOOL)checkNoChar:(NSString *)str;
/**
 *  隐藏tabbar
 */
+ (void)hiddenTabBar;
/**
 *  显示tabbar
 */
+ (void)showTabBar;
/**
 *  检查电话号码合法性
 *
 *  @param phoneNumber a
 *
 *  @return a
 */
+ (BOOL)checkPhoneNumInput:(NSString *)phoneNumber;
/**
 *  根据dict返回data
 *
 *  @param dict a
 *
 *  @return a
 */
+ (NSData*)returnDataWithDictionary:(NSDictionary*)dict;
/**
 *  根据输入的日期 返回周几的字符串
 *
 *  @param inputDate a
 *
 *  @return a
 */
+ (NSString*)weekdayStringFromDate:(NSDate*)inputDate;
/**
 *  获取今日日期
 *
 *  @return a
 */
+ (NSString *)getDate;
/**
 *  获取当前周的日期数组
 *
 *  @param date a
 *
 *  @return a
 */
+ (NSArray *)getCurrentWeekDay:(NSDate *)date;
/**
 *  计算当前路径下文件大小
 *
 *  @param path a
 *
 *  @return a
 */
+ (float)fileSizeAtPath:(NSString *)path;
/**
 *  当前路径文件夹的大小
 *
 *  @param path a
 *
 *  @return a
 */
+ (float)folderSizeAtPath:(NSString *)path;
/**
 *  清除文件
 *
 *  @param path a
 */
+ (void)clearCache:(NSString *)path;

/**
 *POST 提交 并可以上传图片目前只支持单张
 */
+ (NSString *)postRequestWithURL: (NSString *)url  // IN
                      postParems: (NSMutableDictionary *)postParems // IN 提交参数据集合
                     picFilePath: (NSString *)picFilePath  // IN 上传图片路径
                     picFileName: (NSString *)picFileName;  // IN 上传图片名称

/**
 * 修发图片大小
 */
+ (UIImage *) imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize) newSize;

//获取根文件夹路径
+ (NSString *)rootFilePathWithFileName:(NSString *)fileName;

/**
 * 保存图片
 */
+ (NSString *)saveImage:(UIImage *)tempImage WithName:(NSString *)imageName;
/**
 * 生成GUID
 */
+ (NSString *)generateUuidString;

/**
 * 检查系统"照片"授权状态, 如果权限被关闭, 提示用户去隐私设置中打开.
 */
+ (BOOL)checkPhotoLibraryAuthorizationStatus;

/**
 * 检查系统"相机"授权状态, 如果权限被关闭, 提示用户去隐私设置中打开.
 */
+ (BOOL)checkCameraAuthorizationStatus;

/**
 *  百度转火星坐标
 *
 *  @param coord a
 *
 *  @return a
 */
+ (CLLocationCoordinate2D )bdToGGEncrypt:(CLLocationCoordinate2D)coord;
/**
 *  火星转百度坐标
 *
 *  @param coord a
 *
 *  @return a
 */
+ (CLLocationCoordinate2D )ggToBDEncrypt:(CLLocationCoordinate2D)coord;
+(NSString  *)displayDataStyleWithNumber:(NSString *)timeNumber;

/**
 @brief 获取动态字符的高度

 @param str 对应的字符串
 @param width 字符串的宽度
 @return 返回的字符串高度
 */
+ (CGFloat)getLabelHeightWithString:(NSString *)str needWidth:(CGFloat)width;

@end
