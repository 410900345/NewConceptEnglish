//
//  NceOneDoubleDetail.m
//  newIdea1.0
//
//  Created by jiuhao-yangshuo on 16/3/30.
//  Copyright © 2016年 YangShuo. All rights reserved.
//

#import "NceOneDoubleDetail.h"
#import "FileManagerModel.h"
#import "AppUtil.h"
#import "NceOneDoublePlayView.h"
#import "NetAccess.h"
#import "AppUtil.h"
#import "PlayEnlishView.h"

@interface NceOneDoubleDetail ()<UIWebViewDelegate,NetAccessDelegate>
{
    UIWebView *m_webView;
    NetAccess *myNet;
    PlayEnlishView *playView;
}
@end

@implementation NceOneDoubleDetail

#pragma mark -life cycle
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)dealloc
{
    m_webView.delegate = nil;
    m_webView = nil;
    [self closeNowView];
}

-(BOOL)closeNowView
{
    [myNet setUpNilDelegate];
    [playView removeView];
    myNet = nil;
    return [super closeNowView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"课文详情";
    // Do any additional setup after loading the view.
    _indexBook = [self.m_superDic[@"kBookIndexTxt"] integerValue];
    WS(weakSelf);
    
    BmobQuery *query = [BombModel getBombModelWothName:@"NceOneDoubleBean"];
    [query whereKey:@"index" equalTo:@(_indexBook)];
    query.limit = 1;
//    [self showLoadingActiview];
    //执行查询
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        [weakSelf fengzhuangArray:array withError:error];
    }];
}

-(void)createWebViewViewWithIndexbook:(NSInteger)index
{
    NSString *path = [AppUtil getDoubleBookHtmlPath];
    NSString* docPath = path;
    //找到Docutement目录
    NSString* jsonFile = nil;
    NSData* jsonData;
    if (docPath) {
        NSString *fileName = [NSString stringWithFormat:@"double_page/Lesson%03ld.html",_indexBook];
        jsonFile = [docPath stringByAppendingFormat:@"%@",fileName];
        NSString* jsonString = [NSString stringWithContentsOfFile:jsonFile encoding:NSUTF8StringEncoding error:nil];
        //将字符串写到缓冲区。
        jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    }
    m_webView= [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight-kContentViewH)];
    [self.view  addSubview:m_webView];
    m_webView.delegate = self;
    [m_webView setBackgroundColor:[UIColor clearColor]];
    NSString *str = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSString *fileName = [docPath stringByAppendingFormat:@"double_pic"];
    //     NSString *picFile = [@"double_pic" stringByAppendingFormat:@"%@",fileName];
    NSURL *baseURL = [NSURL fileURLWithPath:fileName];
    [m_webView loadHTMLString:str baseURL:baseURL];
}

-(void)fengzhuangArray:(NSArray*)array withError:(NSError *)error
{
    //错误处理
    if (error )
    {
        return;
    }
    __block NSMutableArray *firstArray = [NSMutableArray array];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (BmobObject *obj in array)
        {
            NSArray *array= @[@"title",@"index",@"fileUrl",@"mp3Url",@"updatedAt",
                              @"objectId"];
            NSDictionary *dict = [BombModel getDataFrom:obj withParam:array withDict:nil];
            [firstArray addObject:dict];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self loadMp3FileWithArray:firstArray];
        });
    });
}

-(void)loadMp3FileWithArray:(NSArray *)fileArray
{
    NSDictionary *dict = nil;
    if (fileArray.count)
    {
        dict = [fileArray firstObject];
    }
    if (!dict.count)
    {
        return;
    }
    NSString *urlStr = dict[@"mp3Url"];
    NSString *docPath = [AppUtil getDoubleBookHtmlPath];
    NSString *fileName = [self mp3FileName];
    NSInteger indexLession = _indexBook;
    NSString *filePath = [docPath stringByAppendingFormat:@"double_pic/Lesson%03ld/%@",indexLession,fileName];
    
    NSFileManager *fileManage = [NSFileManager defaultManager];
    BOOL isDir;
    if(![fileManage fileExistsAtPath:filePath isDirectory:&isDir])
    {
         [self downloadbookWthName:fileName withUrl:urlStr];
    }
    else
    {
        [self showPlayviewWithFileName:filePath];
    }
}


-(void)showPlayviewWithFileName:(NSString *)absolutePath
{
    WS(weakSelf);
    if (!playView)
    {
        playView = [[PlayEnlishView alloc]initPlayEnlishViewBlock:^(kPlayEventName playEventName,BOOL state) {
            [weakSelf handlePlayViewWEventWithName:playEventName];
        } withSelectFileName:absolutePath];
        [playView showInTargetShowView:self.view];
    }
    else
    {
        [playView startPlay:absolutePath];
    }
    
    [self.m_superDic setValue:self.m_superDic[@"kBookTxt"] forKey:kPlayItemPropertyTitle];
    playView.musicInfo = self.m_superDic;
    [self createWebViewViewWithIndexbook:_indexBook];
}

#pragma mark - PrivateMethod
-(void)handlePlayViewWEventWithName:(kPlayEventName)eventName
{
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)downloadbookWthName:(NSString *)bookName  withUrl:(NSString *)url
{
    if (!myNet)
    {
        myNet = [[NetAccess alloc]init];
        myNet.m_fileSavedocPath = [AppUtil  getDocDownloadWordPath];
    }
    [self showLoadingActiview];
    NSString *urlStr = url;
    myNet.delegate = self;
    NSString *docPath = [AppUtil getDoubleBookHtmlPath];
    NSInteger indexLession = _indexBook;
    NSString *filePath = [docPath stringByAppendingFormat:@"double_pic/Lesson%03ld",(long)indexLession];
    myNet.m_fileSavedocPath = filePath;
    NSString *fileName = [self mp3FileName];
    [myNet downLoadUrl:urlStr andProgressView:nil withBookName:fileName];
}

//mp3 名称
-(NSString *)mp3FileName
{
    NSInteger indexLession = _indexBook;
    NSString *fileName = [NSString stringWithFormat:@"NceLesson%03ld.mp3",(long)indexLession];
    return fileName;
}

-(void)downLoadFinishWithFilePath:(NSString *)filePath withFileName:(NSString *)fileName
{
    WS(weakSelf);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *downLoadFile = [filePath stringByAppendingPathComponent:fileName];//doc
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf stopLoadingActiView];
            [weakSelf showPlayviewWithFileName:downLoadFile];
        });
    });
}

@end
