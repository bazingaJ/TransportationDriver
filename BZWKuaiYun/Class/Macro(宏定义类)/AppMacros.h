//
//  AppMacros.h
//  BZWKuaiYun
//
//  Created by Jessey Young on 2017/5/19.
//  Copyright © 2017年 ISU. All rights reserved.
//

#ifndef AppMacros_h
#define AppMacros_h

//** 沙盒路径 ***********************************************************************************
#define PATH_OF_APP_HOME    NSHomeDirectory()
#define PATH_OF_TEMP        NSTemporaryDirectory()
#define PATH_OF_DOCUMENT    [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]

/* *********************************************** */
/** DEBUG LOG **/
#ifdef DEBUG

#define JXLog( s, ... ) NSLog( @"< %@:(%d) > %@", [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__] )

#else

#define JXLog( s, ... )

#endif

/* **********************************************************/
#pragma mark - Frame (宏 x, y, width, height)

// App Frame
#define Application_Frame       [[UIScreen mainScreen] applicationFrame]

// App Frame Height&Width
#define App_Frame_Height        [[UIScreen mainScreen] applicationFrame].size.height
#define App_Frame_Width         [[UIScreen mainScreen] applicationFrame].size.width

// MainScreen Height&Width
#define Main_Screen_Height      [[UIScreen mainScreen] bounds].size.height
#define Main_Screen_Width       [[UIScreen mainScreen] bounds].size.width


#define kDelay  1.5
#define delayRun dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kDelay * NSEC_PER_SEC)), dispatch_get_main_queue()

#define kDelay01  0.7
#define delayRun05 dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kDelay01 * NSEC_PER_SEC)), dispatch_get_main_queue()

#define kFileManager                [NSFileManager defaultManager]
#define kUserDefaults               [NSUserDefaults standardUserDefaults]
#define kWindow                     [[UIApplication sharedApplication] keyWindow]
#define kNotificationCenter         [NSNotificationCenter defaultCenter]
// View 坐标(x,y)和宽高(width,height)
#define X(v)                    (v).frame.origin.x
#define Y(v)                    (v).frame.origin.y
#define WIDTH(v)                (v).frame.size.width
#define HEIGHT(v)               (v).frame.size.height

#define MinX(v)                 CGRectGetMinX((v).frame)
#define MinY(v)                 CGRectGetMinY((v).frame)

#define MidX(v)                 CGRectGetMidX((v).frame)
#define MidY(v)                 CGRectGetMidY((v).frame)

#define MaxX(v)                 CGRectGetMaxX((v).frame)
#define MaxY(v)                 CGRectGetMaxY((v).frame)


#define RECT_CHANGE_x(v,x)          CGRectMake(x, Y(v), WIDTH(v), HEIGHT(v))
#define RECT_CHANGE_y(v,y)          CGRectMake(X(v), y, WIDTH(v), HEIGHT(v))
#define RECT_CHANGE_point(v,x,y)    CGRectMake(x, y, WIDTH(v), HEIGHT(v))
#define RECT_CHANGE_width(v,w)      CGRectMake(X(v), Y(v), w, HEIGHT(v))
#define RECT_CHANGE_height(v,h)     CGRectMake(X(v), Y(v), WIDTH(v), h)
#define RECT_CHANGE_size(v,w,h)     CGRectMake(X(v), Y(v), w, h)

/// 系统控件默认高度
#define kStatusBarHeight        (20.f)

#define kTopBarHeight           (44.f)
#define kNavBarHeight           (64.f)
#define kBottomBarHeight        (49.f)

#define kCellDefaultHeight      (44.f)

#define kEnglishKeyboardHeight  (216.f)
#define kChineseKeyboardHeight  (252.f)

/* ***************************************************/
#pragma mark - Funtion Method (宏 方法)

//cell
#define LoadBbundleCell(bundleName,index)   [[[NSBundle mainBundle]loadNibNamed:(bundleName) owner:nil options:nil]objectAtIndex:(index)];

// PNG JPG 图片路径
#define PNGPATH(NAME)           [[NSBundle mainBundle] pathForResource:[NSString stringWithUTF8String:NAME] ofType:@"png"]
#define JPGPATH(NAME)           [[NSBundle mainBundle] pathForResource:[NSString stringWithUTF8String:NAME] ofType:@"jpg"]
#define PATH(NAME, EXT)         [[NSBundle mainBundle] pathForResource:(NAME) ofType:(EXT)]

