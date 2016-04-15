//
//  OrderViewController.m
//  ifengNewsOrderDemo
//
//  Created by zer0 on 14-2-27.
//  Copyright (c) 2014年 zer0. All rights reserved.
//

#import "OrderViewController.h"
#import "TouchView.h"
#import "FileManagerModel.h"
//#import "NSArray+SNFoundation.h"

static float const kNextBtnHight = 40;
static const float kEarlyTime = 0.3;//提前一点

@interface OrderViewController ()<TouchViewDelegate,UIScrollViewDelegate>
{
    NSInteger m_lastIndex;
    NSMutableArray *reuseArray;
    UIButton *freButton;
    UILabel *midLable;
    UIButton * nextButton;
    UILabel *correctLable;
    UIScrollView *m_scrollView;
    float offHeight;
    UIButton *resetPlay;
    UIView *m_bottomView;//底部视图
    float kLabelWidth;
    UIButton *m_nextPlay;
    UIButton *m_resetButton;
}
@end

@implementation OrderViewController
@synthesize m_currentPage;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"句子听写";
        m_lastIndex = 0;
        reuseArray = [[NSMutableArray alloc] init];
        kLabelWidth = 50;
    }
    return self;
}

-(void)createContentView
{
    float mBottomH = 130;
    m_scrollView = [[UIScrollView alloc]init];
    m_scrollView.frame = CGRectMake(0, 0, kDeviceWidth,kDeviceHeight- mBottomH);
    m_scrollView.delegate = self;
    m_scrollView.showsHorizontalScrollIndicator = NO;
    m_scrollView.backgroundColor = [CommonImage colorWithHexString:VERSION_BACKGROUD_COLOR2];
    [self.view addSubview:m_scrollView];
    
    m_bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, m_scrollView.bottom, kDeviceWidth, mBottomH)];
    m_bottomView.backgroundColor = [CommonImage colorWithHexString:@"ffffff"];
    [self.view addSubview:m_bottomView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createContentView];
    //    self.dataArray = @[@"Whose handbag is it?",@"Thank you very much Thank you very much"];
    // Do any additional setup after loading the view.
    NSArray * modelArr2 = @[];
    _viewArr1 = [[NSMutableArray alloc] init];
    _viewArr2 = [[NSMutableArray alloc] init];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(UI_leftMargin, 25, kDeviceWidth - 2*UI_leftMargin, 40)];
    _titleLabel.text = @"我的答案";
    _titleLabel.font = [UIFont systemFontOfSize:M_FRONT_EIGHTEEN];
    [_titleLabel setTextAlignment:NSTextAlignmentLeft];
    [_titleLabel setTextColor:[CommonImage colorWithHexString:COLOR_ORANGE]];
    [m_scrollView addSubview:_titleLabel];
    
    _titleLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(UI_leftMargin, KTableStartPointY + KButtonHeight * ([self array2StartY] - 1) + KMoreChannelDeltaHeight, _titleLabel.width, 40)];
    _titleLabel2.text = @"句子提示";
    [_titleLabel2 setFont:[UIFont systemFontOfSize:M_FRONT_SIXTEEN]];
    [_titleLabel2 setTextAlignment:NSTextAlignmentLeft];
    [_titleLabel2 setTextColor:[UIColor grayColor]];
    [m_scrollView addSubview:_titleLabel2];
    
    for (int i = 0; i < _modelArr1.count; i++)
    {
        TouchView * touchView = [[TouchView alloc] initWithFrame:CGRectMake(KTableStartPointX + KButtonWidth * (i%5), KTableStartPointY + KButtonHeight * (i/5), KButtonWidth, KButtonHeight)];
        [_viewArr1 addObject:touchView];
        touchView->_array = _viewArr1;
        touchView.label.text = [_modelArr1 objectAtIndex:i] ;
        [touchView setMoreChannelsLabel:_titleLabel2];
        touchView->_viewArr11 = _viewArr1;
        touchView->_viewArr22 = _viewArr2;
        touchView.delegate = self;
        [m_scrollView addSubview:touchView];
        [reuseArray addObject:touchView];
    }
    
    for (int i = 0; i < modelArr2.count; i++)
    {
        TouchView * touchView = [[TouchView alloc] initWithFrame:CGRectMake(KTableStartPointX + KButtonWidth * (i%5), KTableStartPointY + KDeltaHeight + [self array2StartY] * KButtonHeight + KButtonHeight * (i/5)  , KButtonWidth, KButtonHeight)];
        [_viewArr2 addObject:touchView];
        touchView->_array = _viewArr2;
        touchView.label.text = [modelArr2 objectAtIndex:i] ;
        [touchView setMoreChannelsLabel:_titleLabel2];
        touchView->_viewArr11 = _viewArr1;
        touchView->_viewArr22 = _viewArr2;
        touchView.delegate = self;
        [m_scrollView addSubview:touchView];
        [reuseArray addObject:touchView];
    }
    
    correctLable = [[UILabel alloc] initWithFrame:CGRectMake(UI_leftMargin, offHeight + 20, kDeviceWidth - 2*UI_leftMargin, 40)];
    correctLable.text = @"答案结果";
    correctLable.font = [UIFont systemFontOfSize:M_FRONT_EIGHTEEN];
    [correctLable setTextAlignment:NSTextAlignmentCenter];
    [correctLable setTextColor:_titleLabel.textColor];
    [m_scrollView addSubview:correctLable];
    offHeight = correctLable.bottom +20;
    
    [self createFooterView];
    [self orderViewNextSentenceWithIndex:m_currentPage withReloadView: YES];
}

