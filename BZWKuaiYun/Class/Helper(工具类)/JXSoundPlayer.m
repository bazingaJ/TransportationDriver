//
//  JXSoundPlayer.m
//  YOU+E_Driver
//
//  Created by  Jesse Enzo on 2017/4/1.
//  Copyright © 2017年 isu. All rights reserved.
//

#import "JXSoundPlayer.h"

static JXSoundPlayer * soundPlayer = nil;

@interface JXSoundPlayer ()

@property (nonatomic, strong) AVSpeechSynthesizer *synthesizer;

@end

@implementation JXSoundPlayer

+(instancetype)defaultSoundPlayer
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        soundPlayer=[[self alloc] init];
    });
    
    return soundPlayer;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (soundPlayer == nil)
        {
            soundPlayer = [super allocWithZone:zone];
        }
    });
    return soundPlayer;
}
- (BOOL)isPlaying
{
    if ([self.synthesizer isSpeaking])
    {
        return YES;
    }
    else
    {
        return NO;
    }
}
- (void)play:(NSString *)text
{
    if([[JXSoundPlayer defaultSoundPlayer] isPlaying])
    {
        [[JXSoundPlayer defaultSoundPlayer]stopNow];
    }
    if (![text isKindOfClass:[NSNull class]])
    {
        if (![text isEqualToString:@""])
        {
            self.synthesizer =[[AVSpeechSynthesizer alloc] init];
            AVSpeechUtterance * utterance =[[AVSpeechUtterance alloc] initWithString:text];
            utterance.voice=[AVSpeechSynthesisVoice voiceWithLanguage:@"zh-CN"];//设置语言
            utterance.volume=1.0; //设置音量 (0.0 ~ 1.0)
            NSString *strSysVersion = [[UIDevice currentDevice] systemVersion];
            NSLog(@"版本号%@",strSysVersion);
            NSLog(@"%f",[strSysVersion floatValue]);
            if ([strSysVersion floatValue]>9) {
                utterance.rate = .5; // 设置语速
            }else{
                utterance.rate = 0.1;
            }
            utterance.pitchMultiplier=1.0;
            [self.synthesizer speakUtterance:utterance];
        }
    }
    
}
- (void)stopNow
{
    if ([self.synthesizer isSpeaking])
    {
        [self.synthesizer stopSpeakingAtBoundary:AVSpeechBoundaryImmediate];
        AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:@""];
        [self.synthesizer speakUtterance:utterance];
        [self.synthesizer stopSpeakingAtBoundary:AVSpeechBoundaryImmediate];
    }
}


@end
