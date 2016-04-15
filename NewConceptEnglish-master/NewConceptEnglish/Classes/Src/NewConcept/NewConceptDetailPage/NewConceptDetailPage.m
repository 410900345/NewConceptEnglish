//
//  NewConceptDetailPage.m
//  newIdea1.0
//
//  Created by yangshuo on 15/9/26.
//  Copyright (c) 2015年 xuGuohong. All rights reserved.
//

#import "NewConceptDetailPage.h"
#import "KXSlideView.h"
#import "NewConceptDetailItem.h"
#import "ExerciseVC.h"
#import "ExplainDetailVC.h"
#import "BilingualismVC.h"
#import "VocabularyVC.h"
#import "PlayEnlishView.h"
#import "AppUtil.h"
#import "NetAccess.h"
#import "ChangeSoundSource.h"
#import "OrderViewController.h"
#import "ReadingFollowViewController.h"
#import "ChangeSpeed.h"
#import "BookReadDao.h"
#import "CommonSet.h"
#import "WebViewController.h"
#import "ChangePlayerModel.h"

@interface NewConceptDetailPage()<SlideViewDelegate>
{
    NSMutableArray *viewArray;
    int currentPage;
    PlayEnlishView *playView;
    KXSlideView *slideView;
    NetAccess *myNetAccess;
    BOOL lastPlayingEnglishSate;//上一次的状态
    NSMutableArray *firstArray;
    UIButton *m_right2;
}
@end

@implementation NewConceptDetailPage
@synthesize isShowLove;
@synthesize m_bookIndexModel;
@synthesize bookIndexDict;

#pragma mark -life cycle
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"课文详解";
        isShowLove = YES;
        viewArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)dealloc
{
    [self closeNowView];
    TTVIEW_RELEASE_SAFELY(playView);
    TTVIEW_RELEASE_SAFELY(slideView);
    TT_RELEASE_SAFELY(viewArray);
    TT_RELEASE_SAFELY(firstArray);
}

-(void)changeButtonContent
{
    NSString *title = @"收藏";
    
    //    UIBarButtonItem* leftBar = [[UIBarButtonItem alloc] initWithCustomView:m_right2];
    //    self.navigationItem.rightBarButtonItem = leftBar;
    
    float kLeftW = 44;//视频
    float kRightW = kLeftW;
    UIView* navaView = [[UIView alloc] initWithFrame:CGRectMake(kDeviceWidth - kRightW-kLeftW*2-5, 0, kRightW+kLeftW, 44)];
    UIBarButtonItem* rightBar = [[UIBarButtonItem alloc] initWithCustomView:navaView];
    
    m_right2 = [UIButton buttonWithType:UIButtonTypeCustom];
    m_right2.frame = CGRectMake(kLeftW, 0, kLeftW, 44);
    m_right2.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    m_right2.titleLabel.adjustsFontSizeToFitWidth = YES;
    [m_right2 addTarget:self action:@selector(butEventRight) forControlEvents:UIControlEventTouchUpInside];
    [m_right2 setTitle:title forState:UIControlStateNormal];
    [navaView addSubview:m_right2];
    
    UIButton* right2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [right2 setTitle:@"视频" forState:UIControlStateNormal];
    right2.frame = CGRectMake(0, 0, kLeftW, 44);
    [right2 addTarget:self action:@selector(playVdieo:) forControlEvents:UIControlEventTouchUpInside];
    [navaView addSubview:right2];
    self.navigationItem.rightBarButtonItem = rightBar;
}

-(void)playVdieo:(id)sender
{
    [self showLoadingActiview];
    if (playView.m_musicPlayer.isPlaying)
    {
        [playView stopMusic];
    }
    WS(weakSelf);
    //创建BmobQuery实例，指定对应要操作的数据表名称
    NSString *itemBook =[NSString stringWithFormat:@"%d",self.itemBook+1];
    int bookIndexNum = [self.bookIndexDict[kBookIndexDocTxt] intValue];
    if (self.itemBook == ItemBookNumOne)
    {
        bookIndexNum = bookIndexNum*2-1;
    }
    NSString *bookIndex = [NSString stringWithFormat:@"%d",bookIndexNum];
    
    BmobQuery *query = [BombModel getBombModelWothName:@"VieoBean"];
    [query whereKey:@"bookId" equalTo:itemBook];
    [query whereKey:@"pageId" equalTo:bookIndex];
    query.limit = 1;
    query.maxCacheAge = 360;
    query.cachePolicy = kBmobCachePolicyCacheElseNetwork;//缓存策略
    //执行查询
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        //处理查询结果
        [weakSelf handleTopAdWithArray:array withError:error];
    }];
}

