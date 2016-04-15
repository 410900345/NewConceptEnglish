//
//  FlySpeechEvaluator.m
//  newIdea1.0
//
//  Created by yangshuo on 15/10/13.
//  Copyright (c) 2015年 xuGuohong. All rights reserved.
//

#import "FlySpeechEvaluator.h"
#import "IFlyMSC/IFlyMSC.h"
#import "ISEResult.h"
#import "ISEResultXmlParser.h"
#import "ISEParams.h"
#import "TTSConfig.h"
#import "PcmPlayer.h"
#import "FlyMSC.h"
#import "AudioConvertManager.h"
#import "AppUtil.h"
#import <BmobSDK/Bmob.h>

@interface FlySpeechEvaluator()<IFlySpeechEvaluatorDelegate,ISEResultXmlParserDelegate>
@property (nonatomic, strong) IFlySpeechEvaluator *iFlySpeechEvaluator;
@property (nonatomic, copy) NSString *m_audioName;

@property (nonatomic, copy) NSString* resultText;
@property (nonatomic, assign) BOOL isSessionResultAppear;
@property (nonatomic, assign) BOOL isSessionEnd;
@property (nonatomic, strong) PcmPlayer *m_pcmPlayer;
@property (nonatomic, strong) ISEParams *iseParams;
@end

@implementation FlySpeechEvaluator
@synthesize speechEvaluatorContent;

-(id)init
{
    self = [super init];
    if (self)
    {
        [self initIFlySpeechEvaluator];
    }
    return self;
}

-(id)initWithAudioName:(NSString *)audioName
{
    self = [super init];
    if (self)
    {
        _m_audioName = audioName;
        [self initIFlySpeechEvaluator];
    }
    return self;
}

-(void)dealloc
{
    [_iFlySpeechEvaluator cancel];
    _iFlySpeechEvaluator.delegate = nil;
    _m_block = nil;
}

-(void)setM_block:(SXBasicBlock)block
{
    if (block != _m_block) {
        _m_block = [block copy];
    }
}

-(void)initIFlySpeechEvaluator
{
    [FlyMSC shareInstance];
    _iFlySpeechEvaluator = [IFlySpeechEvaluator sharedInstance];
    _iFlySpeechEvaluator.delegate = self;
    
    //清空参数，目的是评测和听写的参数采用相同数据
    [self.iFlySpeechEvaluator setParameter:@"" forKey:[IFlySpeechConstant PARAMS]];
    self.iseParams=[ISEParams fromUserDefaults];
    NSString *rootFilePath =  [Common datePath];
//    _m_audioName = [NSString stringWithFormat:@"%ld_%d.pcm", [CommonDate getLongTime], arc4random()%1000];
    if (!_m_audioName.length)
    {
        _m_audioName = @"record.pcm";
    }
    _recordPath = [rootFilePath stringByAppendingFormat:@"/%@",self.m_audioName];
   [self reloadCategoryText];
}

-(void)reloadCategoryText
{
    [IFlySpeechConstant ISE_AUDIO_PATH];
    TTSConfig *instance = [TTSConfig sharedInstance];
    [self.iFlySpeechEvaluator setParameter:self.iseParams.bos forKey:[IFlySpeechConstant VAD_BOS]];
    [self.iFlySpeechEvaluator setParameter:self.iseParams.eos forKey:[IFlySpeechConstant VAD_EOS]];
    [self.iFlySpeechEvaluator setParameter:self.iseParams.category forKey:[IFlySpeechConstant ISE_CATEGORY]];
    [self.iFlySpeechEvaluator setParameter:self.iseParams.language forKey:[IFlySpeechConstant LANGUAGE]];
    [self.iFlySpeechEvaluator setParameter:self.iseParams.rstLevel forKey:[IFlySpeechConstant ISE_RESULT_LEVEL]];
    [self.iFlySpeechEvaluator setParameter:self.iseParams.timeout forKey:[IFlySpeechConstant SPEECH_TIMEOUT]];
    [self.iFlySpeechEvaluator setParameter:instance.sampleRate forKey:[IFlySpeechConstant SAMPLE_RATE]];
    [self.iFlySpeechEvaluator setParameter:@"utf-8" forKey:[IFlySpeechConstant TEXT_ENCODING]];
    [self.iFlySpeechEvaluator setParameter:@"xml" forKey:[IFlySpeechConstant ISE_RESULT_TYPE]];
    [self.iFlySpeechEvaluator setParameter:self.m_audioName forKey:[IFlySpeechConstant ISE_AUDIO_PATH]];
}

