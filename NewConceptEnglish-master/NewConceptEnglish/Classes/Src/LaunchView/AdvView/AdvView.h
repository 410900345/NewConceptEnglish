//
//  AdvView.h
//  jiuhaohealth2.1
//
//  Created by 徐国洪 on 14-10-16.
//  Copyright (c) 2014年 xuGuohong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebViewController.h"
static NSString *const kImageKey = @"imagePath";
static NSString *const kUrlKey = @"url";

@protocol AdViewDelegate <NSObject>

-(void)removeAdWithDelay:(BOOL)delay;

@end
@interface AdvView : WebViewController

@property(nonatomic,weak)id<AdViewDelegate>deledate;
@property (nonatomic, retain) NSDictionary *m_dicInfo;

///  广告的参数
///
///  @return 数组
+ (NSArray *)createAdItemArray;
@end
