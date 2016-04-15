//
//  ChangeSpeed.m
//  newIdea1.0
//
//  Created by yangshuo on 15/10/9.
//  Copyright (c) 2015年 xuGuohong. All rights reserved.
//

#import "ChangeSpeed.h"

@implementation ChangeSpeed
{
    UISlider *_durationSlider;
}

-(void)createContentView
{
    self.height = 100;
    
    UILabel *titleLabel = [Common createLabel:CGRectMake(UI_leftMargin, UI_leftMargin, self.width - 2*UI_leftMargin, 20) TextColor:COLOR_333333 Font:[UIFont systemFontOfSize:M_FRONT_SIXTEEN] textAlignment:NSTextAlignmentLeft labTitle:@"朗读速度调节"];
    [self addSubview:titleLabel];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(self.width-50-10,titleLabel.top, 50,titleLabel.height);
    [btn setTitle:@"恢复" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:M_FRONT_SIXTEEN];
    btn.layer.masksToBounds = YES;
    btn.layer.borderColor = [CommonImage colorWithHexString:@"c8c8c8"].CGColor;
    btn.layer.borderWidth = 0.5;
    btn.layer.cornerRadius = 2.0f;
    btn.clipsToBounds = YES;
    UIImage* disenbleImage= [CommonImage createImageWithColor:[CommonImage colorWithHexString:@"ffffff"]];
    UIImage* enbleImage = [CommonImage createImageWithColor:[CommonImage colorWithHexString:@"cccccc"]];
    [btn setBackgroundImage:disenbleImage forState:UIControlStateNormal];
    [btn setBackgroundImage:enbleImage forState:UIControlStateHighlighted];
    [btn setTitleColor:[CommonImage colorWithHexString:Color_Nav] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(restBtn) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
    
    _durationSlider = [[UISlider alloc] init];
    _durationSlider.value = 1.f;
    _durationSlider.continuous = NO;
    [_durationSlider setThumbImage:[UIImage imageNamed:@"common.bundle/player/seek_thumb_normal.png"] forState:UIControlStateNormal];
    _durationSlider.minimumTrackTintColor = [CommonImage colorWithHexString:Color_Nav];
    [_durationSlider addTarget:self action:@selector(durationSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    _durationSlider.frame  = CGRectMake(UI_leftMargin, titleLabel.bottom +15, self.width - 2*UI_leftMargin, 34.0);
    [self addSubview:_durationSlider];
    _durationSlider.maximumValue = 2.0f;
    _durationSlider.minimumValue = 0.0f;
    
    float m_isPlayRate = [[[CommonSet sharedInstance] fetchSystemPlistValueforKey:kPlayRate] floatValue];
    _durationSlider.value = m_isPlayRate;
}

-(void)setUpViewValue
{
    if (_durationSlider)
    {
        _durationSlider.value = self.m_musicPlayer.rate;
        NSLog(@"-------%f",_durationSlider.value);
    }
}

- (void)durationSliderValueChanged:(UISlider *)slider
{
    if (self.m_musicPlayer)
    {
        self.m_musicPlayer.rate = slider.value;
        [[CommonSet sharedInstance] saveSystemPlistValue:@(_durationSlider.value) forKey:kPlayRate];
    }
}

-(void)restBtn
{
    if (self.m_musicPlayer)
    {
        _durationSlider.value = 1.0;
        self.m_musicPlayer.rate = _durationSlider.value;
        [[CommonSet sharedInstance] saveSystemPlistValue:@(_durationSlider.value) forKey:kPlayRate];
    }
}

+(void)showChangeSpeedWithPlayer:(AVAudioPlayer*)player
{
    ChangeSpeed *cv = [[ChangeSpeed alloc]init];
    cv.m_musicPlayer = player;
    [cv show];
}
@end
