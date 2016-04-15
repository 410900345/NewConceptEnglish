//
//  WordBookListCell.m
//  newIdea1.0
//
//  Created by jiuhao-yangshuo on 16/3/29.
//  Copyright © 2016年 YangShuo. All rights reserved.
//

#import "WordBookListCell.h"
#import "AppDelegate.h"
#import "NewWordListViewController.h"

@interface WordBookListCell()

@end


@implementation WordBookListCell
{
    UIView *m_backgroundView;
    UILabel *m_labTitle;
    UILabel *m_labTDetail;
}
- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        m_backgroundView = [[UIView alloc] initWithFrame:CGRectMake(5, 5, kDeviceWidth-10, kWordBookListCell-10)];
        m_backgroundView.backgroundColor = [CommonImage colorWithHexString:@"ffffff"];
        m_backgroundView.layer.cornerRadius = 2.5f;
        m_backgroundView.layer.borderWidth = 0.5f;
        m_backgroundView.layer.masksToBounds = YES;
        m_backgroundView.layer.borderColor = [CommonImage colorWithHexString:@"e5e5e5"].CGColor;
        [self.contentView addSubview:m_backgroundView];
        
        m_labTitle = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, m_backgroundView.width-30, 30)];
        m_labTitle.backgroundColor = [UIColor clearColor];
        m_labTitle.textColor = [CommonImage colorWithHexString:@"333333"];
        m_labTitle.font = [UIFont systemFontOfSize:18];
        [m_backgroundView addSubview:m_labTitle];
        
        m_labTDetail = [Common createLabel];
        m_labTDetail.textColor = [CommonImage colorWithHexString:@"666666"];
        m_labTDetail.font = [UIFont systemFontOfSize:M_FRONT_SIXTEEN];
        m_labTDetail.frame = CGRectMake(m_labTitle.left, m_labTitle.bottom, m_labTitle.width, 20);
        [m_backgroundView addSubview:m_labTDetail];
        

        float height = m_labTDetail.bottom+15;
        float buttonHeight = m_backgroundView.height- height;
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0 ,height, m_backgroundView.width,buttonHeight);

        UIImage* image =  [CommonImage createImageWithColor:[CommonImage colorWithHexString:@"ffffff"]];
        [btn setBackgroundImage:image forState:UIControlStateNormal];
        [btn setTitle:@"开始复习" forState:UIControlStateNormal];
        [btn setTitleColor:[CommonImage colorWithHexString:COLOR_333333] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [m_backgroundView addSubview:btn];
        
        UILabel *lineLable = [Common createLineLabelWithHeight:0];
        lineLable.width = btn.width;
        [btn addSubview:lineLable];
        

        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        
        UIButton *moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
        moreButton.frame = CGRectMake(0,10, 50.0,25);
//        moreButton.layer.cornerRadius = moreButton.height/2.0;
//        moreButton.layer.masksToBounds = YES;
        moreButton.tag = 1007;
//        UIImage *backImage =  [CommonImage createImageWithColor:[CommonImage colorWithHexString:Color_Nav]];
//        [moreButton setBackgroundImage:bacyuekImage forState:UIControlStateNormal];
        [moreButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [m_backgroundView addSubview:moreButton];
//        [moreButton setTitle:@"更多" forState:UIControlStateNormal];
        [moreButton setTitleColor:[CommonImage colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
        moreButton.titleLabel.adjustsFontSizeToFitWidth = YES;
        UIImage *backImageNormal = [CommonImage ninePatchImageByCroppingImage:[UIImage imageNamed:@"common.bundle/book/word_book_display_more.png"]];
//        moreButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [moreButton setImage:backImageNormal forState:UIControlStateNormal];
        moreButton.right =  m_backgroundView.width -10;
        

    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)btnClick:(UIButton *)btn
{
    if (btn.tag == 1007)
    {
        [self routerEventWithEventType:SXEventTypeTitle userInfo:self];
    }
    else
    {
        [[self class] goToListWordViewWithDict:_dicInfo];
    }
}

+(void)goToListWordViewWithDict:(NSDictionary *)dict
{
    int count = [dict[kBookWordCount] intValue];
    
    if (!count)
    {
        [Common MBProgressTishi:@"还未添加生词" forHeight:kDeviceHeight];
        return;
    }
    AppDelegate* myDelegate = [Common getAppDelegate];
    NewWordListViewController *newBook = [[NewWordListViewController alloc] init];
    newBook.m_superDic = dict;
    [myDelegate.navigationVC pushViewController:newBook animated:YES];
}

- (void)setDicInfo:(NSMutableDictionary *)dicInfo
{
    if (_dicInfo != dicInfo)
    {
        _dicInfo = nil;
        _dicInfo = dicInfo;
        m_labTitle.text = _dicInfo[@"book_name"];
        NSString *titleString = [NSString stringWithFormat:@"词汇数目:%@个",dicInfo[kBookWordCount]];
        m_labTDetail.attributedText = [NSString replaceRedColorWithNSString:titleString andUseKeyWord:[dicInfo[kBookWordCount] stringValue] andWithFontSize:M_FRONT_SIXTEEN andWithFrontColor:COLOR_ORANGE];
    }
}

@end
