//
//  TouchView.h
//  TouchDemo
//
//  Created by Zer0 on 13-10-11.
//  Copyright (c) 2013年 Zer0. All rights reserved.
//

#import <UIKit/UIKit.h>
static const NSInteger kRowCount  = 5;
//默认订阅频道数
#define KTableStartPointX 25
#define KTableStartPointY 60
//已订阅的按钮起始的位置
#define KButtonWidth  (kDeviceWidth - KTableStartPointX*2)/5.0
#define KButtonHeight 40
//按钮的大小
#define KDeltaHeight 60
//更多频道下面按钮的起始位置向下偏移
#define KMoreChannelDeltaHeight 62

@protocol TouchViewDelegate <NSObject>

@optional
- (void)arrayChange;
@end

//@class TouchViewModel;
@interface TouchView : UIImageView
{
    CGPoint _point;
    CGPoint _point2;
    NSInteger _sign;
    @public
    
    NSMutableArray * _array;
    NSMutableArray * _viewArr11;
    NSMutableArray * _viewArr22;
}
@property (nonatomic,retain) UILabel * label;
@property(nonatomic,assign)id<TouchViewDelegate> delegate;
@property (nonatomic,retain) UILabel * moreChannelsLabel;

@end
