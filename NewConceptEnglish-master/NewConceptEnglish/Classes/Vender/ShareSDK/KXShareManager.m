//
//  KXShareManager.m
//  jiuhaohealth4.0
//
//  Created by wangmin on 15/9/11.
//  Copyright (c) 2015年 xuGuohong. All rights reserved.
//

#import "AppDelegate.h"
#import "KXShareManager.h"
#import <ShareSDKExtension/SSEShareHelper.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <ShareSDKUI/SSUIShareActionSheetStyle.h>
#import <ShareSDKUI/SSUIShareActionSheetCustomItem.h>
#import <ShareSDK/ShareSDK+Base.h>

//腾讯开放平台（对应QQ和QQ空间）SDK头文件
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
//以下是腾讯SDK的依赖库：
//libsqlite3.dylib

//微信SDK头文件
#import "WXApi.h"
//以下是微信SDK的依赖库：
//libsqlite3.dylib

//新浪微博SDK头文件
#import "WeiboSDK.h"

@implementation KXShareManager
{
    __block MBProgressHUD *_m_Progress;
}

+ (KXShareManager *)sharedManager
{
    static KXShareManager *class;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        class = [[KXShareManager alloc] init];
        [ShareSDK registerApp:@"332d6a53e11a"
              activePlatforms:@[
                                @(SSDKPlatformTypeSinaWeibo),
                                @(SSDKPlatformTypeWechat),
                                @(SSDKPlatformTypeQQ)
                                ]
                     onImport:^(SSDKPlatformType platformType) {
                         
                         switch (platformType)
                         {
                             case SSDKPlatformTypeWechat:
                                 //                             [ShareSDKConnector connectWeChat:[WXApi class]];
                                 [ShareSDKConnector connectWeChat:[WXApi class] delegate:self];
                                 break;
                             case SSDKPlatformTypeQQ:
                                 [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                                 break;
                             case SSDKPlatformTypeSinaWeibo:
                                 [ShareSDKConnector connectWeibo:[WeiboSDK class]];
                                 break;
                             default:
                                 break;
                         }
                         
                     }
              onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo) {
                  
                  switch (platformType)
                  {
                      case SSDKPlatformTypeSinaWeibo:
                          //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                          [appInfo SSDKSetupSinaWeiboByAppKey:kSinaWeiAppKey
                                                    appSecret:kSinaWeiAppSecret
                                                  redirectUri:kSinaWeiAppURL
                                                     authType:SSDKAuthTypeBoth];
                          break;
                      case SSDKPlatformTypeWechat:
                          //微信
                          [appInfo SSDKSetupWeChatByAppId:kWXAppKey
                                                appSecret:kWXAppSecret];
                          break;
                      case SSDKPlatformTypeQQ:
                          //QQ
                          [appInfo SSDKSetupQQByAppId:kQQAppKey
                                               appKey:kQQAppSecret
                                             authType:SSDKAuthTypeBoth];
                          break;
                        
                      default:
                          break;
                  }
              }];
    });
    
    return class;
}


