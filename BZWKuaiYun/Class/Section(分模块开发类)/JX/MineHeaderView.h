//
//  MineHeaderView.h
//  BZWKuaiYun
//
//  Created by Jessey Young on 2017/5/22.
//  Copyright © 2017年 ISU. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JXHeaderViewDelegate <NSObject>

- (void)headViewClick;

@end


@interface MineHeaderView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *backImg;
@property (weak, nonatomic) IBOutlet UIImageView *headImg;

@property (weak, nonatomic) IBOutlet UILabel *userNameLab;
@property (weak, nonatomic) IBOutlet UILabel *onTimeLab;
@property (weak, nonatomic) IBOutlet UILabel *refuseLab;
@property (weak, nonatomic) IBOutlet UILabel *grageLab;





@property (strong, nonatomic) id<JXHeaderViewDelegate>delegate;
@end
