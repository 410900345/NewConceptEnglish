//
//  BackContentView.m
//  newIdea1.0
//
//  Created by yangshuo on 16/3/22.
//  Copyright © 2016年 YangShuo. All rights reserved.
//

#import "BackContentView.h"
#import "FileManagerModel.h"

@implementation BackContentView
{
    UILabel *titleLabel;
    UIView *topView;
    UILabel *contentLabel;
    UIImageView * m_vocImage;
    WordModel *m_wordModel;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        titleLabel = [Common createLabel: CGRectMake(UI_TopMargin,0, frame.size.width-2*UI_TopMargin,30) TextColor:COLOR_333333 Font:[UIFont systemFontOfSize:18.] textAlignment:NSTextAlignmentLeft labTitle:@""];
        [self addSubview:titleLabel];
    
        topView = [[UIView alloc]initWithFrame:CGRectMake(0,0, frame.size.width, 120)];
        topView.backgroundColor = [CommonImage colorWithHexString:kBackColor];
        [self addSubview:topView];
        
        contentLabel = [Common createLabel: CGRectMake(UI_TopMargin,UI_TopMargin, topView.width-2*UI_TopMargin,30) TextColor:COLOR_333333 Font:[UIFont systemFontOfSize:16.] textAlignment:NSTextAlignmentLeft labTitle:@""];
        [topView addSubview:contentLabel];
        contentLabel.numberOfLines = 0;
        
    }
    return self;
}

-(void)createContentViewWithWordModel:(WordModel *)wordModel
{
    m_wordModel = wordModel;
    NSString *title = wordModel.title;
    NSString *content = wordModel.content;
    self.backgroundColor = [UIColor clearColor];
    float contenth = 0;
    
    if (title.length) {
        titleLabel.text = title;
        contenth = titleLabel.height;
        titleLabel.hidden = NO;
    }
    else
    {
        titleLabel.hidden = YES;
    }
    
    contentLabel.width = topView.width-2*UI_TopMargin;
    if (wordModel.readSentense)
    {
        if (!m_vocImage)
        {
            UIImage *rightImage = [UIImage imageNamed:@"common.bundle/book/bar_voice.png"];
            float imageW = 20;
            m_vocImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, imageW,imageW)];
            m_vocImage.contentMode = UIViewContentModeScaleAspectFill;
            m_vocImage.image = [rightImage imageWithNavTintColor];
            m_vocImage.userInteractionEnabled = YES;
            [topView addSubview:m_vocImage];
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(takePicture)];
            [m_vocImage addGestureRecognizer:tap];
        }
        m_vocImage.center = CGPointMake(topView.width - m_vocImage.width-5, contentLabel.centerY);
        contentLabel.width = topView.width-3*UI_TopMargin;
    }
    else
    {
        m_vocImage.hidden = YES;
    }
    
    
    topView.top = contenth;
    
    NSMutableAttributedString *attriStr = [NSString replaceRedColorWithNSString:content andUseKeyWord:wordModel.keyWord andWithFontSize:16.0 andWithFrontColor:Color_Nav];
    contentLabel.attributedText = attriStr;
    [contentLabel sizeToFit];
    topView.height = contentLabel.bottom+UI_TopMargin;
    self.height =  topView.height+ contenth;
    
}

-(void)takePicture
{
    NSString *title = m_wordModel.readSentense;
    [[FileManagerModel sharedFileManagerModel] readWordFromResoure:title withIsUk:YES withUrl:nil];
}
@end
