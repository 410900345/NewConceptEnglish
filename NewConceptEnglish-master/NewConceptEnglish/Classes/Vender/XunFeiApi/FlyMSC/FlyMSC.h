//
//  FlyMSC.h
//  jiuhaohealth3.0
//
//  Created by jiuhao-yangshuo on 15-1-20.
//  Copyright (c) 2015年 xuGuohong. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef  void (^completionBlock)(NSString *content, int errorCode);

@interface FlyMSC : NSObject

//单例
+(FlyMSC*)shareInstance;

//听
-(void)listenword:(completionBlock)handler;
//设置显示的页面 自带得界面
//-(void)setIFlYRecognizerViewCenterInFatherView:(UIView *)fatherView;

//创建自定义的识别页面
-(void)createIFlyRecognizerView:(UIView*)view;

-(void)setLanguageEn:(BOOL)isEn;

@end