-(void)gotoVideoWebViewWithDict:(NSDictionary *)medicineDic
{
    [self stopLoadingActiView];
    if (medicineDic.count)
    {
        //        NSString *myDescriptionHTML = [NSString stringWithFormat:@"<html><body> <iframe height= \"500\" width= \"375\" src= \"http://v.youku.com/v_show/id_XMzEzNjQ0ODA4.html\" frameborder=\"0\"></iframe> </body></html>"];
        //        [m_webView loadHTMLString:myDescriptionHTML baseURL:nil];kBookTxt
        WebViewController *help = [[WebViewController alloc] init];
        help.m_url = [HEALP_SERVER_youku stringByAppendingFormat:@"%@.html",medicineDic[@"ykUrl"]];
        NSString *indexStr =[FileManagerModel getBookNumStrIndexWithBookItem:self.itemBook];
        NSString *titleNew  = [NSString stringWithFormat:@"第%@册、%@课:%@",indexStr,self.bookIndexDict[kBookIndexTxt],self.bookIndexDict[kBookTxt]];
        help.title = titleNew;
        [self.navigationController pushViewController:help animated:YES];
    }
}

-(void)handleTopAdWithArray:(NSArray *)array withError:(NSError *)error
{
    if (error)
    {
        return;
    }
    WS(weakSelf);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //存关注的圈子
        NSDictionary *dict =nil;
        if (array.count)
        {
            BmobObject *obj = array[0];
            NSArray *arraySub =@[@"url",@"ykUrl",@"objectId",@"bookId",@"pageId"];
            dict = [BombModel getDataFrom:obj withParam:arraySub withDict:nil];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf gotoVideoWebViewWithDict:dict];
        });
        
    });
}

-(void)butEventRight
{
    //    if ([CommonUser isLoginSuccess])
    //    {
    NSString *strTitle = @"已收藏";
    [m_right2 setTitle:strTitle forState:UIControlStateNormal];
    m_right2.enabled = NO;
    [self rightEventWithShow:YES];
    //    }
}

-(void)rightEventWithShow:(BOOL)show
{
    NSMutableDictionary *newDict = [NSMutableDictionary dictionaryWithDictionary:self.bookIndexDict];
    [newDict setObject:[NSString stringWithFormat:@"%d",self.itemBook] forKey:@"itemBook"];
    [newDict setObject:self.bookIndex forKey:@"bookIndex"];
    [newDict setObject:@"1" forKey:@"loveBook"];
    [self btnReadBookIntoDBWithDict:newDict withTipShow:show];
}

-(void)btnReadBookIntoDBWithDict:(NSDictionary *)dict withTipShow:(BOOL)show
{
    BookReadDao *dao = [[BookReadDao alloc] init];
    BOOL state = [dao writeBookReadToDB:dict];
    if (state && show)
    {
        [Common MBProgressTishi:@"收藏成功" forHeight:kDeviceHeight];
    }
    TT_RELEASE_SAFELY(dao);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self hiddenNavigationBarLine];
    //    [playView startMusic];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (isShowLove)
    {
        [self changeButtonContent];
    }
    NSArray *titleArray = @[@"原文",@"双语",@"词汇",@"详解",@"习题"];
    NewConceptDetailItem *itemVC= [[NewConceptDetailItem alloc] init];
    [viewArray addObject:itemVC];
    
    BilingualismVC *itemTwo= [[BilingualismVC alloc] init];
    [viewArray addObject:itemTwo];
    
    VocabularyVC *itemThree= [[VocabularyVC alloc] init];
    [viewArray addObject:itemThree];
    
    ExplainDetailVC *itemFour= [[ExplainDetailVC alloc] init];
    [viewArray addObject:itemFour];
    
    ExerciseVC *itemFive= [[ExerciseVC alloc] init];
    [viewArray addObject:itemFive];
    
    slideView = [[KXSlideView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight) titleScrollViewFrame:
                 CGRectMake(0, 0, kDeviceWidth, 40)];
    slideView.delegate = self;
    slideView.theSlideType = NormalType;
    [slideView setTitleArray:titleArray SourcesArray:viewArray SetDefault:0];
    [self.view addSubview:slideView];
    
    WS(weakSelf);
    SXBasicBlock finishBlock = ^(NSString *temp)
    {
        [weakSelf handleDataWithEventName:temp];
    };
    itemVC.myBaseBlock = finishBlock;
    
    SXBasicBlock finishBlockTwo = ^(NSString *temp)
    {
        [weakSelf handleDataWithEventNameTwo:temp];
    };
    itemTwo.myBaseBlock = finishBlockTwo;
    
    myNetAccess = [[NetAccess alloc]init];
    [self getData];
}

