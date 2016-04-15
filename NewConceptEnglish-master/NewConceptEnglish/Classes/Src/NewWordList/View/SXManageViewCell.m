//
//  SXManageViewCell.m
//  newIdea1.0
//
//  Created by jiuhao-yangshuo on 16/3/29.
//  Copyright © 2016年 YangShuo. All rights reserved.
//

#import "SXManageViewCell.h"

@implementation SXManageViewCell
{
    UILabel *nameLable;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        float spaceImageW = 25.0;

        nameLable = [Common createLabel:CGRectMake(15,0,kDeviceWidth-30, kSXManageViewCellH) TextColor:@"333333" Font:[UIFont systemFontOfSize:M_FRONT_SIXTEEN] textAlignment:NSTextAlignmentLeft labTitle:@"123"];
        [self.contentView addSubview:nameLable];
    }
    return self;
}

- (void)dealloc
{
    nameLable = nil;
}

-(void)setM_dict:(NSDictionary *)m_dict
{
    nameLable.text = m_dict[@"book_name"];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
@end
