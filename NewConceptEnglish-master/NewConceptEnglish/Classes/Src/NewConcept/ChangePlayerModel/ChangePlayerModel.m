//
//  ChangePlayerModel.m
//  newIdea1.0
//
//  Created by jiuhao-yangshuo on 16/1/6.
//  Copyright © 2016年 xuGuohong. All rights reserved.
//

#import "ChangePlayerModel.h"
#import "CommonSet.h"


static const NSInteger checkBoxBeginTag = 5000;

@implementation ChangePlayerModel
{
    SSCheckBoxView *lastChexBox;
}

-(void)createContentView
{
    NSArray *titleArray = [BookIndexModel fetchPlayerModelTitleArray];
     float cellHight = 40;
    self.height = 40 + titleArray.count*cellHight +10;
    
    NSNumber *playerModelType = [[CommonSet sharedInstance] fetchSystemPlistValueforKey:KChangePlayerModel];
    
    UILabel *titleLabel = [Common createLabel:CGRectMake(UI_leftMargin, UI_leftMargin, self.width - 2*UI_leftMargin, 20) TextColor:COLOR_333333 Font:[UIFont systemFontOfSize:M_FRONT_SIXTEEN] textAlignment:NSTextAlignmentLeft labTitle:@"播放模式"];
    [self addSubview:titleLabel];
   
    for (int i = 0; i< titleArray.count; i++)
    {
        BOOL checkState = NO;
        if (i == playerModelType.intValue)
        {
            checkState = YES;
        }
        SSCheckBoxView * checkBox = [[SSCheckBoxView alloc] initWithFrame:CGRectMake(UI_leftMargin, titleLabel.bottom +5 + cellHight*i, titleLabel.width, cellHight) style:kSSCheckBoxViewStyleDark checked:checkState];
        checkBox.tag = checkBoxBeginTag+i;
        [checkBox setUpCheckImage:@"common.bundle/common/exercise_option_s.png" andWithNormalImage:@"common.bundle/common/exercise_option_n.png"];
        checkBox.titleColor = [CommonImage colorWithHexString:COLOR_666666];
        [self addSubview:checkBox];
        [checkBox setText:titleArray[i]];
        
        if (i == playerModelType.intValue)
        {
            lastChexBox = checkBox;
        }
        
        WS(weakSelf);
        [checkBox setStateChangedBlock:^(SSCheckBoxView *vc) {
//            checkBox.checked = !vc.checked;
            [weakSelf handleChangePlayerModelWithCheckBox:vc];
        }];
    }
}


-(void)handleChangePlayerModelWithCheckBox:(SSCheckBoxView *)checkBox
{
    BOOL state = checkBox.checked;
    PlayerModelType type = checkBox.tag - checkBoxBeginTag;
    if (state)
    {
        [[CommonSet sharedInstance] saveSystemPlistValue:@(type) forKey:KChangePlayerModel];
        if (self.m_block)
        {
            self.m_block(@(type));
        }
        [self hiddenView];
    }
    lastChexBox.checked = NO;
}

+ (void)showChangePlayerModelWithBlock:(ContentViewControllerBlock)block
{
    ChangePlayerModel *cv = [[ChangePlayerModel alloc]init];
    [cv show];
    [cv setM_block:block];
}

@end
