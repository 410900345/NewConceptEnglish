//
//  BilingualismVCCell.m
//  newIdea1.0
//
//  Created by yangshuo on 15/9/26.
//  Copyright (c) 2015年 xuGuohong. All rights reserved.
//

#import "BilingualismVCCell.h"
#import "FileManagerModel.h"

@implementation BilingualismVCCell
{
    UILabel *m_titleLabel;//英语
    UILabel *m_subTitleLabel;//中文
}

@synthesize m_dict;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        NSString *foorString = @"sometime";
        m_titleLabel = [Common createLabel:CGRectMake(15, UI_leftMargin, kDeviceWidth - UI_leftMargin*2 , 20) TextColor:COLOR_333333 Font:[UIFont systemFontOfSize:M_FRONT_SIXTEEN] textAlignment:NSTextAlignmentLeft labTitle:foorString];
        [self.contentView addSubview:m_titleLabel];
        m_titleLabel.numberOfLines = 0;
        
        m_subTitleLabel = [Common createLabel:CGRectMake(m_titleLabel.left, m_titleLabel.bottom, kDeviceWidth - UI_leftMargin*2 , 20) TextColor:COLOR_999999 Font:[UIFont systemFontOfSize:M_FRONT_SIXTEEN] textAlignment:NSTextAlignmentLeft labTitle:foorString];
        [self.contentView addSubview:m_subTitleLabel];
        m_subTitleLabel.numberOfLines = 0;
    }
    return self;
}

-(void)setM_dict:(NSMutableDictionary *)m_infodict
{
    m_dict = m_infodict;
    NSString *txtDetail = m_infodict[kTxtDetail];
    m_titleLabel.text = txtDetail;
    CGSize size = [Common sizeForAllString:txtDetail andFont:M_FRONT_SIXTEEN andWight:kDeviceWidth - UI_leftMargin*2];
    m_titleLabel.height = ceilf(size.height);
    
    m_subTitleLabel.top = m_titleLabel.bottom + UI_leftMargin;
    NSString *txtSubDetail = m_infodict[kTxtChinese];
    m_subTitleLabel.text = txtSubDetail;
    size = [Common sizeForAllString:txtSubDetail andFont:M_FRONT_SIXTEEN andWight:kDeviceWidth - UI_leftMargin*2];
    m_subTitleLabel.height = ceilf(size.height);
    
    BOOL isChange = [m_dict[kTxtChangeColor] boolValue];
    [self changeCellLabelColorIsChange:isChange];
}

//变颜色
-(void)changeCellColorIsChange:(BOOL)isChange
{
    [m_dict setObject:@(isChange) forKey:kTxtChangeColor];
    [self changeCellLabelColorIsChange:isChange];
}

- (void)changeCellLabelColorIsChange:(BOOL)isChange
{
    m_titleLabel.textColor = [CommonImage colorWithHexString:(isChange? Color_Nav:COLOR_333333)];
    m_subTitleLabel.textColor = [CommonImage colorWithHexString:(isChange? Color_Nav:COLOR_999999)];
}

+ (float)getHightFromDict:(NSMutableDictionary *)dcit
{
    float newHight = [dcit[kTxtCellHight] floatValue];
    if (!newHight)
    {
        NSString *txtDetail = dcit[kTxtDetail];
        CGSize size = [Common sizeForAllString:txtDetail andFont:M_FRONT_SIXTEEN andWight:kDeviceWidth - UI_leftMargin*2];
        newHight += ceilf(size.height);
        newHight += UI_leftMargin;
        
        NSString *txtSubDetail = dcit[kTxtChinese];
        size = [Common sizeForAllString:txtSubDetail andFont:M_FRONT_SIXTEEN andWight:kDeviceWidth - UI_leftMargin*2];
        newHight += ceilf(size.height);
//        if (newHight < kNewConceptDetailItemCellHeight-2*UI_leftMargin)
//        {
//            newHight  = kNewConceptDetailItemCellHeight;
//        }
        newHight += 2*UI_leftMargin;
        [dcit setObject:[NSString stringWithFormat:@"%d",(int)newHight] forKey:kTxtCellHight];
    }
    return newHight;
}

@end
