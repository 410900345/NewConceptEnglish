//
//  EvaDatailViewController.m
//  newIdea1.0
//
//  Created by jiuhao-yangshuo on 15/10/14.
//  Copyright © 2015年 xuGuohong. All rights reserved.
//

#import "EvaDatailViewController.h"

@interface EvaDatailViewController ()<UITextViewDelegate>
{
      UITextView *m_textView;
}
@end


@implementation EvaDatailViewController
@synthesize allstring;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"句子评测";
    // Do any additional setup after loading the view.
    [self getsSubViews];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)getsSubViews
{
    m_textView = [[UITextView alloc]initWithFrame:CGRectMake(UI_TopMargin, 0, kDeviceWidth -2*UI_TopMargin, kDeviceHeight)];
    m_textView.editable = NO;
    m_textView.delegate = self;
    m_textView.backgroundColor = self.view.backgroundColor;
    [self.view addSubview:m_textView];
    m_textView.textColor = [CommonImage colorWithHexString:COLOR_333333];
    m_textView.showsVerticalScrollIndicator = NO;
    
    [self refrehTableViewWithData:self.allstring];
}

//刷新数据
-(void)refrehTableViewWithData:(NSString *)string
{
    NSAssert(string != nil, @"Argument must be non-nil");
    NSMutableAttributedString *attrituteString = [[NSMutableAttributedString alloc] initWithString:string] ;
    [attrituteString setAttributes:@{NSForegroundColorAttributeName : [CommonImage colorWithHexString:COLOR_333333], NSFontAttributeName : [UIFont systemFontOfSize:M_FRONT_SIXTEEN]} range:NSMakeRange(0, allstring.length)];
    m_textView.attributedText = attrituteString;
}

@end