// 加载图片
#define PNGkImg(NAME)          [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:(NAME) ofType:@"png"]]
#define JPGkImg(NAME)          [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:(NAME) ofType:@"jpg"]]
#define kImg(NAME, EXT)        [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:(NAME) ofType:(EXT)]]

#define JX_IMAGE(imgName) [UIImage imageNamed:imgName]

#define URL(url) [NSURL URLWithString:url]
#define string(str1,str2) [NSString stringWithFormat:@"%@%@",str1,str2]
#define s_str(str1) [NSString stringWithFormat:@"%@",str1]
#define s_Num(num1) [NSString stringWithFormat:@"%d",num1]
#define s_Integer(num1) [NSString stringWithFormat:@"%ld",num1]

// 字体大小(常规/粗体)
#define BOLDSYSTEMFONT(FONTSIZE)[UIFont boldSystemFontOfSize:FONTSIZE]
#define SYSTEMFONT(FONTSIZE)    [UIFont systemFontOfSize:FONTSIZE]
#define FONT(NAME, FONTSIZE)    [UIFont fontWithName:(NAME) size:(FONTSIZE)]

// 微软雅黑
#define YC_YAHEI_FONT(FONTSIZE) [UIFont fontWithName:@"MicrosoftYaHei" size:(FONTSIZE)]
// 英文 和 数字
#define YC_ENGLISH_FONT(FONTSIZE) [UIFont fontWithName:@"Helvetica Light" size:(FONTSIZE)]

// 颜色(RGB)
#define RGBCOLOR(r, g, b)       [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define RGBACOLOR(r, g, b, a)   [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]

//number转String
#define IntTranslateStr(int_str) [NSString stringWithFormat:@"%d",int_str];
#define FloatTranslateStr(float_str) [NSString stringWithFormat:@"%.2d",float_str];

// View 圆角和加边框
#define ViewBorderRadius(View, Radius, Width, Color)\
\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES];\
[View.layer setBorderWidth:(Width)];\
[View.layer setBorderColor:[Color CGColor]]

// View 圆角
#define ViewRadius(View, Radius)\
\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES];
//SV 展示的不同的状态

#define SVSHOW    [SVProgressHUD show];

#define SVMISS    [SVProgressHUD dismiss];

#define SVSTATUS(Info);\
\
[SVProgressHUD showWithStatus:(Info)];\
[SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];

#define SVSUCCESS(Info,interval);\
\
[SVProgressHUD showSuccessWithStatus:(Info)];\
[SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];\
[SVProgressHUD dismissWithDelay:(interval)];

#define SVINFO(Info,interval);\
\
[SVProgressHUD showInfoWithStatus:(Info)];\
[SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];\
[SVProgressHUD dismissWithDelay:(interval)];

#define SVERROR(Info,interval);\
\
[SVProgressHUD showErrorWithStatus:(Info)];\
[SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];\
[SVProgressHUD dismissWithDelay:(interval)];

// 当前版本
#define FSystemVersion          ([[[UIDevice currentDevice] systemVersion] floatValue])
#define DSystemVersion          ([[[UIDevice currentDevice] systemVersion] doubleValue])
#define SSystemVersion          ([[UIDevice currentDevice] systemVersion])

// 当前语言
#define CURRENTLANGUAGE         ([[NSLocale preferredLanguages] objectAtIndex:0])

// 是否Retina屏
#define isRetina                ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? \
CGSizeEqualToSize(CGSizeMake(640, 960), \
[[UIScreen mainScreen] currentMode].size) : \
NO)

// 是否iPhone5
#define isiPhone5               ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? \
CGSizeEqualToSize(CGSizeMake(640, 1136), \
[[UIScreen mainScreen] currentMode].size) : \
NO)
// 是否iPhone5
#define isiPhone4               ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? \
CGSizeEqualToSize(CGSizeMake(640, 960), \
[[UIScreen mainScreen] currentMode].size) : \
NO)

#define isIOS8                  ([[[UIDevice currentDevice]systemVersion]floatValue] >= 8.0)
// 是否IOS7
#define isIOS7                  ([[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0)
// 是否IOS6
#define isIOS6                  ([[[UIDevice currentDevice]systemVersion]floatValue] < 7.0)

// 是否iPad
#define isPad                   (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

