//
//  JXSkillCell.h
//  BZWKuaiYun
//
//  Created by Jessey Young on 2017/5/31.
//  Copyright © 2017年 ISU. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JXSkillCellDelegate <NSObject>

- (void)selectedButtonClick:(UIButton *)btn;

@end


@interface JXSkillCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *title;

@property (nonatomic, strong) UILabel *contentLab;
@property (nonatomic, strong) UIButton *btn;

@property (nonatomic, strong) NSMutableArray *wholeArr;
@property (nonatomic, assign) id<JXSkillCellDelegate>delegate;

@property (weak, nonatomic) IBOutlet UITextField *skillTF;

@end