#pragma mark - observeValueForKeyPath
-(void)arrayChange
{
    if (_viewArr2.count)
    {
        return;
    }
    NSString *str = self.dataArray[m_currentPage][kTxtDetail];
    NSMutableArray *array = [[NSMutableArray alloc]init];
    for (TouchView *view in _viewArr1)
    {
        [array addObject:view.label.text];
    }
    NSString *newString = [array componentsJoinedByString:@" "];
    if ([str isEqualToString:newString])
    {
        NSLog(@"----------");
        correctLable.text = @"正确";
    }
    else
    {
        correctLable.text = @"错误";
    }
}
-(void)reLoadViewWithModelArray:(NSArray *)modelArray
{
    if (_viewArr1.count)
    {
        for (UIView *view in _viewArr1)
        {
            [view removeFromSuperview];
        }
    }
    
    _titleLabel2.top = KTableStartPointY + KButtonHeight * ([self array2StartY] - 1) + KMoreChannelDeltaHeight;
    
    [_viewArr1 removeAllObjects];
    [_viewArr2 removeAllObjects];
    float temp = 0;
    for (int i = 0; i < modelArray.count; i++)
    {
        temp = i;
        TouchView * touchView  = nil;
        if (i < reuseArray.count)
        {
            touchView  = reuseArray[i];
        }
        if (!touchView)
        {
            touchView = [[TouchView alloc] init];
            touchView.delegate = self;
            [reuseArray addObject:touchView];
        }
        touchView.frame = CGRectMake(KTableStartPointX + KButtonWidth * (i%5), KTableStartPointY + KDeltaHeight + [self array2StartY] * KButtonHeight + KButtonHeight * (i/5)  , KButtonWidth, KButtonHeight);
        touchView.label.text = [modelArray objectAtIndex:i] ;
        [_viewArr2 addObject:touchView];
        touchView->_array = _viewArr2;
        touchView.label.text = [modelArray objectAtIndex:i] ;
        [touchView setMoreChannelsLabel:_titleLabel2];
        touchView->_viewArr11 = _viewArr1;
        touchView->_viewArr22 = _viewArr2;
        [m_scrollView addSubview:touchView];
        
        if (i == modelArray.count - 1)
        {
            offHeight = touchView.bottom +50;
        }
    }
    correctLable.top = offHeight;
    float bottomH = correctLable.bottom +UI_TopMargin*2;
    m_scrollView.contentSize = CGSizeMake(kDeviceWidth, MAX(m_scrollView.height, bottomH));
    //剩下的隐藏 不进行重复创建
    for (int i = temp+1; i < reuseArray.count; i++)
    {
        TouchView * touchView  = reuseArray[i];
        if (touchView)
        {
            [touchView removeFromSuperview];
        }
    }
}

//- (BOOL)closeNowView
//{
//    [[NSNotificationCenter defaultCenter] removeObserver:<#(nonnull NSObject *)#> forKeyPath:<#(nonnull NSString *)#> context:<#(nullable void *)#>];
//    return  [super closeNowView];
//}

