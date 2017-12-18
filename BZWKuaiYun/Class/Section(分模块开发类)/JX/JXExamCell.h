//
//  JXExamCell.h
//  BZWKuaiYun
//
//  Created by Jessey Young on 2017/5/25.
//  Copyright © 2017年 ISU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JXExamModel.h"

@protocol JXExamOptionDelegate <NSObject>

@required
- (void)optionButtonClick:(UIButton *)btn;

@end

@interface JXExamCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UIButton *btnA;
@property (weak, nonatomic) IBOutlet UIButton *btnB;
@property (weak, nonatomic) IBOutlet UIButton *btnC;
@property (weak, nonatomic) IBOutlet UILabel *option1Lab;
@property (weak, nonatomic) IBOutlet UILabel *option2Lab;
@property (weak, nonatomic) IBOutlet UILabel *option3Lab;
@property (strong, nonatomic) JXExamModel *model;
//选项按钮的选中状态
@property (strong, nonatomic) NSString *btnStatus;
@property (assign, nonatomic) id<JXExamOptionDelegate>delegate;
@end