//处理第一宗
-(void)handleDataWithEventName:(NSString *)tmep
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([kParseDataFinish isEqualToString:tmep])
        {
            [self createViewAndData];
        }
        else  if (kPlayEventNameLoop == [tmep intValue])
        {
            [self handlLoopSimpleSentenceWithItemIsOne:YES];
        }
        else  if (kPlayEventNamePlaySelectSync == tmep)
        {
            [self notificationSelectToTwo];
        }
    });
}

//处理第二宗
-(void)handleDataWithEventNameTwo:(NSString *)tmep
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (kPlayEventNamePlaySelectSync == tmep)
        {
            [self notificationSelectToOne];
        }
    });
}

- (void)notificationSelectToTwo
{
    NewConceptBaseVC *itemVC = viewArray[0];
    NSInteger currentPlayIndex = itemVC.m_selectIndex;
    
    NewConceptBaseVC *itemVCOther = viewArray[1];
    itemVCOther.m_selectIndex = currentPlayIndex;
    NSLog(@"--++++2222 %d",currentPlayIndex);
    [itemVCOther handleCellColorWithIndex:currentPlayIndex];
}

- (void)notificationSelectToOne
{
    NewConceptBaseVC *itemVC = viewArray[1];
    NSInteger currentPlayIndex = itemVC.m_selectIndex;
    
    NewConceptBaseVC *itemVCOther = viewArray[0];
    if (currentPage == 1)
    {
        [itemVCOther handleCellSelectWithIndex:[NSIndexPath indexPathForRow:currentPlayIndex inSection:0]];
    }
}
//创建数据
-(void)createViewAndData
{
    if (viewArray.count)
    {
        NewConceptBaseVC *vc = viewArray[0];
        firstArray = [vc.dataArray mutableCopy];
        
        NewConceptBaseVC *vcTwo = viewArray[1];
        [vcTwo refrehTableViewWithData:firstArray];
    }
    
    [self showPlayview];
    [self stopLoadingActiView];
}

