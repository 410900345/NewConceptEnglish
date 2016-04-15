//
//  AppDelegate.m
//  jiuhaoHealth2.0
//
//  Created by 徐国洪 on 14-3-4.
//  Copyright (c) 2014年 徐国洪. All rights reserved.
//

#import "AppDelegate.h"
#import "Global.h"
#import "KXPayManage.h"
#import "CommonHttpRequest.h"

#import <AVFoundation/AVAudioPlayer.h>
#import <AudioToolbox/AudioToolbox.h>
//#import "GuideViewController.h"
#import "AdvView.h"
#import "MobClick.h"
#import "DAO.h"
#import "DefauleViewController.h"
#import <AlipaySDK/AlipaySDK.h>
#include "CommonSet.h"
#import <ShareSDK/ShareSDK.h>
//#import "LoginViewController.h"
#import <BmobSDK/Bmob.h>
#import "UMFeedback.h"
#import "AppUtil.h"
#import "LaunchAdView.h"
//#import "HomeViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#import "GloblePlayer.h"
#import "KXShareManager.h"

@interface AppDelegate()<AdViewDelegate>

@end

@implementation AppDelegate
{
    AVAudioPlayer *alarmPlayer;
    long lastTime;
    int count;
    
}
@synthesize navigationVC;

- (void)dealloc
{
    self.tokenID = nil;
    self.channelID = nil;
    self.navigationVC = nil;
//    self.stepCounterObj = nil;
    self.stepShareDic = nil;
    
//    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    if(IOS_7){
        //        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        [[UINavigationBar appearance] setBarTintColor:[CommonImage colorWithHexString:Color_Nav]];

        
//        [[UINavigationBar appearance] setBarTintColor:[CommonImage colorWithHexString:Color_fafafa]];
        [[UINavigationBar appearance] setTintColor:[CommonImage colorWithHexString:@"ffffff"]];
        UIFont* font = [UIFont systemFontOfSize:18.0];
        NSDictionary* textAttributes = @{NSFontAttributeName:font, NSForegroundColorAttributeName:[CommonImage colorWithHexString:@"ffffff"]};
        [[UINavigationBar appearance] setTitleTextAttributes:textAttributes];
        
    }else{
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
        
        [application setStatusBarStyle:UIStatusBarStyleBlackTranslucent];
        [[UINavigationBar appearance] setTintColor:[CommonImage colorWithHexString:COLOR_FF5351]];
    }
//    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    [Common addSkipBackupAttributeToItemAtURL:[NSURL URLWithString:DOC_PATH]];
    [Fabric with:@[[Crashlytics class]]];
    
    //-----------------start 全局初始化-----------------
    g_winDic = [[NSMutableDictionary alloc] init];
    [g_winDic setObject:[NSMutableArray array] forKey:[NSString stringWithFormat:@"%x", (unsigned int)self]];
    
    g_iconArrayLock = [[NSLock alloc] init];
    g_imageArrayDic = [[NSMutableDictionary alloc] init];
    
    [self umengTrack];
    /*建表*/
    [DAO createTablesNeeded];
    [Bmob registerWithAppKey:KBmobKey];
    [AppUtil moveHomeJsonData];
     [KXShareManager sharedManager];
    //----------------------end-----------------------
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] ;
    self.window.backgroundColor = [CommonImage colorWithHexString:VERSION_BACKGROUD_COLOR];
    
    int run = [[[NSUserDefaults standardUserDefaults] objectForKey:@"Run"] intValue]+1;
    
    UIViewController *view;
    //本地标示
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    int GuideVersion = [[userDefaults objectForKey:@"GuideVersion"] intValue];
    
    //plist-标示
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    int newGuideVersion = [[infoDic objectForKey:@"GuideVersion"] intValue];
    

    view = [[DefauleViewController alloc] init];
//    LoginViewController*view1 = [[LoginViewController alloc] init];
//    view = [[CommonNavViewController alloc] initWithRootViewController:view1];
    
    //本地通知
//    UILocalNotification *theNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
//    if (theNotification)
//    {
//        [NotificationViews shareInstance].notifiDic = theNotification.userInfo;
//        [self stopSound];
//    }
    //远程通知
    NSDictionary* userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:run] forKey:@"Run"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    if (run != 9999) {
        if (run == 2) {
            
            [self performSelector:@selector(TipDialogComment) withObject:nil afterDelay:3*60];
        }
        else if (!((run-2)%5)) {
            
            [self performSelector:@selector(TipDialogComment) withObject:nil afterDelay:3*60];
        }
    }
    
    self.window.rootViewController = view;//view;
    [self.window makeKeyAndVisible];
    [self getAdvPic];
    //test yangshuo
