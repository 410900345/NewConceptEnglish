//
//  NewConceptItemVC.m
//  newIdea1.0
//
//  Created by yangshuo on 15/9/26.
//  Copyright (c) 2015年 xuGuohong. All rights reserved.
//

#import "NewConceptItemVC.h"
#import "NewConceptDetailVC.h"
#import "AppDelegate.h"
//#import "MJPhotoLoadingView.h"
#import "CommonSet.h"
#import "AppUtil.h"
#import "NetAccess.h"
#import "SDBallProgressView.h"
#import "SDLoopProgressView.h"
#import "ReadBookListViewController.h"
#import "AppDelegate.h"
//#import "BmobProFile.h"
//#import "BmobFile.h"
#import "NceOneDoubleVC.h"

@interface NewConceptItemVC()<NetAccessDelegate>

@end


@implementation NewConceptItemVC
{
    UIScrollView *m_scrollview;
    NSString *m_titleStr;
    NSArray *m_dataArray;
    NetAccess *mynet;
    NSString *convertStr;//1_24
    BOOL isloadingData;
    SXBasicBlock m_sxBlock;
    NSString *m_bookName;
}
#pragma mark -life cycle
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"新概念英语";
        UIBarButtonItem *shareItem = [[UIBarButtonItem alloc] initWithTitle:@"收藏 " style:UIBarButtonItemStylePlain target:self action:@selector(rightEvent)];
        self.navigationItem.rightBarButtonItem = shareItem;
        isloadingData = NO;
    }
    return self;
}

- (void)dealloc
{
    [self closeNowView];
    TT_RELEASE_SAFELY(m_sxBlock);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    m_scrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight-40)];
    [self.view addSubview:m_scrollview];
    m_scrollview.clipsToBounds = YES;
    
    [self createSubViews];
}