-(void)setUpAddObserver
{
    [FileManagerModel sharedFileManagerModel].durationSlider = playView.durationSlider;
    NewConceptBaseVC *itemVC = viewArray[0];
    NewConceptBaseVC *itemTwo = viewArray[1];
    [playView.durationSlider addObserver:itemVC forKeyPath:@"value" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
    [playView.durationSlider addObserver:itemTwo forKeyPath:@"value" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
    
    __weak PlayEnlishView *weak = playView;
    NewConceptBaseVCBlock blockOne = ^(float temp)
    {
        [weak setUpMusicPlayerTime:temp];
    };
    itemVC._inBlock = blockOne;
    itemVC.m_playEnlishView = playView;
    
    NewConceptBaseVCBlock blockTwo = ^(float temp)
    {
        [weak setUpMusicPlayerTime:temp];
    };
    itemTwo._inBlock = blockTwo;
    itemTwo.m_playEnlishView = playView;
    
    [self setUpPlayerModel];
}

-(void)showPlayview
{
    BOOL state = [CommonUser getCurrentEnlishStateIsAmEnglish];
    NSString *fileName =  [self getFileNameWithAm:state];//1001.mp3,写死防止美音文本错误
    NSString *convertStr = self.bookIndex ;
    NSString *indexBookStr = [NSString stringWithFormat:@"%d_%@",(int)(self.itemBook+1),convertStr];
    //book/1_1_24/NCE1/fileName
    NSString *bookPath = [AppUtil getBookPathIndex:indexBookStr withResoureName:[NSString stringWithFormat:@"NCE%d",(int)(self.itemBook+1)]];
    NSString *absolutePath = [bookPath stringByAppendingFormat:@"/%@.mp3",fileName];
    WS(weakSelf);
    if (!playView)
    {
        playView = [[PlayEnlishView alloc]initPlayEnlishViewBlock:^(kPlayEventName playEventName,BOOL state) {
            [weakSelf handlePlayViewWEventWithName:playEventName];
        } withSelectFileName:absolutePath];
        [playView showInTargetShowView:self.view];
        [self setUpAddObserver];
    }
    else
    {
        [playView startPlay:absolutePath];
    }
    lastPlayingEnglishSate = state;
    
    [self.bookIndexDict setValue:self.bookIndexDict[@"kBookTxt"] forKey:kPlayItemPropertyTitle];
    playView.musicInfo = self.bookIndexDict;
    [self resetFirstSelectWithChangeDataOrView:YES];
    
}

//为第一次加载音频
-(void)changeDataSource
{
    [playView setUpTopViewButonSource];//设置view上的来源标题
    BOOL state = [CommonUser getCurrentEnlishStateIsAmEnglish];
    if (lastPlayingEnglishSate == state)
    {
        return;
    }
    [self getDataSourceWithAm:NO];//强制课文
    lastPlayingEnglishSate = state;//防止重复刷新;
}

//为第一次加载音频
-(void)getData
{
    BOOL state = [CommonUser getCurrentEnlishStateIsAmEnglish];
    [self getDataSourceWithAm:state];
}
/**
 *  获取数据
 *
 *  @param isAm 美式
 */
-(void)getDataSourceWithAm:(BOOL)isAm
{
    [self showLoadingActiview];
    NSString *fileName =  [self getFileNameWithAm:isAm];
    NSString *convertStr = self.bookIndex ;
    NSString *indexBookStr = [NSString stringWithFormat:@"%d_%@",(int)(self.itemBook+1),convertStr];
    NSString *bookPath = [AppUtil getBookPathIndex:indexBookStr withResoureName:[NSString stringWithFormat:@"NCE%d",(int)(self.itemBook+1)]];
    [myNetAccess importTextLineWithFilePath:bookPath withFileName:[NSString stringWithFormat:@"%@.dat",fileName] withDelegate:self];
}

-(NSString *)getFileNameWithAm:(BOOL)isAm
{
    NSString *bookIndexStr = self.bookIndexDict[kBookIndexDocTxt];
    NSString *preStr = isAm?@"am_":@"";
    NSString *fileName = [NSString stringWithFormat:@"%@NCE%d",preStr,(int)((self.itemBook+1)*1000 + bookIndexStr.intValue)];
    return fileName;
}

-(void)analysisFinishWithData:(NSArray *)dataArray
{
    NSMutableArray *oneArray = [[NSMutableArray alloc]init];
    NSMutableArray *twoArray = [[NSMutableArray alloc]init];
    NSMutableArray *threeArray = [[NSMutableArray alloc]init];
    NSMutableArray *fourArray = [[NSMutableArray alloc]init];
    
    NSMutableArray *allArray = [@[oneArray,twoArray,threeArray,fourArray] mutableCopy];
    int index = 0;
    NSMutableArray *tempArray = allArray[index];
    for (int i = 0; i <dataArray.count; i++)
    {
        if (![@"*" isEqualToString:dataArray[i]])
        {
            [tempArray addObject:dataArray[i]];
        }
        else
        {
            index++;
            tempArray = allArray[index];
            continue;
        }
    }
    [allArray insertObject:oneArray atIndex:0];
    WS(weakSelf);
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf refreshViewcontrollersWithData:allArray];
    }];
}

-(void)refreshViewcontrollersWithData:(NSArray *)allDataArray
{
    for ( int i= 0; i < viewArray.count ;i++)
    {
        NewConceptBaseVC *vc = viewArray[i];
        if (i!=1)
        {
            [vc refrehTableViewWithData:allDataArray[i]];
        }
    }
}

