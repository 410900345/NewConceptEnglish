//
//  TopicDetailsViewController.m
//  jiuhaohealth2.1
//
//  Created by xjs on 14-8-31.
//  Copyright (c) 2014年 xuGuohong. All rights reserved.
//

#import "WebViewController.h"
#import "AppDelegate.h"
#import <MediaPlayer/MPMoviePlayerController.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVAudioPlayer.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "NJKWebViewProgressView.h"
#import "NJKWebViewProgress.h"
//#import "UMFeedbackViewController.h"

@interface WebViewController ()<UIWebViewDelegate, NJKWebViewProgressDelegate, AVAudioPlayerDelegate>
{

    
    BOOL isHiddenStatusBar;//隐藏状态栏
    BOOL m_isPlay;
    
    //进度条
    NJKWebViewProgressView *m_progressView;
    NJKWebViewProgress *m_progressProxy;
}
@property (nonatomic) CGRect defaultFrame;

@end
@implementation WebViewController
@synthesize m_webView;

#pragma mark - Life cycle
- (id)init
{
    self = [super init];
    if (self) {
        
        self.log_pageID = 65;
    }
    return self;
}

- (void)dealloc
{
//    [self setUpNilDelegate];
//    [self stopWebView];
//    [m_webView release];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"onPlayMusic" object:nil];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"onParuseMusic" object:nil];
//    //进度条
//    [m_progressView removeFromSuperview];
//    [m_progressProxy release];
//    
//    [super dealloc];
}

//-(void)setUpNilDelegate
//{
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
//    m_progressProxy.webViewProxyDelegate = nil;
//    m_progressProxy.progressDelegate = nil;
//    m_webView.delegate = nil;
//}
//- (void)viewDidLoad
//{
//    [super viewDidLoad];
//    
//    [self createWebView];
//    [self createJindu];
//    if (self.m_isHideNavBar) {
//        [self createNavigation];
//    }
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onPlayMusic) name:@"onPlayMusic" object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onParuseMusic) name:@"onParuseMusic" object:nil];
//}
//
////创建webView
//- (void)createWebView
//{
//    m_webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight + (self.m_isHideNavBar?(IOS_7?64:44):0))];
//    m_webView.delegate = self;
////    m_webView.scalesPageToFit = YES;
//    m_webView.backgroundColor = self.view.backgroundColor;
//    m_webView.opaque = NO;
//    m_webView.mediaPlaybackRequiresUserAction = NO;
//    
//    [self.view addSubview:m_webView];
//    m_webView.hidden = YES;
//    UIButton * btn = (UIButton*)[self.view viewWithTag:33];
//    [self.view bringSubviewToFront:btn];
//    
//    if (self.m_url) {
//        [self showLoadingActiview];
//        if (![self.m_url containsString:@"?"])
//        {
//            self.m_url = [self.m_url stringByAppendingString:@"?"];
//        }
//        else
//        {
//             self.m_url = [self.m_url stringByAppendingString:@"&"];
//        }
//        self.m_url = [self.m_url stringByAppendingFormat:@"token=%@",g_nowUserInfo.userToken];
//        [m_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.m_url]]];
//    }
//}
//
////创建进度条
//- (void)createJindu
//{
//    m_progressProxy = [[NJKWebViewProgress alloc] init];
//    m_webView.delegate = m_progressProxy;
//    m_progressProxy.webViewProxyDelegate = self;
//    m_progressProxy.progressDelegate = self;
//    
//    CGFloat progressBarHeight = 2.f;
//    CGRect barFrame = CGRectMake(0, 0, m_webView.width, progressBarHeight);
//    m_progressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
//    [self.view addSubview:m_progressView];
//}
//
//-(void)hidenprogressView
//{
//    m_progressView.hidden = YES;
//}
//
//- (BOOL)closeNowView
//{
//    [super closeNowView];
//    
//    if ([m_webView canGoBack]) {
//        NSString *url = [m_webView.request.URL absoluteString];
//        NSRange ran = [url rangeOfString:@"index.html"];
//        if (!ran.length) {
//            [m_webView goBack];
//            return NO;
//        }
//        else
//        {
//            [self stopWebView];
//            return YES;
//        }
//    }
//    else
//    {
//        [self stopWebView];
//        return YES;
//    }
//}
//
//-(void)stopWebView
//{
//    if (m_webView)
//    {
//        [m_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"about:blank"]]];
//    }
//}
//
//- (void)onPlayMusic
//{
//    [m_webView stringByEvaluatingJavaScriptFromString:@"onPlayMusic()"];
//}
//
//- (void)onParuseMusic
//{
//    [m_webView stringByEvaluatingJavaScriptFromString:@"onParuseMusic()"];
//}
//
//- (void)createNavigation
//{
//    UIButton* left = [UIButton buttonWithType:UIButtonTypeCustom];
//    left.frame = CGRectMake(10, IOS_7?20:0, 44, 44);
//    left.tag = 33;
//    [left addTarget:self action:@selector(popMySelf) forControlEvents:UIControlEventTouchUpInside];
//    left.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//    
//    [left setImage:[UIImage imageNamed:@"common.bundle/nav/icon_back_normal.png"] forState:UIControlStateNormal];
//    [left setImage:[UIImage imageNamed:@"common.bundle/nav/icon_back_pressed.png"] forState:UIControlStateHighlighted];
//    [self.view addSubview:left];
//}
//
//- (void)popMySelf
//{
//    //暂停音频播放
//   [self stopWebView];
//    [self.navigationController popViewControllerAnimated:YES];
//}
//
//
//#pragma mark - UIWebView Delegate
//- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
//{
//    NSURL * url = [request URL];   
//
//    if ([[url scheme] isEqualToString:@"topic"]) {
//        
//        NSString *strurl = [url absoluteString];
//        strurl = [strurl stringByReplacingOccurrencesOfString:@"topic:" withString:@""];
//        
////        [self createMovPlay:strurl];
//
//        return NO;
//    }
//    else if ([[url scheme] isEqualToString:@"ncechina"])
//    {
//            UMFeedbackViewController *modalViewController = [UMFeedbackViewController new];
//            modalViewController.modalStyle = YES;
//            [self presentModalViewController:modalViewController
//                                    animated:YES];
//            NSLog(@"跳转");
//            return NO;
//    }
//    else
//    {
//        return [self handleWebViewDataWithUrl:url];
//    }
//    return YES;
//}
//
//-(BOOL)handleWebViewDataWithUrl:(NSURL *)url
//{
//    return YES;
//}
//- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
//{
//    NSLog(@"didFailLoadWithError");
//    [self stopLoadingActiView];
//}
//
//- (void)webViewDidFinishLoad:(UIWebView*)webView
//{
//    m_webView.hidden = NO;
//    [self stopLoadingActiView];
//}
//
//#pragma mark - NJKWebViewProgressDelegate
//- (void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress
//{
//    [m_progressView setProgress:progress animated:YES];
////    self.title = [_webView stringByEvaluatingJavaScriptFromString:@"document.title"];
//}
//
//- (void)didReceiveMemoryWarning
//{
//    [super didReceiveMemoryWarning];
//}

#pragma mark 播放器相关

@end
