//
//  JXSwitch.h
//  BZWKuaiYun
//
//  Created by Jessey Young on 2017/6/2.
//  Copyright © 2017年 ISU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JXSwitch : UISwitch

@property (nonatomic, strong) UIView *background;
@property (nonatomic, strong) UIView *knob;

//设置不活动的颜色
@property (nonatomic, strong) UIColor *activeColor;

//设置边框颜色
@property (nonatomic, strong) UIColor *borderColor;

//设置开关上按钮的颜色
@property (nonatomic, strong) UIColor *knobColor;

//设置阴影的颜色
@property (nonatomic, strong) UIColor *shadowColor;

//设置不活动的颜色
@property (nonatomic, strong) UIColor *inactiveColor;

//设置打开开关的颜色
@property (nonatomic, strong) UIColor *onColor;


@property (nonatomic, strong) UILabel *label1;
@property (nonatomic, strong) NSString *text1;


@property (nonatomic, strong) UILabel *label2;
@property (nonatomic, strong) NSString *text2;

@property (nonatomic, assign) NSTimeInterval startTime;

@property  BOOL isAnimating;

@end
