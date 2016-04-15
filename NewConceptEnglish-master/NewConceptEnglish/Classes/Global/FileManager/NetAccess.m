//
//  NetAccess.m
//  BreakPointsDownload
//
//  Created by Visitor on 3/13/13.
//  Copyright (c) 2013 Visitor. All rights reserved.
//

#import "NetAccess.h"
#import "AppUtil.h"
#import "Reader.h"

static NSString *const kDownloadid = @"kDownloadid-----";

@implementation NetAccess
{
    // 网络消息队列
    ASINetworkQueue *_queue;
    NSString *_docPath;
    NSString *_docTempPath;
    UIProgressView *_pv;
    ASIHTTPRequest *_request;
    Reader *m_reader;
    NSMutableArray *m_dataArray;
    NSMutableArray *requestArray;
}
@synthesize delegate = _delegate;


- (void)dealloc
{
    [self setUpNilDelegate];
    TT_RELEASE_SAFELY(_request);
    TT_RELEASE_SAFELY(m_dataArray);
    TT_RELEASE_SAFELY(m_reader);
}

//- (void)btnClick:(UIButton *)btn
//{
//
//    if(btn.tag == 0)
//    {
//        if(_isDownLoadFinish)
//        {
//            NSLog(@"开始下载");
//            [_netAccess downLoad:[NSURL URLWithString:@"http://192.168.88.8/download/cityprotector.tar.bz2"] andProgressView:_downLoadProgressView];
//            _isDownLoadFinish = NO;
//        }
//        else
//        {
//
//        }
//    }
//    else if(btn.tag == 1)
//    {
//        if(_isSuspend)
//        {
//            NSLog(@"继续下载");
//            [_suspendBtn setTitle:@"暂停下载" forState:UIControlStateNormal];
//            [_netAccess downLoad:[NSURL URLWithString:@"http://192.168.88.8/download/cityprotector.tar.bz2"] andProgressView:_downLoadProgressView];
//        }
//        else
//        {
//            NSLog(@"暂停下载");
//            [_suspendBtn setTitle:@"继续下载" forState:UIControlStateNormal];
//            [_netAccess suspendDownLoad];
//        }
//        _isSuspend = !_isSuspend;
//    }
//}

//- (void)downLoadFinish
//{
//    _isDownLoadFinish = YES;
//    [_suspendBtn setTitle:@"暂停下载" forState:UIControlStateNormal];
//    _isSuspend = YES;
//}

-(id)init
{
    self = [super init];
    if (self)
    {
        m_dataArray = [[NSMutableArray alloc]init];
        requestArray = [[NSMutableArray alloc] init];
    }
    return self;
}

//+ (instancetype)sharedNetAccess
//{
//    static id sharedInstance = nil;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        sharedInstance = [[self alloc] init];
//    });
//    return sharedInstance;
//}
-(void)setUpNilDelegate
{
    _delegate = nil;
    for (ASIHTTPRequest *asi in requestArray)
    {
        asi.delegate = nil;
        [asi clearDelegatesAndCancel];
    }
    [self suspendDownLoad];
}

#pragma mark - DownloadMethod
- (void)downLoadUrl:(NSString *)urlStr andProgressView:(UIProgressView *)pv withBookName:(NSString *)bookName
{
    // 实例化消息队列
    //    _queue = [[ASINetworkQueue alloc] init];
    //    [_queue reset];
    //    [_queue setShowAccurateProgress:YES];
    //    [_queue go];
    _pv = nil;
    _pv = pv;
    //    urlStr = [NSString stringWithFormat:@"%@%@.hj",downloadurl,bookName];
    //     urlStr = [NSString stringWithFormat:@"http://tts.yeshj.com/uk/s/%s",[@"word" UTF8String]];
    urlStr=  [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSAssert(urlStr != nil, @"Argument must be non-nil");
    // 实例化请求
    
    _request = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:urlStr]];
    _request.delegate = self;
    [requestArray addObject:_request];
    // 下载完成文件路径
    if (self.m_fileSavedocPath)
    {
        _docPath = self.m_fileSavedocPath;
    }
    else
    {
        _docPath = [AppUtil getDocPath];
    }
    // 下载临时文件路径
    _docTempPath = [AppUtil getDocTempPath];
    //创建文件管理器
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //判断Documents文件夹目录下的temp文件夹是否存在
    if (![fileManager fileExistsAtPath:_docTempPath])
    {
        // 如果不存,创建一个temp文件夹,因为下载时,不会自动创建文件夹
        [fileManager createDirectoryAtPath:_docTempPath
               withIntermediateDirectories:YES
                                attributes:nil
                                     error:nil];
    }
    
    // 下载完成后文件保存路径
    NSString *savePath = [_docPath stringByAppendingPathComponent:bookName];
    // 下载中临时文件保存路径
    NSString *tempPath = [_docTempPath stringByAppendingPathComponent:bookName];
    // 设置文件保存路径
    [_request setDownloadDestinationPath:savePath];
    NSLog(@"文件保存路径:%@",savePath);
    // 设置临时文件路径
    [_request setTemporaryFileDownloadPath:tempPath];
    _request.timeOutSeconds = 60;
    NSLog(@"文件临时保存路径:%@",tempPath);
    // 设置进度条的代理
    [_request setDownloadProgressDelegate:_pv];
    // 设置是是否支持断点下载
    [_request setAllowResumeForFileDownloads:YES];
    // 设置下载文件的基本信息
    [_request setUserInfo:[NSDictionary dictionaryWithObjectsAndKeys:bookName,@"DownLoadID",nil]];
    NSLog(@"UserInfo=%@",_request.userInfo);
    
    [_request startAsynchronous];
    // 添加到ASINetworkQueue队列去下载
    //	[_queue addOperation:request];
    [self startLoad];
}

