//
//  SupportTableViewCell.m
//  newIdea1.0
//
//  Created by yangshuo on 15/11/14.
//  Copyright © 2015年 xuGuohong. All rights reserved.
//

#import "SupportTableViewCell.h"
#import "SupportModel.h"

@interface SupportTableViewCell ()
{
    UIView *backView;
    UILabel *m_titleLabel;
    UILabel *m_labTDetail;
    UILabel *m_labTLocation;
    NSDictionary *m_dict;
    UIImageView *commentImageView;
}
@end

@implementation SupportTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self createSubviews];
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)createSubviews
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.contentView.backgroundColor =[CommonImage colorWithHexString:VERSION_BACKGROUD_COLOR2];
    
    backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 0.1)];
    backView.backgroundColor = [CommonImage colorWithHexString:@"ffffff"];
    [self.contentView addSubview:backView];
    
    m_titleLabel = [Common createLabel:CGRectMake(UI_spaceToLeft, UI_TopMargin, kDeviceWidth - 2*UI_spaceToLeft, 40) TextColor:@"ffffff" Font:[UIFont systemFontOfSize:M_FRONT_SIXTEEN] textAlignment:NSTextAlignmentLeft labTitle:@""];
    [backView addSubview:m_titleLabel];
    m_titleLabel.numberOfLines = 2;
    
    m_labTDetail = [Common createLabel:CGRectMake(UI_spaceToLeft, m_titleLabel.bottom, 100, 20) TextColor:@"ffffff" Font:[UIFont systemFontOfSize:M_FRONT_FOURTEEN] textAlignment:NSTextAlignmentLeft labTitle:@""];
    [backView addSubview:m_labTDetail];
//    m_labTDetail.backgroundColor = [UIColor redColor];
    
    float KImageW = 20;
    commentImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kDeviceWidth - 15 - KImageW, m_labTDetail.top, KImageW, KImageW)];
    [backView addSubview:commentImageView];
    commentImageView.hidden = YES;
    
    m_labTLocation = [Common createLabel:CGRectMake(m_labTDetail.right, m_labTDetail.top, commentImageView.right - m_labTDetail.right-5, 20) TextColor:@"ffffff" Font:[UIFont systemFontOfSize:M_FRONT_FOURTEEN] textAlignment:NSTextAlignmentRight labTitle:@""];
//    m_labTLocation.backgroundColor = [UIColor redColor];
    [backView addSubview:m_labTLocation];
//    m_labTDetail.right - commentImageView.left,
//    m_labTLocation = [Common createLabel:CGRectMake((m_labTDetail.right), m_labTDetail.top, kDeviceWidth-UI_spaceToLeft-(m_labTDetail.right)-commentImageView.left, 20) TextColor:@"ffffff" Font:[UIFont systemFontOfSize:M_FRONT_FOURTEEN] textAlignment:NSTextAlignmentRight labTitle:@""];
//    [backView addSubview:m_labTLocation];
//    m_labTLocation.backgroundColor = [UIColor redColor];
    
    backView.height = m_labTDetail.bottom +UI_TopMargin;
    
//    UILabel *lineLabel = [Common createLineLabelWithHeight:kSupportTableViewCellH];
//    lineLabel.backgroundColor = [CommonImage colorWithHexString:@"aaaaaa" alpha:0.8];
//    [backView addSubview:lineLabel];
}

-(void)setUpDict:(NSDictionary *)dict
{
    m_dict = dict;
    NSNumber *index = dict[@"bgColor"];
    NSNumber *money = dict[@"money"];
    NSNumber *tag = dict[@"tag"];//1 为安卓 2为ios
    NSString *city = dict[@"city"];
    NSString *username = dict[@"username"];
    
    NSString *imageStr = @"common.bundle/tools/ios.png";
    if (tag.intValue == 1)
    {
       imageStr = @"common.bundle/tools/android.png";
    }
//    commentImageView.image = [UIImage imageNamed:imageStr];
    
    NSString *indexStr = [SupportModel getIndexColorWithIndex:index.integerValue];
    backView.backgroundColor = [CommonImage colorWithHexString:indexStr];
    m_titleLabel.text = username;
    m_labTDetail.text = [NSString stringWithFormat:@"赞助 :%@ 元", money];
    NSString *source = [SupportModel getSourcePlatformFormTag:tag.integerValue];
//    m_labTLocation.text = [NSString stringWithFormat:@"位置:%@ 客户端: %@",city,source];
     m_labTLocation.text = [NSString stringWithFormat:@"位置:%@",city];
}
@end
