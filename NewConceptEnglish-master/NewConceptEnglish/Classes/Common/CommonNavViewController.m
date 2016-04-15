//
//  CommonNavViewController.m
//  jiuhaohealth4.1
//
//  Created by 徐国洪 on 15-9-1.
//  Copyright (c) 2015年 xuGuohong. All rights reserved.
//

#import "CommonNavViewController.h"

@interface CommonNavViewController ()

@end

@implementation CommonNavViewController

- (id)initWithRootViewController:(UIViewController *)rootViewController
{
    self = [super initWithRootViewController:rootViewController];
    if (self) {
        //        [self hiddenNavigationBarLine];
    }
    
    return self;
}

- (UIViewController*)nowViewController
{
    return [self.viewControllers objectAtIndex:self.viewControllers.count - 1];
}

- (UIViewController*)rootViewController
{
    return [self.viewControllers objectAtIndex:0];
}

- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item {
    //handle the action here
    
    if([self.viewControllers count] < [navigationBar.items count]) {
        return YES;
    }
    
    UIViewController *lastVC = [self.viewControllers lastObject];
    
    if ([lastVC closeNowView]) {
        [self popViewControllerAnimated:YES];
    }
    return NO;
}

- (UIViewController*)popViewControllerAnimated:(BOOL)animated
{
    CommonViewController *close = (CommonViewController*)[self.viewControllers objectAtIndex:self.viewControllers.count-1];
    if (close.m_isPopAndPushing)
    {
        
        NSArray *list = self.navigationBar.subviews;
        
        for ( id obj in list) {
            //            if ([obj isKindOfClass:[UIView class]]) {
            if ([obj isKindOfClass:objc_getClass("_UINavigationBarBackIndicatorView")]) {
                UIView *imageView=(UIView *)obj;
                imageView.alpha = 1;
            }
        }
        
        return close;
    }
    
    NSInteger index= self.viewControllers.count-2;
    if (index<0) {
        index = 0;
    }
    CommonViewController *show = (CommonViewController*)[self.viewControllers objectAtIndex:index];
    if (show.m_isHideNavBar != close.m_isHideNavBar) {
        
        if (close.m_isHideNavBar) {
            
            float y = 20;
            if (IOS_7) {
                y = 0;
            }
            
            UIImageView* imageViewTest = [[UIImageView alloc] initWithFrame:CGRectMake(0, y, kDeviceWidth, kDeviceHeight + 64)];
            imageViewTest.image = [CommonImage imageWithView:self.view];
            imageViewTest.contentMode = UIViewContentModeTop;
            [APP_DELEGATE addSubview:imageViewTest];
            [imageViewTest release];
//            self.navigationBar.hidden = show.m_isHideNavBar;
            
            float widht = kDeviceWidth;
            if (IOS_7) {
                widht = kDeviceWidth/1.45;
            }
            self.view.transform = CGAffineTransformMakeTranslation(-widht, 0);
            
            [UIView animateWithDuration:0.35 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{ //修改坐标
                self.view.transform = CGAffineTransformMakeTranslation(0, 0);
                
                imageViewTest.transform = CGAffineTransformMakeTranslation(kDeviceWidth, 0);
            } completion:^(BOOL finished) {
                [imageViewTest removeFromSuperview];
            }];
        }
        else {
            
            float height = 64;
            UIImage* image = [CommonImage imageWithView:self.view forSize:CGSizeMake(kDeviceWidth, height)];
            
//            self.navigationBar.hidden = show.m_isHideNavBar;
            
            UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, -64, kDeviceWidth, height)];
            imageView.image = image;
            [close.view addSubview:imageView];
            [imageView release];
        }
    }
    close.m_isPopAndPushing = YES;
    show.m_isPopAndPushing = YES;
    
    return [super popViewControllerAnimated:animated];
}

- (UIViewController*)popToRootViewControllerAnimate:(BOOL)animated
{
    
    return [[self popToRootViewControllerAnimated:animated] objectAtIndex:0];
}

- (void)pushViewController:(UIViewController*)viewController animated:(BOOL)animated
{
    BOOL is = animated;
    
    if (((CommonViewController *)(self.topViewController)).m_isPopAndPushing)
    {
        return;
    }
    if (self.viewControllers.count) {
        
        CommonViewController *vc1 = (CommonViewController*)[self.viewControllers objectAtIndex:self.viewControllers.count-1];
        CommonViewController *vc2 = (CommonViewController*)viewController;
        
        if (vc1.m_isHideNavBar != vc2.m_isHideNavBar) {
            
            animated = NO;
            
            float y = 20;
            if (IOS_7) {
                y = 0;
            }
            
            UIImageView* imageViewTest = [[UIImageView alloc] initWithFrame:CGRectMake(0, y, kDeviceWidth, kDeviceHeight + 64)];
            imageViewTest.image = [CommonImage imageWithView:self.view];
            imageViewTest.contentMode = UIViewContentModeTop;
            [APP_DELEGATE addSubview:imageViewTest];
            [imageViewTest release];
            
//            self.navigationBar.hidden = vc2.m_isHideNavBar;
            
            APP_DELEGATE.rootViewController.view.transform = CGAffineTransformMakeTranslation(kDeviceWidth, 0);
            
            [APP_DELEGATE bringSubviewToFront:APP_DELEGATE.rootViewController.view];
            
            [UIView animateWithDuration:0.35 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{ //修改坐标
                APP_DELEGATE.rootViewController.view.transform = CGAffineTransformMakeTranslation(0, 0);
                float widht = kDeviceWidth;
                if (IOS_7) {
                    widht = kDeviceWidth/1.45;
                }
                imageViewTest.transform = CGAffineTransformMakeTranslation(-widht, 0);
            } completion:^(BOOL finished) {
                [imageViewTest removeFromSuperview];
            }];
        }
    }
    ((CommonViewController *)(self.topViewController)).m_isPopAndPushing = YES;
    ((CommonViewController *)(viewController)).m_isPopAndPushing = YES;
    [super pushViewController:viewController animated:is];
    
//    if (self.viewControllers.count > 1) {
        //        [self createBackBtn:viewController];
        //开启iOS7的滑动返回效果
        //        if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        //            self.interactivePopGestureRecognizer.delegate = nil;
        //        }
//    }
}

- (void)removeImageView:(UIImageView*)imageV
{
    [imageV removeFromSuperview];
}

- (void)popMySelf
{
    UIViewController* vc = [self.viewControllers objectAtIndex:self.viewControllers.count - 1];
    if ([vc closeNowView]) {
        @try {
            [vc.navigationController popViewControllerAnimated:YES];
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
    }
}

/**
 *  ios7以下 用leftBarButtonItem作为 返回
 */
- (void)createBackBtn:(UIViewController*)vc
{
    UISwipeGestureRecognizer * Right = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(popMySelf)];
    Right.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:Right];
    [Right release];
    
    UIButton* but = [UIButton buttonWithType:UIButtonTypeCustom];
    but.frame = CGRectMake(0, 0, 44, 44);
    [but addTarget:self action:@selector(popMySelf) forControlEvents:UIControlEventTouchUpInside];
    but.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [but setImage:[UIImage imageNamed:@"common.bundle/nav/back_nor.png"] forState:UIControlStateNormal];
    [but setImage:[UIImage imageNamed:@"common.bundle/nav/back_pre.png"] forState:UIControlStateHighlighted];
    
    UIBarButtonItem* backBar = [[UIBarButtonItem alloc] initWithCustomView:but];
    vc.navigationItem.leftBarButtonItem = backBar;
    //    backBar.customView.hidden = YES;
    [backBar release];
}

@end
