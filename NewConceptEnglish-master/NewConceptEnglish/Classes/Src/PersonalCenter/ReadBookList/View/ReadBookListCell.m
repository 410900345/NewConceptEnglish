//
//  ReadBookListCell.m
//  newIdea1.0
//
//  Created by jiuhao-yangshuo on 15/11/12.
//  Copyright © 2015年 xuGuohong. All rights reserved.
//

#import "ReadBookListCell.h"
#import "FileManagerModel.h"

static float const kMIndexTitleLabelW = 60;
@implementation ReadBookListCell
{
    NSMutableDictionary *m_dict;
    UILabel *m_titleLabel;//英语
    UILabel *m_IndexTitleLabel;//哪册书
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        m_IndexTitleLabel = [Common createLabel:CGRectMake(kDeviceWidth- kMIndexTitleLabelW -15, 0, kMIndexTitleLabelW , kReadBookListCellHeight) TextColor:COLOR_ORANGE Font:[UIFont systemFontOfSize:M_FRONT_SIXTEEN] textAlignment:NSTextAlignmentLeft labTitle:@""];
        [self.contentView addSubview:m_IndexTitleLabel];
        
        NSString *foorString = @"sometime";
        m_titleLabel = [Common createLabel:CGRectMake(15, 0, m_IndexTitleLabel.left -15 , kReadBookListCellHeight) TextColor:COLOR_333333 Font:[UIFont systemFontOfSize:M_FRONT_SIXTEEN] textAlignment:NSTextAlignmentLeft labTitle:foorString];
        [self.contentView addSubview:m_titleLabel];
        
        UIImageView *accessoryView = [CommonImage creatRightArrowX:self.frame.size.width-22 Y:(self.frame.size.height-12)/2 cell:self];
        accessoryView.frame = CGRectMake(kDeviceWidth - accessoryView.width-10, (kReadBookListCellHeight -accessoryView.height)/2.0, accessoryView.width, accessoryView.height);
        [self.contentView addSubview:accessoryView];
    }
    return self;
}

-(void)setM_dict:(NSDictionary *)m_infodict
{
    NSString *indexBook = [NSString stringWithFormat:@"第%d册", [m_infodict[@"itemBook"] intValue]+1];
    
    NSString *titleStr = [NSString stringWithFormat:@"%@. %@",m_infodict[kBookIndexTxt] ,m_infodict[kBookTxt]];
    m_titleLabel.text  =titleStr;
    m_IndexTitleLabel.text = indexBook;
}

@end
