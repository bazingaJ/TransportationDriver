//
//  WalletHeaderView.h
//  BZWKuaiYun
//
//  Created by Jessey Young on 2017/5/26.
//  Copyright © 2017年 ISU. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JXWalletHeaderDelegate <NSObject>

- (void)pointBtnClick;
- (void)balanceBtnClick;

@end

@interface WalletHeaderView : UIView

@property (nonatomic, assign) id<JXWalletHeaderDelegate>delegate;
@property (weak, nonatomic) IBOutlet UILabel *pointLab;
@property (weak, nonatomic) IBOutlet UILabel *balanceLab;

@end