- (unsigned long )array2StartY
{
    unsigned long y = 0;
    y = _modelArr1.count/5 + 2;
    if (_modelArr1.count%5 == 0)
    {
        y -= 1;
    }
    return y;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - PrivateMethod
-(void)createFooterView
{
    float KfloatH = 50;
    float kLeftBtnWight = (kDeviceWidth -kLabelWidth)/2.0;
    
    freButton = [self createItemButton];
    freButton.frame = CGRectMake(0,m_bottomView.height-KfloatH, kLeftBtnWight, KfloatH);
    [freButton setTitle:@"上一句" forState:UIControlStateNormal];
    freButton.tag = 100001;
    [m_bottomView addSubview:freButton];
    
    midLable = [Common createLabel:CGRectMake(freButton.right, freButton.top, kLabelWidth, freButton.height) TextColor:COLOR_333333 Font:[UIFont systemFontOfSize:M_FRONT_SIXTEEN] textAlignment:NSTextAlignmentCenter labTitle:[NSString stringWithFormat:@"%d/%d",m_currentPage+1,(int)self.dataArray.count]];
    [m_bottomView addSubview:midLable];
    midLable.backgroundColor = [UIColor whiteColor];
    
    nextButton = [self createItemButton];
    nextButton.frame = CGRectMake(midLable.right, freButton.top, kLeftBtnWight, freButton.height);
    [nextButton setTitle:@"下一句" forState:UIControlStateNormal];
    [nextButton addTarget:self action:@selector(btnclick:) forControlEvents:UIControlEventTouchUpInside];
    nextButton.tag = 100002;
    [m_bottomView addSubview:nextButton];
    
    float kleftBtnW = 60;
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    float spaceH =10;
    button.frame = CGRectMake(0, spaceH, kleftBtnW, kleftBtnW);
    [button addTarget:self action:@selector(btnclick:) forControlEvents:UIControlEventTouchUpInside];
    button.tag = 100003;
    [m_bottomView addSubview:button];
    resetPlay = button;
    [self changeBtnSateSelect:YES withButton:button];
    button.centerX = m_scrollView.centerX;
    
    m_resetButton = [self createPalyAndDeleteButton];
    m_resetButton.left = 15.0;
    UIImage *imageNormal = [UIImage imageNamed:@"common.bundle/nce/follow_replay.png"];
    [m_resetButton setImage:imageNormal forState:UIControlStateNormal];
    m_resetButton.tag = 150;
    m_resetButton.hidden = YES;
    [m_bottomView addSubview:m_resetButton];
    
    // Do any additional setup after loading the view.
    m_nextPlay = [self createPalyAndDeleteButton];
    imageNormal = [UIImage imageNamed:@"common.bundle/nce/follow_next.png"];
    [m_nextPlay setImage:imageNormal forState:UIControlStateNormal];
    m_nextPlay.tag = 151;
    m_nextPlay.hidden = YES;
    m_nextPlay.left = kDeviceWidth-m_resetButton.width-15.0;
    [m_bottomView addSubview:m_nextPlay];
    
    m_bottomView.height = button.bottom +spaceH +KfloatH;
    m_scrollView.height = kDeviceHeight -  m_bottomView.height;
    m_bottomView.top = m_scrollView.bottom;
    
    int lineBottom[] = {0,freButton.top};
    for (int i = 0; i<2; i++)
    {
        UILabel *lineLabel = [Common createLineLabelWithHeight:lineBottom[i]];
        [m_bottomView addSubview:lineLabel];
    }
    int lineX[] = {0,midLable.width-0.5};
    for (int i = 0; i<2; i++)
    {
        UILabel *lineLabel = [Common createLabel:CGRectMake(lineX[i], 0, 0.5, midLable.height) TextColor:nil Font:nil textAlignment:NSTextAlignmentCenter labTitle:@""];
        lineLabel.backgroundColor = [CommonImage colorWithHexString:LINE_COLOR];
        [midLable addSubview:lineLabel];
    }
}

-(UIButton *)createItemButton
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *normalImage = [CommonImage createImageWithColor:[CommonImage colorWithHexString: @"ffffff"]];
    UIImage *selectImage = [CommonImage createImageWithColor:[CommonImage colorWithHexString: @"ffffff"]];
    UIImage *higlihtImage = [CommonImage createImageWithColor:[CommonImage colorWithHexString: @"dcdcdc"]];
    [button setTitleColor:[CommonImage colorWithHexString:Color_Nav] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:M_FRONT_SIXTEEN];
    [button setBackgroundImage:normalImage forState:UIControlStateNormal];
    [button setBackgroundImage:higlihtImage forState:UIControlStateHighlighted];
    [button setBackgroundImage:selectImage  forState:UIControlStateSelected];
    [button setBackgroundImage:higlihtImage  forState:UIControlStateDisabled];
    button.backgroundColor = [UIColor whiteColor];
    [button addTarget:self action:@selector(btnclick:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

-(void)btnclick:(UIButton *)btn
{
    if (btn.tag == 100001)
    {
        NSLog(@"上一页");
        m_currentPage--;
        if (m_currentPage < 0)
        {
            m_currentPage = 0;
            freButton.enabled = NO;
            return;
        }
    }
    else if(btn.tag == 100002)
    {
        NSLog(@"下一页");
        m_currentPage++;
        if (m_currentPage > self.dataArray.count-1)
        {
            m_currentPage = self.dataArray.count-1;
            nextButton.enabled = NO;
            return;
        }
    }
    else if(btn.tag == 100003)
    {
        if (!resetPlay.selected)
        {
            [self resetButonStateWithSate:YES];
            [self orderViewNextSentenceWithIndex:m_currentPage withReloadView: NO];
        }
        return;
    }
    else if(btn.tag == 150)
    {
        [self resetButonStateWithSate:YES];
        [self orderViewNextSentenceWithIndex:m_currentPage withReloadView:YES];
        return;
    }
    else if(btn.tag == 151)
    {
        UIButton *btn = [m_bottomView viewWithTag:100002];
        [self btnclick:btn];
        return;
    }
    correctLable.text = @"";
    freButton.enabled = (m_currentPage == 0)? NO:YES;
    nextButton.enabled = (m_currentPage == self.dataArray.count-1)? NO:YES;
    midLable.text = [NSString stringWithFormat:@"%d/%d",(int)(m_currentPage+1),(int)self.dataArray.count];
    if ((m_lastIndex != m_currentPage))
    {
        [self resetButonStateWithSate:YES];
    }
    [self orderViewNextSentenceWithIndex:m_currentPage withReloadView: (m_lastIndex != m_currentPage)];
    
}

#pragma mark - PrivateMethod
-(void)handleCellColorWithIndex:(int)index
{
    NSLog(@"m_lastIndex----%d -- --index %d",m_lastIndex,index);
    if (m_lastIndex < index)
    {
        if (self.m_playEnlishView.m_musicPlayer.isPlaying)
        {
            [self.m_playEnlishView stopMusic];
            if (resetPlay.selected)
            {
                [self resetButonStateWithSate:NO];
            }
        }
        //        m_lastIndex = index;
    }
    //    [self orderViewNextSentenceWithIndex:index];
}

-(void)resetButonStateWithSate:(BOOL)state
{
    //no 显示
    m_nextPlay.hidden = state;
    m_resetButton.hidden = state;
    [self changeBtnSateSelect:state withButton:resetPlay];
}
-(void)changeBtnSateSelect:(BOOL)selet withButton:(UIButton *)button
{
    //yes 为正常
    NSString *imgeNormal = @"";
    NSString *imgeHighlig = @"";
    UIControlState state;
    if (selet)
    {
        imgeNormal = @"common.bundle/player/moviePause.png";
        imgeHighlig = imgeNormal;
        state = UIControlStateSelected;
    }
    else
    {
        imgeNormal = @"common.bundle/player/moviePlay.png";
        imgeHighlig = imgeNormal;
        state = UIControlStateNormal;
    }
    [button setImage:[UIImage imageNamed:imgeNormal] forState:state];
    [button setImage:[UIImage imageNamed:imgeHighlig] forState:UIControlStateSelected];
    resetPlay.selected = selet;
}
/**
 *  刷新页面
 *
 *  @param index      第几个
 *  @param reloadView 是否刷新
 */
-(void)orderViewNextSentenceWithIndex:(NSInteger)index withReloadView:(BOOL)reloadView
{
    NSString *str = self.dataArray[index][kTxtDetail];
    if (reloadView)
    {
        NSMutableArray *modelArray = [[str componentsSeparatedByString:@" "] mutableCopy];
//        [self reLoadViewWithModelArray:[NSMutableArray randomSortArrayWithArray:modelArray]];
    }
    
//    NSString *stringTime = self.dataArray[index][kTxtTime];
//    stringTime = [stringTime substringWithRange:NSMakeRange(4, stringTime.length-5)];
    NSString *stringTime = self.dataArray[index][kTxtTimeNum];
    [self.m_playEnlishView setUpMusicPlayerTime:stringTime.floatValue -kEarlyTime];
    if (!self.m_playEnlishView.m_musicPlayer.isPlaying)
    {
        [self.m_playEnlishView stopMusic];
        
    }
    m_lastIndex = index;
    self.m_selectIndex = m_currentPage;
}


-(UIButton *)createPalyAndDeleteButton
{
    float kleftBtnW = 50;
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, kleftBtnW, kleftBtnW);
    btn.centerY = resetPlay.centerY;
    btn.layer.cornerRadius = kleftBtnW/2.0;
    btn.layer.masksToBounds = YES;
    btn.clipsToBounds = YES;
    [btn addTarget:self action:@selector(btnclick:) forControlEvents:UIControlEventTouchUpInside];
    btn.contentEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    UIImage *NormalImage = [CommonImage createImageWithColor:[CommonImage colorWithHexString:Color_Nav]];
    [btn setBackgroundImage:NormalImage forState:UIControlStateNormal];
    UIImage *HighlightedImage = [CommonImage createImageWithColor:[CommonImage colorWithHexString:Color_Nav alpha:0.6]];
    [btn setBackgroundImage:HighlightedImage forState:UIControlStateHighlighted];
    return btn;
}
@end
