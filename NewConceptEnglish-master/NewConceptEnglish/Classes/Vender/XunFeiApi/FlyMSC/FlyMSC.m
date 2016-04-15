//
//  FlyMSC.m
//  jiuhaohealth3.0
//
//  Created by jiuhao-yangshuo on 15-1-20.
//  Copyright (c) 2015年 xuGuohong. All rights reserved.
//

#import "FlyMSC.h"
#import "iflyMSC/IFlySpeechConstant.h"
#import "iflyMSC/IFlySpeechUtility.h"
#import "iflyMSC/IFlyRecognizerView.h"
#import "iflyMSC/IFlySpeechRecognizerDelegate.h"
#import <iflyMSC/IFlyRecognizerView.h>
#import <iflyMSC/IFlySpeechRecognizer.h>
#import <iflyMSC/IFlySetting.h>
#import "iflyMSC/iflyMSC.h"

typedef enum : NSUInteger {
    STATE_Listening, //正在录声音
    STATE_Searching, //正在识别
    STATE_ERROR,     //出现错误
    STATE_GRAY,      //所有控件禁用
    STATE_NORMAL     //录音，识别被取消或停止
} STATE_UI;

static NSString *const Search_SpeakGoodsOrStore = @"请说出您要表达的内容";
static NSString *const Search_TheCoreTechnologyProvidedByiFLYTEK = @"核心技术由科大讯飞提供";
static NSString *const Search_Recognising = @"亲,正在识别中...";
static NSString *const Search_Searching = @"正在为您搜索";
static NSString *const Search_NotRecogniseYourVoice = @"亲,未识别出您的语音,请点击话筒重新开始!";

static NSString *const Search_NotRecogniseYourVoice2 = @"亲,未识别出您的语音,请点击话筒重新开始!";
static NSString *const Search_ClickTooMuch = @"亲，您点击太频繁了，请稍后重试!";
static NSString *const Search_RecogniseCancel = @"识别取消";
static NSString *const Search_NoRecogniseResult = @"无识别结果";
static NSString *const Search_RecogniseSuccess = @"识别成功";

static NSString *const Search_ServerIsBusy = @"亲，服务器正忙，请您稍后重试!";

#define APPID_VALUE @"54bdf863"
#define TIMEOUT_VALUE         @"20000"             // timeout      连接超时的时间，以ms为单位

@interface FlyMSC ()<IFlySpeechRecognizerDelegate,IFlyRecognizerViewDelegate>
{
    completionBlock _inBLock;
    IFlyRecognizerView *_iFlyRecognizerView;//识别有页面
    IFlySpeechRecognizer * _iFlySpeechRecognizer;//识别无页面
    UIView * m_view;
}
@property(nonatomic)BOOL                 isCanceled;
@property (nonatomic, copy) NSString      * result;
#pragma mark - UI
@property (nonatomic, strong) UILabel *labelTopTip; //顶部提示
@property (nonatomic, strong) UILabel *labelKeyWord; //识别出的用户的话
@property (nonatomic, strong) UILabel *labelBottomTip;  //科大讯飞的文案
@property (nonatomic, strong) UIButton *btnClose;   //关闭按钮
@property (nonatomic, strong) UIButton *btnCloseBig; //关闭按钮放大版
@property (nonatomic, strong) UIButton *btnSpeaker;  //话筒按钮
@property (nonatomic, strong) UIImageView *imgViewAnimation;  //动画控件
@property (nonatomic, assign) STATE_UI state; // set方法里调用了updateUI，不用再额外调用
@property (nonatomic, strong) NSMutableArray *arrayAnimationListening;
@property (nonatomic, strong) NSMutableArray *arrayAnimationSearching;
@property (nonatomic, strong) NSMutableArray *arrayAnimationEnding;      //识别结束

@end

@implementation FlyMSC
@synthesize isCanceled;

+(FlyMSC *)shareInstance
{
    static FlyMSC *shareManagerInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareManagerInstance = [[self alloc]init];
    });
    return shareManagerInstance;
}

-(void)dealloc
{
    _iFlySpeechRecognizer.delegate = nil;
    _iFlyRecognizerView.delegate = nil;
    _result = nil;
    TT_RELEASE_SAFELY(m_view);
    TT_RELEASE_SAFELY(_inBLock);
    TT_RELEASE_SAFELY(_iFlySpeechRecognizer);
    TT_RELEASE_SAFELY(_iFlyRecognizerView);
}

