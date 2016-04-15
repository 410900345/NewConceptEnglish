//
//  DefauleViewController.m
//  jiuhaohealth2.1
//
//  Created by 徐国洪 on 14-7-26.
//  Copyright (c) 2014年 xuGuohong. All rights reserved.
//

#import "DefauleViewController.h"
//#import "HomeViewController.h"
#import "AppDelegate.h"
#import "DBOperate.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVAudioPlayer.h>
//#import "CommunityViewController.h"
//#import "PostListViewController.h"
//#import "PersonalViewController.h"
#import "CommonSet.h"
#import "SetInfoModel.h"

@interface DefauleViewController () <UINavigationControllerDelegate>
{
    long m_lastNewShowVC;
    long longTime;
    NSMutableDictionary *m_lastMsgDic;
    AppDelegate *myAppDelegate;
}

@end

@implementation DefauleViewController
@synthesize customBarView ,m_selectedViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        g_tabbarHeight = 49;
        m_prevViewControllersnum = -1;
        //
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clickOpenURL) name:@"open_Url" object:nil];
        //        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setTabbarTip) name:@"setTabbarTip" object:nil];
    }
    return self;
}

//将视图控制器的实例添加到标签栏中
- (void)creatViewControolers
{
//    HomeViewController *homeVC = [[HomeViewController alloc] init];
//    CommonNavViewController *nav1 = [[CommonNavViewController alloc] initWithRootViewController:homeVC];
//    nav1.m_DefalutViewCon = self;
//    nav1.view.backgroundColor = [UIColor redColor];
//    nav1.delegate = self;
//    m_selectedViewController = nav1;
//    
//    myAppDelegate = [Common getAppDelegate];
//    myAppDelegate.navigationVC = (CommonNavViewController*)m_selectedViewController;
//    
//    //圈子
//    CommunityViewController *com = [[CommunityViewController alloc] init];
//    com.m_tableHeight = kDeviceHeight - g_tabbarHeight;
//    CommonNavViewController *nav2 = [[CommonNavViewController alloc] initWithRootViewController:com];
//    nav2.m_DefalutViewCon = self;
//    nav2.delegate = self;
//    
//    PersonalViewController *Personal = [[PersonalViewController alloc] init];
//    CommonNavViewController *nav3 = [[CommonNavViewController alloc] initWithRootViewController:Personal];
//    nav3.m_DefalutViewCon = self;
//    Personal.m_tableHeight = kDeviceHeight - g_tabbarHeight;
//    nav3.delegate = self;
//    
//    //背单词
//    LearnWordViewController *learnWord = [[LearnWordViewController alloc] init];
//    com.m_tableHeight = kDeviceHeight - g_tabbarHeight;
//    CommonNavViewController *nav4 = [[CommonNavViewController alloc] initWithRootViewController:learnWord];
//    nav4.m_DefalutViewCon = self;
//    nav4.delegate = self;
//    
//    if (!IOS_7) {
//        nav1.view.frame = CGRectMake(0, 0, kDeviceWidth, kDeviceHeight + 44);
//        nav2.view.frame = CGRectMake(0, 0, kDeviceWidth, kDeviceHeight + 44);
//        nav3.view.frame = CGRectMake(0, 0, kDeviceWidth, kDeviceHeight + 44);
//        nav4.view.frame = CGRectMake(0, 0, kDeviceWidth, kDeviceHeight + 44);
//    }
//    
//    m_viewArray = [[NSArray alloc]initWithObjects:nav1,nav2, nav3,nav4,nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //    if (g_nowUserInfo.userid) {
    [self creatHomeView];
    //    }
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    //    [self setNeedsStatusBarAppearanceUpdate];
    [SetInfoModel crateInitdata];
}



