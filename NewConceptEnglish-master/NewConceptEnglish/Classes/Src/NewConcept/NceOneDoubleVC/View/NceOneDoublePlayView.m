//
//  NceOneDoublePlayView.m
//  newIdea1.0
//
//  Created by jiuhao-yangshuo on 16/4/12.
//  Copyright © 2016年 YangShuo. All rights reserved.
//

#import "NceOneDoublePlayView.h"
#import <MediaPlayer/MediaPlayer.h>
#import "GloblePlayer.h"

@interface NceOneDoublePlayView()<AVAudioPlayerDelegate>
{
    UIButton *_playPauseButton;
}
@end

@implementation NceOneDoublePlayView
{
      AVAudioPlayer *m_musicPlayer;
}

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        
    }
    return self;
}

//- (void)playMusic:(UIButton *)btn
//{
//    if(m_musicPlayer){
//        if(m_musicPlayer.playing){
//            //暂停转
//            btn.selected = NO;
//            [m_musicPlayer pause];
//        }else{
//            // 转
//            btn.selected = YES;
//            [m_musicPlayer play];
//        }
//
//        return;
//    }

//    NSString *filePath = _mp3Url;
//    NSURL *soundFileURL = [NSURL fileURLWithPath:filePath];
//    NSError * error;
//    player = [[AVAudioPlayer alloc] initWithContentsOfURL:soundFileURL error:&error];
////    player.volume = 0.5;
//    player.numberOfLoops = -1; //Infinite
//    [player prepareToPlay];
//    [player play];
//    btn.selected = YES;
//}

- (void)playPausePressed:(UIButton *)button
{
//    NSLog(@"playPausePressed------%d",m_musicPlayer.playing);
//    if (m_musicPlayer.playing)
//    {
//        [m_musicPlayer pause];
//        [self stopDurationTimer];
//        
//    }
//    else
//    {
//        [m_musicPlayer play];
//        [self startDurationTimer];
//        [self updatePlayerTimeFromSuspend];
//    }
//    button.selected = !m_musicPlayer.playing;
//    [self resetLoopState];
}

- (void)playMusic:(NSString *)file
{
    NSAssert(file != nil, @"Argument must be non-nil");
    if (m_musicPlayer)
    {
        [m_musicPlayer stop];
        TT_RELEASE_SAFELY(m_musicPlayer);
    }
    [self loadMusicFileName:file];
    _playPauseButton.selected = NO;
}

//封装系统加载函数
-(void)loadMusicFileName:(NSString*)fileName
{
    NSURL* url = [NSURL fileURLWithPath:fileName];
    NSAssert(url != nil, @"Argument must be non-nil");
    OSStatus osStatus;
    NSError * error;
    
    NSString *version = [[UIDevice currentDevice] systemVersion];
    if([version floatValue] >= 6.0f)
    {
        
        //        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback withOptions:AVAudioSessionCategoryOptionMixWithOthers error:nil];//后台播放
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
        //        [[AVAudioSession sharedInstance] setActive: YES error: &error];//静音状态下播放
        //        [[AVAudioSession sharedInstance] setDelegate:self];//设置代理 可以处理电话打进时中断音乐播放
    }
    else
    {
        osStatus = AudioSessionSetActive(true);
        UInt32 category = kAudioSessionCategory_MediaPlayback;
        osStatus = AudioSessionSetProperty(kAudioSessionProperty_AudioCategory, sizeof(category), &category);
        UInt32 allowMixing = true;
        osStatus = AudioSessionSetProperty(kAudioSessionProperty_OverrideCategoryMixWithOthers, sizeof (allowMixing), &allowMixing );
    }
    m_musicPlayer= [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    
    m_musicPlayer.delegate = self;
    m_musicPlayer.enableRate = YES;
    [m_musicPlayer prepareToPlay];
//    [self updateSet];
}

@end