-(id)init
{
    self = [super init];
    if (self)
    {
        //设置log等级，此处log为默认在app沙盒目录下的msc.log文件
        [IFlySetting setLogFile:LVL_NONE];//不进行打印
        //输出在console的log开关
        [IFlySetting showLogcat:NO];
        
        //创建语音配置,appid必须要传入，仅执行一次则可
        NSString *initString = [NSString stringWithFormat:@"appid=%@,timeout=%@",APPID_VALUE,TIMEOUT_VALUE];
        //所有服务启动前，需要确保执行createUtility
        [IFlySpeechUtility createUtility:initString];
        
        /** IFlyFlowerCollector是统计的核心类，本身不需要实例化，所有方法以类方法的形式提供.
         */
        //        [IFlyFlowerCollector SetDebugMode:YES];
        //        [IFlyFlowerCollector SetCaptureUncaughtException:YES];
        //        [IFlyFlowerCollector SetAppid:APPID_VALUE];
        //        [IFlyFlowerCollector SetAutoLocation:YES];
        [self initiFlySpeechRecognizer];
    }
    return self;
}


//-(void)setIFlYRecognizerViewCenterInFatherView:(UIView *)fatherView
//{
//    _iFlyRecognizerView = [[IFlyRecognizerView alloc] initWithCenter:fatherView.center];
//    /**应用领域。
//     */
//    [_iFlyRecognizerView setParameter: @"search" forKey:[IFlySpeechConstant IFLY_DOMAIN]];
//    /**
//     返回结果的数据格式，可设置为json，xml，plain，默认为json。
//     */
//    [_iFlyRecognizerView setParameter:@"plain" forKey:[IFlySpeechConstant RESULT_TYPE]];
//    [_iFlyRecognizerView setParameter: @"16000" forKey:[IFlySpeechConstant SAMPLE_RATE]];
//    /**设置是否有标点符号
//     */
//    [_iFlyRecognizerView setParameter:@"0" forKey:[IFlySpeechConstant ASR_PTT]];
//    /** VAD前端点超时<br>
//     
//     可选范围：0-10000(单位ms)<br>
//     */
//    [_iFlyRecognizerView setParameter: @"1800" forKey:[IFlySpeechConstant VAD_BOS]];
//    [_iFlyRecognizerView setParameter: @"700" forKey:[IFlySpeechConstant VAD_EOS]];
//    
//    _iFlyRecognizerView.delegate = self;
//}

-(void)initiFlySpeechRecognizer
{
    _iFlySpeechRecognizer =  [IFlySpeechRecognizer sharedInstance];
    _iFlySpeechRecognizer.delegate = self;
    //设置为录音模式
    [_iFlySpeechRecognizer setParameter:IFLY_AUDIO_SOURCE_MIC forKey:@"audio_source"];
    [_iFlySpeechRecognizer setParameter: @"1800" forKey:[IFlySpeechConstant VAD_BOS]];
    [_iFlySpeechRecognizer setParameter: @"1000" forKey:[IFlySpeechConstant VAD_EOS]];
    [_iFlySpeechRecognizer setParameter:@"plain" forKey:[IFlySpeechConstant RESULT_TYPE]];
    [_iFlySpeechRecognizer setParameter: @"16000" forKey:[IFlySpeechConstant SAMPLE_RATE]];
    [_iFlySpeechRecognizer setParameter:@"0" forKey:[IFlySpeechConstant ASR_PTT]];
    [_iFlySpeechRecognizer setParameter: @"iat" forKey:[IFlySpeechConstant IFLY_DOMAIN]];
    //设置为非语义模式
    [_iFlySpeechRecognizer setParameter:@"0" forKey:[IFlySpeechConstant ASR_SCH]];
    //关闭保存录音
    [_iFlySpeechRecognizer setParameter:@"111" forKey:[IFlySpeechConstant ASR_AUDIO_PATH]];
}

-(void)setLanguageEn:(BOOL)isEn
{
    [_iFlySpeechRecognizer setParameter:isEn?@"en_us":@"zh_cn" forKey:[IFlySpeechConstant LANGUAGE]];
}

