//
//  CellFloatView.h
//  jiuhaohealth4.0
//
//  Created by jiuhao-yangshuo on 15-4-30.
//  Copyright (c) 2015年 xuGuohong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FloatViewDelegate <NSObject>

- (void)didSelectedRowAtIndex:(int)index;

- (void)dismissView;//消失

- (void)loadSuccess;//加载成功
@end

@interface FloatView : UIView

@property (nonatomic, assign) id<FloatViewDelegate> delegate;

-(id)initWithPointButton:(UIView *)touchView withData:(NSString*)data;

-(void)setUpDeledate:(id)delegate;

-(void)show;

// 如下两个方法一般不会用到
//-(void)dismiss;

-(void)dismiss:(BOOL)animated;


@end
