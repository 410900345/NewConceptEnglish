//
//  AppDelegate.h
//  Assistant1.0
//
//  Created by 徐国洪 on 14-7-11.
//  Copyright (c) 2014年 xuGuohong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate,UIAlertViewDelegate>
{
   __block MBProgressHUD *_m_Progress;
}

@property (strong, nonatomic) UIWindow *window;

//@property (nonatomic,retain) NSString *userID;//用户编号---会员号

@property (nonatomic,retain) NSString *tokenID;//机器编号--百度返回的userid

@property (nonatomic,retain) NSString *channelID;//频道编号--百度返回的channelid

@property (nonatomic,assign) BOOL  isUploadPushInfo;//是否上传push信息到服务器

@property (nonatomic,assign) BOOL getServiceInfoFlag;//从服务器获得上次信息

@property (nonatomic,retain) UINavigationController *navigationVC;

@property (nonatomic,retain) NSString *currentClientPhoneNum;//当前客户的联系电话

@property (nonatomic,retain) NSMutableDictionary *stepShareDic;//分享计步信息


@property (nonatomic,assign) BOOL isMusicPlaying;//音乐播放标志位

@property (nonatomic,assign) BOOL isActiveFlag;//是否处于活跃



@property (nonatomic,assign) BOOL isShowAlertViewFlag;//是否现在


@property (nonatomic,assign) BOOL isLandView;


@property (nonatomic,assign) id  customShareDelegate;//分享代理

- (void)noneUIShareAllButtonClickHandler:(id)sender
                                 Content:(NSString *)contentStrings
                               ImagePath:(UIImage *)imagePath
                                AndTitle:(NSString *)titleString
                                     Url:(NSString *)url
                          haveCustomItem:(BOOL)haveCutomItem;

- (void)setUserID:(NSString *)userID;


- (void)startSignificantChangeUpdates;
- (void)stopSingificantChangeUpdates;

@end