- (void)creatHomeView
{
    [self creatViewControolers];
    //获取未读消息
    
    m_selectViewIndex = 0;
    m_selectedView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight - g_tabbarHeight)];
    m_selectedView = m_selectedViewController.view;
    [self.view addSubview:m_selectedView];
    m_selectedView.backgroundColor = [CommonImage colorWithHexString:VERSION_BACKGROUD_COLOR];
    
    //    [APP_DELEGATE2 setUserID:g_nowUserInfo.userid];
    
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setTabbarShowHiddle:) name:@"setTabbarShowHiddle" object:nil];
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setShowView:) name:@"setShowView" object:nil];
    
    [self creatCusetumBar];
    //    [self updateDB];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)updateDB
{
    //本地标示®
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *build = [userDefaults objectForKey:@"DBversionNum"];
    
    //plist-标示
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *newKangxunDBVersion = [infoDic objectForKey:@"DBversionNum"];
    
    if (!build) {
        build = newKangxunDBVersion;
        [userDefaults setObject:newKangxunDBVersion forKey:@"DBversionNum"];
    }
    
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    //    NSString *build = [[NSUserDefaults standardUserDefaults] objectForKey:@"versionNum"];
    //    build = !build ? @"0" : build;
    [dic setObject:build forKey:@"DBversionNum"];
    NSLog(@"versionNum==%@",build);
    [[CommonHttpRequest defaultInstance] sendNewPostRequest:UPDATE_DATA_DB values:dic requestKey:UPDATE_DATA_DB delegate:self controller:self actiViewFlag:0 title:0];
}



- (void)creatCusetumBar
{
    //获取七牛token
    //    [self getQiniuToken];
    // 创建一个自定义的imgeView ,作为底图
    customBarView = [[UIImageView alloc] init];
    customBarView.frame = CGRectMake(0,self.view.frame.size.height-49, kDeviceWidth, 49);
    customBarView.backgroundColor = [CommonImage colorWithHexString:Color_fafafa];
    customBarView.userInteractionEnabled = YES;
    customBarView.tag = 999;
    [self.view addSubview:customBarView];
    
    UILabel *lineLabel =  [Common createLineLabelWithHeight:0.5];
    lineLabel.backgroundColor = [CommonImage colorWithHexString:@"cccccc"];
    [customBarView addSubview:lineLabel];
    
    NSArray *arrayTabBarImage = [NSArray arrayWithObjects:
                                 [NSArray arrayWithObjects:@"common.bundle/myTab/home.png", @"common.bundle/myTab/home_p.png", @"首页", nil],
//                                 [NSArray arrayWithObjects:@"common.bundle/myTab/quanzi.png", @"common.bundle/myTab/quanzi_p.png",@"背单词", nil],
                                 [NSArray arrayWithObjects:@"common.bundle/myTab/quanzi.png", @"common.bundle/myTab/quanzi_p.png",@"圈子", nil],
                                 [NSArray arrayWithObjects:@"common.bundle/myTab/me.png", @"common.bundle/myTab/me_p.png", @"我", nil],
                                 nil];
    CGFloat widht = kDeviceWidth/arrayTabBarImage.count;
    UIButton *btn;
    //    UILabel *labTip;
    NSArray *array;
    CGRect rect;
    NSString *title;
    for (int i = 0; i < [arrayTabBarImage count]; i++)
    {
        array = [arrayTabBarImage objectAtIndex:i];
        btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(widht*i, 1, widht, 48);
        title = [array objectAtIndex:2];
        [btn setTitle:title forState:UIControlStateNormal];
        [btn setTitleColor:[CommonImage colorWithHexString:@"666666"] forState:UIControlStateNormal];
        [btn setTitleColor:[CommonImage colorWithHexString:Color_Nav] forState:UIControlStateHighlighted];
        [btn setTitleColor:[CommonImage colorWithHexString:Color_Nav] forState:UIControlStateSelected];
        btn.titleLabel.font = [UIFont systemFontOfSize:11];
        [btn setImage:[UIImage imageNamed:[array objectAtIndex:0]] forState:UIControlStateNormal];
        //        UIImage *imageBack = [[UIImage imageNamed:[array objectAtIndex:1]] imageWithTintColor:[CommonImage colorWithHexString:Color_Nav]];
        UIImage *imageBack = [UIImage imageNamed:[array objectAtIndex:1]];
        [btn setImage:imageBack forState:UIControlStateHighlighted];
        [btn setImage:imageBack forState:UIControlStateSelected];
        
        CGSize size = btn.currentImage.size;
        [btn setTitleEdgeInsets:UIEdgeInsetsMake(13, -size.width, -13, 0)];
        [btn setImageEdgeInsets:UIEdgeInsetsMake(-8, 0, 8, -[title sizeWithFont:btn.titleLabel.font].width)];
        //        if (i == 2) {
        //            [btn setImageEdgeInsets:UIEdgeInsetsMake(-6, 0, 6, -[title sizeWithFont:btn.titleLabel.font].width-13)];
        //        }
        btn.tag = i+100;
        if (i==0)
        {
            btn.selected = YES;
        }
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchDown];
        //        [btn addTarget:self action:@selector(setButSel:) forControlEvents:UIControlEventTouchDragExit];
        //        [btn addTarget:self action:@selector(setButSel:) forControlEvents:UIControlEventTouchUpInside];
        [customBarView addSubview:btn];
        
        //        labTip = [Common createLabel:rect TextColor:@"e65341" Font:[UIFont systemFontOfSize:15] textAlignment:NSTextAlignmentCenter labTitle:@""];
        //        labTip.tag = i+200;
        //        labTip.hidden = YES;
        //        labTip.clipsToBounds = YES;
        //        labTip.layer.cornerRadius = rect.size.width/2;
        //        labTip.backgroundColor = [CommonImage colorWithHexString:@"e65341"];
        //        [btn addSubview:labTip];
        
        if (i == arrayTabBarImage.count-1) {
            
            rect = CGRectMake(50, 4, 12, 12);
            UIImage *redHeartImageContent = [UIImage imageNamed:@"common.bundle/topic/conversation_icon_redpoint.png"];
            UIImageView *redHeartImage = [[UIImageView alloc]initWithFrame:rect];
            redHeartImage.tag = 3+200;
            redHeartImage.image = redHeartImageContent;
            redHeartImage.hidden = YES;
            [btn addSubview:redHeartImage];
        }
    }
    
    //    [APP_DELEGATE2 setUserID:g_nowUserInfo.userid setMainID:g_nowUserInfo.userid];
}

