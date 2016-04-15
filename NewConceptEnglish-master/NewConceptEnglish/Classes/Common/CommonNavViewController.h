//
//  CommonNavViewController.h
//  jiuhaohealth4.1
//
//  Created by 徐国洪 on 15-9-1.
//  Copyright (c) 2015年 xuGuohong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommonNavViewController : UINavigationController

@property (nonatomic, assign) UIImage *m_image;
@property (nonatomic, assign) UIViewController *m_DefalutViewCon;

@property (nonatomic, readonly, getter = rootViewController) UIViewController *rootViewController;
@property (nonatomic, readonly, getter = nowViewController) UIViewController *nowViewController;

- (UIViewController *)popViewControllerAnimated:(BOOL)animated;

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated;

- (UIViewController *)popToRootViewControllerAnimate:(BOOL)animated;

- (void)hiddenNavigationBarLine;

@end
