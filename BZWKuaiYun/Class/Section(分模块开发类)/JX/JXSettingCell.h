//
//  JXSettingCell.h
//  BZWKuaiYun
//
//  Created by Jessey Young on 2017/5/27.
//  Copyright © 2017年 ISU. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JXSettingDelegate <NSObject>

- (void)theSwitchBtnClickChange;

@end


@interface JXSettingCell : UITableViewCell
@property (nonatomic, assign) id<JXSettingDelegate>delegate;
@property (weak, nonatomic) IBOutlet UISwitch *voiceSwitch;

@end