- (void)setTabbarTip
{
    UILabel *labTip;
    //    for (int i = 0; i < 5; i++) {
    
    labTip = (UILabel*)[customBarView viewWithTag:3+200];
    
    //        labTip.text = text;
    //        float widht = [labTip.text sizeWithFont:labTip.font].width;
    //        CGRect rect = labTip.frame;
    //        rect.origin.x = kDeviceWidth/4-10-widht;
    //        labTip.frame = rect;
    
    //        if (g_nowUserInfo.broadcastNotReadNum + g_nowUserInfo.myMessageNoReadNum) {
    //            labTip.hidden = NO;
    //        }
    //        else {
    //            labTip.hidden = YES;
    //        }
    //    }
}

- (void)btnClick:(UIButton*)but
{
    but.selected = YES;
    int selectindex = (int)but.tag;
    [self gotoSelectViewControllerWithSelectIndex:selectindex];
}

- (void)gotoSelectViewControllerWithSelectIndex:(int)selectIndex
{
    //    if (m_lock) {
    //        return;
    //    }
    //    m_lock = YES;
    
    if (m_selectViewIndex == selectIndex-100) {
        return;
    }
    //获取未读消息
    //    [self getMsg];
    UIButton *lastSelBut = (UIButton*)[customBarView viewWithTag:m_selectViewIndex+100];
    lastSelBut.selected = NO;
    [((CommonNavViewController*)m_selectedViewController).nowViewController viewWillDisappear:YES];
    [m_selectedView removeFromSuperview];
    
    m_selectedViewController = [m_viewArray objectAtIndex:selectIndex-100];
    NSLog(@"%@", ((CommonNavViewController*)m_selectedViewController).nowViewController.view);
    m_selectedView = m_selectedViewController.view;
    [((CommonNavViewController*)m_selectedViewController).nowViewController viewWillAppear:YES];
    
    AppDelegate *myAppDelegate = [Common getAppDelegate];
    myAppDelegate.navigationVC = (CommonNavViewController*)m_selectedViewController;
    
    [self.view addSubview:m_selectedView];
    [self.view bringSubviewToFront:customBarView];
    m_selectViewIndex = (int)selectIndex-100;
    
    //    if (selectIndex == m_viewArray.count -1)
    //    {
    //         [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    //    }
    //    [self setLoadingCore];
    //获取七牛token
    //    [self getQiniuToken];
    
}

- (void)setButSel:(UIButton*)but
{
    but.selected = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setTabbarTip];
}

#pragma - UINavigationControllerDelegate

