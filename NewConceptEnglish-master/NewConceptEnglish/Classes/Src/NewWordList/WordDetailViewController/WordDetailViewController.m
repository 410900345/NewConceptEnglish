//
//  WordDetailViewController.m
//  newIdea1.0
//
//  Created by jiuhao-yangshuo on 15/11/9.
//  Copyright © 2015年 xuGuohong. All rights reserved.
//

#import "WordDetailViewController.h"
//#import "WordDetailView.h"
#import "DBOperate.h"

@interface WordDetailViewController ()<UIScrollViewDelegate>
{
    UIScrollView *m_scrollView;
    NSDictionary *m_topDict;//顶部数据
    NSArray *m_sentenceArray;//句子内容数组
    DBOperate *myDataBase;
}
@end

@implementation WordDetailViewController
@synthesize m_word;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     myDataBase = [DBOperate shareInstance];
    if (m_word.length)
    {
//         [self loadDataWithWord:m_word];
    }
}

//- (void)didReceiveMemoryWarning
//{
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}
//
//- (void)createLocalView
//{
//    if (!m_scrollView)
//    {
//        m_scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight)];
//        m_scrollView.backgroundColor = [UIColor clearColor];
//        m_scrollView.showsVerticalScrollIndicator = NO;
//        m_scrollView.delegate = self;
//        [self.view addSubview:m_scrollView];
//        
//        WordDetailView *backView = [[WordDetailView alloc] initWithFrame:CGRectMake(UI_leftMargin, UI_TopMargin, kDeviceWidth-2*UI_leftMargin,m_scrollView.height-2*UI_TopMargin)];
//        [m_scrollView addSubview:backView];
//        m_scrollView.contentSize = CGSizeMake(kDeviceWidth, MAX(kDeviceHeight+1 , backView.height + UI_TopMargin));
//    }
//    [self updteData];
//    [self.view bringSubviewToFront:m_scrollView];
//}
//
//-(void)updteData
//{
//    WordDetailView *backView = [m_scrollView viewWithTag:kLocalViewTag];
//    if (backView)
//    {
//        backView.m_topDict = m_topDict;
//        backView.m_sentenceArray = m_sentenceArray;
//        [backView fillData];
//    }
//    m_scrollView.contentSize = CGSizeMake(kDeviceWidth, MAX(kDeviceHeight, backView.height + UI_TopMargin));
//}
//
//-(void)loadDataWithWord:(NSString *)word
//{
//    [self showLoadingActiview];
//    WS(weakSelf);
//    
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM wordinfo WHERE word = '%@' order by word_id ASC LIMIT 1",[word lowercaseString]];
//        NSArray *medicinesArray = [myDataBase getDataForSQL:sql getParam:@[@"word_id",@"word",@"spell",@"meaning"] withDbName:kWordDb];
//        NSLog(@"clss:%@",medicinesArray);
//        if (medicinesArray.count)
//        {
//            m_topDict = nil;
//            m_topDict = [medicinesArray firstObject];
//        }
//        NSString *sqlTwo = [NSString stringWithFormat:@"SELECT * FROM sentence WHERE english like '%%%@%%' order by sentence_id ASC LIMIT 3",[word lowercaseString]];
//        m_sentenceArray = [myDataBase getDataForSQL:sqlTwo getParam:@[@"sentence_id",@"english",@"chinese"] withDbName:kSentenceDb];
//        NSLog(@"clss:%@",m_sentenceArray);
//        
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [weakSelf createLocalView];//隐藏view
//            [weakSelf stopLoadingActiView];
//        });
//    });
//}


@end
