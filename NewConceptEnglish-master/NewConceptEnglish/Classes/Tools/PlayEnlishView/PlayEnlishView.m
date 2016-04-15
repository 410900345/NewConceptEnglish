//
//  PlayEnlishView.m
//  newIdea1.0
//
//  Created by yangshuo on 15/9/27.
//  Copyright (c) 2015年 xuGuohong. All rights reserved.
//

#import "PlayEnlishView.h"
#import "ALButton.h"
#import "ContentViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "AppUtil.h"
#import "UIButton+EnlargeTouchArea.h"
#import "GloblePlayer.h"

static const CGFloat iPhoneScreenPortraitWidth = 320.f;

@interface ALMoviePlayerControlsBar : UIView

@property (nonatomic, strong) UIColor *color;

@end

# pragma mark - ALMoviePlayerControlsBar

@implementation ALMoviePlayerControlsBar

- (id)init {
    if ( self = [super init] )
    {
        self.opaque = NO;
    }
    return self;
}

- (void)setColor:(UIColor *)color
{
    if (_color != color)
    {
        _color = [color retain];
        [self setNeedsDisplay];
    }
}
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [_color CGColor]);
    CGContextFillRect(context, rect);
}

@end


static const float kTopContentViewH = 50;//控制栏
static const float DELTA = 5;//延迟
static const float kNstimerTime = 0.15;

@interface PlayEnlishView ()<ALButtonDelegate,AVAudioPlayerDelegate>

@property (nonatomic, strong) ALButton *playPauseButton;
@property (nonatomic, strong) UILabel *timeElapsedLabel;
@property (nonatomic, strong) UILabel *timeRemainingLabel;
@property (nonatomic, strong) ALButton *seekForwardButton;
@property (nonatomic, strong) ALButton *seekBackwardButton;
@property (nonatomic, strong) ALButton *hidenBarButton;
@property (nonatomic, strong) ALButton *soundButton;
@property (nonatomic, strong) ALButton *shareButton;

@property (nonatomic) BOOL timeRemainingDecrements;
@property (nonatomic, strong) NSTimer *durationTimer;

@end

@implementation PlayEnlishView
{
    UIView* m_view;
    PlayEnlishViewBlock _inBlock;
    UIView *m_contentView;
    UIView *targetView;//要放上面的view
    
    UILabel *currTimeLabel;
    UIView *m_topView;
    UIView *m_bottomView;
}
@synthesize m_musicPlayer;
@synthesize isLooping;
@synthesize loopCount;
@synthesize isLastSentence;
@synthesize musicInfo;

- (void)dealloc
{
    NSLog(@"--------dealloc-------PlayEnlishView");
    [self changeProximityMonitorEnableState:NO];
    TT_RELEASE_SAFELY(_inBlock);
    TT_RELEASE_SAFELY(musicInfo);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    TT_INVALIDATE_TIMER(_durationTimer);
    [self nilDelegates];
    TT_RELEASE_SAFELY(m_view);
    TT_RELEASE_SAFELY(m_contentView);
    TT_RELEASE_SAFELY(m_topView);
    TT_RELEASE_SAFELY(_durationSlider);
    TT_RELEASE_SAFELY(_timeElapsedLabel);
    TT_RELEASE_SAFELY(_timeRemainingLabel);
    [super dealloc];
}

- (void)nilDelegates
{
    _playPauseButton.delegate = nil;
    _seekForwardButton.delegate = nil;
    _seekBackwardButton.delegate = nil;
}
-(id)initPlayEnlishViewBlock:(PlayEnlishViewBlock)handler withSelectFileName:(NSString *)fileName
{
    self = [super initWithFrame:CGRectMake(0, 0, kDeviceWidth, kContentViewH)];
    if (self)
    {
        m_view = [[UIView alloc] initWithFrame:self.bounds];
        m_view.backgroundColor = [UIColor clearColor];
        [self addSubview:m_view];
        _inBlock = [handler copy];
        
        m_contentView = [[UIView alloc] init];
        m_contentView.backgroundColor = [UIColor clearColor];
        [self addSubview:m_contentView];
        m_contentView.frame = CGRectMake(0, 0, kDeviceWidth, kContentViewH);
        
        m_topView = [[self createTopView] retain];
        [m_contentView addSubview:m_topView];
        
        m_bottomView = [[self createBottomView] retain];
        [m_contentView addSubview:m_bottomView];
        [self setupPlayerWithFilename:fileName];
        
        isLooping = NO;
        loopCount = 0;
        isLastSentence = NO;
         [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackgroundControlRadioStatus:) name:SXRadioViewStatusNotifiation object:nil];
         [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackgroundSetSongInformation:) name:SXRadioViewSetSongInformationNotification object:nil];
