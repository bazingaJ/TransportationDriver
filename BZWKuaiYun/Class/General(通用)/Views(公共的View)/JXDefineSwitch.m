//
//  JXDefineSwitch.m
//  BZWKuaiYun
//
//  Created by Jessey Young on 2017/6/2.
//  Copyright © 2017年 ISU. All rights reserved.
//

#import "JXDefineSwitch.h"

@interface JXDefineSwitch ()

@property (nonatomic, strong) UIButton *knobBtn;
@property (nonatomic, strong) UIButton *bottomBtnLeft;
@property (nonatomic, strong) UIButton *bottomBtnRight;
@property (nonatomic, assign) CGRect initialFrame;
@end

@implementation JXDefineSwitch

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithFrame:(CGRect)frame
{
    if (CGRectIsEmpty(frame))
    {
        self.initialFrame = CGRectMake(0, 0, 60, 30);
    }
    else
    {
        self.initialFrame = frame;
    }
    if (self = [super initWithFrame:frame])
    {
        [self setupUIWithFrame:frame];
    }
    return self;
}

//创建
- (void)setupUIWithFrame:(CGRect)frame
{
    CGFloat centerX = frame.size.width/2;
    CGFloat W = frame.size.width;
    CGFloat H = frame.size.height;
    
    self.backgroundColor = self.backColor;
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = H/2;
    
    self.bottomBtnLeft = [UIButton buttonWithType:UIButtonTypeCustom];
    self.bottomBtnLeft.frame = CGRectMake(0, 0, W/2, H);
    self.bottomBtnLeft.titleLabel.font = F15;
    [self.bottomBtnLeft addTarget:self action:@selector(viewChange) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.bottomBtnLeft];
    
    
    self.bottomBtnRight = [UIButton buttonWithType:UIButtonTypeCustom];
    self.bottomBtnRight.frame = CGRectMake(centerX, 0, W/2, H);
    self.bottomBtnRight.titleLabel.font = F15;
    [self.bottomBtnRight addTarget:self action:@selector(viewChange) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.bottomBtnRight];
    
    
    //创建中间滑块
    self.knobBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.knobBtn.frame = CGRectMake(1, 1, (W-2)/2, H-2);
    self.knobBtn.titleLabel.font = F15;
    self.knobBtn.layer.masksToBounds = YES;
    self.knobBtn.layer.cornerRadius = (H-2)/2;
    [self addSubview:self.knobBtn];
    
    UISwipeGestureRecognizer *pan = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(gesturePan:)];
    pan.direction =  UISwipeGestureRecognizerDirectionRight;
    [self addGestureRecognizer:pan];
    
    UISwipeGestureRecognizer *swipe=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(gesturePan:)];
    
    swipe.direction=UISwipeGestureRecognizerDirectionLeft;
    
    [self addGestureRecognizer:swipe];
}

- (void)setOn:(BOOL)on
{
    _on = on;
    CGFloat centerX = self.initialFrame.size.width/2;
    CGFloat W = self.initialFrame.size.width;
    CGFloat H = self.initialFrame.size.height;
    if (on)
    {
        self.knobBtn.frame = CGRectMake(centerX, 1, (W-2)/2, H-2);
        [self.knobBtn setTitle:_onText forState:UIControlStateNormal];
        
        self.bottomBtnLeft.alpha = 1;
        self.bottomBtnRight.alpha = 0;
    }
    else
    {
        self.knobBtn.frame = CGRectMake(1, 1, (W-2)/2, H-2);
        [self.knobBtn setTitle:_offText forState:UIControlStateNormal];
        
        self.bottomBtnLeft.alpha = 0;
        self.bottomBtnRight.alpha = 1;
    }
}


- (void)viewChange
{
    if ([self.delegate respondsToSelector:@selector(bottonViewClick)])
    {
        [self.delegate bottonViewClick];
    }
    CGFloat W = self.initialFrame.size.width;
    [UIView animateWithDuration:.3f delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        if (_on)
        {
            self.knobBtn.transform = CGAffineTransformMakeTranslation(W/2-1, 0);
            [self.knobBtn setTitle:_offText forState:UIControlStateNormal];
            
            self.bottomBtnLeft.alpha = 0;
            self.bottomBtnRight.alpha = 1;
            
            
            self.on = NO;
        }
        else
        {
            self.knobBtn.transform = CGAffineTransformMakeTranslation(-(W/2-1), 0);
            [self.knobBtn setTitle:_onText forState:UIControlStateNormal];
            
            self.bottomBtnLeft.alpha = 1;
            self.bottomBtnRight.alpha = 0;
            
            self.on = YES;
        }
        
        
    } completion:^(BOOL finished) {
        
    }];
}

- (void)gesturePan:(UISwipeGestureRecognizer *)reconizer
{
    if ([self.delegate respondsToSelector:@selector(swtichSwipeEvent)])
    {
        [self.delegate swtichSwipeEvent];
    }
    CGFloat W = self.initialFrame.size.width;
    if (reconizer.direction == UISwipeGestureRecognizerDirectionLeft)
    {
        [UIView animateWithDuration:.3f delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.knobBtn.transform = CGAffineTransformMakeTranslation(W/2-1, 0);
            [self.knobBtn setTitle:_offText forState:UIControlStateNormal];
            
            self.bottomBtnLeft.alpha = 0;
            self.bottomBtnRight.alpha = 1;
            
            
            self.on = NO;
            
        } completion:^(BOOL finished) {
            
        }];
    }
    
    if (reconizer.direction == UISwipeGestureRecognizerDirectionRight)
    {
        [UIView animateWithDuration:.3f delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.knobBtn.transform = CGAffineTransformMakeTranslation(-(W/2-1), 0);
            [self.knobBtn setTitle:_onText forState:UIControlStateNormal];
            
            self.bottomBtnLeft.alpha = 1;
            self.bottomBtnRight.alpha = 0;
            
            self.on = YES;
            
        } completion:^(BOOL finished) {
            
        }];
        
        
    }
}

- (void)setBackColor:(UIColor *)backColor
{
    _backColor = backColor;
    self.backgroundColor = backColor;
}

- (void)setKnobBackColor:(UIColor *)knobBackColor
{
    _knobBackColor = knobBackColor;
    [self.knobBtn setBackgroundColor:knobBackColor];
}

- (void)setKnobTextColor:(UIColor *)knobTextColor
{
    _knobTextColor = knobTextColor;
    [self.knobBtn setTitleColor:knobTextColor forState:UIControlStateNormal];
}

- (void)setOnText:(NSString *)onText
{
    _onText = onText;
    [self.bottomBtnRight setTitle:_onText forState:UIControlStateNormal];
    if (_on)
    {
        [self.knobBtn setTitle:_onText forState:UIControlStateNormal];
    }
}

- (void)setOffText:(NSString *)offText
{
    _offText = offText;
    [self.bottomBtnLeft setTitle:offText forState:UIControlStateNormal];
    if (!_on)
    {
        [self.knobBtn setTitle:_offText forState:UIControlStateNormal];
    }
}

- (void)setOffTextColor:(UIColor *)offTextColor
{
    _offTextColor = offTextColor;
    [self.bottomBtnLeft setTitleColor:_offTextColor forState:UIControlStateNormal];
    [self.bottomBtnRight setTitleColor:offTextColor forState:UIControlStateNormal];
}

- (BOOL)isBeing
{
    if (_on)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

@end