#pragma mark - Set-getUi
-(void)createSubViews
{
    NSString *indexStr =[FileManagerModel getBookNumStrIndexWithBookItem:self.itemBook];
    m_dataArray = [FileManagerModel getBookIndexWithBookItem:self.itemBook];
    
    m_titleStr = [NSString stringWithFormat:@"新概念英语第%@册",indexStr];
    NSString *subTitle = [NSString stringWithFormat:@"第%@册",indexStr];
    
    float kTtitleH  = 30;
    float kTtitleBottomH  = 50;
    float kTtitleButtommH  = 170;
    float kfloatH = [CommonSet getFrameHightWith6H:35.0];

    UILabel *titleLabel = [Common createLabel:CGRectMake(0, kfloatH, kDeviceWidth, kTtitleH) TextColor:COLOR_333333 Font:[UIFont boldSystemFontOfSize:30] textAlignment:NSTextAlignmentCenter labTitle:m_titleStr];
    [m_scrollview addSubview:titleLabel];
    
    float heightView = titleLabel.bottom + 10;
    
    if (_itemBook == ItemBookNumOne)
    {
        UIButton *doubleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        doubleBtn.frame = CGRectMake(0, heightView, kDeviceWidth, 30);
        [m_scrollview addSubview:doubleBtn];
        NSString * titleBtn = @"双数课文入口";
        NSMutableAttributedString *content = [[NSMutableAttributedString alloc]initWithString:titleBtn];
        NSRange contentRange = {0,[content length]};
        [content addAttribute:NSForegroundColorAttributeName
                                 value:[CommonImage colorWithHexString:Color_Nav]
                                 range:contentRange];
        [content addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:contentRange];
        [doubleBtn.titleLabel setFont:[UIFont systemFontOfSize:M_FRONT_SIXTEEN]];
        [doubleBtn setTitleColor:[CommonImage colorWithHexString:Color_Nav] forState:UIControlStateNormal];
//        doubleBtn.titleLabel.attributedText = content;
        [doubleBtn setAttributedTitle:content forState:UIControlStateNormal];
        [doubleBtn addTarget:self action:@selector(setJumpDoubleEvents:) forControlEvents:UIControlEventTouchUpInside];
        [m_scrollview addSubview:doubleBtn];
        heightView += doubleBtn.height+10;
    }
    
    CGFloat w,h;
    UIButton * backViewBtn = nil;
    int rowNums = 3;
    CGFloat viewW = (kDeviceWidth -30)/3.0;
    float spaceNum = 290/225.0;//比例
    CGFloat viewH = viewW *spaceNum;
//    float heightView = titleLabel.bottom + 10;
    
    float heightSpace = 30;
    float heightLabel = (35*viewH)/290.0 ;//比例
    float heightLabelAll = (70*viewH)/290.0  +(IS_Small_SCREEN?10:13)*spaceNum;//比例
    float zoomInH = 8.0;
    
    UIImage * backImage = [UIImage imageNamed:@"common.bundle/book/book.png"];
    for (int i = 0; i<m_dataArray.count; i++) {
        h = i%rowNums;
        w = i/rowNums;
        
        backViewBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        backViewBtn.tag = 100+i;
        backViewBtn.frame = CGRectMake(h * viewW +15, w * (viewH +heightSpace)+ heightView, viewW, viewH);
        [m_scrollview addSubview:backViewBtn];
        NSString * titleBtn = m_dataArray[i];
        [backViewBtn.titleLabel setFont:[UIFont systemFontOfSize:M_FRONT_SIXTEEN]];
        [backViewBtn setImage:backImage forState:UIControlStateNormal];
        [backViewBtn addTarget:self action:@selector(setJumpEvents:) forControlEvents:UIControlEventTouchUpInside];
        backViewBtn.contentEdgeInsets = UIEdgeInsetsMake(zoomInH*spaceNum, zoomInH, zoomInH*spaceNum, zoomInH);
        
        UILabel *m_titleLabel = [Common createLabel:CGRectMake(0, backViewBtn.imageView.bottom -heightLabelAll, backViewBtn.width, heightLabel) TextColor:@"a1681d" Font:[UIFont boldSystemFontOfSize:M_FRONT_SIXTEEN] textAlignment:NSTextAlignmentCenter labTitle:titleBtn];
        [backViewBtn addSubview:m_titleLabel];
        
        UILabel *m_titleSubLabel =   [Common createLabel: CGRectMake(0,m_titleLabel.bottom + 3/spaceNum, m_titleLabel.width,heightLabel) TextColor:@"a1681d" Font:[UIFont boldSystemFontOfSize:M_FRONT_FOURTEEN] textAlignment:NSTextAlignmentCenter labTitle:subTitle];;
        
        [backViewBtn addSubview:m_titleSubLabel];
        
        UIImageView *backImageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"common.bundle/book/bookcase.png"]];
        backImageV.frame = CGRectMake(15, backViewBtn.bottom, kDeviceWidth-30, heightSpace);
        [m_scrollview addSubview:backImageV];
        
    }
    m_scrollview.height = m_scrollview.height -kTtitleBottomH;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0,m_scrollview.bottom , kDeviceWidth, kTtitleBottomH);
    [button setTitle:@"我的学习记录" forState:UIControlStateNormal];
    button.tag = 1000;
    button.backgroundColor = [CommonImage colorWithHexString:Color_Nav];
    [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitleColor:[CommonImage colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:M_FRONT_SIXTEEN];
    [self.view addSubview:button];
    m_scrollview.contentSize = CGSizeMake(kDeviceWidth,backViewBtn.bottom + 20);
}

-(void)setJumpDoubleEvents:(id)sender
{
    AppDelegate * myAppdelegate = [Common getAppDelegate];
    NceOneDoubleVC *newBook = [[NceOneDoubleVC alloc] init];
    newBook.title = @"双数课";
    [myAppdelegate.navigationVC pushViewController:newBook animated:YES];
}

-(void)setUpNewConceptItemVCBlock:(SXBasicBlock)mBlock
{
    m_sxBlock = mBlock;
}

- (void)btnClick:(UIButton*)btn
{
    AppDelegate * myAppdelegate = [Common getAppDelegate];
    NSLog(@"12313");
    ReadBookListViewController *newBook = [[ReadBookListViewController alloc] init];
    newBook.title = @"学习记录";
    [myAppdelegate.navigationVC pushViewController:newBook animated:YES];
}

- (void)rightEvent
{
    NSLog(@"123133");
}

-(BOOL)closeNowView
{
    [mynet setUpNilDelegate];
    mynet = nil;
    return [super closeNowView];
}