#if (__IPHONE_OS_VERSION_MIN_REQUIRED >= 60000)
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(interruptionOccurred:)
                                                     name:AVAudioSessionInterruptionNotification
                                                   object:nil];
#endif
//         [self changeProximityMonitorEnableState:YES];//打开距离传感器
    }
    return self;
}

- (void)interruptionOccurred:(NSNotification *)notification
{
#if (__IPHONE_OS_VERSION_MIN_REQUIRED >= 60000)
    NSNumber *interruptionType = [[notification userInfo] valueForKey:AVAudioSessionInterruptionTypeKey];
    if ([interruptionType intValue] == AVAudioSessionInterruptionTypeBegan) {
        [self stopMusic];
    } else if ([interruptionType intValue] == AVAudioSessionInterruptionTypeEnded) {
//        [[AVAudioSession sharedInstance] setActive:YES error:nil];
        WSS(weakSelf);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf startMusic];
        });
    }
#endif
}

-(void)applicationDidEnterBackgroundControlRadioStatus:(NSNotification *)notification
{
    NSDictionary *dict = [notification userInfo];
    NSString * string = [dict objectForKey:@"keyStatus"];
    if ([string isEqualToString:@"UIEventSubtypeRemoteControlPause"])
    {
        [self stopMusic];
    }else if ([string isEqualToString:@"UIEventSubtypeRemoteControlPlay"])
    {
        [self startMusic];
    }
    else if ([string isEqualToString:@"UIEventSubtypeRemoteControlTogglePlayPause"])
    {
        [self playPausePressed:_playPauseButton];
    }else if ([string isEqualToString:@"UIEventSubtypeRemoteControlPreviousTrack"])
    {
        [self backMusic:nil];
    }else if ([string isEqualToString:@"UIEventSubtypeRemoteControlNextTrack"])
    {
        [self forwardMusic:nil];
    }
    else
    {
        NSLog(@"applicationDidEnterBackgroundControlRadioStatus --%@",dict);
    }
}

-(void)setupPlayerWithFilename:(NSString *)fileName
{
//    [[UIDevice currentDevice] setProximityMonitoringEnabled:NO];
    [self startPlay:fileName];
    [self monitorMoviePlayback]; //resume values
    [self startDurationTimer];
    //    m_musicPlayer.rate =  1; //速率变化
}

-(void)showInTargetShowView:(UIView *)tapView
{
    targetView = tapView;
    //    tapView.frameHeight -= kContentViewH;
    [tapView addSubview:self];
    self.frameY = kDeviceHeight - kContentViewH;
    [self showAnimation];
    _inBlock(kPlayEventNameFrameChange,YES);
}

