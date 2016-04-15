//
//  FileManagerModel.m
//  newIdea1.0
//
//  Created by jiuhao-yangshuo on 15/9/28.
//  Copyright © 2015年 xuGuohong. All rights reserved.
//

#import "FileManagerModel.h"
#import <AVFoundation/AVFoundation.h>
#import "NetAccess.h"
#import "AppUtil.h"
#import "NSString+SNFoundation.h"

@interface FileManagerModel()<NetAccessDelegate,AVAudioPlayerDelegate>
{
     AVAudioPlayer *m_musicPlayer;
    AVSpeechSynthesizer *m_synthesizer;
    NetAccess *myNet;
    SXBasicBlock m_callBack;
    
}
@end

@implementation FileManagerModel


@synthesize showView;

+ (instancetype)sharedFileManagerModel
{
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

-(id)init
{
    self = [super init];
    if (self)
    {
        [g_winDic setObject:[NSMutableArray array] forKey:[NSString stringWithFormat:@"%x", (unsigned int)self]];
    }
    return self;
}

-(void)dealloc
{
    if (m_callBack)
    {
        m_callBack = nil;
    }
     [g_winDic removeObjectForKey:[NSString stringWithFormat:@"%x", (unsigned int)self]];
}

+ (NSString *)getStringFromFileName:(NSString *)fileName
{
    NSString *fileStr = @"NCE1";
    NSString* pathname =  [[NSBundle mainBundle] pathForResource:fileName ?fileName:fileStr ofType:@"txt"];
    NSString* str = [NSString stringWithContentsOfFile:pathname encoding:NSUTF8StringEncoding error:nil];
    return str;
}

+ (NSArray *)getBookIndexWithBookItem:(ItemBookNum)bookNum
{
    NSArray *m_dataArray = @[@"1-24", @"25-48", @"49-72", @"73-96", @"97-120",@"121-144"];
    switch (bookNum) {
        case 0:
            break;
        case 1:
            m_dataArray = @[@"1-16", @"17-32", @"33-48", @"49-64", @"65-80",@"81-96"];
            break;
        case 2:
            m_dataArray = @[@"1-10", @"11-20", @"21-30", @"31-40", @"41-50",@"51-60" ];
            break;
        case 3:
            m_dataArray = @[@"1-8", @"9-16", @"17-24", @"25-32", @"33-40", @"41-48"];
            break;
        default:
            break;
    }
    return m_dataArray;
}

+ (NSString *)getBookNumStrIndexWithBookItem:(ItemBookNum)bookNum
{
    NSString *indexStr = @"一";
    switch (bookNum) {
        case 0:
            break;
        case 1:
            indexStr = @"二";
            break;
        case 2:
            indexStr = @"三";
            break;
        case 3:
            indexStr = @"四";
            break;
        default:
            break;
    }
    return indexStr;
}


#pragma mark - 读单词
- (void)readWordSystem:(NSString *)wordStr withMale:(BOOL)isMale
{
    if (!m_synthesizer)
    {
        m_synthesizer = [[AVSpeechSynthesizer alloc]init];
    }
    
    if (m_synthesizer.isSpeaking)
    {
        BOOL success = [m_synthesizer stopSpeakingAtBoundary:AVSpeechBoundaryImmediate];
        NSLog(@"---%d",success);
    }
    //    if (! m_synthesizer.isSpeaking)
    //    {
    AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:wordStr];
    if (isMale) //flag for male or female voice selected
    {
        // need US male voice as en-US is providing only US female voice
        utterance.voice = [AVSpeechSynthesisVoice voiceWithLanguage:@"en-GB"]; //UK male voice
    }
    else
    {
        utterance.voice = [AVSpeechSynthesisVoice voiceWithLanguage:@"en-US"]; //US female voice
    }
    [utterance setRate:0.02f];
    [m_synthesizer speakUtterance:utterance];
    //    }
}

//url 为语言网址
- (void)readWordFromResoure:(NSString *)wordStr withIsUk:(BOOL)isUK withUrl:(NSString *)url
{
     wordStr = [wordStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    wordStr = [wordStr stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
    NSString *wordPath = [AppUtil  getDocDownloadWordPath];
    NSFileManager *fileManage = [NSFileManager defaultManager];
    BOOL isDir;
    NSString *newFieName = [[self class] getExtensionWithFileName:wordStr withIsUk:isUK];
    NSString *indexBook = [NSString stringWithFormat:@"%@/%@",wordPath,newFieName];//doc/book/zipName-en
    //文件存在
    if(![fileManage fileExistsAtPath:indexBook isDirectory:&isDir])
    {
        NetWorkType type = [Common checkNetworkIsValidType];
        if(type == NetWorkType_None)
        {
            NSString *mReadWord = wordStr;//怕传入的url 不能正确本地读取
            if (self.readWord.length)
            {
                mReadWord = self.readWord;
            }
            [self readWordSystem:self.readWord withMale:YES];
            self.readWord = @"";
            return;
        }
        [self downloadbookWthName:wordStr withIsUk:isUK withUrl:url];
    }
    else
    {
        [self playMusic:indexBook];
    }
}

+(NSString *)getExtensionWithFileName:(NSString *)fileName withIsUk:(BOOL)isUK
{
    return  [NSString stringWithFormat:@"%@-%@",fileName,isUK?@"uk":@"us"];
}

-(void)downloadbookWthName:(NSString *)bookName withIsUk:(BOOL)isUK withUrl:(NSString *)url
{
    if (!myNet)
    {
        myNet = [[NetAccess alloc]init];       
        myNet.m_fileSavedocPath = [AppUtil  getDocDownloadWordPath];
    }
    [self showGetUrlAudioView];
    NSString *urlStr = url;
    if (!url.length)
    {
         urlStr = [NSString stringWithFormat:@"%@%@",isUK?KDownloadUKWordurl:KDownloadUSWordurl,bookName];
    }
     myNet.delegate = self;
    [myNet downLoadUrl:urlStr andProgressView:nil withBookName:[[self class] getExtensionWithFileName:bookName withIsUk:isUK]];
}

-(void)showGetUrlAudioView
{
//    if (showView)
//    {
        [Common MBProgressTishi:@"正在获取网络发音" forHeight:kDeviceHeight];
//        CommonViewController *view =  showView.viewController;
//        if ([view isKindOfClass:[CommonViewController class]])
//        {
//            view showLoadingActiview
//        }
//    }
}

-(void)downLoadFinishWithFilePath:(NSString *)filePath withFileName:(NSString *)fileName
{
    WS(weakSelf);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *downLoadFile = [filePath stringByAppendingPathComponent:fileName];//doc
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf playMusic:downLoadFile];
        });
    });
}

