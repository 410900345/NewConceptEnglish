//
//  ExerciseCell.m
//  newIdea1.0
//
//  Created by yangshuo on 15/9/26.
//  Copyright (c) 2015年 xuGuohong. All rights reserved.
//

#import "ExerciseCell.h"
#import "SSCheckBoxView.h"

@implementation ExerciseCell
{
    NSMutableDictionary *m_dict;
    UILabel *m_titleLabel;//英语
    SSCheckBoxView *checkBox;
    UIImageView *m_checkPicImge;//图片
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        float kNewConceptDetailItemCellHeight = 44;
        
        checkBox = [[SSCheckBoxView alloc] initWithFrame:CGRectMake(UI_leftMargin, 0, 20, 20) style:kSSCheckBoxViewStyleDark checked:NO];
        [checkBox setUpCheckImage:@"common.bundle/common/exercise_option_s.png" andWithNormalImage:@"common.bundle/common/exercise_option_n.png"];
        [self.contentView addSubview:checkBox];
        checkBox.titleFont = [UIFont systemFontOfSize:M_FRONT_SIXTEEN];
        
        NSString *foorString = @"sometime";
        float m_checkPicImgeWeight = 20;
        m_titleLabel = [Common createLabel:CGRectMake(checkBox.right+UI_leftMargin, UI_leftMargin, kDeviceWidth - checkBox.right - UI_leftMargin*3 -m_checkPicImgeWeight, kNewConceptDetailItemCellHeight - 2*UI_leftMargin) TextColor:COLOR_333333 Font:[UIFont systemFontOfSize:M_FRONT_SIXTEEN] textAlignment:NSTextAlignmentLeft labTitle:foorString];
        [self.contentView addSubview:m_titleLabel];
        m_titleLabel.numberOfLines = 0;
        
        m_checkPicImge = [[UIImageView alloc]initWithFrame:CGRectMake(kDeviceWidth - m_checkPicImgeWeight -UI_leftMargin, (kNewConceptDetailItemCellHeight-m_checkPicImgeWeight)/2.0, m_checkPicImgeWeight, m_checkPicImgeWeight)];
        [self.contentView addSubview:m_checkPicImge];
        
    }
    return self;
}

-(void)setM_dict:(NSDictionary *)m_infodict
{
    //重置数据
    checkBox.checked = NO;
    m_checkPicImge.image = [UIImage imageNamed:@""];
    
    NSString *txtAnswer = m_infodict[kTxtAnswerDetail];
    m_titleLabel.text = txtAnswer;
    float newHight = [m_infodict[kTxtCellHight] floatValue];
//    m_titleLabel.top = UI_leftMargin;
    m_titleLabel.height = newHight - 2*UI_leftMargin;
    
    checkBox.centerY = m_titleLabel.centerY;
    m_checkPicImge.centerY = m_titleLabel.centerY;
    m_checkPicImge.hidden = YES;
    if ([m_infodict[kTxtIsAnswered] boolValue])
    {
        checkBox.checked = [m_infodict[kTxtAnswerSelect] boolValue];
        UIImage *imageError = [UIImage imageNamed:@"common.bundle/common/exercise_option_f"];
        UIImage *imageCorrect = [UIImage imageNamed:@"common.bundle/common/exercise_option_t"];
        BOOL iskTxtAnswerIs = [m_infodict[kTxtAnswerIs]boolValue];//是正确答案
        m_checkPicImge.image = iskTxtAnswerIs? imageCorrect :imageError;
        if ( checkBox.checked || iskTxtAnswerIs)
        {
            m_checkPicImge.hidden = NO;//只有答案和选择才显示
        }
    }
}

+ (float)getHightFromDict:(NSMutableDictionary *)dcit
{
    float newHight = [dcit[kTxtCellHight] floatValue];
    if (!newHight)
    {
        NSString *txtDetail = dcit[kTxtAnswerDetail];
        CGSize size = [Common sizeForAllString:txtDetail andFont:M_FRONT_SIXTEEN andWight:kDeviceWidth - UI_leftMargin*3 -30 -54];
        newHight = ceilf(size.height);

        newHight += 2*UI_leftMargin;
        [dcit setObject:[NSString stringWithFormat:@"%d",(int)newHight] forKey:kTxtCellHight];
    }
    return newHight;
}

@end
