//
//  CommonViewController.m
//  jiuhaohealth4.1
//
//  Created by 徐国洪 on 15-9-1.
//  Copyright (c) 2015年 xuGuohong. All rights reserved.
//

#import "CommonViewController.h"
#import "MobClick.h"
#import "AppDelegate.h"
#import "KXShareManager.h"
//#import "DatabaseManager.h"
#import "DAO.h"
//#import "UIView+ActivityIndicator.h"
#import "UINavigationController+FDFullscreenPopGesture.h"

@interface CommonViewController ()

@end


@implementation CommonViewController
@synthesize autoSize, autoV, height, statusBarHeight, width, customTitle,m_isPopAndPushing,m_superDic;
@synthesize m_nowPage;


-(void)showLoadProgressView
{
    if (!m_loadingView)
    {
        m_loadingView = [SDLoopProgressView progressView];
        m_loadingView.frame = CGRectMake(0, 0, 100, 100);
        m_loadingView.centerX =   kDeviceWidth/2.0;
        m_loadingView.centerY =   kDeviceHeight/2.0 - 100;
        [self.view addSubview:m_loadingView];
        [self.view bringSubviewToFront:m_loadingView];
    }
}

-(void)removeProgressView
{
    [m_loadingView dismiss];
    m_loadingView = nil;
//    TT_RELEASE_SAFELY(m_loadingView);
//    TTVIEW_RELEASE_SAFELY(m_loadingView);
}
/**
 *  显示加载中
 */
- (void)showLoadingActiview
{
    [self displayOverFlowActivityView:@"玩命加载中.."];    
}

- (void)showLoadingActiviewOffY:(float)offY
{
//    [self.view showHUDIndicatorViewAtCenter:@"玩命加载中.." yOffset:offY];
}

- (void)displayOverFlowActivityView:(NSString*)indiTitle{
    
//    [self.view showHUDIndicatorViewAtCenter:indiTitle];
    return;
}

/**
 *  移除加载中view
 */
- (void)stopLoadingActiView
{
    [self removeOverFlowActivityView];
}

- (void)removeOverFlowActivityView
{
//    [self.view hideHUDIndicatorViewAtCenter];
}

- (BOOL)closeNowView
{
    NSMutableArray* array = [g_winDic objectForKey:[NSString stringWithFormat:@"%x", (unsigned int)self]];
    for (ASIHTTPRequest* asi in array) {
       // if (!asi.winCloseIsNoCancle) {
           [asi clearDelegatesAndCancel];
       // }
    }
    [g_winDic removeObjectForKey:[NSString stringWithFormat:@"%x", (unsigned int)self]];
    //    if (!m_isInNav) {
    //        [g_winDic removeObjectForKey:[NSString stringWithFormat:@"%x", (unsigned int)self]];
    //    }
    
    m_isClose = YES;
    return YES;
}

- (id)initWithNibName:(NSString*)nibNameOrNil bundle:(NSBundle*)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [g_winDic setObject:[NSMutableArray array] forKey:[NSString stringWithFormat:@"%x", (unsigned int)self]];
        //        UIButton* but = [UIButton buttonWithType:UIButtonTypeCustom];
        //        but.frame = CGRectMake(0, 0, 44, 44);
        //        [but setImage:[UIImage imageNamed:@"common.bundle/nav/back_nor.png"] forState:UIControlStateNormal];
        //
        UIBarButtonItem* backBar = [[UIBarButtonItem alloc] init];
        backBar.title = @"返回";
        self.navigationItem.backBarButtonItem = backBar;
        m_nowPage = 0;
    }
    return self;
}

- (void)butEventBack
{
    NSLog(@"123123123123123123123");
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    m_isInNav = [self.navigationController.viewControllers containsObject:self];
    
    hasMoreFlag = YES;
    self.view.backgroundColor = [CommonImage colorWithHexString:VERSION_BACKGROUD_COLOR2];
    // Do any additional setup after loading the view.
    height = self.view.frame.size.height;
    width = self.view.frame.size.width;
    if (iOS_Version >= 7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.automaticallyAdjustsScrollViewInsets = YES;
        
        self.autoSize = height / 416;
        self.autoV = height - 480;
        statusBarHeight = 20;
    } else {
        self.autoSize = height / 416;
        self.autoV = height - 460;
        statusBarHeight = 0;
    }
    
    [self sendStatisticsLog];
    self.fd_prefersNavigationBarHidden = self.m_isHideNavBar;
}