//    [CommonSet checkAppUpdate];
    //testyangshuo
//    [AppUtil clearCachesWithAsyHomeList];
//    [KXPayManage setUpPayManage];
//    [WanpuConnect singleTaskApplication:application options:launchOptions];
    return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"onPlayMusic" object:nil];
//    self.isActiveFlag = YES;
//    application.applicationIconBadgeNumber = 0;
//    
//    [self.stepCounterObj stopBackTimer];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"open_Url" object:nil];
//    [NotificationViews  handleRemoteNotificationWithUserInfo:nil];
//      [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
    [GloblePlayer sharedInstance].isApplicationEnterBackground = NO;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    self.isActiveFlag = NO;
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"onParuseMusic" object:nil];
    
    BOOL isStopCountering = [[NSUserDefaults standardUserDefaults] boolForKey:@"isStopCountering"];
    if(!isStopCountering){
        //正在运行时 推入后台开启定位服务
//        [[LocationManager sharedManager] startSignificantChangeUpdates];
//        [self.stepCounterObj sendToBackground];
    }else{
        //否则关闭
//        [[LocationManager sharedManager] stopSingificantChangeUpdates];
    }
    UIApplication *myApp = [UIApplication sharedApplication];
    if ([myApp respondsToSelector:@selector(beginReceivingRemoteControlEvents)])
    {
        [myApp beginReceivingRemoteControlEvents];
        BOOL state = [self becomeFirstResponder];
        NSLog(@"---%d",state);
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:SXRadioViewSetSongInformationNotification object:nil userInfo:nil];
      [GloblePlayer sharedInstance].isApplicationEnterBackground = YES;
}

-(BOOL)canBecomeFirstResponder
{
    return YES;
}
- (void)remoteControlReceivedWithEvent:(UIEvent *)event
{
    NSString * statu = @"noState";
    if (event.type == UIEventTypeRemoteControl) {
        switch (event.subtype) {
            case UIEventSubtypeRemoteControlPause:
                statu = @"UIEventSubtypeRemoteControlPause";
                break;
            case UIEventSubtypeRemoteControlPreviousTrack:
                statu = @"UIEventSubtypeRemoteControlPreviousTrack";
                break;
            case UIEventSubtypeRemoteControlNextTrack:
                statu = @"UIEventSubtypeRemoteControlNextTrack";
                break;
            case UIEventSubtypeRemoteControlPlay:
                statu = @"UIEventSubtypeRemoteControlPlay";
                break;
            case UIEventSubtypeRemoteControlTogglePlayPause:
                 statu = @"UIEventSubtypeRemoteControlTogglePlayPause";
                 break;
            default:
                break;
        }
    }
    NSMutableDictionary * dict = [NSMutableDictionary new];
    [dict setObject:statu forKey:@"keyStatus"];
   [[NSNotificationCenter defaultCenter] postNotificationName:SXRadioViewStatusNotifiation object:nil userInfo:dict];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    
    //进入前台关闭后台服务
//    [self.stepCounterObj stopRuningInBackground];
    
    //    versioncheck_xhtml
//    NSDictionary *body = [[NSUserDefaults standardUserDefaults] objectForKey:@"versioncheck_xhtml"];
//    if (body) {
//        BOOL isCheck = [[body objectForKey:@"is_force_update"] boolValue];
//        int version_no = [[body objectForKey:@"version_no"] intValue];
//        
//        if (isCheck && version_no > (int)CFBundleVersion) {
//            UIAlertView *av = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"升级提示",nil) message:body[@"version_desc"] delegate:self cancelButtonTitle:NSLocalizedString(@"确认升级",nil) otherButtonTitles:nil, nil];
//            av.tag = 66;
//            [av show];
//            [av release];
//        }
//        else {
//            //强制升级标签
//            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"versioncheck_xhtml"];
//            [[NSUserDefaults standardUserDefaults] synchronize];
//        }
//        [self stopSound];
//    }

}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
//    [self.stepCounterObj writeToFileWithCurrentDic];//写入
    
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    //	NSString *str = [NSString stringWithFormat:@"%@", deviceToken];
//    [APService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *) error {
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