- (int)setNav:(UINavigationController *)navigationController
{
    //	NSLog(@"as---------------------------------------start");
    if (m_prevViewControllersnum == -1) {
        m_prevViewControllersnum = (int)[[navigationController viewControllers] count];
        return -1;
    }
    
    BOOL pushed;
    
    if (m_prevViewControllersnum <= (int)[[navigationController viewControllers] count])
    {
        pushed = YES;
        m_lock = NO;
    }
    else
    {
        pushed = NO;
    }
    m_prevViewControllersnum = (int)[[navigationController viewControllers] count];
    
    return pushed;
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    //	NSLog(@"as---------------------------------------start");
    int pushed = [self setNav:navigationController];
    if (pushed == -1) {
        return;
    }
    UIViewController *vc = [navigationController.viewControllers objectAtIndex:0];
    if (pushed && m_prevViewControllersnum == 2 ) {
        if (!customBarView.hidden) {
            [self createImage:vc.view];
            customBarView.hidden = YES;
        }
    }
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    //	NSLog(@"as---------------------------------------start");
    int pushed = [self setNav:navigationController];
    if (pushed == -1) {
        return;
    }
    UIViewController *vc = [navigationController.viewControllers objectAtIndex:0];
    
    if (pushed && m_prevViewControllersnum == 1){
        [self removeImage:vc.view];
        //        [self performSelector:@selector(removeImage:) withObject:vc.view afterDelay:0.4];
        [self viewWillAppear:NO];
    }
}

- (void)removeImage:(UIView*)vc
{
    UIView *imageV = [vc viewWithTag:900];
    if (imageV) {
        customBarView.hidden = NO;
        [imageV removeFromSuperview];
    }
}

- (void)createImage:(UIView*)view
{
    UIImage *image = [CommonImage imageWithView:customBarView];
    UIImageView *imagV = [[UIImageView alloc] initWithFrame:CGRectMake(0, kDeviceHeight - g_tabbarHeight, kDeviceWidth, g_tabbarHeight)];
    imagV.tag = 900;
    imagV.image = image;
    [view addSubview:imagV];
    
}

//start
- (void)reciveMesg:(NSNotification*)aNotification
{
    NSDictionary *dicc = [aNotification.object objectForKey:@"extras"];
    if (m_lastMsgDic) {
        if (([dicc[@"createTime"] longLongValue] - [m_lastMsgDic[@"createTime"] longLongValue]) >= 3000) {
            if ([dicc[@"content"] isEqualToString:m_lastMsgDic[@"content"]]) {
                return;
            }
        }
        m_lastMsgDic = nil;
    }
    
    m_lastMsgDic = [[NSMutableDictionary alloc] initWithDictionary:dicc] ;
    
    if (!g_nowUserInfo) {
        return;
    }
    
    [m_lastMsgDic setObject:@"1" forKey:@"forSelf"];
    NSString *fromId = [NSString stringWithFormat:@"%@", [m_lastMsgDic objectForKey:@"fromId"]];
    [m_lastMsgDic setObject:fromId forKey:@"friendId"];
    [m_lastMsgDic setObject:fromId forKey:@"toId"];
    [m_lastMsgDic setObject:@"0" forKey:@"isSendOK"];
    [m_lastMsgDic setObject:@"1" forKey:@"isInsertDB"];
    
    
    //    [dic setObject:@"0" forKey:@"isInsertDB"];
    //    [dic setObject:@"0" forKey:@"forSelf"];//自己发的
    //    [dic setObject:@"1" forKey:@"isSendOK"];//发送状态
    //    int yongshi = m_registerTimeLen;
    //    [dic setObject:m_audioSessio.m_audioName forKey:@"content"];//发送内容 必填
    //    [dic setObject:@2 forKey:@"contentType"];//内容类型 必填
    //    [dic setObject:[NSNumber numberWithInt:yongshi] forKey:@"audioTime"];//当内容类型为2 也就是音频时，需传
    //    [dic setObject:m_dicInfo[@"friendId"] forKey:@"friendId"];//接收者id，必填
    
    NSArray *array = ((CommonNavViewController*)m_selectedViewController).viewControllers;
    BOOL is = NO;
    
    //	[[DBOperate shareInstance] insertChatRecordToDBWithData:m_lastMsgDic];
    //	//	[Common TipDialog2:[m_msgDic objectForKey:@"msgContent"]];
    ////	if (!m_lastNewShowVC) {
    //		if (is) {
    //            [m_showView addMessage:m_lastMsgDic isLishi:NO];
    //		} else {
    //            //未读红点
    //            if ([m_lastMsgDic[@"accountType"] intValue] == 2) { //1 患者 2 医师
    //                g_nowUserInfo.doctorMsgCount += 1;
    //                [[NSNotificationCenter defaultCenter] postNotificationName:@"refleshTip" object:nil];
    //            }
    //            else {
    //                g_nowUserInfo.friendMsgCount += 1;
    //                [[NSNotificationCenter defaultCenter] postNotificationName:@"refleshFriendListTip" object:nil];
    //            }
    //
    //			m_lastNewShowVC = 1;
    //            NSString *msg = nil;
    //            switch ([[m_lastMsgDic objectForKey:@"contentType"] intValue]) {
    //                case 0:
    //                    msg = [m_lastMsgDic objectForKey:@"content"];
    //                    break;
    //                case 1:
    //                    msg = @"您收到一张图片";
    //                    break;
    //                case 2:
    //                    msg = @"您收到一条语音消息";
    //                    break;
    //                case 3:
    //                    msg = @"您收到一个图片表情";
    //                    break;
    //                default:
    //                    msg = @"您收到一条新的消息";
    //                    break;
    //            }
    //            SystemSoundID soundID = 0;
    //            NSString *mainBundlPath = [[NSBundle mainBundle] bundlePath];
    //            NSString *filePath =[mainBundlPath stringByAppendingPathComponent:@"common.bundle/mp3/newdatatoast.wav"];
    //
    //            NSURL* fileURL =  [NSURL fileURLWithPath:filePath];
    //
    //            if (fileURL != nil) {
    //                SystemSoundID theSoundID;
    //                OSStatus error = AudioServicesCreateSystemSoundID((__bridge CFURLRef)fileURL, &theSoundID);
    //                if (error == kAudioServicesNoError) {
    //                    soundID = theSoundID;
    //                } else {
    //                    NSLog(@"Failed to create sound ");
    //                }
    //            }
    //            AudioServicesPlaySystemSound(soundID);
    //            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    //
    //			UIAlertView *av = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"新消息提醒",nil) message:msg delegate:self cancelButtonTitle:NSLocalizedString(@"忽略",nil) otherButtonTitles:NSLocalizedString(@"查看",nil), nil];
    //			av.tag = 120;
    //			[av show];
    //			[av release];
    //		}
    //	}
    //	else {
    //		[m_msgDic release];
    //	}
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    m_lastNewShowVC = 0;
    if (alertView.tag == 120) {
        if (buttonIndex) {
            //			[[NSNotificationCenter defaultCenter] postNotificationName:@"setShowView" object:[NSNumber numberWithInt:0]];
            
            //			ShowConsultViewController *show = [[ShowConsultViewController alloc] init];
            //			[((CommonNavViewController*)m_selectedViewController).nowViewController.navigationController pushViewController:show animated:YES];
            //			[show release];
        }
    }
}