-(void)createIFlyRecognizerView:(UIView*)view
{
    if (![self canRecord])
    {
        return;
    }
    //创建识别
    self.result = @"";
    [self createVoiceView];
}

- (BOOL)canRecord
{
    __block BOOL bCanRecord = YES;
    if ([[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending)
    {
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        if ([audioSession respondsToSelector:@selector(requestRecordPermission:)]) {
            [audioSession performSelector:@selector(requestRecordPermission:) withObject:^(BOOL granted) {
                if (granted) {
                    bCanRecord = YES;
                } else {
                    bCanRecord = NO;
                }
            }];
        }
    }
    return bCanRecord;
}

//开启语音
-(void)startListen
{
    self.labelKeyWord.text = @"";
    self.result = @"";
    if (_iFlySpeechRecognizer.isListening)
    {
        self.labelTopTip.text = Search_ClickTooMuch;
        [self performSelector:@selector(restoreText) withObject:@"restoreText" afterDelay:0.5];
    }
    else
    {
        bool ret = [_iFlySpeechRecognizer startListening];
        self.isCanceled = NO;
        if (ret)
        {
            NSLog(@"正在识别+++++++");
        }
        else
        {
            NSLog(@"启动识别服务失败，请稍后重试");
            return;
        }
    }
}

- (void)restoreText
{
    self.labelTopTip.text = Search_SpeakGoodsOrStore;
}

-(void)createVoiceView
{
    m_view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight+64)];
    m_view.backgroundColor = [UIColor whiteColor];
    [APP_DELEGATE addSubview:m_view];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeAllVoiceView)];
    [m_view addGestureRecognizer:tap];
    
    WS(weakSelf);
    self.imgViewAnimation.center = self.btnSpeaker.center;
    self.btnCloseBig.center = self.btnClose.center;
    [m_view addSubview:self.labelTopTip];
    [m_view addSubview:self.labelKeyWord];
    [m_view addSubview:self.labelBottomTip];
    [m_view addSubview:self.btnClose];
    [m_view addSubview:self.imgViewAnimation];
    [m_view addSubview:self.btnCloseBig];
    [m_view addSubview:self.btnSpeaker];
    
    self.state = STATE_Listening;
    [self startListen];
}

-(void)removeView
{
    [UIView animateWithDuration:0.2 animations:^ {
//        _audioInputView.frameY = m_view.bottom;
        m_view.backgroundColor = [UIColor clearColor];
    } completion:^(BOOL is) {
//        [_audioInputView removeFromSuperview];
//        _audioInputView = nil;
        [m_view removeFromSuperview];
    }];
}

-(void)removeAllVoiceView
{
    [self removeView];
    [self onBtnCancel];
}

-(void)endIFlyRecognizerView
{
    [_iFlySpeechRecognizer cancel];
    [_iFlySpeechRecognizer setDelegate: nil];
}

-(void)listenword:(completionBlock)handler
{
    _inBLock = [handler copy];
    //    [self cancelRecognizer];
    //    BOOL start =[_iFlyRecognizerView start];
    //    if (start == NO)
    //    {
    //        NSLog(@"启动失败");
    //    }
    //    else
    //    {
    //        NSLog(@"启动成功");
    //    }
}

/*
 * @ 暂停录音
 */
- (void) onBtnStop
{
    [_iFlySpeechRecognizer stopListening];
}

/*
 * @取消识别
 */
- (void) onBtnCancel
{
    self.isCanceled = YES;
    [_iFlySpeechRecognizer cancel];
}

#pragma mark - IFlySpeechRecognizerDelegate
/**
 * @fn      onVolumeChanged
 * @brief   音量变化回调
 *
 * @param   volume      -[in] 录音的音量，音量范围1~100
 * @see
 */
- (void) onVolumeChanged: (int)volume
{
    //    NSLog(@"onVolumeChanged=%d",volume);
    //    if (self.isCanceled) {
    //
    //        [_popUpView removeFromSuperview];
    //
    //        return;
    //    }
    
//    _audioInputView.nowVolume = volume;
    //    NSString * vol = [NSString stringWithFormat:@"音量：%d",volume];
}

