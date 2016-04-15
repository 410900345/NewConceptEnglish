//
//  ContentViewController.h
//  newIdea1.0
//
//  Created by yangshuo on 15/10/6.
//  Copyright (c) 2015年 xuGuohong. All rights reserved.
//

#import "CommonViewController.h"

typedef void (^ContentViewControllerBlock)(id content);

@interface ContentViewController : UIView

@property (nonatomic, strong) AVAudioPlayer *m_musicPlayer;

@property(nonatomic,copy)ContentViewControllerBlock m_block;

- (void)show;

- (void)dismiss:(BOOL)animated;
//页面展示
- (void)createContentView;

- (void)setUpViewValue;

//隐藏页面
- (void)hiddenView;

@end