/*!
 *  开始录音
 *
 *  @param sender startBtn
 */
- (void)onBtnStart
{
    NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    
    NSLog(@"text encoding:%@",[self.iFlySpeechEvaluator parameterForKey:[IFlySpeechConstant TEXT_ENCODING]]);
    NSLog(@"language:%@",[self.iFlySpeechEvaluator parameterForKey:[IFlySpeechConstant LANGUAGE]]);
    
    BOOL isUTF8=[[self.iFlySpeechEvaluator parameterForKey:[IFlySpeechConstant TEXT_ENCODING]] isEqualToString:@"utf-8"];
    BOOL isZhCN=[[self.iFlySpeechEvaluator parameterForKey:[IFlySpeechConstant LANGUAGE]] isEqualToString:KCLanguageZHCN];
    
    BOOL needAddTextBom=isUTF8&&isZhCN;
    NSMutableData *buffer = nil;
    
    NSString *textString = @"测试";
    if (self.speechEvaluatorContent)
    {
        textString = self.speechEvaluatorContent;
    }
    if(needAddTextBom){
        if(textString && [textString length]>0){
            Byte bomHeader[] = { 0xEF, 0xBB, 0xBF };
            buffer = [NSMutableData dataWithBytes:bomHeader length:sizeof(bomHeader)];
            [buffer appendData:[textString dataUsingEncoding:NSUTF8StringEncoding]];
            NSLog(@" \ncn buffer length: %lu",(unsigned long)[buffer length]);
        }
    }else{
        buffer= [NSMutableData dataWithData:[textString dataUsingEncoding:encoding]];
        NSLog(@" \nen buffer length: %lu",(unsigned long)[buffer length]);
    }
//    self.resultView.text =KCResultNotify2;
    self.resultText=@"";
    [self.iFlySpeechEvaluator startListening:buffer params:nil];
    self.isSessionResultAppear=NO;
    self.isSessionEnd=NO;
}

/*!
 *  暂停录音
 *
 *  @param sender stopBtn
 */
- (void)onBtnStop
{
    if(!self.isSessionResultAppear &&  !self.isSessionEnd){
//        self.resultView.text =KCResultNotify3;
        self.resultText=@"";
    }
    [self.iFlySpeechEvaluator stopListening];
//    [self.resultView resignFirstResponder];
//    [self.textView resignFirstResponder];
//    self.startBtn.enabled=YES;
}

/*!
 *  取消
 *
 *  @param sender cancelBtn
 */
- (void)onBtnCancel
{
    [self.iFlySpeechEvaluator cancel];
//    [self.resultView resignFirstResponder];
//    [self.textView resignFirstResponder];
//    [self.popupView removeFromSuperview];
//    self.resultView.text =KCResultNotify1;
    self.resultText=@"";
//    self.startBtn.enabled=YES;
}


/*!
 *  开始解析
 *
 *  @param sender parseBtn
 */
- (void)onBtnParse:(id)sender
{
    WS(weakSelf);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        ISEResultXmlParser* parser=[[ISEResultXmlParser alloc] init];
        parser.delegate=weakSelf;
        [parser parserXml:weakSelf.resultText];
    });
}

#pragma mark - IFlySpeechEvaluatorDelegate
/*!
 *  音量和数据回调
 *
 *  @param volume 音量
 *  @param buffer 音频数据
 */
- (void)onVolumeChanged:(int)volume buffer:(NSData *)buffer
{
        NSLog(@"volume:%d",volume);
//     [NSString stringWithFormat:@"音量：%d",volume]];
//    [self.view addSubview:self.popupView];
}
/*!
 *  开始录音回调
 *  当调用了`startListening`函数之后，如果没有发生错误则会回调此函数。如果发生错误则回调onError:函数
 */
- (void)onBeginOfSpeech {
    
}

/*!
 *  停止录音回调
 *    当调用了`stopListening`函数或者引擎内部自动检测到断点，如果没有发生错误则回调此函数。
 *  如果发生错误则回调onError:函数
 */
- (void)onEndOfSpeech
{
    [self finisBlockWithStr:kSpeechEvaluatorSuccess];
}

/*!
 *  正在取消
 */
- (void)onCancel {
    
}

