//
//  NewConceptDetailCell.m
//  newIdea1.0
//
//  Created by yangshuo on 15/9/26.
//  Copyright (c) 2015年 xuGuohong. All rights reserved.
//

#import "NewConceptDetailCell.h"
#import "FileManagerModel.h"

@implementation NewConceptDetailCell
{
    NSMutableDictionary *m_dict;
    UILabel *m_titleLabel;//英语
//    UILabel *m_IndexTitleLabel;//英语
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        NSString *foorString = @"sometime";
        m_titleLabel = [Common createLabel:CGRectMake(15, 0, kDeviceWidth - 15*2 , kNewConceptDetailCellHeight) TextColor:COLOR_333333 Font:[UIFont systemFontOfSize:M_FRONT_EIGHTEEN] textAlignment:NSTextAlignmentLeft labTitle:foorString];
        [self.contentView addSubview:m_titleLabel];
        
        UIImageView *accessoryView = [CommonImage creatRightArrowX:self.frame.size.width-22 Y:(self.frame.size.height-12)/2 cell:self];
        accessoryView.frame = CGRectMake(kDeviceWidth - accessoryView.width-10, (kNewConceptDetailCellHeight -accessoryView.height)/2.0, accessoryView.width, accessoryView.height);
        [self.contentView addSubview:accessoryView];
    }
    return self;
}

-(void)setM_dict:(NSDictionary *)m_infodict
{
    NSString *titleStr = [NSString stringWithFormat:@"%@. %@",m_infodict[kBookIndexTxt] ,m_infodict[kBookTxt]];
    m_titleLabel.text  =titleStr;
}
@end