#pragma mark - Set-getUi
-(UIView *)createBottomView
{
    ALMoviePlayerControlsBar *bottomView = [[[ALMoviePlayerControlsBar alloc]initWithFrame:CGRectMake(0, m_topView.height, kDeviceWidth, kContentViewH -kTopContentViewH)] autorelease];
    bottomView.color = [CommonImage colorWithHexString:@"1b1b1b"];
    _timeRemainingDecrements = NO;
    
    _durationSlider = [[UISlider alloc] init];
    _durationSlider.value = 0.f;
    _durationSlider.continuous = YES;
    _durationSlider.minimumTrackTintColor = [CommonImage colorWithHexString:Color_Nav];
    [_durationSlider setThumbImage:[UIImage imageNamed:@"common.bundle/player/seek_thumb_normal.png"] forState:UIControlStateNormal];
    [_durationSlider addTarget:self action:@selector(durationSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    [_durationSlider addTarget:self action:@selector(durationSliderTouchBegan:) forControlEvents:UIControlEventTouchDown];
    [_durationSlider addTarget:self action:@selector(durationSliderTouchEnded:) forControlEvents:UIControlEventTouchUpInside];
    [_durationSlider addTarget:self action:@selector(durationSliderTouchEnded:) forControlEvents:UIControlEventTouchUpOutside];
    
    _timeElapsedLabel = [[UILabel alloc] init];
    _timeElapsedLabel.backgroundColor = [UIColor clearColor];
    _timeElapsedLabel.font = [UIFont systemFontOfSize:12.f];
    _timeElapsedLabel.textColor = [UIColor whiteColor];
    _timeElapsedLabel.textAlignment = NSTextAlignmentRight;
    _timeElapsedLabel.text = @"0:00";
    _timeElapsedLabel.layer.shadowColor = [UIColor blackColor].CGColor;
    _timeElapsedLabel.layer.shadowRadius = 1.f;
    _timeElapsedLabel.layer.shadowOffset = CGSizeMake(1.f, 1.f);
    _timeElapsedLabel.layer.shadowOpacity = 0.8f;
    
    _timeRemainingLabel = [[UILabel alloc] init];
    _timeRemainingLabel.backgroundColor = [UIColor clearColor];
    _timeRemainingLabel.font = [UIFont systemFontOfSize:12.f];
    _timeRemainingLabel.textColor = [UIColor whiteColor];
    _timeRemainingLabel.textAlignment = NSTextAlignmentLeft;
    _timeRemainingLabel.text = @"0:00";
    _timeRemainingLabel.layer.shadowColor = [UIColor blackColor].CGColor;
    _timeRemainingLabel.layer.shadowRadius = 1.f;
    _timeRemainingLabel.layer.shadowOffset = CGSizeMake(1.f, 1.f);
    _timeRemainingLabel.layer.shadowOpacity = 0.8f;
    
    //static stuff
    _playPauseButton = [[ALButton alloc]init];
    [_playPauseButton setImage:[UIImage imageNamed:@"common.bundle/player/moviePause.png"] forState:UIControlStateNormal];
    [_playPauseButton setImage:[UIImage imageNamed:@"common.bundle/player/moviePlay.png"] forState:UIControlStateSelected];
    [_playPauseButton setSelected:m_musicPlayer.playing ? YES : NO];
    [_playPauseButton addTarget:self action:@selector(playPausePressed:) forControlEvents:UIControlEventTouchUpInside];
    _playPauseButton.delegate = self;
    
    _seekForwardButton = [[ALButton alloc] init];
    [_seekForwardButton setImage:[UIImage imageNamed:@"common.bundle/player/movieForward.png"] forState:UIControlStateNormal];
    [_seekForwardButton setImage:[UIImage imageNamed:@"common.bundle/player/movieForwardSelected.png"] forState:UIControlStateHighlighted];
    _seekForwardButton.delegate = self;
    [_seekForwardButton addTarget:self action:@selector(seekForwardPressed:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:_seekForwardButton];
    
    _shareButton = [[ALButton alloc] init];
//    [_shareButton setImage:[UIImage imageNamed:@"common.bundle/player/play_share_normal.png"] forState:UIControlStateNormal];
//    [_shareButton setImage:[UIImage imageNamed:@"common.bundle/player/play_share_press.png"] forState:UIControlStateHighlighted];
    [_shareButton setImage:[UIImage imageNamed:@"common.bundle/player/playcntrol_repeating.png"] forState:UIControlStateNormal];
    [_shareButton setImage:[UIImage imageNamed:@"common.bundle/player/playcntrol_repeating.png"] forState:UIControlStateHighlighted];
//    [_shareButton setImage:[UIImage imageNamed:@"common.bundle/player/playcntrol_repeating_hover.png"] forState:UIControlStateHighlighted | UIControlStateSelected];
    [_shareButton setImage:[UIImage imageNamed:@"common.bundle/player/playcntrol_repeating_hover.png"] forState:UIControlStateSelected];
    _shareButton.delegate = self;
    [_shareButton addTarget:self action:@selector(shareButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:_shareButton];
    
    _seekBackwardButton = [[ALButton alloc] init];
    [_seekBackwardButton setImage:[UIImage imageNamed:@"common.bundle/player/movieBackward.png"] forState:UIControlStateNormal];
    [_seekBackwardButton setImage:[UIImage imageNamed:@"common.bundle/player/movieBackwardSelected.png"] forState:UIControlStateHighlighted];
    _seekBackwardButton.delegate = self;
    [_seekBackwardButton addTarget:self action:@selector(seekBackwardPressed:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:_seekBackwardButton];
    
    _hidenBarButton = [[ALButton alloc] init];
    [_hidenBarButton setImage:[UIImage imageNamed:@"common.bundle/player/player_more_normal.png"] forState:UIControlStateNormal];
    [_hidenBarButton setImage:[UIImage imageNamed:@"common.bundle/player/player_more_press.png"] forState:UIControlStateHighlighted];
    [_hidenBarButton addTarget:self action:@selector(hidenTheMoview) forControlEvents:UIControlEventTouchUpInside];
    _hidenBarButton.delegate = self;
    [bottomView addSubview:_hidenBarButton];
    
    _soundButton= [[ALButton alloc] init];
    [_soundButton setImage:[UIImage imageNamed:@"common.bundle/player/bar_vlume.png"] forState:UIControlStateNormal];
//    [_soundButton setImage:[UIImage imageNamed:@"common.bundle/player/bar_vlume@.png"] forState:UIControlStateHighlighted];
    [_soundButton addTarget:self action:@selector(soundButtonPress) forControlEvents:UIControlEventTouchUpInside];
    _soundButton.delegate = self;
    [bottomView addSubview:_soundButton];
    
    [bottomView addSubview:_durationSlider];
    [bottomView addSubview:_timeElapsedLabel];
    [bottomView addSubview:_timeRemainingLabel];
    [bottomView addSubview:_playPauseButton];
//    TT_RELEASE_SAFELY(_playPauseButton);
//    TT_RELEASE_SAFELY(_soundButton);
    
    CGFloat labelWidth = 38.f;
    CGFloat playWidth = 40;
    CGFloat playHeight =playWidth;
    CGFloat sliderHeight = 25.f; //default height
    CGFloat paddingBetweenLabelsAndSlider = 8.f;
    CGFloat paddingBetweenButtonsAndSlider = 3.f;
    CGFloat seekWidth = playWidth+3;
    CGFloat seekHeight = seekWidth;
    CGFloat soundkWidth = 35.f;
    CGFloat paddingBetweenPlaybackButtons = self.frame.size.width <= iPhoneScreenPortraitWidth ? 35.f : 50.f;
    
    _timeElapsedLabel.frame = CGRectMake(0, paddingBetweenLabelsAndSlider, labelWidth, sliderHeight);
    _timeRemainingLabel.frame = CGRectMake(kDeviceWidth - labelWidth -soundkWidth, _timeElapsedLabel.top, labelWidth, sliderHeight);
    _soundButton.frame = CGRectMake(_timeRemainingLabel.right, 0, soundkWidth, soundkWidth);
 
    _durationSlider.frame = CGRectMake(_timeElapsedLabel.right + paddingBetweenLabelsAndSlider,_timeElapsedLabel.top, _timeRemainingLabel.left - paddingBetweenLabelsAndSlider*2- labelWidth, sliderHeight);
    _soundButton.centerY = _durationSlider.centerY;
    
    NSArray *buttonArray = @[_shareButton,_seekBackwardButton,_playPauseButton,_seekForwardButton,_hidenBarButton];
    float palyBottonW = kDeviceWidth/buttonArray.count;
    _playPauseButton.frame = CGRectMake(palyBottonW, _durationSlider.bottom +paddingBetweenButtonsAndSlider, palyBottonW, playHeight);
//    _playPauseButton.centerY = _playPauseButton.bottom + _playPauseButton;
    
    _shareButton.frame = CGRectMake(0, 0, palyBottonW, playHeight);
    _shareButton.centerY = _playPauseButton.centerY;
    
    _seekForwardButton.frame = CGRectMake(0, 0, palyBottonW, playHeight);
    _seekForwardButton.centerY = _playPauseButton.centerY;
    
    _seekBackwardButton.frame = CGRectMake(self.playPauseButton.frame.origin.x - paddingBetweenPlaybackButtons - seekWidth, 0, palyBottonW, playHeight);
    _seekBackwardButton.centerY = _playPauseButton.centerY;
    
    _hidenBarButton.frame = CGRectMake(kDeviceWidth -40, 0, palyBottonW, playHeight);
    _hidenBarButton.centerY = _playPauseButton.centerY;
    
    for (int i = 0; i<buttonArray.count; i++)
    {
        UIButton *view = buttonArray[i];
        view.frameX = palyBottonW*i;
        float space = (palyBottonW -playHeight)/2.0;
        view.contentEdgeInsets = UIEdgeInsetsMake(0, space, 0, space);
    }
    return bottomView;
}

-(UIView *)createTopView
{
    UIView *headerView = [[[UIView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, kTopContentViewH)] autorelease];
    BOOL state = [CommonUser getCurrentEnlishStateIsAmEnglish];
    NSString *title = state?@"美音":@"英音";
    NSArray *titleArray = @[title,@"听写",@"跟读",@"循环",@"调速"];
    NSArray *imageArray = @[@"voice_more_listen.png",
                            @"voice_more_write.png",
                            @"voice_more_speak.png",
//                            @"voice_more_recite.png",
                            @"voice_loop_Article",
                            @"voice_more_write.png"];
    headerView.backgroundColor = [CommonImage colorWithHexString:@"303030"];
    NSString *imageSelectLoop = @"common.bundle/book/voice_loop_Article_p.png";
    float kBtnW = 50;
//    float kSpaceW = (kDeviceWidth -UI_leftMargin*2 -kBtnW*(titleArray.count))/(titleArray.count -1);
    float kSpaceW = kDeviceWidth/titleArray.count;
    for (int i = 0; i< titleArray.count; i++)
    {
        float playHeight = kTopContentViewH- 15;
        UIButton *customBtton = [UIButton buttonWithType:UIButtonTypeCustom];
        customBtton.frame = CGRectMake(kSpaceW*i,0, kSpaceW,playHeight);
        customBtton.tag =1000+i;
        [customBtton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        NSString *imageString = [@"common.bundle/book/" stringByAppendingString:imageArray[i]];
        [customBtton setImage:[UIImage imageNamed:imageString] forState:UIControlStateNormal];
        [headerView addSubview:customBtton];
        float spaceToImage = 8;
        float space = (kSpaceW -playHeight)/2.0 +spaceToImage;
        customBtton.contentEdgeInsets = UIEdgeInsetsMake(spaceToImage, space, spaceToImage, space);
        if (i == 3)
        {
             [customBtton setImage:[UIImage imageNamed:imageSelectLoop] forState:UIControlStateSelected];
        }
        [customBtton setEnlargeEdgeWithTop:10 right:0 bottom:15 left:0];
        UILabel *m_titleLabel;
        m_titleLabel = [Common createLabel:CGRectMake(customBtton.left, customBtton.bottom , customBtton.width , 10) TextColor:@"ffffff" Font: [UIFont fontWithName:@"HelveticaNeue-Light" size:12] textAlignment:NSTextAlignmentCenter labTitle:titleArray[i]];
        [headerView addSubview:m_titleLabel];
        m_titleLabel.tag = 2000+i;
    }
    return headerView;
}

- (void)setUpTopViewButonSource
{
    //第一个
    UILabel *button = (UILabel *)[m_topView viewWithTag:2000];
    if (button)
    {
        BOOL state = [CommonUser getCurrentEnlishStateIsAmEnglish];
        button.text = state?@"美音":@"英音";
    }
}
#pragma mark - PrivateMethod
-(void)btnClick:(UIButton *)btn
{
    kPlayEventName palyEventName = kPlayEventNameChange;
    NSLog(@"%@",btn);
    switch (btn.tag - 1000) {
        case 0:
            palyEventName = kPlayEventNameChange;
            break;
        case 1:
            palyEventName = kPlayEventNameDictation;
            break;
        case 2:
            palyEventName = kPlayEventNameRead;
            break;
        case 3:
//            [self changeLoopMusic];
             palyEventName = kPlayEventNameLoopMuSic;
            break;
        case 4:
            palyEventName = kPlayEventNameSpeedControl;
            break;
        default:
            break;
    }
    if (_inBlock)
    {
        _inBlock(palyEventName,YES);
    }
}

//切换循环
-(void)changeLoopMusicWithModel:(PlayerModelType)type
{
    NSString *title = [BookIndexModel fetchPlayerModelPlayViewTitleWithPlayerModelType:type];
    UIButton *loopMusicBtn = [m_topView viewWithTag:1003];
//    loopMusicBtn.selected = !loopMusicBtn.selected;
//    m_musicPlayer.numberOfLoops = loopMusicBtn.selected?-1:0;
    UILabel *buttonLabel = (UILabel *)[m_topView viewWithTag:2003];
    if (buttonLabel)
    {
        buttonLabel.textColor = [CommonImage colorWithHexString:!loopMusicBtn.selected?@"ffffff":Color_Nav];
        buttonLabel.text = title;
    }
}

- (void)startPlay:(NSString *)fileName
{
    //    NSString *musicFile = [[NSBundle mainBundle] pathForResource:fileName ofType:nil];
    [self playMusic:fileName];
}

//显示
-(void)layoutFrameShow
{
    m_contentView.frameHeight = kContentViewH;
    m_bottomView.frameY = m_topView.height;
    self.frameY = kDeviceHeight - m_contentView.frameHeight;
    self.frameHeight = m_contentView.frameHeight;
    m_topView.frameY = m_bottomView.frameY;
    [UIView animateWithDuration:0.3 animations:^{
        m_topView.frameY = 0;
    }completion:^(BOOL finished) {
         _inBlock(kPlayEventNameFrameChange ,NO);
    }];
}
//隐藏
-(void)layoutFrameHiden
{
    m_contentView.frameHeight = kContentViewH - m_topView.height;
    self.frameY = kDeviceHeight - m_contentView.frameHeight;
    m_bottomView.frameY = 0;
    self.frameHeight = m_contentView.frameHeight;
    m_topView.frameY = -m_topView.height;
    [UIView animateWithDuration:0.3 animations:^{
        m_topView.frameY = 0;
    }completion:^(BOOL finished) {
        
    }];
     _inBlock(kPlayEventNameFrameChange,YES);
}

-(void)hidenTheMoview
{
    if (m_bottomView.frameY == 0)
    {
        [self layoutFrameShow];
    }
    else
    {
        [self layoutFrameHiden];
    }
}

-(void)soundButtonPress
{
    ContentViewController *cv = [[ContentViewController alloc]init];
    cv.m_musicPlayer = m_musicPlayer;
    [cv show];
}

- (void)forwardMusic:(id)arg
{
    kPlayEventName palyEventName = kPlayEventNameforwardMusic;
    if (_inBlock)
    {
        _inBlock(palyEventName,YES);
    }
}
- (void) backMusic:(id)arg
{
    kPlayEventName palyEventName = kPlayEventNamebackMusic;
    if (_inBlock)
    {
        _inBlock(palyEventName,YES);
    }
//    NSTimeInterval currTime = [m_musicPlayer currentTime];
//    currTime -= DELTA;
//    if (currTime < 0) currTime = 0;
//    [m_musicPlayer setCurrentTime:currTime];
}

- (void)pauseMusic:(id)sender
{
    // 暂停当前音乐
    [m_musicPlayer pause];
    // [m_musicPlayer stop];
    // play就是播放或者继续播放
    // 继续播放也是 [m_musicPlayer play]
}

- (void)playMusic:(NSString *)file
{
    NSAssert(file != nil, @"Argument must be non-nil");
    if (m_musicPlayer)
    {
        [m_musicPlayer stop];
         TT_RELEASE_SAFELY(m_musicPlayer);
        TT_INVALIDATE_TIMER(_durationTimer);
        [self startDurationTimer];
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
    if (error)
    {
        [AppUtil deleteSingleFilePath:fileName];
        return;
    }
    m_musicPlayer.delegate = self;
    m_musicPlayer.enableRate = YES;
    [m_musicPlayer prepareToPlay];
    [self setDurationSliderMaxMinValues];
    [self updateSet];
}

-(void)updateSet
{
    [m_musicPlayer play];
    WSS(weakSelf);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf updateSetInfo];
    });
    
    //设置相关 关闭自动播放设置
    BOOL m_isReadAuto = [[[CommonSet sharedInstance] fetchSystemPlistValueforKey:kPlayAuto] boolValue];
    if (m_isReadAuto)
    {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf stopMusic];
            _durationSlider.value = 0;
        });
    }
    float m_isPlayRate = [self fetchPlayerKey:kPlayRate withDefaut:1.0];//1.0
    m_musicPlayer.rate = m_isPlayRate;
    
    float m_isPlaySound = [self fetchPlayerKey:kPlaySound withDefaut:1.0];//1.0
    m_musicPlayer.volume = m_isPlaySound;
  
}

//默认数值
- (float )fetchPlayerKey:(NSString *)key  withDefaut:(float)defualt
{
    float value = [[[CommonSet sharedInstance] fetchSystemPlistValueforKey:key] floatValue];
    if (value < 0.01)
    {
         [[CommonSet sharedInstance] saveSystemPlistValue:@(1) forKey:key];
         value = 1.0;
    }
    NSLog(@"-------%f",value);
    return value;
}

-(void)updateSetInfo
{
    if ([GloblePlayer sharedInstance].isApplicationEnterBackground) {
        [self applicationDidEnterBackgroundSetSongInformation:nil];
    }
}

-(void)applicationDidEnterBackgroundSetSongInformation:(NSNotification *)notification
{
    if (NSClassFromString(@"MPNowPlayingInfoCenter")) {
        
        NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
        NSString *titleStr = [self createTitleStrWithKey:kPlayItemPropertyTitle withDefautStr:@"学英语"];
        NSString *titleArtist = [self createTitleStrWithKey:kPlayItemPropertyArtist withDefautStr:AppDisplayName];
        [dict setObject:titleStr forKey:MPMediaItemPropertyTitle];
//        [dict setObject:titleArtist forKey:MPMediaItemPropertyAlbumTitle];
        [dict setObject:titleArtist  forKey:MPMediaItemPropertyArtist];
        [dict setObject:[NSNumber numberWithDouble:m_musicPlayer.currentTime] forKey:MPNowPlayingInfoPropertyElapsedPlaybackTime]; //音乐当前已经播放时间
        [dict setObject:[NSNumber numberWithFloat:1.0] forKey:MPNowPlayingInfoPropertyPlaybackRate];//进度光标的速度 （这个随 自己的播放速率调整，我默认是原速播放）
        [dict setObject:[NSNumber numberWithDouble:m_musicPlayer.duration] forKey:MPMediaItemPropertyPlaybackDuration];//歌曲总时间设置
       
//        NSURL *url = [NSURL URLWithString:musicInfo[kPlayItemPropertyPicture]];
//        SDWebImageManager *manager = [SDWebImageManager sharedManager];
//        UIImage *imgPick;
//        if ([manager diskImageExistsForURL:url])
//        {
//            imgPick =  [[manager imageCache] imageFromDiskCacheForKey:url.absoluteString];
//            [dict setObject:[[MPMediaItemArtwork alloc] initWithImage:imgPick] forKey:MPMediaItemPropertyArtwork];
//        }
        [MPNowPlayingInfoCenter defaultCenter].nowPlayingInfo = nil;
        [MPNowPlayingInfoCenter defaultCenter].nowPlayingInfo = dict;
        TT_RELEASE_SAFELY(dict);
    }
}

-(void)updatePlayerTimeFromSuspend
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[[MPNowPlayingInfoCenter defaultCenter] nowPlayingInfo]];
    [dict setObject:[NSNumber numberWithDouble:m_musicPlayer.currentTime] forKey:MPNowPlayingInfoPropertyElapsedPlaybackTime]; //音乐当前已经过时间
    [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:dict];
}

