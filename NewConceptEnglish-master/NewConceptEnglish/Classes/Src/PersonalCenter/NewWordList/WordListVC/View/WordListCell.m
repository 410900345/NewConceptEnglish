//
//  WordListCell.m
//  newIdea1.0
//
//  Created by jiuhao-yangshuo on 15/11/9.
//  Copyright © 2015年 xuGuohong. All rights reserved.
//

#import "WordListCell.h"

@implementation WordListCell
{
    UILabel *m_textLable;
    UILabel *m_subTextLable;

    UIImageView * m_vocImage;

}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleGray;
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews
{
    UIImage *rightImage = [UIImage imageNamed:@"common.bundle/other/bar_vlume_small.png"];
    float imageW = 20;
    m_vocImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, imageW,imageW)];
    m_vocImage.contentMode = UIViewContentModeScaleAspectFill;
    m_vocImage.image = [rightImage imageWithNavTintColor];
    m_vocImage.userInteractionEnabled = YES;
    [self.contentView addSubview:m_vocImage];
    m_vocImage.center = CGPointMake(kDeviceWidth - m_vocImage.width-25, KWordListCellH/2.0);
    
    m_textLable = [Common createLabel:CGRectMake(15, 4, m_vocImage.left - 15, 30) TextColor:COLOR_333333 Font:[UIFont systemFontOfSize:M_FRONT_EIGHTEEN] textAlignment:NSTextAlignmentLeft labTitle:@"123"];
    m_textLable.numberOfLines = 0;
    m_textLable.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview: m_textLable];
    
    m_subTextLable = [Common createLabel:CGRectMake(15, m_textLable.bottom, kDeviceWidth-30, 30) TextColor:COLOR_999999 Font:[UIFont systemFontOfSize:M_FRONT_EIGHTEEN] textAlignment:NSTextAlignmentLeft labTitle:@"123"];
    m_subTextLable.numberOfLines = 0;
    m_subTextLable.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview: m_subTextLable];
}

-(void)setUpDict:(NSMutableDictionary *)content
{
    m_textLable.text = content[@"word"];
    m_subTextLable.text = content[@"explain"];
}

@end