#pragma mark - Event response
-(void)setUpPlayerModel
{
    NSNumber *playerModelType = [[CommonSet sharedInstance] fetchSystemPlistValueforKey:KChangePlayerModel];
    m_bookIndexModel.m_playerModelType = playerModelType.intValue;
    [playView changeLoopMusicWithModel:playerModelType.intValue];
}
//下一篇文章
-(void)gotoNextPageWithForword:(BOOL)forword
{
    PlayerModelType type = m_bookIndexModel.m_playerModelType;
    NSInteger bookIndex = m_bookIndexModel.bookModelIndex;
    switch (type) {
        case PlayerModelPlayOnce:
            return;
            break;
        case PlayerModelSingleLoop:
            bookIndex = m_bookIndexModel.bookModelIndex;
            break;
        case PlayerModelPlayOrder:
            if (forword)
            {
                bookIndex = m_bookIndexModel.bookModelIndex +1;
                if (bookIndex >= m_bookIndexModel.bookIndexModelArray.count)
                {
                    return;
                }
            }
            else
            {
                bookIndex = m_bookIndexModel.bookModelIndex - 1;
                bookIndex = MAX(0, bookIndex);
            }
            
            break;
        case PlayerModelPlayRandom:
            bookIndex = arc4random()%(m_bookIndexModel.bookIndexModelArray.count);
            break;
        case PlayerModelListLoop:
            if (forword)
            {
                bookIndex = m_bookIndexModel.bookModelIndex +1;
                if (bookIndex >= m_bookIndexModel.bookIndexModelArray.count)
                {
                    bookIndex = 0;
                }
            }
            else
            {
                bookIndex = m_bookIndexModel.bookModelIndex - 1;
                if (bookIndex < 0)
                {
                    bookIndex = m_bookIndexModel.bookIndexModelArray.count -1;
                }
            }
            break;
        default:
            break;
    }
    [playView changeLoopMusicWithModel:type];
    
    m_bookIndexModel.bookModelIndex = bookIndex;
    bookIndexDict =  [m_bookIndexModel.bookIndexModelArray[bookIndex] mutableCopy];
    BOOL state = [CommonUser getCurrentEnlishStateIsAmEnglish];
    [self getDataSourceWithAm:state];
    lastPlayingEnglishSate = state;//防止重复刷新;
    [self rightEventWithShow:NO];
}

-(NSInteger)fetchCurrentIndex
{
    NewConceptBaseVC *itemVCOne = viewArray[0];
    NSLog( @"fetchCurrentIndex--------%d",itemVCOne.m_selectIndex);
    return itemVCOne.m_selectIndex;
}