-(NSString *)createTitleStrWithKey:(NSString *)keystr withDefautStr:(NSString *)defualtString
{
    NSString *valueStr = self.musicInfo[keystr];
    if (IsStrEmpty(valueStr))
    {
        valueStr = defualtString;
    }
    return valueStr;
}

#pragma mark - 接收方法的设置
- (void)removeView
{
//    [UIView animateWithDuration:0.35 animations:^{
        //        m_view.backgroundColor = [UIColor clearColor];
        m_contentView.frameY  = kDeviceHeight;
        //        targetView.frameHeight += kContentViewH;
//    } completion:^(BOOL finished) {
        TTVIEW_RELEASE_SAFELY(m_view);
        //        [self removeFromSuperview];
//    }];
    TT_INVALIDATE_TIMER(_durationTimer);
    [self nilDelegates];
    [m_musicPlayer stop];
    m_musicPlayer = nil;
    _durationSlider = nil;
}

-(void)showAnimation
{
    //    m_contentView.frameY  = kDeviceHeight;
    m_contentView.frameY = self.height;
    [UIView animateWithDuration:0.35 animations:^{
        //        m_view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
        //        m_contentView.frameY  = kDeviceHeight - kContentViewH;
        m_contentView.frameY  = 0;
    } completion:^(BOOL finished) {
        
    }];
}

