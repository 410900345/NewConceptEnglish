//
//  ExplainDetailVC.m
//  newIdea1.0
//
//  Created by yangshuo on 15/9/26.
//  Copyright (c) 2015年 xuGuohong. All rights reserved.
//

#import "ExplainDetailVC.h"
#import "UITextView+Extras.h"
#import "FloatView.h"
#import "GlideTooltip.h"

@interface ExplainDetailVC()<UITextViewDelegate,FloatViewDelegate>
{
    UITextView *m_textView;
    UILabel* m_selectionView;
}
@end

@implementation ExplainDetailVC

#pragma mark - life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self getsSubViews];
}

#pragma mark - ScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self removeHighlight];
}

-(void)getsSubViews
{
    m_textView = [[UITextView alloc]initWithFrame:CGRectMake(UI_TopMargin, 0, kDeviceWidth -2*UI_TopMargin, kDeviceHeight -35)];
    m_textView.editable = NO;
//    m_textView.delegate = self;
    m_textView.backgroundColor = self.view.backgroundColor;
    [self.view addSubview:m_textView];
    m_textView.textColor = [CommonImage colorWithHexString:COLOR_333333];
    m_textView.showsVerticalScrollIndicator = NO;
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap:)];
    [self.view addGestureRecognizer:tap];
    
    m_selectionView = [[UILabel alloc]initWithFrame:CGRectZero];
    m_selectionView.font = [UIFont systemFontOfSize:M_FRONT_EIGHTEEN];
    m_selectionView.backgroundColor = [UIColor grayColor];
    m_selectionView.textColor = [CommonImage colorWithHexString:COLOR_333333];
    m_selectionView.adjustsFontSizeToFitWidth = YES;
    [m_textView addSubview:m_selectionView];
}


//刷新数据
-(void)refrehTableViewWithData:(NSArray *)array
{
    NSString *allstring = [array componentsJoinedByString:@"\n"];
    NSAssert(allstring != nil, @"Argument must be non-nil");
    
    NSMutableParagraphStyle *paragraphStyle =[[NSMutableParagraphStyle  alloc] init];
    paragraphStyle.minimumLineHeight = 25;;
    paragraphStyle.maximumLineHeight = 25;
    
    NSDictionary *attributtes = @{
                                  NSParagraphStyleAttributeName : paragraphStyle,
                                  NSForegroundColorAttributeName : [CommonImage colorWithHexString:COLOR_333333],
                                  NSFontAttributeName : [UIFont systemFontOfSize:M_FRONT_SIXTEEN]
                                  };
    NSMutableAttributedString *attrituteString = [[NSMutableAttributedString alloc] initWithString:allstring attributes:attributtes] ;
    m_textView.attributedText = attrituteString;
}

//语法详情
-(void)refrehGrammarViewWithData:(NSString *)allstring
{
    if (!allstring.length)
    {
        return;
    }
    
    NSMutableParagraphStyle *paragraphStyle =[[NSMutableParagraphStyle  alloc] init];
    paragraphStyle.minimumLineHeight = 25;;
    paragraphStyle.maximumLineHeight = 25;
    
    NSDictionary *attributtes = @{
                                  NSParagraphStyleAttributeName : paragraphStyle,
                                  NSForegroundColorAttributeName : [CommonImage colorWithHexString:COLOR_333333],
                                  NSFontAttributeName : [UIFont systemFontOfSize:M_FRONT_SIXTEEN]
                                  };
    NSMutableAttributedString *attrituteString = [[NSMutableAttributedString alloc] initWithString:allstring attributes:attributtes] ;
    m_textView.attributedText = attrituteString;
    m_textView.frameHeight = kDeviceHeight;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Gesture Handling
-(void)handleTap:(UITapGestureRecognizer*)tap
{
    if(tap.state == UIGestureRecognizerStateRecognized)
    {
        CGPoint tappedPoint = [tap locationInView:m_textView];
        NSUInteger idx = [m_textView closestCharacterIndexToPoint:tappedPoint];
        //        UITextGranularity granularity =_granularityControl.selectedSegmentIndex;
        UITextGranularity granularity  = UITextGranularityWord;
        UIBezierPath* selectionPathInTextView = [m_textView selectionPathWithGranularity:granularity atIndex:idx];
        CGRect newFrame = CGPathGetPathBoundingBox(selectionPathInTextView.CGPath);
        NSRange selectRane = [m_textView.myTextRange rangeValue];
        if (selectRane.location == NSNotFound)
        {
            [self dismissView];
            return;
        }
        NSString *srTxt  = [m_textView.text substringWithRange:m_textView.myTextRange.rangeValue];
        //         NSString *sre  = [m_textView.text substringWithRange:NSMakeRange(idx, 1)];
        //        m_selectionView.frame = [self.view convertRect:newFrame fromView:m_textView];
        m_selectionView.frame = newFrame;
        m_selectionView.text = srTxt;
        [self showFloatViewWithData];
    }
}

-(void)showFloatViewWithData
{
    FloatView *fv = [[FloatView alloc] initWithPointButton:m_selectionView withData:m_selectionView.text];
//    fv.delegate = self;
    [fv setUpDeledate:self];
}

-(void)dismissView
{
    [self removeHighlight];
}

- (void)removeHighlight
{
    if (m_textView.myTextRange.rangeValue.location != NSNotFound)
    {
        //remove highlight from previously selected word
        m_textView.myTextRange = [NSValue valueWithRange:NSMakeRange(NSNotFound, 0)];
        m_selectionView.frame = CGRectZero;
    }
}

-(void)adjustContentViewWithIsAdjust:(float)adjust
{
    m_textView.frameHeight = adjust;
}

-(void)showTip
{
    GlideTooltipModel *model = [[GlideTooltipModel alloc] init];
    model.title = @"点击单词可进行翻译";
    model.view = self.view;
    model.key = NSStringFromClass([self class]);
    [GlideTooltip showInView:model];
}
@end
