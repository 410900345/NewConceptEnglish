//
//  KXPayManage.h
//  testAliPay
//
//  Created by JSen on 14/9/29.
//  Copyright (c) 2014年 wifitong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AlipaySDK/AlipaySDK.h>

static NSString *const kOrderID = @"OrderID";
static NSString *const kTotalAmount = @"TotalAmount";
static NSString *const kProductDescription = @"productDescription";
static NSString *const kProductName = @"productName";
static NSString *const kNotifyURL = @"NotifyURL";
//static NSString *const kAppSchema = @"com.xiaobin.ncenglish";

typedef void(^paymentFinishCallBack)(id resultDict);


@interface KXPayManage : NSObject
{
    
    NSString *_schema;
    
    paymentFinishCallBack _finishBlock;
    SEL _resultSEL;
}

//设置支付
+ (void)setUpPayManage;

+ (instancetype)sharePayEngine;

- (void)paymentWithPrice:(NSString *)price andWithProductName:(NSString *)productName andWithDescription:(NSString *)description result:(paymentFinishCallBack)block;

@end