# pragma mark - UIControl/Touch Events
- (void)startDurationTimer
{
    if (!self.durationTimer)
    {
        self.durationTimer = [NSTimer scheduledTimerWithTimeInterval:kNstimerTime target:self selector:@selector(monitorMoviePlayback) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.durationTimer forMode:NSDefaultRunLoopMode];
    }
}

- (void)stopDurationTimer {
    [self.durationTimer invalidate];
    self.durationTimer = nil;
}

- (void)monitorMoviePlayback
{
    float formatF = 100;
    double currentTime = ceil(m_musicPlayer.currentTime *formatF)/formatF;
//    NSLog(@"monitorMoviePlayback %f",currentTime);
    double totalTime = ceil(m_musicPlayer.duration *formatF)/formatF;
    [self setTimeLabelValues:currentTime totalTime:totalTime];
    //    self.durationSlider.value = ceil(currentTime);
    _durationSlider.value = currentTime;
}

- (void)setDurationSliderMaxMinValues
{
    CGFloat duration = m_musicPlayer.duration;
    _durationSlider.minimumValue = 0.f;
    _durationSlider.maximumValue = duration;
}
- (void)durationSliderTouchBegan:(UISlider *)slider {
    [m_musicPlayer pause];
    [self stopDurationTimer];
}

