//
//  DefauleViewController.h
//  jiuhaohealth2.1
//
//  Created by 徐国洪 on 14-7-26.
//  Copyright (c) 2014年 xuGuohong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DefauleViewController : CommonViewController
{
    NSArray *m_viewArray;
    
    int m_selectViewIndex;
    UIViewController *m_selectedViewController;
    UIView *m_selectedView;
//    UIImageView *customBarView;
    
    int m_prevViewControllersnum;
    
    BOOL m_lock;
}

@property (nonatomic, strong) UIImageView *customBarView;

@property (nonatomic, retain) UIViewController *m_selectedViewController;

- (void)setTabbarShowHiddle:(NSNotification*)aNotification;

@end