#pragma mark - PrivateMethod
-(void)handlePlayViewWEventWithName:(kPlayEventName)eventName
{
    if (kPlayEventNameFrameChange == eventName)
    {
        [self adjustViewcontrollers];
    }
    else if (kPlayEventNameChange == eventName)
    {
        WS(weakSelf);
        [ChangeSoundSource showChangeSoundSourceWithBlock:^(id content) {
            [weakSelf changeDataSource];
        }];
    }
    else if (kPlayEventNameDictation == eventName)
    {
        [playView closeLoopState];
        OrderViewController *orderVC = [[OrderViewController alloc]init];
        orderVC.dataArray = firstArray;
        orderVC.m_playEnlishView = playView;
        orderVC.m_currentPage = [self fetchCurrentIndex];
        [self.navigationController pushViewController:orderVC animated:YES];
        [playView.durationSlider addObserver:orderVC forKeyPath:@"value" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
    }
    else if (kPlayEventNameRead == eventName)
    {
        [playView closeLoopState];
        ReadingFollowViewController *orderVC = [[ReadingFollowViewController alloc]init];
        orderVC.dataArray = firstArray;
        orderVC.m_playEnlishView = playView;
        orderVC.m_currentPage = [self fetchCurrentIndex];
        [self.navigationController pushViewController:orderVC animated:YES];
        [playView.durationSlider addObserver:orderVC forKeyPath:@"value" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
        TT_RELEASE_SAFELY(orderVC);
    }
    else  if (kPlayEventNameforwardMusic ==  eventName)
    {
        [self changeToNextSenstenceWithForword:YES];
    }
    else  if (kPlayEventNamebackMusic ==  eventName)
    {
        [self changeToNextSenstenceWithForword:NO];
    }
    else  if (kPlayEventNameSpeedControl == eventName)
    {
        [ChangeSpeed showChangeSpeedWithPlayer:playView.m_musicPlayer];
    }
    else  if (kPlayEventNameShareControl == eventName)
    {
        self.shareTitle = AppDisplayName;
        NSString *indexStr =[FileManagerModel getBookNumStrIndexWithBookItem:self.itemBook];
        NSString *bookIndex = [self.bookIndex stringByReplacingOccurrencesOfString:@"_" withString:@"-"];
        self.shareContentString = [NSString stringWithFormat:@"我正在用[%@]学习新概念第%@册,课文:%@",AppDisplayName,indexStr,self.bookIndexDict[kBookIndexTxt]];
        self.shareURL = [CommonSet getAppStorUrl];
        [self goToShare];
        NSLog(@"分享!");
    }
    else  if (kPlayEventNamePlayFinish ==  eventName)
    {
        [self changeItemViewFinish];
    }
    else  if (kPlayEventNameLoopMuSic ==  eventName)
    {
        [self changeLoopMusic];
    }
    else
    {
        NSLog(@"-----%d",eventName);
    }
}

-(void)changeLoopMusic
{
    WS(weakSelf);
    [ChangePlayerModel showChangePlayerModelWithBlock:^(NSNumber *content) {
        [weakSelf changePlayerModelWithSelect:content];
    }];
}

-(void)changePlayerModelWithSelect:(NSNumber *)content
{
    m_bookIndexModel.m_playerModelType = [content intValue];
    [playView changeLoopMusicWithModel:content.intValue];
    NSString *playTitle = [BookIndexModel fetchPlayerModelTitleWithPlayerModelType:content.intValue];
    [Common MBProgressTishi:playTitle forHeight:kDeviceHeight];
}

-(void)changeItemViewFinish
{
    [self gotoNextPageWithForword:YES];
}

//初始化第一句的颜色
-(void)resetFirstSelectWithChangeDataOrView:(BOOL)changeData
{
    NewConceptBaseVC *itemVCOne = viewArray[0];
    NewConceptBaseVC *itemVCTwo = viewArray[1];
    if (changeData)
    {
         itemVCOne.lastCellIndex = -1;
         itemVCTwo.lastCellIndex = -1;
    }
    else
    {
        [itemVCOne resetSelectIndex];
        [itemVCTwo resetSelectIndex];
    }
}

-(void)changeToNextSenstenceWithForword:(BOOL)forword
{
    if (!playView.isLooping)
    {
        [self gotoNextPageWithForword:forword];
        return;
    }
    int index = 0;
    NewConceptBaseVC *itemVC = viewArray[index];
    NSInteger currentPlayIndex = itemVC.m_selectIndex;
    if (forword)
    {
        currentPlayIndex = MIN(currentPlayIndex+1, itemVC.dataArray.count-1);
    }
    else
    {
        currentPlayIndex = MAX(itemVC.m_selectIndex-1,0);
    }
    [itemVC handleCellSelectWithIndex:[NSIndexPath indexPathForRow:currentPlayIndex inSection:0]];
    [self notificationSelectToTwo];
}

-(void)handlLoopSimpleSentenceWithItemIsOne:(BOOL)isOne
{
    if (playView.isLooping && playView.loopCount)
    {
        playView.loopCount --;
        if (playView.loopCount == 0)
        {
            playView.isLooping = NO;
            [playView resetLoopState];
        }
        NewConceptBaseVC *itemVC = viewArray[0];
        NSInteger currentPlayIndex = MAX(itemVC.m_selectIndex-1,0);
        if (playView.isLastSentence)
        {
            currentPlayIndex = itemVC.m_selectIndex;//直接最后一个句子
        }
        //        NSLog(@"---currentPlayIndex-- %d",currentPlayIndex);
        [itemVC handleCellSelectWithIndex:[NSIndexPath indexPathForRow:currentPlayIndex inSection:0]];
        
        //        [self notificationSelectToTwo];
    }
}
//调整
-(void)adjustViewcontrollers
{
    for ( int i= 0; i < viewArray.count ;i++)
    {
        NewConceptBaseVC *vc = viewArray[i];
        [UIView animateWithDuration:0.3 animations:^{
            [vc adjustContentViewWithIsAdjust:kDeviceHeight-40 -playView.height];
        }];
    }
}
- (BOOL)closeNowView
{
    for (CommonViewController *vc in viewArray)
    {
        [g_winDic removeObjectForKey:[NSString stringWithFormat:@"%x", (unsigned int)vc]];
    }
    myNetAccess.delegate = nil;
    [FileManagerModel sharedFileManagerModel].durationSlider = nil;
    [playView removeView];
    return [super closeNowView];
}

- (void)selPageScrollView:(int)page
{
    currentPage = page;
    CommonViewController *currentVC = viewArray[page];
    
    if (currentPage == 3)
    {
        [(ExplainDetailVC*)currentVC showTip];
    }
}
@end