-(void)downloadbookWthName:(NSString *)bookName
{
    if (!mynet)
    {
        mynet = [[NetAccess alloc]init];
        mynet.delegate = self;
    }
    [self showLoadProgressView];
    [self setLoadingData:YES];
    //   NSString *bookName = @"1_1_24";
    NSString *urlStr = [NSString stringWithFormat:@"%@%@.hj",kDownloadurl,bookName];
    m_bookName = bookName;
    [mynet downLoadUrl:urlStr andProgressView:m_loadingView withBookName:bookName];
}

- (void)getDataSourceWithBookName:(NSString *)bookName
{
    if (!bookName.length)
    {
        return;
    }
    WS(weakSelf);
    BmobQuery *query = [BombModel getBombModelWothName:@"choiceServer"];
    
    NSArray *array =  @[@{@"downId":bookName}];
    [query addTheConstraintByOrOperationWithArray:array];
    //执行查询
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        [weakSelf handleLoginUserInfoWithArray:array withError:error withBooKName:bookName];
    }];
}

-(void)handleLoginUserInfoWithArray:(NSArray *)array withError:(NSError *)error withBooKName:(NSString *)bookName
{
    BmobObject *model = nil;
    if (IsArrEmpty(array) || error)
    {
        [self stopLoadingActiView];
        [Common MBProgressTishi:kDHUBPREGRESSTITLE forHeight:kDeviceHeight];
        return;
    }
    model = [array firstObject];
    NSArray *subArray= @[@"book",@"pageId",@"downId",@"bookid",@"nceFile"];
    NSDictionary *dict = [BombModel getDataFrom:model withParam:subArray withDict:nil];
    
    NSString *fileUrl = dict[@"nceFile"];
    [mynet downLoadUrl:fileUrl andProgressView:m_loadingView withBookName:bookName];
}

-(void)setLoadingData:(BOOL)load
{
    isloadingData = load;
    NSString *str = load?@"1":@"0";
    m_sxBlock(str);    
}

-(void)requestFailed
{
    [self getDataSourceWithBookName:m_bookName];
    m_bookName = nil;
    [self removeProgressView];
    [self setLoadingData:NO];
}

-(void)downLoadFinishWithFilePath:(NSString *)filePath withFileName:(NSString *)fileName
{
    WS(weakSelf);
    m_bookName = nil;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [AppUtil extZipResWithZipName:fileName withOldPath:filePath withNewPath:[AppUtil getBookPath]];
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf handleViewDataDownloadFinish];
        });
    });
}

-(void)handleViewDataDownloadFinish
{
    [self removeProgressView];
    [self gotoDetailVC];
    [self setLoadingData:NO];
}

- (void)setJumpEvents:(UIButton*)btn
{
    if (isloadingData)
    {
        return;
    }
    
    NSString *selectBook = @"1-24";
    if (btn.tag -100 < m_dataArray.count)
    {
        selectBook = m_dataArray[btn.tag -100];
    }
    NSLog(@"%@",btn);
    
    convertStr = [selectBook stringByReplacingOccurrencesOfString:@"-" withString:@"_"];
    NSString *indexBookStr = [NSString stringWithFormat:@"%d_%@",(int)(self.itemBook+1),convertStr];//1_1_24
    
    NSString *bookPath = [AppUtil  getBookPath];
    NSFileManager *fileManage = [NSFileManager defaultManager];
    BOOL isDir;
    NSString *indexBook = [NSString stringWithFormat:@"%@%@",bookPath,indexBookStr];//doc/book/zipName
    //文件存在
    if(![fileManage fileExistsAtPath:indexBook isDirectory:&isDir])
    {
        [self downloadbookWthName:indexBookStr];
    }
    else
    {
        [self gotoDetailVC];
    }
}

- (void)gotoDetailVC
{
    AppDelegate * myAppdelegate = [Common getAppDelegate];
    NewConceptDetailVC *newBook = [[NewConceptDetailVC alloc] init];
    newBook.title = m_titleStr;
    newBook.bookIndex = convertStr;
    newBook.itemBook = self.itemBook;
    [myAppdelegate.navigationVC pushViewController:newBook animated:YES];
}

@end