- (BOOL)prefersStatusBarHidden
{
    return NO;
}
#pragma mark 点击对应
- (void)clickOpenURL
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    //    [self setNeedsStatusBarAppearanceUpdate];
    //    [self viewWillAppear:YES];
    
    //    [myAppDelegate.window makeKeyAndVisible];
    //    CGRect viewBounds = self.view.bounds;
    //    CGFloat topBarOffset = -20.0;
    //    viewBounds.origin.y = topBarOffset;
    //    self.view.bounds  = viewBounds;
    
    //    [self gotoSelectViewControllerWithSelectIndex:100];
    //    if (!g_nowUserInfo.userid.length)
    //    {
    //        return;
    //    }
    [self performSelector:@selector(gotoSelectViewController) withObject:nil afterDelay:0.4];
}

#pragma mark 跳转
- (void)gotoSelectViewController
{
    NSString *todayButtonTitle = [[NSUserDefaults standardUserDefaults] objectForKey:@"kangxun_goToView"];
    if ([todayButtonTitle isEqualToString:kTodayWidget_ONE] || [todayButtonTitle isEqualToString:kTodayWidget_TWO]  || [todayButtonTitle isEqualToString:kTodayWidget_THREE]  ||[todayButtonTitle isEqualToString:kTodayWidget_FOUR] )
    {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"kangxun_goToView"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        UIViewController *newViewController = [[NSClassFromString(todayButtonTitle) alloc] init];
        UINavigationController *myNavCOntroller = ((CommonNavViewController*)m_selectedViewController).nowViewController.navigationController;
        if ([myNavCOntroller.topViewController isKindOfClass:[newViewController class]])
        {
            return;
        }
        [((CommonNavViewController*)m_selectedViewController) pushViewController:newViewController animated:YES];
    }
}