/*!
 *  评测结果回调
 *    在进行语音评测过程中的任何时刻都有可能回调此函数，你可以根据errorCode进行相应的处理.
 *  当errorCode没有错误时，表示此次会话正常结束，否则，表示此次会话有错误发生。特别的当调用
 *  `cancel`函数时，引擎不会自动结束，需要等到回调此函数，才表示此次会话结束。在没有回调此函
 *  数之前如果重新调用了`startListenging`函数则会报错误。
 *
 *  @param errorCode 错误描述类
 */
- (void)onError:(IFlySpeechError *)errorCode
{
    if(errorCode && errorCode.errorCode!=0)
    {
        NSString *strError = [ NSString stringWithFormat:@"错误码：%d %@",[errorCode errorCode],[errorCode errorDesc]];
        NSLog(@"-----%@",strError);
        [self finisBlockWithStr:kSpeechEvaluatorError];
    }
    [self performSelectorOnMainThread:@selector(resetBtnSatus:) withObject:errorCode waitUntilDone:NO];
}

-(void)resetBtnSatus:(IFlySpeechError *)errorCode{
    
    if(errorCode && errorCode.errorCode!=0){
        self.isSessionResultAppear=NO;
        self.isSessionEnd=YES;
//        self.resultView.text =KCResultNotify1;
        self.resultText=@"";
    }else{
        self.isSessionResultAppear=YES;
        self.isSessionEnd=YES;
    }
//    self.startBtn.enabled=YES;
}

/*!
 *  评测结果回调
 *   在评测过程中可能会多次回调此函数，你最好不要在此回调函数中进行界面的更改等操作，只需要将回调的结果保存起来。
 *
 *  @param results -[out] 评测结果。
 *  @param isLast  -[out] 是否最后一条结果
 */
- (void)onResults:(NSData *)results isLast:(BOOL)isLast
{
    if (results) {
        NSString *showText = @"";
        
        const char* chResult=[results bytes];
        
        BOOL isUTF8=[[self.iFlySpeechEvaluator parameterForKey:[IFlySpeechConstant RESULT_ENCODING]]isEqualToString:@"utf-8"];
        NSString* strResults=nil;
        if(isUTF8){
            strResults=[[NSString alloc] initWithBytes:chResult length:[results length] encoding:NSUTF8StringEncoding];
        }else{
            NSLog(@"result encoding: gb2312");
            NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
            strResults=[[NSString alloc] initWithBytes:chResult length:[results length] encoding:encoding];
        }
        if(strResults){
            showText = [showText stringByAppendingString:strResults];
        }
        
        self.resultText=showText;
//        self.resultView.text = showText;
        self.isSessionResultAppear=YES;
        self.isSessionEnd=YES;
        [self onBtnParse:nil];
        if(isLast){
//            [self.popupView setText:@"评测结束"];
//            [self.view addSubview:self.popupView];
//            [self onBtnParse:nil];
            NSLog(@"123131313133");
        }
        
    }
    else{
        if(isLast){
//            [self.popupView setText:@"你好像没有说话哦"];
//            [self.view addSubview:self.popupView];
        }
        
        self.isSessionEnd=YES;
    }
//    self.startBtn.enabled=YES;
}

#pragma mark - ISEResultXmlParserDelegate

-(void)onISEResultXmlParser:(NSXMLParser *)parser Error:(NSError*)error
{
    
}

-(void)onISEResultXmlParserResult:(ISEResult*)result
{
    NSString *resultString  = [result toString];
    WS(weakSelf);
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf finisBlockWithStr:result];
    });
}

-(void)finisBlockWithStr:(id)str
{
    if (self.m_block)
    {
        self.m_block(str);
    }
}
#pragma mark - 播放uri合成音频
- (void)playUriAudioWithUrl:(NSString *)urlPath
{
    if (_m_pcmPlayer.isPlaying)
    {
        [_m_pcmPlayer stop];
        _m_pcmPlayer = nil;
    }
    TTSConfig *instance = [TTSConfig sharedInstance];
    NSError *error = [[NSError alloc] init];
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:&error];
    _m_pcmPlayer = [[PcmPlayer alloc] initWithFilePath:_recordPath sampleRate:[instance.sampleRate integerValue]];
    [_m_pcmPlayer play];
}

-(void)playUriAudioStop
{
    if (_m_pcmPlayer.isPlaying)
    {
        [_m_pcmPlayer stop];
        _m_pcmPlayer = nil;
    }
}
@end
