//
//  JXSettingCell.m
//  BZWKuaiYun
//
//  Created by Jessey Young on 2017/5/27.
//  Copyright © 2017年 ISU. All rights reserved.
//

#import "JXSettingCell.h"

@implementation JXSettingCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    if ([JXTool verifyIsNullString:USERVOICECONTROL])
    {
        self.voiceSwitch.on = YES;
    }
    else
    {
        if ([USERVOICECONTROL isEqualToString:@"0"])
        {
            self.voiceSwitch.on = NO;
        }
        else if ([USERVOICECONTROL isEqualToString:@"1"])
        {
            self.voiceSwitch.on = YES;
        }
    }
    
    
}
- (IBAction)voiceChange:(UISwitch *)sender
{
    if (sender.isOn)
    {
        [kUserDefaults setObject:@"1" forKey:@"voiceControl"];
        [kUserDefaults synchronize];
        [[JXSoundPlayer defaultSoundPlayer]play:@"语音播报已打开"];
        SVSUCCESS(@"语音播报已打开", 1.5)
    }
    else
    {
        [kUserDefaults setObject:@"0" forKey:@"voiceControl"];
        [kUserDefaults synchronize];
        SVSUCCESS(@"语音播报已关闭", 1.5)
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    
}

@end
