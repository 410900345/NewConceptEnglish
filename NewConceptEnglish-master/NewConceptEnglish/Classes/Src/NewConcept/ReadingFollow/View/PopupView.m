//
//  PopupView.m
//  MSCDemo
//
//  Created by iflytek on 13-6-7.
//  Copyright (c) 2013年 iflytek. All rights reserved.
//


#import "PopupView.h"
#import <QuartzCore/QuartzCore.h>
#ifdef __IPHONE_6_0
# define ALIGN_CENTER NSTextAlignmentCenter
#else
# define ALIGN_CENTER UITextAlignmentCenter
#endif

static float kContentW = 130;
static NSInteger kPopViewTag = 1861;

@implementation PopupView
{
    
}
@synthesize ParentView = _parentView;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent: 0.75f];
        self.layer.cornerRadius = 5.0f;
        _textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 100, 10)];
        _textLabel.numberOfLines = 0;
        _textLabel.font = [UIFont systemFontOfSize:17];
        _textLabel.textColor = [UIColor whiteColor];
        _textLabel.textAlignment = ALIGN_CENTER;
        _textLabel.backgroundColor = [UIColor clearColor];
        _textLabel.textAlignment = ALIGN_CENTER;
        [self addSubview:_textLabel];
        _queueCount = 0;
    }
    return self;
}

- (void) setText:(NSString *) text
{
    _textLabel.frame = CGRectMake(0, 10, kContentW, 10);
    _queueCount ++;
    self.alpha = 1.0f;
    self.hidden = NO;
    _textLabel.text = text;
    [_textLabel sizeToFit];
    CGRect frame = CGRectMake(5, 0, _textLabel.frame.size.width, _textLabel.frame.size.height);
    _textLabel.frame = frame;
    _textLabel.frame = CGRectMake(_textLabel.frame.origin.x, _textLabel.frame.origin.y+10, _textLabel.frame.size.width, _textLabel.frame.size.height);
    frame =  CGRectMake((_parentView.frame.size.width - frame.size.width)/2, self.frame.origin.y, _textLabel.frame.size.width+10, _textLabel.frame.size.height+20);
    self.frame = frame;
    [UIView animateWithDuration:2.0
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.alpha = 0;
                         self.hidden = YES;
                     }
                     completion:^(BOOL finished){
//                         if (_queueCount == 1) {
//                             [self removeFromSuperview];
//                         }
                         _queueCount--;
                         
                     }
     ];
    
}

-(void)dismissView
{
     [self removeFromSuperview];
}

+(instancetype )showPopViewWithText:(NSString *)tipText withViewController:(UIViewController *)VC
{
    PopupView *m_popView = [VC.view viewWithTag:kPopViewTag];
    if (!m_popView)
    {
        m_popView = [[PopupView alloc] initWithFrame:CGRectMake(100, 300, 0, 0)];
        [VC.view addSubview:m_popView];
        m_popView.ParentView = VC.view;
    }
    [m_popView setText: tipText];
    m_popView.hidden = NO;
    return m_popView;
}

@end