- (void)durationSliderTouchEnded:(UISlider *)slider {
    [m_musicPlayer setCurrentTime:floor(slider.value)];
    [m_musicPlayer play];
    [self startDurationTimer];
}

- (void)durationSliderValueChanged:(UISlider *)slider {
    double currentTime = floor(slider.value);
    double totalTime = floor(m_musicPlayer.duration);
    [self setTimeLabelValues:currentTime totalTime:totalTime];
}

- (void)playPausePressed:(UIButton *)button
{
     NSLog(@"playPausePressed------%d",m_musicPlayer.playing);
    if (m_musicPlayer.playing)
    {
        [m_musicPlayer pause];
        [self stopDurationTimer];
        
    }
    else
    {
        [m_musicPlayer play];
        [self startDurationTimer];
        [self updatePlayerTimeFromSuspend];
    }
    button.selected = !m_musicPlayer.playing;
    [self resetLoopState];
}

- (void)startMusic
{
    if (!m_musicPlayer.playing)
    {
        NSLog(@"startMusic-------%d",m_musicPlayer.playing);
        [self playPausePressed:_playPauseButton];
        NSLog(@"startMusic-------%d",m_musicPlayer.playing);
    }
}

- (void)stopMusic
{
    if (m_musicPlayer.playing)
    {
       [self playPausePressed:_playPauseButton];
    }
}