-(void)startLoad
{
    if (_pv)
    {
        return;
    }
    CommonViewController *view =_delegate;
    if (view &&[view isKindOfClass:[CommonViewController class]])
    {
        [view showLoadingActiview];
    }
}

-(void)hidenView
{
    if (_pv)
    {
        return;
    }
    CommonViewController *view =_delegate;
    if (view &&[view isKindOfClass:[CommonViewController class]])
    {
        [view stopLoadingActiView];
    }
}

// 暂停下载
- (void)suspendDownLoad
{
    // 暂停下载
    [_request clearDelegatesAndCancel];
}

// ASIHTTPRequestDelegate,下载之前获取信息的方法,主要获取下载内容的大小，可以显示下载进度多少字节
- (void)request:(ASIHTTPRequest *)request didReceiveResponseHeaders:(NSDictionary *)responseHeaders
{
    NSLog(@"didReceiveResponseHeaders-%@",[responseHeaders valueForKey:@"Content-Length"]);
    NSLog(@"下载内容大小contentlength=%.1f",request.contentLength/1024.0/1024.0);
    
    NSString *downLoadID = [request.userInfo objectForKey:@"downLoadID"] ;
    
    float allcontentlength = [[responseHeaders valueForKey:@"Content-Length"] floatValue];
    float receiveLength = request.contentLength/1024.0/1024.0;
    NSString *strAllcontent = [NSString stringWithFormat:@"%.1f-%.1f",receiveLength,allcontentlength];
    [[self class] savedowLoadIdReceiveLenght:strAllcontent withDownloadId:downLoadID];
}

//保存进度
+(void)savedowLoadIdReceiveLenght:(NSString *)receiveLengthStr withDownloadId:(NSString *)downLoadID
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:receiveLengthStr forKey:[NSString stringWithFormat:@"%@%@",kDownloadid,downLoadID]];
    [userDefaults synchronize];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSString *downLoadID = [request.userInfo objectForKey:@"DownLoadID"] ;
    NSLog(@"DownLoadID:%@ 下载完成",downLoadID);
    [self hidenView];
    if ([_delegate respondsToSelector:@selector(downLoadFinishWithFilePath:withFileName:)])
    {
        [_delegate downLoadFinishWithFilePath:_docPath withFileName:downLoadID];
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"下载失败");
    [self hidenView];
//    _pv.progress = 0.0;
    if ([g_winDic objectForKey:[NSString stringWithFormat:@"%x", (unsigned int)_delegate]])
    {
        if ([_delegate respondsToSelector:@selector(requestFailed)])
        {
            [_delegate requestFailed];
        }
    }
//    TT_RELEASE_SAFELY(_pv);
}

#pragma mark - PrivateMethod
-(void)importTextLineWithFilePath:(NSString *)filePath withFileName:(NSString *)fileName withDelegate:(id)delegate
{
    [m_dataArray removeAllObjects];
    self.delegate = delegate;
    WS(weakSelf);
    //    NSURL *fileURL = [filePath URLForResource:@"Clarissa Harlowe" withExtension:@"txt"];
    NSURL *fileURL = [[NSURL alloc ] initFileURLWithPath:[filePath stringByAppendingPathComponent:fileName]];
    @try {
        NSAssert([[NSFileManager defaultManager] fileExistsAtPath:[fileURL path]], @"Please download the sample data");
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        if (![[NSFileManager defaultManager] fileExistsAtPath:[fileURL path]])
        {
            [[AppUtil class] deleteBookFile];
            return;
        }
    }
    
    m_reader= [[Reader alloc] initWithFileAtURL:fileURL];
    [m_reader enumerateLinesWithBlock:^(NSUInteger i, NSString *line){
        line = [line stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
        NSString *strDec = [AppUtil decodeTextWithStr:line];
         __strong __typeof(weakSelf)strongSelf = weakSelf;
        if (strDec.length)
        {
            [strongSelf->m_dataArray addObject:strDec];
        }
        //        if ((i % 2000ull) == 0) {
        NSLog(@"i: %d -- %@", i,strDec);
        //        }
    } completionHandler:^(NSUInteger numberOfLines){
        NSLog(@"lines: %d", numberOfLines);
        [weakSelf.delegate  analysisFinishWithData:m_dataArray];
    }];
}


@end













