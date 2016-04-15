//
//  TouchView.m
//  TouchDemo
//
//  Created by Zer0 on 13-8-11.
//  Copyright (c) 2013年 Zer0. All rights reserved.
//

#import "TouchView.h"


@implementation TouchView
- (void)dealloc
{

}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.multipleTouchEnabled = YES;
        self.userInteractionEnabled = YES;
        UILabel *l = [[UILabel alloc] initWithFrame:CGRectZero];
        self.label = l;
        _sign = 0;
    }
    return self;
}

- (void)layoutSubviews
{
    [self.label setFrame:CGRectMake(1, 1, KButtonWidth - 2, KButtonHeight - 2)];
    self.label.adjustsFontSizeToFitWidth = YES;
  [self.label setBackgroundColor:[CommonImage colorWithHexString:@"ffffff"]];
    [self.label setTextColor:[UIColor blackColor]];
    self.label.layer.masksToBounds = YES;
    self.layer.cornerRadius = 4.0;
    self.layer.borderWidth = 0.5;
    self.layer.borderColor = [CommonImage colorWithHexString:@"dddddd"].CGColor;
    [self.label setTextAlignment:NSTextAlignmentCenter];
    [self addSubview:self.label];
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    UITouch * touch = [touches anyObject];
    
    _point = [touch locationInView:self];
    _point2 = [touch locationInView:self.superview];
    
    [self.superview exchangeSubviewAtIndex:[self.superview.subviews indexOfObject:self] withSubviewAtIndex:[[self.superview subviews] count] - 1];//拿到最外层
    
    [self enableScrollView:NO];
}

-(void)enableScrollView:(BOOL)enble
{
    UIScrollView * view = (UIScrollView *)self.superview;
    if ([view isKindOfClass:[UIScrollView class]])
    {
        view.scrollEnabled = enble;
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
     [self enableScrollView:YES];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
//    [self.label setBackgroundColor:[CommonImage colorWithHexString:Color_Nav alpha:0.6]];
    [self setImage:nil];
    
    if (_sign == 0 && ![self.label.text isEqualToString:@"头条"]) {
        if (_array == _viewArr11) {
            [_viewArr11 removeObject:self];
            [_viewArr22 insertObject:self atIndex:_viewArr22.count];
            _array = _viewArr22;
        }
        else if (_array == _viewArr22){
            [_viewArr22 removeObject:self];
            [_viewArr11 insertObject:self atIndex:_viewArr11.count];
            _array = _viewArr11;
        }
        
    }
    
    [self animationAction];
    _sign = 0;
    if ([_delegate respondsToSelector:@selector(arrayChange)])
    {
        [_delegate arrayChange];
    }
    [self enableScrollView:YES];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"%f,%f",self.frame.origin.x,self.frame.origin.y);
    
    _sign = 1;
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.superview];
    if (![self.label.text isEqualToString:@"头条"]) {
         [self.label setBackgroundColor:[CommonImage colorWithHexString:@"ffffff"]];
//        [self setImage:[UIImage imageNamed:@"order_drag_move_bg.png"]];
        [self setFrame:CGRectMake( point.x - _point.x, point.y - _point.y, self.frame.size.width, self.frame.size.height)];
        
        CGFloat newX = point.x - _point.x + KButtonWidth/2;
        CGFloat newY = point.y - _point.y + KButtonHeight/2;
//        if (!_viewArr11.count)
//        {
//            return;
//        }
//        if (!CGRectContainsPoint([[_viewArr11 objectAtIndex:0] frame], CGPointMake(newX, newY)) ) {
        //下部的
            if ( _array == _viewArr22) {
                
                if ([self buttonInArrayArea1:_viewArr11 Point:point]) {
                    
                    int index = ((int)newX - KTableStartPointX)/KButtonWidth + (kRowCount * (((int)newY - KTableStartPointY)/KButtonHeight));
                    [ _array removeObject:self];
                    [_viewArr11 insertObject:self atIndex:index];
                    _array = _viewArr11;
                    [self animationAction1a];//不排自己
                    [self animationAction2];//
                }
                //上部为空
                else if (newY < KTableStartPointY + KDeltaHeight + [self array2StartY] * KButtonHeight   &&![self buttonInArrayArea1:_viewArr11 Point:point]){
                    
                    [ _array removeObject:self];
                    [_viewArr11 insertObject:self atIndex:_viewArr11.count];
                    _array = _viewArr11;
                    [self animationAction2];//之排序2
                    
                }
                //还在下部
                else if([self buttonInArrayArea2:_viewArr22 Point:point]){
                    unsigned long index = ((unsigned long )(newX) - KTableStartPointX)/KButtonWidth + (kRowCount * (((int)(newY) - [self array2StartY] * KButtonHeight - KTableStartPointY - KDeltaHeight)/KButtonHeight));
                    [ _array removeObject:self];
                    [_viewArr22 insertObject:self atIndex:index];
                    [self animationAction2a];//之排序2
                    
                }
                //超出页面
                else if(newY > KTableStartPointY + KDeltaHeight + [self array2StartY] * KButtonHeight   &&![self buttonInArrayArea2:_viewArr22 Point:point]){
                    [ _array removeObject:self];
                    [_viewArr22 insertObject:self atIndex:_viewArr22.count];
                    [self animationAction2a];//之排序2
                    
                }
            }
            else if ( _array == _viewArr11) {//上部的
                if ([self buttonInArrayArea1:_viewArr11 Point:point]) {
                    int index = ((int)newX - KTableStartPointX)/KButtonWidth + (kRowCount * (((int)(newY) - KTableStartPointY)/KButtonHeight));
                    [ _array removeObject:self];
                    [_viewArr11 insertObject:self atIndex:index];
                    _array = _viewArr11;
                    
                    [self animationAction1a];
                    [self animationAction2];
                }
                else if (newY < KTableStartPointY + KDeltaHeight + [self array2StartY] * KButtonHeight  &&![self buttonInArrayArea1:_viewArr11 Point:point]){
                    [ _array removeObject:self];
                    [_viewArr11 insertObject:self atIndex: _array.count];
                    [self animationAction1a];
                    [self animationAction2];
                }
                else if([self buttonInArrayArea2:_viewArr22 Point:point]){
                    unsigned long index = ((unsigned long)(newX) - KTableStartPointX)/KButtonWidth + (kRowCount * (((int)(newY) - [self array2StartY] * KButtonHeight - KDeltaHeight - KTableStartPointY)/KButtonHeight));
                    [ _array removeObject:self];
                    [_viewArr22 insertObject:self atIndex:index];
                    _array = _viewArr22;
                    [self animationAction2a];
                }
                else if(newY > KTableStartPointY + KDeltaHeight + [self array2StartY] * KButtonHeight  &&![self buttonInArrayArea2:_viewArr22 Point:point]){
                    [ _array removeObject:self];
                    [_viewArr22 insertObject:self atIndex:_viewArr22.count];
                    _array = _viewArr22;
                    [self animationAction2a];
                    
                }
            }
        }
    if ([_delegate respondsToSelector:@selector(arrayChange)])
    {
        [_delegate arrayChange];
    }
    