-(void)shareButtonPressed:(UIButton *)btn
{
//     NSString *palyEventName = kPlayEventNameShareControl;
    isLooping = !isLooping;
    btn.selected = isLooping;
    
    [self showLoopTipStr];
    loopCount = isLooping? kLoopSimpleSentenceCount :0;
    
    NSLog(@"------%d,------%d",isLooping,loopCount);
    kPlayEventName palyEventName = kPlayEventNameLoop;
    if (_inBlock)
    {
        _inBlock(palyEventName,YES);
    }
}

//提示框
-(void)showLoopTipStr
{
    NSString *loopTipStr = isLooping?@"开启单句循环模式":@"关闭单句循环模式";
    [Common MBProgressTishi:loopTipStr forHeight:kDeviceHeight];
}

-(void)closeLoopState
{
    if (isLooping)
    {
        [self setUpLoopState];
    }
}

-(void)setUpLoopState
{
    [self shareButtonPressed:_shareButton];
}

-(void)resetLoopState
{
//    NSLog(@"------%d,------%d",isLooping,loopCount);
    isLooping = NO;
    _shareButton.selected = isLooping;
    loopCount = 0;
//    [self showLoopTipStr];
}

- (void)seekForwardPressed:(UIButton *)button
{
    [self forwardMusic:nil];
//    [self durationSliderValueChanged:_durationSlider];
//    [self startDurationTimer];
//    [self resetLoopState];
}

