//
//  JXMainBottomView.h
//  BZWKuaiYun
//
//  Created by Jessey Young on 2017/6/1.
//  Copyright © 2017年 ISU. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JXHomePageBottomDelegate <NSObject>

- (void)buttonClick:(UIButton *)btn;
//- (void)telBtnClick:(UIButton *)telBtn;

@end

@interface JXMainBottomView : UIView
@property (weak, nonatomic) IBOutlet UIButton *statusBtn;

@property (weak, nonatomic) IBOutlet UIImageView *headImg;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *mileLab;
@property (weak, nonatomic) IBOutlet UILabel *starLab;
@property (weak, nonatomic) IBOutlet UILabel *startDetailLab;
@property (weak, nonatomic) IBOutlet UILabel *endLab;
@property (weak, nonatomic) IBOutlet UILabel *endDetailLab;
@property (weak, nonatomic) IBOutlet UILabel *remark;

@property (nonatomic, strong) NSString *telStr;
@property (nonatomic, strong) NSString *reciverStr;

@property (nonatomic, strong) JXHomeModel *model;

@property (nonatomic, assign) id<JXHomePageBottomDelegate>doThing;
@end