//ios8 之前
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    // 取得 APNs 标准信息内容
    //    NSDictionary *aps = [userInfo valueForKey:@"aps"];
    //    NSString *content = [aps valueForKey:@"alert"]; //推送显示的内容
    //    NSInteger badge = [[aps valueForKey:@"badge"] integerValue]; //badge数量
    //    NSString *sound = [aps valueForKey:@"sound"]; //播放的声音
//    if (!application.applicationState == UIApplicationStateActive)//非正在运行状态
//    {
//        [NotificationViews shareInstance].notifiDic = userInfo;
//    }
    // Required
//    [APService handleRemoteNotification:userInfo];
    [UMFeedback didReceiveRemoteNotification:userInfo];
    NSLog(@"------++++%@",userInfo);
}

//iOS 8 Remote Notification
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    switch ([[userInfo objectForKey:@"type"] intValue]) { //1预警 2.系统消息 3.@消息
        case 1:
            //            g_nowUserInfo.warningNotReadNum += 1;
            break;
        case 2:
            g_nowUserInfo.broadcastNotReadNum += 1;
            break;
        case 3:
            g_nowUserInfo.myMessageNoReadNum +=1;
            
            break;
    }
    g_nowUserInfo.totalunreadMsgCount += 1;
    
    
//    [APService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNoData);
}

//- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
//{
//    return [ShareSDK handleOpenURL:url wxDelegate:self];
//}
//

//ios9 以上两个都的实现
-(BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options
{
    return [self KxHandleUrl:url withApplication:app];
}

-(BOOL)KxHandleUrl:(NSURL *)url withApplication:(UIApplication *)application
{
    NSString *todayButtonTitle = [url host];
    
    if ([todayButtonTitle isEqualToString:kTodayWidget_ONE] || [todayButtonTitle isEqualToString:kTodayWidget_TWO]  || [todayButtonTitle isEqualToString:kTodayWidget_THREE]  ||[todayButtonTitle isEqualToString:kTodayWidget_FOUR] )
    {
        [self handleTodayButtonClickWithString:todayButtonTitle];
        return YES;
    }
    else if ([url.host isEqualToString:@"safepay"])
    {
//         [HBConnect parseURL:url application:application];
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
        }];
    }
    return YES;
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
     return [self KxHandleUrl:url withApplication:application];
//    if ([url.host isEqualToString:@"safepay"]) {
//        [HBConnect parseURL:url application:application];
//    }
    return YES;
}

#pragma mark 接受本地通知
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
//    application.applicationIconBadgeNumber -= 1;
//    NSDictionary *NotDict = notification.userInfo;
//    
//    if (![notification.userInfo[@"ActivityClock"] isEqualToString:@"123456789"])
//    {
//        if (application.applicationState == UIApplicationStateInactive )
//        {
//            [NotificationViews shareInstance].notifiDic = notification.userInfo;
//            if (alarmPlayer)
//            {
//                [alarmPlayer stop];
//            }
//            NSLog(@"app not running");
//        }
//        else if(application.applicationState == UIApplicationStateActive )
//        {
//            NSLog(@"didFinishLaunchingWithOptions");
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:notification.alertBody delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
//            [self createAudioplyerWithSoundName:notification.soundName];
//            alert.tag = 10001;
//            [alarmPlayer play];
//            [alert show];
//            if ([NotDict[@"isShake"] isEqualToString:@"Y"])
//            {
//                AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);//震动
//            }
//            NSLog(@"app running");
//        }
//    }
//    if ([notification.userInfo[@"ActivityClock"] isEqualToString:@"123456789"])
//    {
//        NSLog(@"消除计步器数目!");
//    }
//    NSLog(@"Receive Notify: %@", notification.userInfo);
}



#pragma mark Locations API
- (void)startSignificantChangeUpdates
{
//    [[LocationManager sharedManager] startSignificantChangeUpdates];
}

- (void)stopSingificantChangeUpdates
{
//    [[LocationManager sharedManager] stopSingificantChangeUpdates];
}