//end
- (void)setShowView:(NSNotification*)aNotification
{
    int is = [aNotification.object boolValue];
    customBarView.transform = CGAffineTransformIdentity;
    customBarView.hidden = NO;
    UIButton *but = (UIButton*)[self.view viewWithTag:100+is];
    [self btnClick:but];
}

- (void)setTabbarShowHiddle:(NSNotification*)aNotification
{
    BOOL is = [aNotification.object boolValue];
    customBarView.hidden = NO;
    if (!is) {
        customBarView.transform = CGAffineTransformMakeTranslation(0, customBarView.height);
    }
    [UIView animateWithDuration:0.2 animations:^{
        if (is) {
            customBarView.transform = CGAffineTransformMakeTranslation(0, customBarView.height);
        } else {
            customBarView.transform = CGAffineTransformMakeTranslation(0, 0);
        }
    } completion:^(BOOL finished) {
        //		if (is) {
        customBarView.hidden = is;
        //        }
        customBarView.transform = CGAffineTransformIdentity;
    }];
}

- (void)didFinishFail:(ASIHTTPRequest*)loader
{

}

- (void)didFinishSuccess:(ASIHTTPRequest*)loader
{
    NSString* responseString = [loader responseString];
    NSDictionary* dict = [responseString KXjSONValueObject];
    NSDictionary * dic = dict[@"head"];
        if([loader.username isEqualToString:UPDATE_DATA_DB])
    {
        NSArray *rs = [dic objectForKey:@"rs"];
        NSDictionary *dicItem = [rs objectAtIndex:rs.count-1];
        if ([dicItem objectForKey:@"versionNum"]) {
            [NSThread detachNewThreadSelector:@selector(updateDB2:) toTarget:self withObject:rs];
        }
    }
}

- (void)removeAdvView
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    AppDelegate* myDelegate = [Common getAppDelegate];
    UIImageView *imageV = (UIImageView*)[myDelegate.window viewWithTag:1006];
    if (!imageV)
    {
        return;
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
        dispatch_async( dispatch_get_main_queue(), ^(void){
            
            [UIView animateWithDuration:0.2 animations:^{
                imageV.alpha = 0;
            } completion:^(BOOL finished) {
                [imageV removeFromSuperview];
            }];
        });
    });
}

/**
 *  返回登录界面
 */
- (void)qweqwe
{
    //    LoginViewController* LoginViewCon = [[LoginViewController alloc] init];
    //    UIImage* loginViewImage = [CommonImage imageWithView:LoginViewCon.view];
    //    UIImageView* loginView = [[UIImageView alloc] initWithImage:loginViewImage];
    //    loginView.frame = CGRectMake(0, kDeviceHeight + 64, kDeviceWidth, kDeviceHeight + 64);
    //    [self.navigationController.view addSubview:loginView];
    //
    //
    ////    [UIView animateWithDuration:0.35 animations:^{
    //        CGRect rect = loginView.frame;
    //        rect.origin.y = 0;
    //        loginView.frame = rect;
    ////    } completion:^(BOOL finished) {
    ////
    ////        //      LoginViewController *view1 = [[LoginViewController alloc] init];
    //        CommonNavViewController *view1 = [[CommonNavViewController alloc] initWithRootViewController:LoginViewCon];
    //        [LoginViewCon release];
    //        APP_DELEGATE.rootViewController = view1;
    //        [view1 release];
    //     [loginView release];
    //    }];
}

- (void)updateDB2:(NSArray*)array
{
    @try {
        for (NSDictionary *dic in array) {
            [[DBOperate shareInstance] updateDataForServer:[dic objectForKey:@"changeSql"]];
        }
        [[DBOperate shareInstance] closeDB];
        
        NSDictionary *dicItem = [array objectAtIndex:array.count-1];
        [[NSUserDefaults standardUserDefaults] setObject:[dicItem objectForKey:@"versionNum"] forKey:@"DBversionNum"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    @catch (NSException *exception) {
    }
    @finally {
    }
}

- (void)getQiniuToken
{
    //    long time = [CommonDate getLongTime];
    //    if (time - g_longTime > 11 * 60 * 60) {
    //        [[CommonHttpRequest defaultInstance] sendNewPostRequest:GET_QINIU_TOKEN values:[NSDictionary dictionary] requestKey:GET_QINIU_TOKEN delegate:self controller:self actiViewFlag:0 title:nil];
    //    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"reciveMesg" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"FloatViewClickNotification" object:nil];
    
    if (m_lastMsgDic) {
        m_lastMsgDic = nil;
    }
}

@end