- (void)showNavigationBarLine
{
    if ([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]){
        
        NSArray *list = self.navigationController.navigationBar.subviews;
        
        for (id obj in list) {
            
            if ([obj isKindOfClass:[UIImageView class]]) {
                
                UIImageView *imageView=(UIImageView *)obj;
                
                NSArray *list2=imageView.subviews;
                
                for (id obj2 in list2) {
                    
                    if ([obj2 isKindOfClass:[UIImageView class]]) {
                        
                        UIImageView *imageView2=(UIImageView *)obj2;
                        imageView2.hidden = NO;
                        
                        imageView2.backgroundColor = [CommonImage colorWithHexString:@"cccccc"];
                        imageView2.height = 0.5;
                    }
                }
            }
        }
    }
}

- (void)hiddenNavigationBarLine
{
    if ([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]){
        
        NSArray *list = self.navigationController.navigationBar.subviews;
        
        for (id obj in list) {
            
            if ([obj isKindOfClass:[UIImageView class]]) {
                
                UIImageView *imageView=(UIImageView *)obj;
                
                NSArray *list2=imageView.subviews;
                
                for (id obj2 in list2) {
                    
                    if ([obj2 isKindOfClass:[UIImageView class]]) {
                        
                        UIImageView *imageView2=(UIImageView *)obj2;
                        
                        imageView2.hidden=YES;
                    }
                }
            }
        }
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [self hiddenNavigationBarLine];
    [MobClick beginLogPageView:self.title];
//     self.navigationController.navigationBar.hidden = self.m_isHideNavBar;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //	[MobClick beginLogPageView:[NSString stringWithFormat:@"%d", self.log_pageID]];//开启iOS7的滑动返回效果
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        //只有在二级页面生效
        //        if ([self.navigationController.viewControllers count] == 2) {
        //            self.navigationController.interactivePopGestureRecognizer.delegate = self;
        ////            self.navigationController.interactivePopGestureRecognizer.enabled = YES;
        //        }
    }
    self.m_isPopAndPushing = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
//    self.navigationController.navigationBar.hidden = NO;
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [MobClick endLogPageView:self.title];
    
    //    if (m_isInNav) {
    //        if (![self.navigationController.viewControllers containsObject:self])
    //        {
    //            [g_winDic removeObjectForKey:[NSString stringWithFormat:@"%x", (unsigned int)self]];
    //        }
    //    }
    
//    if (![self.navigationController.viewControllers containsObject:self])
//    {
//        if (loadView) {
//            [self stopLoadingActiView];
//        }
//    }
    //代理置空，否则会闪退
    //    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
    //        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    ////        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    //    }
    //	[MobClick endLogPageView:[NSString stringWithFormat:@"%d", self.log_pageID]];
    self.m_isPopAndPushing = NO;
}

- (void)sendStatisticsLog
{
    if (!g_nowUserInfo.userid || ![Common checkNetworkIsValid]) {
        return;
    }
}

- (void)setLog_pageID:(int)log_pageID
{
    [MobClick event:[NSString stringWithFormat:@"_%d", log_pageID]];
}

- (void)removeAllSubClassFromNetDic
{
}

/**
 *  分享功能
 */
- (void)goToShare
{
    [[KXShareManager  sharedManager] noneUIShareAllButtonClickHandler:self.view Content:self.shareContentString ImagePath:self.shareImage AndTitle:self.shareTitle Url:self.shareURL haveCustomItem:self.shareCustomItem];
}

- (NSString*)getShareURLType:(NSString*)type andId:(NSString*)idString
{
    NSString* shareURL = [NSString stringWithFormat:@"%@%@.html", Share_Server_URL,idString];
    return shareURL;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    [super preferredStatusBarStyle];
    return UIStatusBarStyleLightContent;
}

- (BOOL)prefersStatusBarHidden
{
    [super prefersStatusBarHidden];
    return NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    NSLog(@"dealloc--------dealloc");
//    [self closeNowView];
    NSMutableArray* array = [g_winDic objectForKey:[NSString stringWithFormat:@"%x", (unsigned int)self]];
    for (ASIHTTPRequest* asi in array) {
        //if (!asi.winCloseIsNoCancle) {
            [asi clearDelegatesAndCancel];
       // }
    }
//    if (!m_isInNav) {
    [g_winDic removeObjectForKey:[NSString stringWithFormat:@"%x", (unsigned int)self]];
//    }
    TT_RELEASE_SAFELY(customTitle);
    TT_RELEASE_SAFELY(m_superDic);
    TT_RELEASE_SAFELY(_shareTitle);
    TT_RELEASE_SAFELY(_shareContentString);
    TT_RELEASE_SAFELY(_shareImage);
    TT_RELEASE_SAFELY(_shareURL);
}

@end