#pragma mark - Tools
- (void)umengTrack
{
    [self initCommonsSet];
    [MobClick setCrashReportEnabled:NO]; // 如果不需要捕捉异常，注释掉此行
#if DEBUG
    [MobClick setLogEnabled:YES];  // 打开友盟sdk调试，注意Release发布时需要注释掉此行,减少io消耗
#endif
    [MobClick setAppVersion:BundleVersion]; //参数为NSString * 类型,自定义app版本信息，如果不设置，默认从CFBundleVersion里取
    //
    [MobClick startWithAppkey:UMENG_APPKEY reportPolicy:(ReportPolicy) BATCH channelId:VERSION_CHANNEL_ID];
    //   reportPolicy为枚举类型,可以为 REALTIME, BATCH,SENDDAILY,SENDWIFIONLY几种
    //   channelId 为NSString * 类型，channelId 为nil或@""时,默认会被被当作@"App Store"渠道
    
//    [MobClick checkUpdate];   //自动更新检查, 如果需要自定义更新请使用下面的方法,需要接收一个(NSDictionary *)appInfo的参数
    //    [MobClick checkUpdateWithDelegate:self selector:@selector(updateMethod:)];
//    [UMCheckUpdate checkUpdateWithAppkey:UMENG_APPKEY channel:VERSION_CHANNEL_ID];
    
    [MobClick updateOnlineConfig];  //在线参数配置
    [UMFeedback setAppkey:UMENG_APPKEY];
    //    1.6.8之前的初始化方法
    //    [MobClick setDelegate:self reportPolicy:REALTIME];  //建议使用新方法
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onlineConfigCallBack:) name:UMOnlineConfigDidFinishedNotification object:nil];
}

- (void)onlineConfigCallBack:(NSNotification *)note {
    
    NSLog(@"online config has fininshed and note = %@", note.userInfo);
    [self initCommonsSet];
}

- (NSString*)getUserName
{
    NSUserDefaults* userDefault = [NSUserDefaults standardUserDefaults];
    NSString* username = [userDefault objectForKey:@"username"];
    return username;
}

- (NSString*)getUserPswd
{
    NSUserDefaults* userDefault = [NSUserDefaults standardUserDefaults];
    NSString* userpswd  = @"";
//    NSString* username = [userDefault objectForKey:@"username"];
//    NSString* userpswd = [SFHFKeychainUtils getPasswordForUsername:username andServiceName:BUNDLE_IDENTIFIER error:NULL];
    return userpswd;
}



- (void)setUserID:(NSString *)userID
{
//    [APService setTags:[NSSet setWithObjects:userID,nil] alias:userID callbackSelector:@selector(tagsAliasCallback:tags:alias:) target:self];
}


//网络加载
- (void)loadDataBegin
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:VERSION_APPID forKey:@"appId"];
    [dic setObject:@"0" forKey:@"source"];
    [dic setObject:CFBundleVersion forKey:@"version"];
    [dic setObject:@"0" forKey:@"clientType"];
    [dic setObject:@"zh_CN" forKey:@"clientLanguage"];
    [[CommonHttpRequest defaultInstance] sendNewPostRequest:URL_getCheck values:dic requestKey:URL_getCheck delegate:self controller:self actiViewFlag:0 title:0];
}

//Log
- (void)sendSetUpdateLog
{
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"sendSetUpdateLog"]) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:[NSNumber numberWithLong:[CommonDate getLongTime]] forKey:@"logTime"];
        [dic setObject:[Common getMacAddress] forKey:@"uniqueNum"];
        [dic setObject:[[UIDevice currentDevice] model] forKey:@"phoneModel"];
        [dic setObject:@"IOS" forKey:@"setupTerminal"];
        [dic setObject:@"app_store" forKey:@"channelId"];
        [dic setObject:@"com.jiuhaohealth.kangxun360.logback.log.app.SetupLogPojo" forKey:@"clazz"];
        NSString *str = [dic KXjSONString];
       
        NSMutableDictionary *dic2 = [NSMutableDictionary dictionary];
        [dic2 setObject:str forKey:@"logJson"];
        [[CommonHttpRequest defaultInstance] sendNewPostRequest:Send_Log values:dic2 requestKey:Send_Log delegate:self controller:self actiViewFlag:0 title:0];
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"sendSetUpdateLog"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

//广告
- (void)getAdvPic
{
//    NSString *url = [CommonSet getAdUrlInfoWithUrl];
//    if (url.length)
//    {
    WS(weakSelf);
        __block  LaunchAdView *launchAdView = [[LaunchAdView alloc] init];
        [launchAdView setDismissBlock:^(id content){
            //检查更新
            launchAdView = nil;
            [weakSelf postNotification];
        }];
        [launchAdView showOnWindow:self.window];
//    }
}

