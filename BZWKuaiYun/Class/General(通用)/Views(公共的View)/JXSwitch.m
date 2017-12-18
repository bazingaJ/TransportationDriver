//
//  JXSwitch.m
//  BZWKuaiYun
//
//  Created by Jessey Young on 2017/6/2.
//  Copyright © 2017年 ISU. All rights reserved.
//

#import "JXSwitch.h"

@implementation JXSwitch

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)init
{
    self = [super initWithFrame:CGRectMake(0, 0, 50, 30)];
    if (self)
    {
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self setup];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    CGRect initialFrame;
    if (CGRectIsEmpty(frame))
    {
        initialFrame = CGRectMake(0, 0, 50, 30);
    }
    else
    {
        initialFrame = frame;
    }
    self = [super initWithFrame:initialFrame];
    if (self)
    {
        [self setup];
    }
    return self;
}

//创建
- (void)setup
{
    self.on = NO;//设置开关是开还是关
    self.inactiveColor = [UIColor clearColor];//设置不活动的颜色
    self.activeColor = [UIColor colorWithRed:0.89f green:0.89f blue:0.89f alpha:1.00f];
    self.onColor = [UIColor colorWithRed:1.0f green:0.85f blue:0.39f alpha:1.00f];//设置打开开关的颜色
    self.borderColor = [UIColor colorWithRed:0.89f green:0.89f blue:0.91f alpha:1.00f];//设置边框颜色
    self.knobColor = [UIColor whiteColor];//设置开关上按钮的颜色
    self.shadowColor = [UIColor grayColor];//设置阴影的颜色
    self.background = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    self.background.backgroundColor = [UIColor clearColor];
    self.background.layer.cornerRadius = self.frame.size.height * 0.5;//圆角半径
    self.background.layer.borderColor = self.borderColor.CGColor;
    self.background.layer.borderWidth = 1.0;
    self.background.userInteractionEnabled = NO;
    [self addSubview:self.background];
    self.label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width - self.frame.size.height, self.frame.size.height)];
    self.label1.text = self.text1;
    self.label1.alpha = 1;
    self.label1.textAlignment =NSTextAlignmentCenter;
    [self addSubview:self.label1];
    
    self.label2= [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.height, 0, self.frame.size.width - self.frame.size.height, self.frame.size.height)];
    self.label2.text = self.text2;
    self.label2.alpha = 1.0;
    self.label2.textAlignment =NSTextAlignmentCenter;
    [self addSubview:self.label2];
    
    self.knob = [[UIView alloc] initWithFrame:CGRectMake(1, 1, self.frame.size.height - 2, self.frame.size.height - 2)];
    self.knob.backgroundColor = self.knobColor;
    self.knob.layer.cornerRadius = (self.frame.size.height * 0.5) - 1;
    self.knob.layer.shadowColor = self.shadowColor.CGColor;
    self.knob.layer.shadowRadius = 2.0;
    self.knob.layer.shadowOpacity = 0.5;
    self.knob.layer.shadowOffset = CGSizeMake(0, 3);
    self.knob.layer.masksToBounds = NO;
    self.knob.userInteractionEnabled = NO;
    [self addSubview:self.knob];
    self.background.layer.cornerRadius = 2;
    self.knob.layer.cornerRadius = 2;
    
    self.isAnimating = NO;
}


- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {//开始触摸
    [super beginTrackingWithTouch:touch withEvent:event];
    self.startTime = [[NSDate date] timeIntervalSince1970];
    CGFloat activeKnobWidth = self.bounds.size.height - 2 + 5;
    self.isAnimating = YES;
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseOut|UIViewAnimationOptionBeginFromCurrentState animations:^{
        if (self.on) {
            self.knob.frame = CGRectMake(self.bounds.size.width - (activeKnobWidth + 1), self.knob.frame.origin.y, activeKnobWidth, self.knob.frame.size.height);
            self.background.backgroundColor = self.onColor;
        }
        else {
            self.knob.frame = CGRectMake(self.knob.frame.origin.x, self.knob.frame.origin.y, activeKnobWidth, self.knob.frame.size.height);
            self.background.backgroundColor = self.activeColor;
        }
    } completion:^(BOOL finished) {
        self.isAnimating = NO;
    }];
    return YES;
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    //继续触摸
    [super continueTrackingWithTouch:touch withEvent:event];
    
    //往右滑动就是开，往左滑动就是关
    CGPoint lastPoint = [touch locationInView:self];
    if (lastPoint.x > self.bounds.size.width * 0.5)
        [self showOn:YES];
    else
        [self showOff:YES];
    
    return YES;
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    //结束触摸
    [super endTrackingWithTouch:touch withEvent:event];
    double endTime = [[NSDate date] timeIntervalSince1970];
    double difference = endTime - self.startTime;
    BOOL previousValue = self.on;
    //判断用户是否轻拍开关或者保持长按很久
    if (difference <= 0.2)
    {
        CGFloat normalKnobWidth = self.bounds.size.height - 2;
        self.knob.frame = CGRectMake(self.knob.frame.origin.x, self.knob.frame.origin.y, normalKnobWidth, self.knob.frame.size.height);
        [self setOn:!self.on animated:YES];
    }
    else
    {
        CGPoint lastPoint = [touch locationInView:self];
        if (lastPoint.x > self.bounds.size.width * 0.5)
            
            [self setOn:YES animated:YES];
        else
            
            [self setOn:NO animated:YES];
    }
    
    if (previousValue != self.on)
        
        [self sendActionsForControlEvents:UIControlEventValueChanged];//
}

