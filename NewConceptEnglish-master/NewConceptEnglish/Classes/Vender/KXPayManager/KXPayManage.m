//
//  KXPayManage.h
//  testAliPay
//
//  Created by JSen on 14/9/29.
//  Copyright (c) 2014年 wifitong. All rights reserved.
//

#import "KXPayManage.h"
#import <UIKit/UIKit.h>
#import <BmobPay/BmobPay.h>
//#import "CommentManage.h"

@interface KXPayManage ()<BmobPayDelegate>
{
    BmobPay* bPay;
//    CommentManage *m_commentManage;
}
@end

@implementation KXPayManage

+ (instancetype)sharePayEngine
{
    static KXPayManage *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (instancetype)init
{
    if (self = [super init])
    {
        bPay = [[BmobPay alloc] init];
        bPay.delegate = self;
    }
    return self;
}

+ (void)setUpPayManage
{
    [BmobPaySDK registerWithAppKey:KBmobKey];
}

-(void)paymentWithPrice:(NSString *)priceNum andWithProductName:(NSString *)productName andWithDescription:(NSString *)body result:(paymentFinishCallBack)block
{
    _finishBlock = [block copy];
    if (priceNum.length && productName.length && body.length)
    {
        __weak BmobPay *weakPay = bPay;
        [bPay setPrice:@([priceNum floatValue])];
        [bPay setProductName:productName];
        [bPay setBody:body];
        [bPay setAppScheme:kURLSchemes];
        //    [bPay payInBackground];
        [bPay payInBackgroundWithBlock:^(BOOL isSuccessful, NSError *error) {
            if (isSuccessful)
            {
                NSLog(@"商品订单%@",[bPay tradeNo]);
                //将订单号保存至文本框以测试查询方法
            } else{
                NSLog(@"%@",[error description]);
                [Common MBProgressTishi:@"系统繁忙,请重试" forHeight:kDeviceHeight];
                [weakPay forceFree];
            }
        }];
    }
    else
    {
          [Common MBProgressTishi:@"信息填写不正确!" forHeight:kDeviceHeight];
    }
}


-(void)handleBlock
{
    if (_finishBlock)
    {
         _finishBlock(nil);
    }
   
}

-(void)payFailWithErrorCode:(int) errorCode
{
        int code = errorCode;
        NSString *message = @"";
        switch (code)
        {
            case 9000:
                message = @"多谢您的支持";
                break;
            case 8000:
                message = @"正在处理中";
                break;
            case 4000:
                message = @"订单支付失败";
                break;
            case 6001:
                message = @"订单支付取消";
                [self showAlert];
                break;
            case 6002:
                message = @"网络连接出错";
                break;
            default:
                break;
        }
        [Common MBProgressTishi:message forHeight:kDeviceHeight];
}

-(void)showAlert
{
//   m_commentManage =  [CommentManage showPayCancelAlert];
}

-(void)paySuccess
{
    NSLog(@"支付成功！");
    [self  handleBlock];
    NSString *  message = @"多谢您的支持";
   [Common MBProgressTishi:message forHeight:kDeviceHeight];
}

@end