-(void)postNotification
{
//    [[NSNotificationCenter defaultCenter] postNotificationName:kActiveMsg object:nil];
}

-(void)initCommonsSet
{
    [[CommonSet sharedInstance] fillData];//获取数据
}

#pragma mark - Network Response Delegate
- (void)didFinishSuccess:(ASIHTTPRequest *)loader
{
    NSString *responseString = [loader responseString];
    NSDictionary * dic = [responseString KXjSONValueObject];
    
    NSDictionary *head = [dic objectForKey:@"head"];
    if (![[head objectForKey:@"state"] intValue]) {
        
        NSDictionary *body = [dic objectForKey:@"body"];
        
        if ([loader.username isEqualToString:URL_getCheck]) {
            
        }
        else if ([loader.username isEqualToString:URL_getadv]) {
        
        }
    }
}


- (void)TipDialogComment
{
    if(!self.isShowAlertViewFlag){
        return;
    }
    
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"给个好评吧!" message:@"你要是觉的我们做的还行,就去给个好评吧,谢谢您了!" delegate:self cancelButtonTitle:@"残忍滴拒绝" otherButtonTitles:@"仁慈滴赐一个", nil];
    av.tag = 785;
    [av show];

}



- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 785) {
        if (buttonIndex) {
            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:9999] forKey:@"Run"];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://itunes.apple.com/cn/app/id%@?mt=8", VERSION_APPID]]];
        }
        else {
        }
    }
    else if(alertView.tag == 66){
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:9999] forKey:@"Run"];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://itunes.apple.com/cn/app/id%@?mt=8", VERSION_APPID]]];
    }
    else if(alertView.tag == 10001)
    {
        NSLog(@"健康提醒处理");
        [self stopSound];
    }
    else {
        if (!buttonIndex) {
            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:9999] forKey:@"Run"];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://itunes.apple.com/cn/app/id%@?mt=8", VERSION_APPID]]];
        }
        [self stopSound];
    }
}

- (void)createAudioplyerWithSoundName:(NSString *)soundName
{
    //    NSString *path = [[NSBundle mainBundle]pathForResource:soundName ofType:@"caf"];
    NSString *mainBundlPath = [[NSBundle mainBundle] bundlePath];
    NSString *path =[mainBundlPath stringByAppendingPathComponent:soundName];
    //    NSString *path = [bundlePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.caf",soundName]];
    NSURL *url = [NSURL fileURLWithPath:path];
    if (!url)
    {
        return;
    }
    alarmPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:nil];
    //    -1无线循环
    alarmPlayer.numberOfLoops = 5;
}


- (void)stopSound
{
    if (alarmPlayer)
    {
        [alarmPlayer stop];
 
        alarmPlayer = nil;
    }
}

#pragma mark - NetWork Status

- (void)networkDidSetup:(NSNotification *)notification {
    //    [_infoLabel setText:@"已连接"];
    NSLog(@"已连接");
}

- (void)networkDidClose:(NSNotification *)notification {
    //    [_infoLabel setText:@"未连接。。。"];
    NSLog(@"未连接。。。");
}

- (void)networkDidRegister:(NSNotification *)notification {
    //    [_infoLabel setText:@"已注册"];
    NSLog(@"已注册");
}

- (void)networkDidLogin:(NSNotification *)notification {
    //    [_infoLabel setText:@"已登录"];
    NSLog(@"已登录");
}

- (void)networkDidReceiveMessage:(NSNotification *)notification {
    NSDictionary * userInfo = [notification userInfo];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reciveMesg" object:userInfo];
}

- (void)tagsAliasCallback:(int)iResCode tags:(NSSet*)tags alias:(NSString*)alias {
    //    NSLog(@"rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, tags , alias);
}


-(void)handleTodayButtonClickWithString:(NSString *)todayButtonTitle
{
    [[NSUserDefaults standardUserDefaults] setObject:todayButtonTitle forKey:@"kangxun_goToView"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UIView *view = [[touches anyObject] view];
    if (view.tag == 451) {
        NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:@"ADVInfo"];
        if ([[dic objectForKey:@"islink"] intValue]) {
            AdvView *adv = [[AdvView alloc] init];
            [self.window addSubview:adv];
     
        }
    }
}


@end