//    }
}
- (void)animationAction1{
    for (int i = 0; i < _viewArr11.count; i++) {
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
                
            [[_viewArr11 objectAtIndex:i] setFrame:CGRectMake(KTableStartPointX + (i%kRowCount) * KButtonWidth, KTableStartPointY + (i/kRowCount)* KButtonHeight, KButtonWidth, KButtonHeight)];
        } completion:^(BOOL finished){
                
        }];
    }
}

- (void)animationAction1a{
    for (int i = 0; i < _viewArr11.count; i++) {
        if ([_viewArr11 objectAtIndex:i] != self) {
            [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
                
                [[_viewArr11 objectAtIndex:i] setFrame:CGRectMake(KTableStartPointX + (i%kRowCount) * KButtonWidth, KTableStartPointY + (i/kRowCount)* KButtonHeight, KButtonWidth, KButtonHeight)];
            } completion:^(BOOL finished){
                
            }];
        }
    }
    
}
- (void)animationAction2{
    for (int i = 0; i < _viewArr22.count; i++) {
        
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
            
            [[_viewArr22 objectAtIndex:i] setFrame:CGRectMake(KTableStartPointX + (i%kRowCount) * KButtonWidth, KTableStartPointY + [self array2StartY] * KButtonHeight + KDeltaHeight + (i/kRowCount)* KButtonHeight, KButtonWidth, KButtonHeight)];
            
        } completion:^(BOOL finished){
            
        }];
    }
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
        
        [self.moreChannelsLabel setFrame:CGRectMake(self.moreChannelsLabel.frame.origin.x, KTableStartPointY + KButtonHeight * ([self array2StartY] - 1) + KMoreChannelDeltaHeight, self.moreChannelsLabel.frame.size.width, self.moreChannelsLabel.frame.size.height)];
        
    } completion:^(BOOL finished){
        
    }];
}
- (void)animationAction2a{
    for (int i = 0; i < _viewArr22.count; i++) {
        if ([_viewArr22 objectAtIndex:i] != self) {
            
            [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
                
                
                [[_viewArr22 objectAtIndex:i] setFrame:CGRectMake(KTableStartPointX + (i%kRowCount) * KButtonWidth, KTableStartPointY + [self array2StartY] * KButtonHeight + KDeltaHeight  + (i/kRowCount)* KButtonHeight, KButtonWidth, KButtonHeight)];
                
            } completion:^(BOOL finished){
            }];
        }
        
    }
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
        
        [self.moreChannelsLabel setFrame:CGRectMake(self.moreChannelsLabel.frame.origin.x, KTableStartPointY + KButtonHeight * ([self array2StartY] - 1) + KMoreChannelDeltaHeight, self.moreChannelsLabel.frame.size.width, self.moreChannelsLabel.frame.size.height)];
        
    } completion:^(BOOL finished){
        
    }];
}
- (void)animationActionLabel{
    
}

