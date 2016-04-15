//
//  PlayEnlishView.h
//  newIdea1.0
//
//  Created by yangshuo on 15/9/27.
//  Copyright (c) 2015年 xuGuohong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BookIndexModel.h"

typedef enum : NSUInteger {
    kPlayEventNameChange = 0,//名字来源
    kPlayEventNameDictation,//听写
    kPlayEventNameRead,//读
    kPlayEventNameLoop,//循环单句
    kPlayEventNameSpeedControl,//速度
    kPlayEventNameShareControl,//单句
    kPlayEventNameforwardMusic,//前进
    kPlayEventNamebackMusic,//后退
    kPlayEventNameSoundControl,//声音大小
    kPlayEventNameFrameChange,//位置
    kPlayEventNameReview,
    kPlayEventNamePlayFinish,//播放结束
    kPlayEventNameLoopMuSic//循环文章
} kPlayEventName;
static const float kContentViewH = 130; //总高度
static NSString *const kPlayItemPropertyTitle = @"kPlayItemPropertyTitle";//名字
static NSString *const kPlayItemPropertyArtist = @"kPlayItemPropertyArtist";//作者
static NSString *const kPlayItemPropertyPicture = @"kPlayItemPropertyPicture";//图片

typedef void (^PlayEnlishViewBlock)(kPlayEventName playEventName,BOOL state);

static float const kDelyTime = 0.4;//修正发音延迟
static float const kLoopSimpleSentenceCount = 1000;//默认循环次数
static float const kLastPlaySpaceTime = 2.0;//最后一次时间间隙

@interface PlayEnlishView : UIView

@property (nonatomic, strong) AVAudioPlayer *m_musicPlayer;
@property (nonatomic, strong) UISlider *durationSlider;

@property (nonatomic,assign) BOOL isLooping;
@property (nonatomic,assign) int loopCount;//循环次数
@property (nonatomic,assign) BOOL isLastSentence;//最后一句循环

@property (nonatomic,strong) NSDictionary *musicInfo;//信息

-(id)initPlayEnlishViewBlock:(PlayEnlishViewBlock)handler withSelectFileName:(NSString *)fileName;

//设置位置根据点击的控件
-(void)showInTargetShowView:(UIView *)tapView;

-(void)removeView;

//设置时间
- (void)setUpMusicPlayerTime:(float)time;

- (void)startPlay:(NSString *)fileName;

- (void)stopMusic;

- (void)setUpTopViewButonSource;//标题

- (void)startMusic;

//重置循环播放
- (void)resetLoopState;
//关闭循环
-(void)closeLoopState;
//主动开启循环
- (void)setUpLoopState;

-(void)changeLoopMusicWithModel:(PlayerModelType)type;

@end