// UIView - viewWithTag
#define VIEWWITHTAG(_OBJECT, _TAG)\
\
[_OBJECT viewWithTag : _TAG]

// RGB颜色转换（16进制->10进制）
#define UIColorFromRGB(rgbValue)\
\
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 \
alpha:1.0]

#if TARGET_OS_IPHONE
/** iPhone Device */
#endif

#if TARGET_IPHONE_SIMULATOR
/** iPhone Simulator */
#endif

// ARC
#if __has_feature(objc_arc)
/** Compiling with ARC */
#else
/** Compiling without ARC */
#endif

/* ************************************************************************************************* */

///正常字体
#define F30 [UIFont systemFontOfSize:30]
#define F29 [UIFont systemFontOfSize:29]
#define F28 [UIFont systemFontOfSize:28]
#define F27 [UIFont systemFontOfSize:27]
#define F26 [UIFont systemFontOfSize:26]
#define F25 [UIFont systemFontOfSize:25]
#define F24 [UIFont systemFontOfSize:24]
#define F23 [UIFont systemFontOfSize:23]
#define F22 [UIFont systemFontOfSize:22]
#define F20 [UIFont systemFontOfSize:20]
#define F19 [UIFont systemFontOfSize:19]
#define F18 [UIFont systemFontOfSize:18]
#define F17 [UIFont systemFontOfSize:17]
#define F16 [UIFont systemFontOfSize:16]
#define F15 [UIFont systemFontOfSize:15]
#define F14 [UIFont systemFontOfSize:14]
#define F13 [UIFont systemFontOfSize:13]
#define F12 [UIFont systemFontOfSize:12]
#define F11 [UIFont systemFontOfSize:11]
#define F10 [UIFont systemFontOfSize:10]
#define F9  [UIFont systemFontOfSize:9]
#define F8  [UIFont systemFontOfSize:8]

///粗体
#define HB20 [UIFont boldSystemFontOfSize:20]
#define HB18 [UIFont boldSystemFontOfSize:18]
#define HB16 [UIFont boldSystemFontOfSize:16]
#define HB14 [UIFont boldSystemFontOfSize:14]
#define HB13 [UIFont boldSystemFontOfSize:13]
#define HB12 [UIFont boldSystemFontOfSize:12]
#define HB11 [UIFont boldSystemFontOfSize:11]
#define HB10 [UIFont boldSystemFontOfSize:10]
#define HB8 [UIFont boldSystemFontOfSize:8]

///常用颜色
#define black_color         [UIColor blackColor]
#define blue_color          [UIColor blueColor]
#define brown_color         [UIColor brownColor]
#define clear_color         [UIColor clearColor]
#define darkGray_color      [UIColor darkGrayColor]
#define darkText_color      [UIColor darkTextColor]
#define white_color         [UIColor whiteColor]
#define yellow_color        [UIColor yellowColor]
#define red_color           [UIColor redColor]
#define cyan_color          [UIColor cyanColor]
#define orange_color        [UIColor orangeColor]
#define purple_color        [UIColor purpleColor]
#define lightText_color     [UIColor lightTextColor]
#define lightGray_color     [UIColor lightGrayColor]
#define green_color         [UIColor greenColor]
#define gray_color          [UIColor grayColor]
#define magenta_color       [UIColor magentaColor]
#define Main_Color          [UIColor colorWithRed:(254)/255.0 green:(98)/255.0 blue:(70)/255.0 alpha:1.0]
#define Main2_Color         [UIColor colorWithRed:(144)/255.0 green:(144)/255.0 blue:(144)/255.0 alpha:1.0]
#define VTColor(r, g, b)    [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define Text_Color          [UIColor colorWithRed:(100)/255.0 green:(100)/255.0 blue:(100)/255.0 alpha:1.0]
#define BackGround_Color    [UIColor colorWithRed:(240)/255.0 green:(240)/255.0 blue:(240)/255.0 alpha:1.0]

#define kBackColor UIColorFromRGB(0xd81460)

//系统版本号
#define _DEVICE_SYSTEM_VERSION_  [[[UIDevice currentDevice] systemVersion]floatValue]

#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;

#define APPICONIMAGE [UIImage imageNamed:[[[[NSBundle mainBundle] infoDictionary] valueForKeyPath:@"CFBundleIcons.CFBundlePrimaryIcon.CFBundleIconFiles"] lastObject]]
#define APPNAME [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"]


#endif /* AppMacros_h */
