//
//  LoadingAnimation.m
//  jiuhaohealth2.1
//
//  Created by xjs on 14-12-19.
//  Copyright (c) 2014年 xuGuohong. All rights reserved.
//

#import "LoadingAnimation.h"

@implementation LoadingAnimation
{
    NSTimer * _timer;
    UIView * headerView;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        [self creatLoadingImage];
        headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 65, 65)];
        headerView.backgroundColor = [UIColor clearColor];
        headerView.layer.cornerRadius = 15;
        headerView.center = CGPointMake(kDeviceWidth/2, (kDeviceHeight-64)/2);
        UIView * cleanView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 65, 65)];
        cleanView.tag = 525;
        cleanView.backgroundColor = [UIColor clearColor];
        [headerView addSubview:cleanView];
        
        UIView * imageView;
        for (int i = 0; i<2; i++) {
            
            imageView = [[UIView alloc]initWithFrame:CGRectMake(i*18+18, 18, 11, 11)];
            imageView.clipsToBounds = YES;
            imageView.tag = i+1;
            if (!i) {
                imageView.backgroundColor = [CommonImage colorWithHexString:@"ff4c4c"];
            }else{
                imageView.backgroundColor = [CommonImage colorWithHexString:@"ff961b"];
            }
            imageView.layer.cornerRadius = 11/2.f;
            [cleanView addSubview:imageView];
            [imageView release];
            
            imageView = [[UIView alloc]initWithFrame:CGRectMake(i*18+18, 18+7+11, 11, 11)];
            if (!i) {
                imageView.backgroundColor = [CommonImage colorWithHexString:@"00a1fe"];
            }else{
                imageView.backgroundColor = [CommonImage colorWithHexString:@"00ca72"];
            }
            imageView.clipsToBounds = YES;
            imageView.tag = i+3;
            
            imageView.layer.cornerRadius = 11/2.f;
            [cleanView addSubview:imageView];
            [imageView release];
        }
        [self addSubview:headerView];
        _timer =[NSTimer scheduledTimerWithTimeInterval:1 target:self selector: @selector(stopPlay) userInfo:nil repeats:YES];
        [_timer fire];
        
        CAKeyframeAnimation *anim = [CAKeyframeAnimation animation];
        anim.keyPath = @"transform";
        NSValue *val1 = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(0.0 * M_PI, 0, 0, 1)];
        NSValue *val2 = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(0.5 * M_PI, 0, 0, 1)];
        NSValue *val3 = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(1.0 * M_PI, 0, 0, 1)];
        NSValue *val4 = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(1.5 * M_PI, 0, 0, 1)];
        NSValue *val5 = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(2.0 * M_PI, 0, 0, 1)];
        anim.values = @[val1, val2, val3, val4, val5];
        anim.duration = 4;
        anim.removedOnCompletion = NO;
        anim.fillMode = kCAFillModeForwards;
        anim.repeatCount = MAXFLOAT;
        anim.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        [cleanView.layer addAnimation:anim forKey:@"ringLayerAnimation"];
        [cleanView release];
    }
    return self;
}

-(UIImage*)convertViewToImage:(UIView*)v{
    UIGraphicsBeginImageContext(v.bounds.size);
    [v.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage*image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void)stopPlay{
//    NSLog(@"88888");
    UIView * image1 = (UIView*)[self viewWithTag:1];
    UIView * image2 = (UIView*)[self viewWithTag:2];
    UIView * image3 = (UIView*)[self viewWithTag:3];
    UIView * image4 = (UIView*)[self viewWithTag:4];
    
    [UIView animateWithDuration:0.5 animations:^{
        image1.frame = [Common rectWithOrigin:image1.frame x:2+18 y:2+18];
        image2.frame = [Common rectWithOrigin:image1.frame x:36-2 y:2+18];
        image3.frame = [Common rectWithOrigin:image1.frame x:2+18 y:36-2];
        image4.frame = [Common rectWithOrigin:image1.frame x:36-2 y:36-2];
        
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.5 animations:^{
            image1.frame = [Common rectWithOrigin:image1.frame x:18 y:18];
            image2.frame = [Common rectWithOrigin:image1.frame x:36 y:18];
            image3.frame = [Common rectWithOrigin:image1.frame x:18 y:36];
            image4.frame = [Common rectWithOrigin:image1.frame x:36 y:36];
        }];
        
    }];

}

- (void)beginAnimating
{
    _timer =[NSTimer scheduledTimerWithTimeInterval:1 target:self selector: @selector(stopPlay) userInfo:nil repeats:YES];
    [_timer fire];
}

- (void)stopAnimating{
    UIView * cleanView = (UIView*)[headerView viewWithTag:525];
    [cleanView.layer removeAnimationForKey:@"ringLayerAnimation"];
    
    [_timer invalidate];
    _timer = nil;
    [headerView removeFromSuperview];
    [headerView release];
//    [self removeFromSuperview];
//    [self release];
//    [ringLayer removeAnimationForKey:@"ringLayerAnimation"];
}


- (UIView *) hitTest:(CGPoint) point withEvent:(UIEvent *)event
{
    CommonViewController *viewController = (CommonViewController *)self.viewController;
    CGRect expandedFrame  = CGRectMake(0 , 0 , 60, IOS_7?64:44);//返回按钮的区域
    if (viewController && viewController.m_isHideNavBar &&  CGRectContainsPoint(expandedFrame ,point))
    {
        return nil;
    }
    return [super hitTest:point withEvent:event];
}

@end
