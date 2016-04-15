//
//  ContentViewController.m
//  newIdea1.0
//
//  Created by yangshuo on 15/10/6.
//  Copyright (c) 2015年 xuGuohong. All rights reserved.
//

#import "ContentViewController.h"
#import "AppDelegate.h"

static float const  kViewHeight = 100;
@interface ContentViewController()
{
    UIButton *m_backView;
}
@property (nonatomic, strong) UISlider *durationSlider;
@end

@implementation ContentViewController

-(id)init
{
    self = [super initWithFrame:CGRectMake(UI_leftMargin, kDeviceHeight/2.0, kDeviceWidth - 2*UI_leftMargin, kViewHeight)];
    if (self)
    {
        [self createTriangleImgeView];
        [self createContentView];
    }
    return self;
}

-(void)dealloc
{
    if (_m_block)
    {
        _m_block = nil;
    }
}

-(void )createTriangleImgeView
{
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = 4.0;
    self.layer.masksToBounds = YES;
    
    m_backView = [UIButton buttonWithType:UIButtonTypeCustom];
    [m_backView setFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight)];
    [m_backView setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.6]];
//    m_backView.frameY = IOS_7? -64:-44;
    m_backView.frameY = 0;
    AppDelegate * myAppdelegate = [Common getAppDelegate];
    CommonViewController *topView = (CommonViewController *)myAppdelegate.navigationVC.topViewController;
    [topView.view addSubview:m_backView];
    [m_backView addSubview:self];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [m_backView addTarget:self action:@selector(dismissButton:) forControlEvents:UIControlEventTouchUpInside];
    });

}

-(void)show
{
    [self setUpViewValue];
    self.center = m_backView.center;
    
    self.alpha = 0.f;
    self.transform = CGAffineTransformMakeScale(0.1f, 0.1f);
    [UIView animateWithDuration:0.2f delay:0.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.transform = CGAffineTransformMakeScale(1.05f, 1.05f);
        self.alpha = 1.f;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.08f delay:0.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.transform = CGAffineTransformIdentity;
        } completion:nil];
    }];
}

-(void)setUpViewValue
{
    if (_durationSlider)
    {
        _durationSlider.value = _m_musicPlayer.volume;
    }
}

-(void)hiddenView
{
    [self dismissButton:m_backView];
}

-(void)dismissButton:(UIButton *)btn
{
    [self dismiss:YES];
}

-(void)dismiss:(BOOL)animate
{
    if (!animate) {
        [m_backView removeFromSuperview];
        return;
    }
    [UIView animateWithDuration:0.3 animations:^{
        self.transform = CGAffineTransformMakeScale(0.1f, 0.1f);
        self.alpha = 0.f;
    } completion:^(BOOL finished) {
        [m_backView removeFromSuperview];
         m_backView = nil;
    }];
}

#pragma mark - PrivateMethod
-(void)createContentView
{
    UILabel *titleLabel = [Common createLabel:CGRectMake(UI_leftMargin, UI_leftMargin, self.width - 2*UI_leftMargin, 20) TextColor:COLOR_333333 Font:[UIFont systemFontOfSize:M_FRONT_SIXTEEN] textAlignment:NSTextAlignmentLeft labTitle:@"朗读音量调节"];
    [self addSubview:titleLabel];
    
    UIImage *image = [UIImage imageNamed:@"common.bundle/book/sound_pressed_default.png"];
    UIImageView *soundImage = [[UIImageView alloc]initWithFrame:CGRectMake(self.width - image.size.width-UI_leftMargin, titleLabel.bottom, image.size.width, image.size.height)];
    soundImage.image =  image;
    [self addSubview:soundImage];
    
    _durationSlider = [[UISlider alloc] init];
    _durationSlider.value = 1.f;
    _durationSlider.continuous = NO;
    _durationSlider.minimumTrackTintColor = [CommonImage colorWithHexString:Color_Nav];
    [_durationSlider addTarget:self action:@selector(durationSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    _durationSlider.frame  = CGRectMake(UI_leftMargin, titleLabel.bottom+15, soundImage.left - 2*UI_leftMargin, 34.0);
    [self addSubview:_durationSlider];
    _durationSlider.maximumValue = 1.0f;
    _durationSlider.minimumValue = 0.0f;
    soundImage.centerY = _durationSlider.centerY;
    
    float m_isPlaySound = [[[CommonSet sharedInstance] fetchSystemPlistValueforKey:kPlaySound] floatValue];
    _durationSlider.value = m_isPlaySound;
    
}

- (void)durationSliderValueChanged:(UISlider *)slider
{
    if (_m_musicPlayer)
    {
        _m_musicPlayer.volume = slider.value;
        [[CommonSet sharedInstance] saveSystemPlistValue:@(_m_musicPlayer.volume) forKey:kPlaySound];
    }
}
@end