/** 识别结果回调
 
 在识别过程中可能会多次回调此函数，你最好不要在此回调函数中进行界面的更改等操作，只需要将回调的结果保存起来。
 
 使用results的示例如下：
 <pre><code>
 - (void) onResults:(NSArray *) results{
 NSMutableString *result = [[NSMutableString alloc] init];
 NSDictionary *dic = [results objectAtIndex:0];
 for (NSString *key in dic)
 {
 //[result appendFormat:@"%@",key];//合并结果
 }
 }
 </code></pre>
 
 @param   results     -[out] 识别结果，NSArray的第一个元素为NSDictionary，NSDictionary的key为识别结果，value为置信度。
 @param   isLast      -[out] 是否最后一个结果
 */

- (void)onResults:(NSArray *) resultArray isLast:(BOOL)isLast
{
    NSMutableString *resultString = [[NSMutableString alloc] init];
    NSDictionary *dic = [resultArray objectAtIndex:0];
    
    for (NSString *key in dic) {
        [resultString appendFormat:@"%@",key];
    }
    NSString *str = [NSString stringWithFormat:@"%@",resultString];
    NSLog(@"----------------%@",str);
    if (!IsStrEmpty(resultString))
    {
        self.result =[NSString stringWithFormat:@"%@%@", self.result,resultString];
        resultString = nil;
    }
    
    if (isLast)
    {
        if (!IsStrEmpty(self.result))
        {
            _inBLock(self.result,0);
        }
        [self removeView];
    }
}

-(BOOL)decideIsNullWithString:(NSString *)str
{
    if ([str isEqual:@" "]||[str length] == 0)
    {
        return YES;
    }
    return NO;
}

//取消识别
-(void)cancelRecognizer
{
    [_iFlyRecognizerView cancel];
}

/** 识别结束回调方法
 @param error 识别错误
 */
- (void)onError:(IFlySpeechError *)error
{
    //    [Common TipDialog2:@"识别结束"];
    NSLog(@"errorCode:%d----%@",error.errorCode,error.errorDesc);
}

/**
 * @fn      onBeginOfSpeech
 * @brief   开始识别回调
 *
 * @see
 */
- (void) onBeginOfSpeech
{
    NSLog(@"onBeginOfSpeech");
    
}

/**
 * @fn      onEndOfSpeech
 * @brief   停止录音回调
 *
 * @see
 */
- (void) onEndOfSpeech
{
    NSLog(@"onEndOfSpeech");
}

/**
 * @fn      onCancel
 * @brief   取消识别回调
 * 当调用了`cancel`函数之后，会回调此函数，在调用了cancel函数和回调onError之前会有一个短暂时间，您可以在此函数中实现对这段时间的界面显示。
 * @param
 * @see
 */
- (void) onCancel
{
    NSLog(@"识别取消");
}

#pragma mark - Set-getUi
#pragma mark - UI
- (UILabel *)labelTopTip
{
    if (!_labelTopTip)
    {
        _labelTopTip = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, kDeviceWidth, 20)];
        _labelTopTip.backgroundColor = [UIColor clearColor];
        _labelTopTip.textAlignment = NSTextAlignmentCenter;
        _labelTopTip.textColor = [CommonImage colorWithHexString:@"313131"];
        _labelTopTip.font = [UIFont systemFontOfSize:16];
        _labelTopTip.text = Search_SpeakGoodsOrStore;
        
    }
    
    return _labelTopTip;
}

- (UILabel *)labelKeyWord
{
    if (!_labelKeyWord)
    {
        _labelKeyWord = [[UILabel alloc] initWithFrame:CGRectMake(0, 145, kDeviceWidth, 20)];
        _labelKeyWord.backgroundColor = [UIColor clearColor];
        _labelKeyWord.textAlignment = NSTextAlignmentCenter;
        _labelKeyWord.textColor = [CommonImage colorWithHexString:@"313131"];
        _labelKeyWord.font = [UIFont systemFontOfSize:16];
        
    }
    
    return _labelKeyWord;
}

