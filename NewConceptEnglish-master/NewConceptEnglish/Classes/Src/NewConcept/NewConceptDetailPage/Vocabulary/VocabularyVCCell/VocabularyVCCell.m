//
//  VocabularyVCCell.m
//  newIdea1.0
//
//  Created by yangshuo on 15/9/26.
//  Copyright (c) 2015年 xuGuohong. All rights reserved.
//

#import "VocabularyVCCell.h"
#import "FileManagerModel.h"
#import "DBOperate.h"
#import "UIButton+EnlargeTouchArea.h"
#import "SXManageView.h"

@implementation VocabularyVCCell
{
    NSMutableDictionary *m_dict;
    UILabel *m_titleLabel;//英语
    UILabel *m_subTitleLabel;//中文
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        NSString *foorString = @"sometime";
        m_titleLabel = [Common createLabel:CGRectMake(15, UI_TopMargin-1, kDeviceWidth - UI_leftMargin*2 , 24) TextColor:COLOR_666666 Font:[UIFont fontWithName:M_FONT_TYPESX size: M_FRONT_SIXTEEN] textAlignment:NSTextAlignmentLeft labTitle:foorString];
        [self.contentView addSubview:m_titleLabel];
        m_titleLabel.numberOfLines = 0;
        
        m_subTitleLabel = [Common createLabel:CGRectMake(m_titleLabel.left, m_titleLabel.bottom+3, kDeviceWidth - UI_leftMargin*2 , 20) TextColor:COLOR_666666 Font:[UIFont systemFontOfSize:M_FRONT_SIXTEEN] textAlignment:NSTextAlignmentLeft labTitle:foorString];
        [self.contentView addSubview:m_subTitleLabel];
        m_subTitleLabel.numberOfLines = 0;
        
        NSArray *imageArray = @[@"common.bundle/book/learn_addword_nor.png",@"common.bundle/book/learn_voice_nor.png"];
        float buttonWeight = 45;
        for(int i= 0;i<2;i++)
        {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(kDeviceWidth- (2-i)*(buttonWeight +UI_leftMargin) ,(kVocabularyVCCellHeight- buttonWeight)/2.0, buttonWeight,buttonWeight);
            btn.tag = 1000 + i;
//            [btn setTitle:@"123" forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:imageArray[i]] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.contentView addSubview:btn];
            [btn setEnlargeEdgeWithTop:5 right:0 bottom:5
                                  left:5];
        }
    }
    return self;
}


-(void)btnClick:(UIButton *)btn
{
    NSString *txtDetail = m_dict[kTxtDetail];
    NSArray *titleArray = [txtDetail componentsSeparatedByString:@"["];
    txtDetail = [titleArray firstObject];
    switch (btn.tag -1000) {
        case 0:
        {
            NSLog(@"1213");
            NSString *symbol = [@"[" stringByAppendingString:[titleArray lastObject]];
          [SXManageView fillModelWithWord:txtDetail andSymbol:symbol andExplain:m_dict[kTxtChinese]];
//             [[DBOperate shareInstance] insertSingleDataToDBWithData:@{KWordName :txtDetail}];
            break;
        }
        case 1:
        {
            NSLog(@"223333");
            NSAssert(txtDetail != nil, @"Argument must be non-nil");
            [[FileManagerModel sharedFileManagerModel]readWordFromResoure:txtDetail withIsUk:NO withUrl:nil];
            break;
        }
        default:
            break;
    }
}


-(void)setM_dict:(NSDictionary *)m_infodict
{
    m_dict = m_infodict;
    NSString *txtDetail = m_infodict[kTxtDetail];
    txtDetail = [txtDetail stringByReplacingOccurrencesOfString:@"  " withString:@" "];
    NSArray *titleArray = [txtDetail componentsSeparatedByString:@"["];
    NSString  *keyTxtDetail = [titleArray firstObject];
    NSAttributedString *titleStr = [NSString replaceRedColorWithNSString:txtDetail andUseKeyWord:keyTxtDetail andWithCsutomFont:[UIFont systemFontOfSize:M_FRONT_NINTEEN] andWithFrontColor:COLOR_333333];
    m_titleLabel.attributedText = titleStr;
//    m_titleLabel.text = txtDetail;
    m_subTitleLabel.text = m_infodict[kTxtChinese];
}
@end
