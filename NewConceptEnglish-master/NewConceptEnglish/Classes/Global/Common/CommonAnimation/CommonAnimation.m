//
//  CommonAnimation.m
//  jiuhaohealth4.1
//
//  Created by jiuhao-yangshuo on 15/10/22.
//  Copyright © 2015年 xuGuohong. All rights reserved.
//

#import "CommonAnimation.h"

@implementation CommonAnimation

//图片放大动画
+ (void)actionWithViewLayer:(CALayer *)layer
{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    animation.values = @[@(0.9), @(1.4), @(0.9), @(1)];
    animation.keyTimes = @[@(0), @(0.3), @(0.6), @(1)];
    animation.duration = 1.0f;
    animation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    [layer addAnimation:animation forKey:@"handler"];
}

@end