- (UILabel *)labelBottomTip
{
    if (!_labelBottomTip)
    {
        _labelBottomTip = [[UILabel alloc] initWithFrame:CGRectMake(0, m_view.height - 25, kDeviceWidth, 20)];
        _labelBottomTip.backgroundColor = [UIColor clearColor];
        _labelBottomTip.textAlignment = NSTextAlignmentCenter;
        _labelBottomTip.textColor = [CommonImage colorWithHexString:@"d2d2d2"];
        _labelBottomTip.font = [UIFont systemFontOfSize:13];
        _labelBottomTip.text = Search_TheCoreTechnologyProvidedByiFLYTEK;
    }
    
    return _labelBottomTip;
}

- (UIButton *)btnSpeaker
{
    if (!_btnSpeaker)
    {
        _btnSpeaker = [[UIButton alloc] initWithFrame:CGRectMake(0, m_view.height - 178, 80, 80)];
        _btnSpeaker.backgroundColor = [UIColor clearColor];
        [_btnSpeaker addTarget:self action:@selector(btnSpeakerTapped) forControlEvents:UIControlEventTouchUpInside];
        [_btnSpeaker setBackgroundImage:[UIImage imageNamed:@"VoiceSearch_SpeakerNormal"] forState:UIControlStateNormal];
        _btnSpeaker.centerX = kDeviceWidth/2.0;
    }
    
    return _btnSpeaker;
}

- (void)btnSpeakerTapped
{
    if (self.state == STATE_Listening)
    {
        [self startListen];
    }
    else if (self.state == STATE_Searching)
    {
        [self startListen];
        self.state = STATE_Listening;
    }
    else if (self.state == STATE_ERROR)
    {
        [self startListen];
        self.state = STATE_Listening;
    }
    else if (self.state == STATE_GRAY)
    {
        [self startListen];
        self.state = STATE_Listening;
    }
    else if (self.state == STATE_NORMAL)
    {
        [self startListen];
        self.state = STATE_Listening;
    }
    
}

- (void)updateUI
{
    switch (self.state) {
        case STATE_Listening:
        {
            self.labelTopTip.text = Search_SpeakGoodsOrStore;
            self.labelKeyWord.text = @"";
            
            [self.btnSpeaker setBackgroundImage:[UIImage imageNamed:@"button-Microphone-normal"] forState:UIControlStateNormal];
            
            self.imgViewAnimation.image = nil;
            self.imgViewAnimation.transform = CGAffineTransformIdentity;
            self.imgViewAnimation.animationImages = self.arrayAnimationListening;
            self.imgViewAnimation.animationDuration = 1.8;
            self.imgViewAnimation.animationRepeatCount = 0;
            [self.imgViewAnimation startAnimating];
            break;
        }
        case STATE_Searching:
        {
            self.labelTopTip.text = Search_Recognising;
            self.labelKeyWord.text = @"";
            
            [self.btnSpeaker setBackgroundImage:[UIImage imageNamed:@"button-Microphone-normal"] forState:UIControlStateNormal];
            
            self.imgViewAnimation.animationImages = nil;
            [self.imgViewAnimation stopAnimating];
            
            
            self.imgViewAnimation.image = [UIImage imageNamed:@"Animation-19.png"];
            
            CABasicAnimation* rotationAnimation;
            rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
            rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
            rotationAnimation.duration = 1;
            rotationAnimation.cumulative = YES;
            rotationAnimation.repeatCount = 1;
            rotationAnimation.removedOnCompletion = YES;
            rotationAnimation.delegate = self;
            
            [self.imgViewAnimation.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
            break;
        }
        case STATE_ERROR:
        {
            self.labelKeyWord.text = @"";
            
            [self.btnSpeaker setBackgroundImage:[UIImage imageNamed:@"button-Microphone-normal"] forState:UIControlStateNormal];
            
            self.imgViewAnimation.image = nil;
            self.imgViewAnimation.transform = CGAffineTransformIdentity;
            self.imgViewAnimation.animationImages = nil;
            break;
        }
        case STATE_GRAY:
        {
            self.labelTopTip.text = [NSString stringWithFormat:@"%@:",Search_Searching];
            self.labelKeyWord.text = self.result;
            
            [self.btnSpeaker setBackgroundImage:[UIImage imageNamed:@"button-Microphone-gray"] forState:UIControlStateNormal];
            
            
            self.imgViewAnimation.image = nil;
            self.imgViewAnimation.transform = CGAffineTransformIdentity;
            self.imgViewAnimation.animationImages = nil;
            break;
        }
        case STATE_NORMAL:
        {
            self.labelTopTip.text = Search_NotRecogniseYourVoice;
            
            
            [self.btnSpeaker setBackgroundImage:[UIImage imageNamed:@"button-Microphone-normal"] forState:UIControlStateNormal];
            
            self.imgViewAnimation.image = nil;
            self.imgViewAnimation.transform = CGAffineTransformIdentity;
            self.imgViewAnimation.animationImages = nil;
            break;
        }
            
        default:
            break;
    }
}

//识别的转圈动画完了后，还要有个收起动画
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if ([anim isKindOfClass:[CABasicAnimation class]])
    {
        self.imgViewAnimation.image = [UIImage imageNamed:@"Animation-20.png"];
        self.imgViewAnimation.transform = CGAffineTransformIdentity;
        self.imgViewAnimation.animationImages = self.arrayAnimationEnding;
        self.imgViewAnimation.animationDuration = 0.6;
        self.imgViewAnimation.animationRepeatCount = 1;
        [self.imgViewAnimation startAnimating];
    }
}

