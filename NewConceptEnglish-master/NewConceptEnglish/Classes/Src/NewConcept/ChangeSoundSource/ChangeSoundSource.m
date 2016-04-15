//
//  ChangeSoundSource.m
//  newIdea1.0
//
//  Created by yangshuo on 15/10/7.
//  Copyright (c) 2015年 xuGuohong. All rights reserved.
//

#import "ChangeSoundSource.h"
#import "CommonUser.h"

@implementation ChangeSoundSource

-(void)createContentView
{
    self.height = 100;
    
    UILabel *titleLabel = [Common createLabel:CGRectMake(UI_leftMargin, UI_leftMargin, self.width - 2*UI_leftMargin, 20) TextColor:COLOR_333333 Font:[UIFont systemFontOfSize:M_FRONT_SIXTEEN] textAlignment:NSTextAlignmentLeft labTitle:@"英音美音切换"];
    [self addSubview:titleLabel];
    
    SSCheckBoxView * checkBox = [[SSCheckBoxView alloc] initWithFrame:CGRectMake(UI_leftMargin, titleLabel.bottom +5, titleLabel.width, 30) style:kSSCheckBoxViewStyleDark checked:NO];
    [checkBox setUpCheckImage:@"common.bundle/common/exercise_option_s.png" andWithNormalImage:@"common.bundle/common/exercise_option_n.png"];
    checkBox.titleColor = [CommonImage colorWithHexString:COLOR_666666];
    [self addSubview:checkBox];
    [checkBox setText:@"英式发音"];
    
    SSCheckBoxView * checkBoxAm = [[SSCheckBoxView alloc] initWithFrame:CGRectMake(UI_leftMargin, checkBox.bottom, titleLabel.width, 30) style:kSSCheckBoxViewStyleDark checked:NO];
    [checkBoxAm setUpCheckImage:@"common.bundle/common/exercise_option_s.png" andWithNormalImage:@"common.bundle/common/exercise_option_n.png"];
    [self addSubview:checkBoxAm];
    
    WS(weakSelf);
    [checkBoxAm setStateChangedBlock:^(SSCheckBoxView *vc) {
        checkBox.checked = !vc.checked;
        [weakSelf handleChangeEnglishSucoreWithState:vc.checked];
    }];
    checkBoxAm.titleColor = checkBox.titleColor;
    [checkBoxAm setText:@"美式发音"];
    
    [checkBox setStateChangedBlock:^(SSCheckBoxView *vc) {
        checkBoxAm.checked = !vc.checked;
        [weakSelf handleChangeEnglishSucoreWithState:!vc.checked];
    }];
    BOOL state = [CommonUser getCurrentEnlishStateIsAmEnglish];
    if (!state)
    {
        checkBox.checked = YES;
    }
    else
    {
        checkBoxAm.checked = YES;
    }
}

-(void)handleChangeEnglishSucoreWithState:(BOOL)state
{
    [CommonUser saveCurrentEnlishStateWith:state];
    if (self.m_block)
    {
        self.m_block(nil);
    }
    [self hiddenView];
}

+ (void)showChangeSoundSourceWithBlock:(ContentViewControllerBlock)block
{
    ChangeSoundSource *cv = [[ChangeSoundSource alloc]init];
    [cv show];
    [cv setM_block:block];
}
@end