- (void)animationAction{
    for (int i = 0; i < _viewArr11.count; i++) {
        
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
            
            [[_viewArr11 objectAtIndex:i] setFrame:CGRectMake(KTableStartPointX + (i%kRowCount) * KButtonWidth, KTableStartPointY + (i/kRowCount)* KButtonHeight, KButtonWidth, KButtonHeight)];
        } completion:^(BOOL finished){
            
        }];
    }
    for (int i = 0; i < _viewArr22.count; i++) {
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
            
            [[_viewArr22 objectAtIndex:i] setFrame:CGRectMake(KTableStartPointX + (i%kRowCount) * KButtonWidth, KTableStartPointY + KDeltaHeight + [self array2StartY] * KButtonHeight   + (i/kRowCount)* KButtonHeight, KButtonWidth, KButtonHeight)];
            
        } completion:^(BOOL finished){
            
        }];
    }
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
        
        [self.moreChannelsLabel setFrame:CGRectMake(self.moreChannelsLabel.frame.origin.x, KTableStartPointY + KButtonHeight * ([self array2StartY] - 1) + KMoreChannelDeltaHeight, self.moreChannelsLabel.frame.size.width, self.moreChannelsLabel.frame.size.height)];
        
    } completion:^(BOOL finished){
        
    }];
    
}

- (BOOL)buttonInArrayArea1:(NSMutableArray *)arr Point:(CGPoint)point{
    CGFloat newX = point.x - _point.x + KButtonWidth/2;
    CGFloat newY = point.y - _point.y + KButtonHeight/2;
    int a =  arr.count%kRowCount;//行
    unsigned long b =  arr.count/kRowCount;//列
    if ((newX > KTableStartPointX && newX < KTableStartPointX + kRowCount * KButtonWidth && newY > KTableStartPointY && newY < KTableStartPointY + b * KButtonHeight) ||
        (newX > KTableStartPointX && newX < KTableStartPointX + a * KButtonWidth && newY > KTableStartPointY + b * KButtonHeight && newY < KTableStartPointY + (b+1) * KButtonHeight) ) {
        return YES;
    }
    return NO;
}
- (BOOL)buttonInArrayArea2:(NSMutableArray *)arr Point:(CGPoint)point{
    CGFloat newX = point.x - _point.x + KButtonWidth/2;
    CGFloat newY = point.y - _point.y + KButtonHeight/2;
    int a =  arr.count%kRowCount;
    unsigned long b =  arr.count/kRowCount;
    if ((newX > KTableStartPointX && newX < KTableStartPointX + kRowCount * KButtonWidth && newY > KTableStartPointY + KDeltaHeight + [self array2StartY] * KButtonHeight   && newY < KTableStartPointY + KDeltaHeight + (b + [self array2StartY]) * KButtonHeight ) || (newX > KTableStartPointX && newX < KTableStartPointX + a * KButtonWidth && newY > KTableStartPointY + KDeltaHeight + (b + [self array2StartY]) * KButtonHeight && newY < KTableStartPointY  +KDeltaHeight + (b+[self array2StartY]+1) * KButtonHeight) ) {
        return YES;
    }
    return NO;
}
- (unsigned long)array2StartY{
    unsigned long y = 0;
    
    y = _viewArr11.count/kRowCount + 2;
    if (_viewArr11.count%kRowCount == 0) {
        y -= 1;
    }
    return y;
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end
