//
//  CommentManage.m
//  newIdea1.0
//
//  Created by jiuhao-yangshuo on 16/2/2.
//  Copyright © 2016年 xuGuohong. All rights reserved.
//

#import "CommentManage.h"
#import "CommonSet.h"
#import "AppDelegate.h"
#import "UMFeedbackViewController.h"
#import "CommonSet.h"
#import "WXApi.h"
#import "WeiXinConfig.h"

typedef enum : NSUInteger {
    CommentManageAlertComment = 5001,//评价
    CommentManageAlertPay = 5002
} CommentManageAlertTag;

static NSString *const kHavedComment =@"kHavedComment";
@interface CommentManage ()<UIAlertViewDelegate>

@end

@implementation CommentManage

+(id)showCommentAlert
{
    //    1为审核 0为通过
    BOOL checkInAppStore = [CommonSet sharedInstance].m_checkVersionAppStore;
    if (checkInAppStore)
    {
        return nil;
    }
    CommentManage *manager = [[CommentManage alloc] init];
    NSString *message = [NSString stringWithFormat:@"喜欢%@就给我们五星好评吧,我们会更努力的~",AppDisplayName];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"求鼓励!"
                                                   message:message
                                                  delegate:manager
                                         cancelButtonTitle:@"再用再看"
                                         otherButtonTitles:@"去鼓励",@"想吐槽", nil];
    [alert show];
    alert.tag = CommentManageAlertComment;
    return manager;
}

//取消支付调用
+(id)showPayCancelAlert
{
    //    1为审核 0为通过
    BOOL checkInAppStore = [CommonSet sharedInstance].m_checkVersionAppStore;
    if (checkInAppStore)
    {
        return nil;
    }
    CommentManage *manager = [[CommentManage alloc] init];
    NSString *message = [NSString stringWithFormat:@"选择其余捐助方式"];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil
                                                   message:message
                                                  delegate:manager
                                         cancelButtonTitle:@"再用再看"
                                         otherButtonTitles:@"微信支付",@"五星好评!", nil];
    [alert show];
    alert.tag = CommentManageAlertPay;
    return manager;
}

+(BOOL)havedComment
{
    BOOL havedCommentState = NO;
    NSString *commentVersion = [[CommonSet sharedInstance] fetchSystemPlistValueforKey:kHavedComment];
    if ([CFBundleVersion isEqualToString: commentVersion])
    {
        havedCommentState = YES;
    }
    return havedCommentState;
}

-(void)changeHaveCommentState
{
    NSString *versionStr = CFBundleVersion;
    [[CommonSet sharedInstance] saveSystemPlistValue:versionStr forKey:kHavedComment];
}

- (void)butEventPingjia
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[CommonSet getAppStorUrl]]];
    [self changeHaveCommentState];
}

- (void)butEventFeedBack
{
    AppDelegate *myAppDelegate = [Common getAppDelegate];
    UINavigationController *nav = myAppDelegate.navigationVC;
    if ([nav isKindOfClass:[UINavigationController class]])
    {
        
        [nav pushViewController:[UMFeedbackViewController new]
                       animated:YES];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (alertView.tag) {
        case CommentManageAlertComment:
            [self handleCommentManageAlertCommentWithIndex:buttonIndex];
            break;
        case CommentManageAlertPay:
            [self handleCommentManageAlertPayWithIndex:buttonIndex];
            break;
        default:
            break;
    }
}

-(void)handleCommentManageAlertCommentWithIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 1:
            [self butEventPingjia];
            break;
        case 2:
        {
            [self butEventFeedBack];
        }
            break;
        default:
            break;
    }
}

-(void)handleCommentManageAlertPayWithIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 1:
            [self goToWiXinPay];
            break;
        case 2:
        {
            [self butEventPingjia];
        }
            break;
        default:
            break;
    }
}


-(void)goToWiXinPay
{
   NSLog(@"-------%d",[WXApi isWXAppInstalled]);
//    if ([WXApi isWXAppInstalled])
//    {
//        JumpToBizProfileReq *req = [[JumpToBizProfileReq alloc]init];
//        req.profileType = WXBizProfileType_Normal;
//        req.username = kWeiXinUserName; //公众号原始ID
//        [WXApi sendReq:req];
//         return;
//    }
//    else
//    {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        [pasteboard setString:kWeiXinUserName];
        [Common MBProgressTishi:@"已复制微信公众号名称" forHeight:kDeviceHeight];
//    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [WXApi openWXApp];
    });
}

@end