-(void)requestFailed
{
    NSLog(@"下载失败!");
}

-(void)setUpNilDelegate
{
    [myNet setUpNilDelegate];
    [m_musicPlayer stop];
    m_musicPlayer = nil;
    m_callBack = nil;
    m_musicPlayer.delegate = nil;
    if (m_synthesizer.isSpeaking)
    {
        BOOL success = [m_synthesizer stopSpeakingAtBoundary:AVSpeechBoundaryImmediate];
        NSLog(@"---%d",success);
    }
}

-(void)setUpCallBackBlock:(SXBasicBlock)block
{
    if (m_callBack != block)
    {
        if (m_callBack)
        {
            if (_cellInfoDict)
            {
                [_cellInfoDict setObject:@0 forKey:@"isPlay"];
            }
            m_callBack(@1);//取消动画
        }
        m_callBack = nil;
        m_callBack = [block copy];
    }
}

-(void)stopPlayMusic
{
    if (m_musicPlayer &&m_musicPlayer.isPlaying)
    {
        [m_musicPlayer stop];
        m_musicPlayer = nil;
    }
}

- (void) playMusic:(NSString *)file
{

    [self stopPlayMusic];
    // 1. 创建AVAudioPlayer播放器对象 这个播放器只能播放一个
    // 2. 加载文件
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
    if(![[NSFileManager defaultManager] fileExistsAtPath:file])
    {
        NSLog(@"文件不存在");
        return;
    }
    NSURL *url = [NSURL fileURLWithPath:file];
    m_musicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    // 3. 准备播放
    m_musicPlayer.enableRate = YES;
    [m_musicPlayer prepareToPlay];
    m_musicPlayer.delegate = self;
    m_musicPlayer.rate =  0.8; //速率变化
    
    if (_skipSecond > 0)
    {
        [m_musicPlayer setCurrentTime: (_skipSecond)];
    }
     // 4. 播放
      [m_musicPlayer play];
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    [m_musicPlayer pause];
    m_musicPlayer = nil;
    if (m_callBack)
    {
         m_callBack(@1);
    }
}

+(NSRange)handleRangeWithString:(NSString *)title
{
    NSRange range2 = [title rangeOfString:@"^"];
    if (range2.location == NSNotFound)
    {
//        range2 = [title rangeOfString:@"." options:NSAnchoredSearch range:NSMakeRange(10, title.length-10)];
//        if (range2.location == NSNotFound)
//        {
            NSRange range = [title rangeOfString:@"[\u4e00-\u9fa5]" options:NSRegularExpressionSearch];
            if (range.location == NSNotFound) {
               range2.location = title.length;
            }
            else
            {
                range2 = NSMakeRange(range.location-1, 1);
            }
//        }
    }
    return range2;
}

+(NSArray *)handleDataWithDetailText:(NSArray *)resutArray
{
    NSMutableArray *newArray = [NSMutableArray array];
    for (NSString *title in resutArray)
    {
        if (!title.length)
        {
            continue;
        }
        NSRange range1 = [title rangeOfString:@"]"];
        NSRange range2 = [[self class] handleRangeWithString:title];
        NSString *str1 = [title substringToIndex:range1.location+1];
        NSString *str2 = [title substringWithRange:NSMakeRange(range1.location+1, range2.location-range1.location-1)];
        NSString *str3 = @"";
        if (range2.location != title.length)
        {
            str3=  [title substringFromIndex:range2.location+1];
        }
        NSString *str4 = [FileManagerModel getTempTimeWitTime:str1];
        
        NSDictionary *dict = @{kTxtTime:str1,
                               kTxtDetail:str2,
                               kTxtChinese:str3,
                               kTxtTimeNum:str4,
                               };
        [newArray addObject:[dict mutableCopy]];
    }
    return newArray;
}

+ (NSString *)getTempTimeWitTime:(NSString *)timeStrNew
{
    NSString *tempStr = timeStrNew;
//    NSLog(@"---------%@",tempStr);
    NSString *string1 = [tempStr substringWithRange:NSMakeRange(1, 2)];
    NSString *string2 = [tempStr substringWithRange:NSMakeRange(4, tempStr.length-5)];
    float temPtime = string1.intValue *60 + string2.floatValue;
    NSString *returnStr = [NSString stringWithFormat:@"%.2f",temPtime];
    return returnStr;
}

+(BOOL)fileDBExistsAtWithName:(NSString *)name
{
    BOOL isExists = YES;
    NSString *pathString = [[AppUtil getDbPath] stringByAppendingFormat:@"/%@",name];
    NSFileManager *fileManage = [NSFileManager defaultManager];
    BOOL isDir;
    //文件存在
    isExists =[fileManage fileExistsAtPath:pathString isDirectory:&isDir];
    return isExists;
}


@end
