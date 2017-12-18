//
//  JXAppTool.m
//  BZWKuaiYun
//
//  Created by Jessey Young on 2017/5/19.
//  Copyright © 2017年 ISU. All rights reserved.
//

#import "JXAppTool.h"
#import <CommonCrypto/CommonDigest.h>

@implementation JXAppTool


+ (UIImage *)createImageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return theImage;
}

+ (NSString *)getNowYearAndMonth
{
    NSDate *date = [NSDate date];
    NSDateFormatter * format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"YYYY-MM"];
    NSString *dateStr = [format stringFromDate:date];
    return dateStr;
}

+ (NSInteger)getNowYearStr
{
    NSDate *date = [NSDate date];
    NSDateFormatter * format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"YYYY"];
    NSString *dateStr = [format stringFromDate:date];
    return [dateStr integerValue];
}

+ (NSInteger)getNowMonthStr
{
    NSDate *date = [NSDate date];
    NSDateFormatter * format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"MM"];
    NSString *dateStr = [format stringFromDate:date];
    return [dateStr integerValue];
}

+ (NSString *)getWholeStrYMDHMS
{
    NSDate *date = [NSDate date];
    NSDateFormatter * format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    format.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT+0800"];
    NSString *dateStr = [format stringFromDate:date];
    return dateStr;
}

+ (NSString *)MD5EncryptionWithString:(NSString *)string
{
    const char *cStr = [string UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result); // This is the md5 call
    NSString *MD5String = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",result[0], result[1], result[2], result[3],result[4], result[5], result[6], result[7],result[8], result[9], result[10], result[11], result[12], result[13], result[14], result[15]];
    
    return MD5String;
}

// 字典转json字符串方法
+ (NSString *)convertToJsonData:(NSDictionary *)dict

{
    
    NSError *error;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    
    NSString *jsonString;
    
    if (!jsonData) {
        
        NSLog(@"%@",error);
        
    }else{
        
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        
    }
    
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    
    NSRange range = {0,jsonString.length};
    
    //去掉字符串中的空格
    
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    
    NSRange range2 = {0,mutStr.length};
    
    //去掉字符串中的换行符
    
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    
    return mutStr;
    
}

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil)
    {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&err];
    
    if(err)
    {
        JXLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

+ (BOOL)isSameVersion
{
    //当前版本
    NSString *nowVersion = [[NSBundle mainBundle].infoDictionary objectForKey:@"CFBundleShortVersionString"];
    
    //本地存储的之前版本
    NSString * oldVersion = [kUserDefaults objectForKey:@"versionCode"];
    if ([oldVersion isEqualToString:nowVersion])
    {
        return YES;
    }
    else
    {
        return NO;
    }
    
}


+ (NSString *)transforMoneyGetPenny:(NSString *)penny
{
    NSMutableString *starMoney = [NSMutableString stringWithString:penny];
    if (penny.length >= 3)
    {
        [starMoney insertString:@"." atIndex:penny.length-2];
        return [NSString stringWithFormat:@"%@",starMoney];
    }
    else if (penny.length == 2)
    {
        return [NSString stringWithFormat:@"0.%@",starMoney];
    }
    else if (penny.length == 1)
    {
        return [NSString stringWithFormat:@"0.0%@",starMoney];
    }
    else
    {
        return @"";
    }
    
}


//自定义 按钮流布局
+ (CGFloat)setupLeaveItem:(NSArray *)arr
{
    CGFloat sumWidth = 0.0f;
    int row = 0;
    CGFloat maxY = .0f;
    
    BOOL isChange = NO;
    if (![JXTool verifyIsNullString:[arr firstObject]])
    {
        for (int i = 0 ; i < arr.count; i++)
        {
            if (sumWidth < Main_Screen_Width)
            {
                UILabel *txtLab = [[UILabel alloc] init];
                CGSize size =  [arr[i] sizeWithAttributes:@{NSFontAttributeName:F13}];
                if (i == 0)//确定第一个位置
                {
                    txtLab.frame = CGRectMake(25, 10, size.width+10, 25);
                    maxY = CGRectGetMaxY(txtLab.frame)+10;
                }
                else
                {
                    if (i == arr.count - 1) //确定最后的maxY
                    {
                        if (sumWidth + size.width + 10 + 25 <= Main_Screen_Width)
                        {
                            txtLab.frame = CGRectMake(sumWidth, row * 25 + 10 * (row + 1), size.width+10, 25);
                            maxY = CGRectGetMaxY(txtLab.frame)+10;
                        }
                        else
                        {
                            row = row + 1;
                            txtLab.frame = CGRectMake(25, row * 25 + 10 * (row + 1), size.width+10, 25);
                            maxY = CGRectGetMaxY(txtLab.frame)+10;
                        }
                    }
                    else //非最后的
                    {
                        if (sumWidth + size.width + 10 + 25 <= Main_Screen_Width)
                        {
                            txtLab.frame = CGRectMake(sumWidth, row * 25 + 10 * (row + 1), size.width+10, 25);
                        }
                        else
                        {
                            row = row + 1;
                            isChange = YES;
                            txtLab.frame = CGRectMake(25, row * 25 + 10 * (row + 1), size.width+10, 25);
                        }
                    }
                    
                }
                
                sumWidth= CGRectGetMaxX(txtLab.frame) + 10;
            }
        }
        return maxY;
    }
    else
    {
        return 0;
    }
}



@end