- (void)noneUIShareAllButtonClickHandler:(id)sender
                                 Content:(NSString *)contentStrings
                               ImagePath:(UIImage *)imagePath
                                AndTitle:(NSString *)titleString
                                     Url:(NSString *)url
                          haveCustomItem:(BOOL)haveCutomItem
{
    
    if(!url){
        url = @"http://english.bmob.cn";
    }
    if (contentStrings.length > 80)
    {
        contentStrings = [contentStrings substringToIndex:80];
    }
    
    UIImage *imageIcon = [UIImage imageNamed:@"common.bundle/common/icon60.png"];
    id sinaImage = imageIcon;//[ShareSDK imageWithUrl:((NSString*)imagePath)];
    
//    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //1、创建分享参数（必要）
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    NSArray* imageArray = @[imageIcon];
    [shareParams SSDKSetupShareParamsByText:contentStrings
                                     images:imageArray
                                        url:[NSURL URLWithString:url]
                                      title:titleString
                                       type:SSDKContentTypeAuto];
    //新浪微博定制
    NSString *titleString2 = titleString;
    if (titleString2.length > 80)
    {
        titleString2 = [titleString2 substringToIndex:80];
    }
    [shareParams SSDKSetupSinaWeiboShareParamsByText:[NSString stringWithFormat:@"%@ [下载地址]:%@",titleString2,url]
                                               title:@""
                                                image:imageIcon
                                                 url:[NSURL URLWithString:url]
                                            latitude:0
                                           longitude:0
                                            objectID:nil
                                                type:SSDKContentTypeAuto];
    //朋友圈定制
    [shareParams SSDKSetupWeChatParamsByText:titleString
                                       title:contentStrings
                                         url:[NSURL URLWithString:url]
                                  thumbImage:imageArray
                                       image:imageArray
                                musicFileURL:nil
                                     extInfo:nil
                                    fileData:nil
                                emoticonData:nil
                                        type:SSDKContentTypeAuto
                          forPlatformSubType:SSDKPlatformSubTypeWechatTimeline];
    //1.2、自定义分享平台（非必要）
    NSMutableArray *activePlatforms = [NSMutableArray arrayWithArray:@[@(SSDKPlatformTypeSinaWeibo),
                                                                       @(SSDKPlatformSubTypeWechatTimeline),
                                                                       @(SSDKPlatformSubTypeWechatSession),
                                                                       @(SSDKPlatformSubTypeQZone),
                                                                       @(SSDKPlatformSubTypeQQFriend)]];
    
    //添加一个自定义的平台（非必要）
    SSUIShareActionSheetCustomItem *myItem = nil;
    if (haveCutomItem)
    {
        UIImage *communityImageView = [UIImage imageNamed:@"common.bundle/community/shareCommunity.png"];
        myItem = [SSUIShareActionSheetCustomItem itemWithIcon:communityImageView
                                                        label:@"糖圈"
                                                      onClick:^{
                                                          //自定义item被点击的处理逻辑
                                                          NSLog(@"=== 自定义item被点击 ===");
                                                          if([Common getAppDelegate].customShareDelegate && [[Common getAppDelegate].customShareDelegate respondsToSelector:@selector(sendPostToCircle)]){
                                                              
                                                              [[Common getAppDelegate].customShareDelegate performSelector:@selector(sendPostToCircle) withObject:nil];
                                                          }
                                                      }];
        [activePlatforms addObject:myItem];
    }
    //2、分享
    SSUIShareActionSheetController *sheet = [ShareSDK showShareActionSheet:nil
                                                                     items:activePlatforms
                                                               shareParams:shareParams
                                                       onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                                                           
                                                
                                                           switch (state) {
                                                                   
                                                               case SSDKResponseStateBegin:
                                                               {
                                                                   //                           [theController showLoadingView:YES];
                                                                   break;
                                                               }
                                                               case SSDKResponseStateSuccess:
                                                               {
                                                                   [Common MBProgressTishi:@"分享成功" forHeight:kDeviceHeight];
                                                                   [self sendShare];
                                                               }
                                                                   break;
                                                               case SSDKResponseStateFail:
                                                               {
                                                                   [Common MBProgressTishi:@"分享失败" forHeight:kDeviceHeight];
                                                               }
                                                                   break;
                                                               case SSDKResponseStateCancel:
                                                               {
                                                                   //                           [Common MBProgressTishi:@"分享已取消" forHeight:kDeviceHeight];
                                                               }
                                                                   break;
                                                               default:
                                                                   break;
                                                           }
                                                       }];
    //删除和添加平台示例
    [sheet.directSharePlatforms addObject:@(SSDKPlatformTypeSinaWeibo)];
    [sheet.directSharePlatforms addObject:@(SSDKPlatformTypeWechat)];
    [sheet.directSharePlatforms addObject:@(SSDKPlatformTypeQQ)];
}

- (void)sendShare
{
//    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
//    [[CommonHttpRequest defaultInstance] sendNewPostRequest:URL_grouppointForForwardPost values:dic requestKey:URL_grouppointForForwardPost delegate:self controller:nil actiViewFlag:0 title:0];
}



- (void)hiddenProgressView
{
    if (_m_Progress)
    {
        [_m_Progress removeFromSuperview];
        _m_Progress  = nil;
    }
}

@end