- (void)cancelTrackingWithEvent:(UIEvent *)event
{
    //取消触摸
    [super cancelTrackingWithEvent:event];
    if (self.on)
        [self showOn:YES];
    else
        [self showOff:YES];
}

- (void)setInactiveColor:(UIColor *)color
{
    //设置不活动的颜色
    self.inactiveColor = color;
    if (!self.on && !self.isTracking)
        self.background.backgroundColor = color;
}

- (void)setOnColor:(UIColor *)color
{
    //设置打开开关的颜色
    self.onColor = color;
    if (self.on && !self.isTracking)
    {
        self.background.backgroundColor = color;
        self.background.layer.borderColor = color.CGColor;
    }
}

- (void)setBorderColor:(UIColor *)color
{
    //设置边框颜色
    self.borderColor = color;
    if (!self.on)
        self.background.layer.borderColor = color.CGColor;
}

- (void)setKnobColor:(UIColor *)color
{
    //设置开关上按钮的颜色
    self.knobColor = color;
    self.knob.backgroundColor = color;
}

- (void)setShadowColor:(UIColor *)color
{
    //设置阴影的颜色
    self.shadowColor = color;
    self.knob.layer.shadowColor = color.CGColor;
}

- (void)setOn:(BOOL)isOn
{
    //设置开关是开还是关
    [self setOn:isOn animated:NO];
}

- (void)setOn:(BOOL)isOn animated:(BOOL)animated
{
    //设置开关的状态，并设置过渡动画
    self.on = isOn;
    
    if (isOn)
    {
        [self showOn:animated];
    }
    else
    {
        [self showOff:animated];
    }
}

//- (BOOL)isOn
//{
//    //获取开关是否为开或关的状态
//    return self.on;
//}

- (void)showOn:(BOOL)animated
{
    //显示开关的开位置，并带有动画
    CGFloat normalKnobWidth = self.bounds.size.height - 2;
    CGFloat activeKnobWidth = normalKnobWidth + 5;
    if (animated)
    {
        self.isAnimating = YES;
        [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseOut|UIViewAnimationOptionBeginFromCurrentState animations:^{
            if (self.tracking)
                self.knob.frame = CGRectMake(self.bounds.size.width - (activeKnobWidth + 1), self.knob.frame.origin.y, activeKnobWidth, self.knob.frame.size.height);
            else
                self.knob.frame = CGRectMake(self.bounds.size.width - (normalKnobWidth + 1), self.knob.frame.origin.y, normalKnobWidth, self.knob.frame.size.height);
            self.background.backgroundColor = self.onColor;
            self.background.layer.borderColor = self.onColor.CGColor;
        } completion:^(BOOL finished)
         {
            self.isAnimating = NO;
        }];
    }
    else {
        if (self.tracking)
            self.knob.frame = CGRectMake(self.bounds.size.width - (activeKnobWidth + 1), self.knob.frame.origin.y, activeKnobWidth, self.knob.frame.size.height);
        else
            self.knob.frame = CGRectMake(self.bounds.size.width - (normalKnobWidth + 1), self.knob.frame.origin.y, normalKnobWidth, self.knob.frame.size.height);
        self.background.backgroundColor = self.onColor;
        self.background.layer.borderColor = self.onColor.CGColor;
    }
}

- (void)showOff:(BOOL)animated
{
    //显示开关的关闭位置，并带有动画
    CGFloat normalKnobWidth = self.bounds.size.height - 2;
    CGFloat activeKnobWidth = normalKnobWidth + 5;
    if (animated) {
        self.isAnimating = YES;
        [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseOut|UIViewAnimationOptionBeginFromCurrentState animations:^{
            if (self.tracking) {
                self.knob.frame = CGRectMake(1, self.knob.frame.origin.y, activeKnobWidth, self.knob.frame.size.height);
                self.background.backgroundColor = self.activeColor;
            }
            else {
                self.knob.frame = CGRectMake(1, self.knob.frame.origin.y, normalKnobWidth, self.knob.frame.size.height);
                self.background.backgroundColor = self.inactiveColor;
            }
            self.background.layer.borderColor = self.borderColor.CGColor;
        } completion:^(BOOL finished) {
            self.isAnimating = NO;
        }];
    }
    else {
        if (self.tracking) {
            self.knob.frame = CGRectMake(1, self.knob.frame.origin.y, activeKnobWidth, self.knob.frame.size.height);
            self.background.backgroundColor = self.activeColor;
        }
        else {
            self.knob.frame = CGRectMake(1, self.knob.frame.origin.y, normalKnobWidth, self.knob.frame.size.height);
            self.background.backgroundColor = self.inactiveColor;
        }
        self.background.layer.borderColor = self.borderColor.CGColor;
    }
}

@end
