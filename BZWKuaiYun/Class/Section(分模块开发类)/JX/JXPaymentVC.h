//
//  JXPaymentVC.h
//  BZWKuaiYun
//
//  Created by Jessey Young on 2017/5/25.
//  Copyright © 2017年 ISU. All rights reserved.
//

typedef NS_ENUM(int, BeforeViewControllerType)
{
    BeforeViewControllerTypeGrade   = 1,
    BeforeViewControllerTypeHome    = 2,
    BeforeViewControllerTypeWallet  = 3
};

#import "JXBaseVC.h"

typedef void(^PaymentBlock)(BOOL isHidden);

@interface JXPaymentVC : JXBaseVC

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topLabHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *underHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewToTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineTop;

@property (nonatomic, weak) IBOutlet UIView *bottonView;
@property (nonatomic, weak) IBOutlet UIButton *payBtn;

@property (weak, nonatomic) IBOutlet UIButton *wechatBtn;
@property (weak, nonatomic) IBOutlet UIButton *alipayBtn;
@property (weak, nonatomic) IBOutlet UILabel *descLab;
@property (weak, nonatomic) IBOutlet UILabel *moneyLab;

@property (nonatomic, strong) NSString *descStr;

@property (weak, nonatomic) IBOutlet UIImageView *img1;
@property (weak, nonatomic) IBOutlet UILabel *lab1;
@property (weak, nonatomic) IBOutlet UIImageView *img2;
@property (weak, nonatomic) IBOutlet UILabel *lab2;



@property (nonatomic, assign) BOOL isRegPart;
@property (nonatomic, assign) BOOL isHomePage;

@property (nonatomic, assign) BeforeViewControllerType type;

@property (nonatomic, copy) PaymentBlock payment;

@end