- (UIButton *)btnClose
{
    if (!_btnClose)
    {
        _btnClose = [[UIButton alloc] initWithFrame:CGRectMake(320 - 21 - 23, 35, 23, 23)];
        _btnClose.backgroundColor = [UIColor clearColor];
        [_btnClose addTarget:self action:@selector(btnCloseTapped) forControlEvents:UIControlEventTouchUpInside];
        [_btnClose setBackgroundImage:[UIImage imageNamed:@"VoiceSearch_CloseBtn"] forState:UIControlStateNormal];
    }
    
    return _btnClose;
}

- (UIButton *)btnCloseBig
{
    if (!_btnCloseBig)
    {
        _btnCloseBig = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
        _btnCloseBig.backgroundColor = [UIColor clearColor];
        [_btnCloseBig addTarget:self action:@selector(btnCloseTapped) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _btnCloseBig;
}


- (void)btnCloseTapped
{
    [_iFlySpeechRecognizer cancel];
    //    [self.iFlySpeechRecognizer setDelegate: nil];
    [self removeView];
}

- (UIImageView*)imgViewAnimation
{
    if (!_imgViewAnimation)
    {
        _imgViewAnimation = [[UIImageView alloc] initWithFrame:CGRectZero];
        _imgViewAnimation.contentMode = UIViewContentModeCenter;
        
        _imgViewAnimation.frame = CGRectMake((320 - 225) / 2, m_view.height - 220, 225, 225);
        _imgViewAnimation.animationDuration = 1.8 ;
    }
    
    return _imgViewAnimation;
}

- (NSMutableArray *)arrayAnimationListening
{
    if (!_arrayAnimationListening)
    {
        _arrayAnimationListening = [NSMutableArray array];
        for (int i = 1; i <= 18; i++)
        {
            NSString *strName = [NSString stringWithFormat:@"Animation-%d@2x.png", i];
            UIImage *image = [UIImage imageNamed:strName];
            if (image)
                [_arrayAnimationListening addObject:image];
        }
    }
    
    return _arrayAnimationListening;
}

- (NSMutableArray *)arrayAnimationSearching
{
    if (!_arrayAnimationSearching)
    {
        _arrayAnimationSearching = [NSMutableArray array];
        for (int i = 1; i <= 18; i++)
        {
            NSString *strName = [NSString stringWithFormat:@"Animation-%d@2x.png", i];
            UIImage *image = [UIImage imageNamed:strName];
            if (image)
                [_arrayAnimationSearching addObject:image];
        }
    }
    
    return _arrayAnimationSearching;
}

- (NSMutableArray *)arrayAnimationEnding
{
    if (!_arrayAnimationEnding)
    {
        _arrayAnimationEnding = [NSMutableArray array];
        for (int i = 21; i <= 25; i++)
        {
            NSString *strName = [NSString stringWithFormat:@"Animation-%d@2x.png", i];
            UIImage *image = [UIImage imageNamed:strName];
            if (image)
                [_arrayAnimationEnding addObject:image];
        }
    }
    
    return _arrayAnimationEnding;
}

- (void)setState:(STATE_UI)state
{
    _state = state;
    [self updateUI];
    
}

@end
