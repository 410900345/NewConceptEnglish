//
//  NewConceptItemVC.m
//  newIdea1.0
//
//  Created by yangshuo on 15/9/26.
//  Copyright (c) 2015年 xuGuohong. All rights reserved.
//

#import "NewConceptDetailItemCell.h"
#import "FileManagerModel.h"

@implementation NewConceptDetailItemCell
{
    UILabel *m_titleLabel;//英语
}
@synthesize m_dict;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        NSString *foorString = @"sometime";
        m_titleLabel = [Common createLabel:CGRectMake(15, UI_leftMargin, kDeviceWidth - UI_leftMargin*2 , kNewConceptDetailItemCellHeight-2*UI_leftMargin) TextColor:COLOR_333333 Font:[UIFont systemFontOfSize:M_FRONT_EIGHTEEN] textAlignment:NSTextAlignmentLeft labTitle:foorString];
        [self.contentView addSubview:m_titleLabel];
        m_titleLabel.numberOfLines = 0;
    }
    return self;
}

-(void)setM_dict:(NSMutableDictionary *)m_infodict
{
    m_dict = m_infodict;
    NSString *txtDetail = m_infodict[kTxtDetail];
    m_titleLabel.text = txtDetail;
    float newHight = [m_infodict[kTxtCellHight] floatValue];
    m_titleLabel.height = newHight - 2*UI_leftMargin;
    BOOL isChange = [m_dict[kTxtChangeColor] boolValue];
    [self changeCellLabelColorIsChange:isChange];
}

+ (float)getHightFromDict:(NSMutableDictionary *)dcit
{
    float newHight = [dcit[kTxtCellHight] floatValue];
    if (!newHight)
    {
        NSString *txtDetail = dcit[kTxtDetail];
        CGSize size = [Common sizeForAllString:txtDetail andFont:M_FRONT_EIGHTEEN andWight:kDeviceWidth - UI_leftMargin*2];
        newHight = ceilf(size.height);
        newHight += 2*UI_leftMargin;
        [dcit setObject:[NSString stringWithFormat:@"%d",(int)newHight] forKey:kTxtCellHight];
    }
    return newHight;
}

- (void)changeCellColorIsChange:(BOOL)isChange
{
    [m_dict setObject:@(isChange) forKey:kTxtChangeColor];
    WS(weakSelf);
    [UIView animateWithDuration:0.2 animations:^{
          [weakSelf changeCellLabelColorIsChange:isChange];
    }];
}

- (void)changeCellLabelColorIsChange:(BOOL)isChange
{
     m_titleLabel.textColor = [CommonImage colorWithHexString:(isChange? Color_Nav:COLOR_333333)];
}
@end
