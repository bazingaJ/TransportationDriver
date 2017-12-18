//
//  JXInOutView.h
//  BZWKuaiYun
//
//  Created by Jessey Young on 2017/6/1.
//  Copyright © 2017年 ISU. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JXDateChoiceDelegate <NSObject>

- (void)yearButtonClick;
- (void)monthButtonClick;

@end


@interface JXInOutView : UIView

@property (nonatomic, weak) IBOutlet UILabel *wholeMoneyLab;
@property (nonatomic, weak) IBOutlet UILabel *moneyDetailLab;
@property (nonatomic, weak) IBOutlet UIButton *yearBtn;
@property (nonatomic, weak) IBOutlet UIButton *monthBtn;
@property (nonatomic, assign) id<JXDateChoiceDelegate>delegate;

@end
