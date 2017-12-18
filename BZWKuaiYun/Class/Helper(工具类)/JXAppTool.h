//
//  JXAppTool.h
//  BZWKuaiYun
//
//  Created by Jessey Young on 2017/5/19.
//  Copyright © 2017年 ISU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface JXAppTool : NSObject

/**
 @brief 把color变成image
 @param color 传来的color
 @return 返回iamge
 */
+ (UIImage *)createImageWithColor:(UIColor *)color;


/**
 @brief 获取当前的年月
 @return 返回的年月字符串 格式是YYYY-MM
 */
+ (NSString *)getNowYearAndMonth;

/**
 @brief 获取当前的年

 @return 返回当前的年
 */
+ (NSInteger)getNowYearStr;

/**
 @brief 获取当前的月

 @return 返回当前的月
 */
+ (NSInteger)getNowMonthStr;

/**
 @brief 获取当前所有时间日期
 
 @return 返回当前的所有时间日期
 */
+ (NSString *)getWholeStrYMDHMS;

/**
 @brief 获取MD5加密数据
 @param string 加密前的数据
 @return 加密后的数据
 */
+ (NSString *)MD5EncryptionWithString:(NSString *)string;

/**
 字典转json字符串方法

 @param dict 需要转换的字典
 @return 返回的JSON字符串
 */
+ (NSString *)convertToJsonData:(NSDictionary *)dict;

/*!
 * @brief 把格式化的JSON格式的字符串转换成字典
 * @param jsonString JSON格式的字符串
 * @return 返回字典
 */
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;
//判断是否 版本相同
+ (BOOL)isSameVersion;


/**
 @brief 把分转换成元

 @param penny 分
 @return 元
 */
+ (NSString *)transforMoneyGetPenny:(NSString *)penny;


/**
 @brief 自定义流布局返回高度

 @param arr 给一个数组过来
 @return 返回约束高度
 */
+ (CGFloat)setupLeaveItem:(NSArray *)arr;

@end
