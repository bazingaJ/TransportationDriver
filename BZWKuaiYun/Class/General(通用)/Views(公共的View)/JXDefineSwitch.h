//
//  JXDefineSwitch.h
//  BZWKuaiYun
//
//  Created by Jessey Young on 2017/6/2.
//  Copyright © 2017年 ISU. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JXSwitchDelegate <NSObject>

- (void)swtichSwipeEvent;
- (void)bottonViewClick;

@end

@interface JXDefineSwitch : UIControl
//设置开关的底部的背景颜色
@property (nonatomic, strong) UIColor *backColor;
//设置滑块的初始位置
@property (nonatomic, assign) BOOL on;
//滑块的背景颜色
@property (nonatomic, strong) UIColor *knobBackColor;
//滑块的字体颜色
@property (nonatomic, strong) UIColor *knobTextColor;
//左侧底层的文字
@property (nonatomic, strong) NSString *offText;
//右侧底层的文字
@property (nonatomic, strong) NSString *onText;
//底层的文字颜色
@property (nonatomic, strong) UIColor *offTextColor;

@property (nonatomic, assign) id<JXSwitchDelegate>delegate;

@property(nonatomic,getter=isBeing) BOOL being;

@end