- (void)seekBackwardPressed:(UIButton *)button
{
    [self backMusic:nil];
//    [self durationSliderValueChanged:_durationSlider];
//    [self startDurationTimer];
//    [self resetLoopState];
}

- (void)setTimeLabelValues:(double)currentTime totalTime:(double)totalTime
{
    double minutesElapsed = floor(currentTime / 60.0);
    double secondsElapsed = fmod(currentTime, 60.0);
    _timeElapsedLabel.text = [NSString stringWithFormat:@"%.0f:%02.0f", minutesElapsed, secondsElapsed];
    
    double minutesRemaining;
    double secondsRemaining;
    if (_timeRemainingDecrements) {
        minutesRemaining = floor((totalTime - currentTime) / 60.0);
        secondsRemaining = fmod((totalTime - currentTime), 60.0);
    } else {
        minutesRemaining = floor(totalTime / 60.0);
        secondsRemaining = floor(fmod(totalTime, 60.0));
    }
    _timeRemainingLabel.text = _timeRemainingDecrements ? [NSString stringWithFormat:@"-%.0f:%02.0f", minutesRemaining, secondsRemaining] : [NSString stringWithFormat:@"%.0f:%02.0f", minutesRemaining, secondsRemaining];
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag;
{
    NSLog(@"------%d",flag);
    if (flag)
    {
        kPlayEventName palyEventName = kPlayEventNamePlayFinish;
        if (_inBlock)
        {
            _inBlock(palyEventName,YES);
        }
    }
    @try {
         [self resetPlayer];
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}

-(void)resetPlayer
{
    self.playPauseButton.selected = YES;
    [m_musicPlayer setCurrentTime:0.0];
    [m_musicPlayer pause];
    [self stopDurationTimer];
    double currentTime = 0;
    [self resetLoopState];
    double totalTime = floor(m_musicPlayer.duration);
    [self setTimeLabelValues:currentTime totalTime:totalTime];
    [UIView animateWithDuration:0.5 animations:^{
        self.durationSlider.value = ceil(currentTime);
    }];
}

- (void)setUpMusicPlayerTime:(float)time
{
    [m_musicPlayer setCurrentTime:time];
    [self startMusic];
    [self monitorMoviePlayback];
}
#pragma mark - 近距离传感器

- (void)changeProximityMonitorEnableState:(BOOL)enable {
    [[UIDevice currentDevice] setProximityMonitoringEnabled:YES];
    if ([UIDevice currentDevice].proximityMonitoringEnabled == YES) {
        if (enable) {
            //添加近距离事件监听，添加前先设置为YES，如果设置完后还是NO的读话，说明当前设备没有近距离传感器
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sensorStateChange:) name:UIDeviceProximityStateDidChangeNotification object:nil];
        } else {
            //删除近距离事件监听
            [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceProximityStateDidChangeNotification object:nil];
            [[UIDevice currentDevice] setProximityMonitoringEnabled:NO];
        }
    }
}

- (void)sensorStateChange:(NSNotificationCenter *)notification {
    //如果此时手机靠近面部放在耳朵旁，那么声音将通过听筒输出，并将屏幕变暗
    if ([[UIDevice currentDevice] proximityState] == YES) {
        //黑屏
        NSLog(@"Device is close to user");
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
        
    } else {
        //没黑屏幕
        NSLog(@"Device is not close to user");
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
//        if (m_musicPlayer && !m_musicPlayer.isPlaying) {
//            //没有播放了，也没有在黑屏状态下，就可以把距离传感器关了
//            [[UIDevice currentDevice] setProximityMonitoringEnabled:NO];
//        }
    }
}
@end
