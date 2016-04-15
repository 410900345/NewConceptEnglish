//
//  LaunchAdView.h
//  newIdea1.0
//
//  Created by jiuhao-yangshuo on 15/11/18.
//  Copyright © 2015年 xuGuohong. All rights reserved.
//

#import "CommonViewController.h"

@interface LaunchAdView : CommonViewController
{
    SXBasicBlock dimissBlock;
}

@property (nonatomic, strong) UIImageView *adImageView;;

- (void)setDismissBlock:(SXBasicBlock)block;
- (void)showOnWindow:(UIWindow *)window;
- (void)requestDMorder;
- (void)dismissAd;

- (NSString *)getRandomAdStr;

@end
