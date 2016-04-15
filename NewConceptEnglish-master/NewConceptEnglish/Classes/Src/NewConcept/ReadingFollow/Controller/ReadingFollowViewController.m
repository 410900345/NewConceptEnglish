//
//  ReadingFollowViewController.m
//  newIdea1.0
//
//  Created by jiuhao-yangshuo on 15/10/9.
//  Copyright © 2015年 xuGuohong. All rights reserved.
//

#import "ReadingFollowViewController.h"
#import "PlayEnlishView.h"
#import "FileManagerModel.h"
#import "FlySpeechEvaluator.h"
#import "EvaDatailViewController.h"
#import "ISEResult.h"
#import "PopupView.h"
#import <AVFoundation/AVPlayerItem.h>
#import "PcmPlayer.h"

static float const kNextBtnHight = 40;
static NSString *const kXTouchToRecord = @"按住录音";
static NSString *const kXTouchToRecordIng = @"正在录音";
static NSString *const kXTouchToFinish = @"准备播放";
static NSString *const kXTouchToPlayIng = @"正在播放";

static NSString *const kXTouchColor = @"2aa7e7";
static float const KSpeakFactor = 20;
static const float kEarlyTime = 0.3;//提前一点

@interface ReadingFollowViewController ()<UIScrollViewDelegate>
{
    UIButton *m_butRecord;
    NSMutableDictionary *m_dcit;
    UIButton *freButton;
    UILabel *midLable;
    UIButton * nextButton;
    
    UILabel *m_titleLabel;
    NSInteger m_lastIndex;
    UIButton *m_scoreBtn;
    UIScrollView *m_scrollView;
    float kLabelWidth;
    UIButton *resetPlay;
    
    UIView *m_bottomView;//底部视图
    UILabel *m_tipLabel;//提示
    UIButton *m_butDelete;
    PopupView *m_popView;
    float KfloatH;
}
@property (nonatomic, retain) FlySpeechEvaluator *m_speechEva;
@property (nonatomic, retain) ISEResult *m_isResult;
@end

@implementation ReadingFollowViewController
@synthesize m_currentPage;

#pragma mark - life cycle
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"句子跟读";
        m_lastIndex = 0;
        m_dcit = [[NSMutableDictionary alloc] init];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(playerFinish:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
        KfloatH = 50.0;//下部按钮高度
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    TTVIEW_RELEASE_SAFELY(m_popView);
    TT_RELEASE_SAFELY(_m_isResult);
    TT_RELEASE_SAFELY(m_dcit);
}

-(void)createContentView
{
    float mBottomH = 150;
    m_scrollView = [[UIScrollView alloc]init];
    m_scrollView.frame = CGRectMake(0, 0, kDeviceWidth,kDeviceHeight-mBottomH);
    m_scrollView.delegate = self;
    m_scrollView.showsHorizontalScrollIndicator = NO;
    m_scrollView.backgroundColor = [CommonImage colorWithHexString:@"eeeeee"];
    [self.view addSubview:m_scrollView];
    
    m_bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, m_scrollView.bottom, kDeviceWidth, mBottomH)];
    m_bottomView.backgroundColor = [CommonImage colorWithHexString:VERSION_BACKGROUD_COLOR];
    [self.view addSubview:m_bottomView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createContentView];
    kLabelWidth = 50;
    
    m_titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(UI_leftMargin, 25, kDeviceWidth - 2*UI_leftMargin, 0.1)];
    m_titleLabel.text = @"";
    m_titleLabel.numberOfLines = 0;
    m_titleLabel.font = [UIFont systemFontOfSize:M_FRONT_EIGHTEEN];
    [m_titleLabel setTextAlignment:NSTextAlignmentLeft];
    [m_titleLabel setTextColor:[CommonImage colorWithHexString:COLOR_333333]];
    [m_scrollView addSubview:m_titleLabel];
    
    m_tipLabel = [Common createLabel:CGRectMake(0, UI_leftMargin, kDeviceWidth , 15) TextColor:COLOR_333333 Font:[UIFont systemFontOfSize:M_FRONT_FOURTEEN] textAlignment:NSTextAlignmentCenter labTitle:@"点击录音"];
    [m_bottomView addSubview:m_tipLabel];
    
    m_scoreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    m_scoreBtn.frame = CGRectMake(0, m_tipLabel.bottom + 10,kDeviceWidth, 15);
    [m_scoreBtn setTitle:@"无评分" forState:UIControlStateNormal];
    m_scoreBtn.titleLabel.font = m_tipLabel.font;
    [m_scoreBtn setTitleColor:[CommonImage colorWithHexString:COLOR_333333] forState:UIControlStateNormal];
    [m_scoreBtn addTarget:self action:@selector(btnclick:) forControlEvents:UIControlEventTouchUpInside];
    m_scoreBtn.tag = 100004;
    [m_bottomView addSubview:m_scoreBtn];
    
    m_butRecord = [self createSpeakBut];
    m_butRecord.top = m_scoreBtn.bottom +10;
    [m_bottomView addSubview:m_butRecord];
    m_butRecord.centerX = self.view.width/2.0;
    m_bottomView.height = m_butRecord.bottom +15 + KfloatH;
    
    m_scrollView.height = kDeviceHeight -  m_bottomView.height;
    m_bottomView.top = m_scrollView.bottom;
    
    m_butDelete = [self createPalyAndDeleteButton];
    m_butDelete.left = 15.0;
    UIImage *imageNormal = [UIImage imageNamed:@"common.bundle/nce/follow_delete.png"];
    [m_butDelete setImage:imageNormal forState:UIControlStateNormal];
    m_butDelete.tag = 150;
    m_butDelete.hidden = YES;
    [m_bottomView addSubview:m_butDelete];
    
    // Do any additional setup after loading the view.
    resetPlay = [self createPalyAndDeleteButton];//播放
    imageNormal = [UIImage imageNamed:@"common.bundle/nce/follow_voice.png"];
    [resetPlay setImage:imageNormal forState:UIControlStateNormal];
    resetPlay.tag = 100003;
    resetPlay.left = kDeviceWidth-m_butDelete.width-15.0;
    [m_bottomView addSubview:resetPlay];
    
    [self createFooterView];
    [self orderViewNextSentenceWithIndex:m_currentPage withReloadView:YES];
    WS(weakSelf);
    if (!_m_speechEva)
    {
        _m_speechEva = [[FlySpeechEvaluator alloc] init];
        [_m_speechEva setM_block:^(id content) {
            [weakSelf handleResutltContent:content];
        }];
    }
}

-(void)handleResutltContent:(id)content
{
    if ([content isKindOfClass:[ISEResult class]])
    {
        [self reloadDataWithResult:content];
        m_butDelete.hidden = NO;
        [self changeBtnRecordStateWithBtn:m_butRecord andWithStateFlag:2];
    }
    else if([kSpeechEvaluatorError isEqualToString:content])
    {
//         [self showPopViewWithText:content];
         [self changeBtnRecordStateWithBtn:m_butRecord andWithStateFlag:0];
    }
    else if([kSpeechEvaluatorSuccess isEqualToString:content])
    {
//        [self changeBtnRecordStateWithBtn:m_butRecord andWithStateFlag:2];
    }
}

-(UIButton *)createPalyAndDeleteButton
{
    float kleftBtnW = 50;
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, kleftBtnW, kleftBtnW);
    btn.centerY = m_butRecord.centerY;
    btn.layer.cornerRadius = kleftBtnW/2.0;
    btn.layer.masksToBounds = YES;
    btn.clipsToBounds = YES;
    [btn addTarget:self action:@selector(btnclick:) forControlEvents:UIControlEventTouchUpInside];
    btn.contentEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    UIImage *NormalImage = [CommonImage createImageWithColor:[CommonImage colorWithHexString:kXTouchColor]];
    [btn setBackgroundImage:NormalImage forState:UIControlStateNormal];
    UIImage *HighlightedImage = [CommonImage createImageWithColor:[CommonImage colorWithHexString:kXTouchColor alpha:0.6]];
    [btn setBackgroundImage:HighlightedImage forState:UIControlStateHighlighted];
    return btn;
}

#pragma mark - PrivateMethod
- (void)showPopViewWithText:(NSString *)tipText
{
    if (!m_popView)
    {
        m_popView = [[PopupView alloc] initWithFrame:CGRectMake(100, 300, 0, 0)];
        [self.view addSubview:m_popView];
         m_popView.ParentView = self.view;
    }
   [m_popView setText: tipText];
    m_popView.hidden = NO;
}

- (void)hidenPopView
{
    m_popView.hidden = YES;
}

- (void)getoDetailViewWithStr:(ISEResult *)content
{
    EvaDatailViewController *orderVC = [[EvaDatailViewController alloc]init];
    orderVC.allstring = content.toString;
    [self.navigationController pushViewController:orderVC animated:YES];
}

-(void)reloadDataWithResult:(ISEResult *)content
{
    self.m_isResult = content;
    int score = (int)ceilf(content.total_score *KSpeakFactor);//取整
    NSString *scroeStr = [NSString stringWithFormat:@"得分:%d 分 查看详情",score];
    [m_scoreBtn setTitle:scroeStr forState:UIControlStateNormal];
    m_scoreBtn.hidden = NO;
}

-(void)createFooterView
{
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
//录音按钮
- (UIButton*)createSpeakBut
{
    UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
     but.frame =CGRectMake(0, 0, 90, 90);
    [but addTarget:self action:@selector(holdDownButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    UIImage *imageNormal = [UIImage imageNamed:@"common.bundle/nce/audio_panel_record_start_nor.png"];
    [but setImage:imageNormal forState:UIControlStateNormal];
    but.buttonDefultString = kXTouchToRecord;
    [but setImage:imageNormal forState:UIControlStateHighlighted];
    but.layer.cornerRadius = but.width/2.0;
    but.layer.masksToBounds = YES;
    but.layer.borderWidth = 10.;
    but.layer.borderColor = [UIColor whiteColor].CGColor;
    but.backgroundColor = [UIColor whiteColor];
    but.contentEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    but.clipsToBounds = YES;
    return but;
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
        [self handleResetPlayOriginal];
        return;
    }
    else if(btn.tag == 100004)
    {
        if (self.m_isResult)
        {
            [self getoDetailViewWithStr:self.m_isResult];
        }
        else
        {
            [Common MBProgressTishi:@"暂无评分" forHeight:kDeviceHeight];
        }
        return;
    }
    else if(btn.tag == 150)
    {
        [self resetPlayer];
        [self showPopViewWithText:@"删除成功"];
        return;
    }
    freButton.enabled = (m_currentPage == 0)? NO:YES;
    nextButton.enabled = (m_currentPage == self.dataArray.count-1)? NO:YES;
    midLable.text = [NSString stringWithFormat:@"%d/%d",(int)(m_currentPage+1),(int)self.dataArray.count];
    if (m_lastIndex != m_currentPage)
    {
        [self resetPlayer];
    }
    [self orderViewNextSentenceWithIndex:m_currentPage withReloadView: (m_lastIndex != m_currentPage)];
}

-(void)handleResetPlayOriginal
{
    BOOL playing  = self.m_playEnlishView.m_musicPlayer.isPlaying;
    [self showPopViewWithText:!playing?@"正在播放原音":@"结束播放原音"];
    if (playing)
    {
        [self.m_playEnlishView stopMusic];
        return;
    }
    [self orderViewNextSentenceWithIndex:m_currentPage withReloadView:NO];
}

-(void)resetPlayer
{
    m_butDelete.hidden = YES;
    [self changeBtnRecordStateWithBtn:m_butRecord andWithStateFlag:0];
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
            
        }
        //        m_lastIndex = index;
    }
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
        m_titleLabel.text = str;
    }
    
    CGSize size = [Common sizeForAllString:m_titleLabel.text andFont:m_titleLabel.font.pointSize andWight:m_titleLabel.width];
    float newHeight = ceil(size.height);
    m_titleLabel.height = newHeight;
    
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
    m_scrollView.contentSize = CGSizeMake(kDeviceWidth, MAX(m_scrollView.frameHeight, m_titleLabel.bottom+20));
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- 音频

- (void)holdDownButtonTouchUpInside:(UIButton *)btn
{
    NSString *stateStr = btn.buttonDefultString;
    NSString *tipMsg = @"";
    int stateChange = 0;
    if ([kXTouchToRecord isEqualToString:stateStr])
    {
        _m_speechEva.speechEvaluatorContent =  m_titleLabel.text;
        [_m_speechEva onBtnStart];
        tipMsg = @"正在录音";
        stateChange = 1;
    }
    else if ([kXTouchToRecordIng isEqualToString:stateStr])
    {
        tipMsg = @"正在结束录音";
        [_m_speechEva onBtnStop];
        stateChange = 2;
    }
    else if ([kXTouchToFinish isEqualToString:stateStr])
    {
        [_m_speechEva playUriAudioWithUrl:nil];
        tipMsg = @"正在播放录音";
        stateChange = 3;
    }
    else if ([kXTouchToPlayIng isEqualToString:stateStr])
    {
        [_m_speechEva playUriAudioStop];
        tipMsg = @"结束播放录音";
        stateChange = 2;
    }
    m_tipLabel.text = @"";
    [self showPopViewWithText:tipMsg];
    [self changeBtnRecordStateWithBtn:btn andWithStateFlag:stateChange];
    NSLog(@"111111111111111");
}

-(void)playerFinish:(NSNotification *)nof
{
    id object  = nof.object;
    if ([object isKindOfClass:[PcmPlayer class]])
    {
        m_butRecord.buttonDefultString = kXTouchToPlayIng;
        [self holdDownButtonTouchUpInside:m_butRecord];
    }
}

-(void)changeBtnRecordStateWithBtn:(UIButton *)btn andWithStateFlag:(int)stateFlag
{
    UIImage *imageNormal = nil;
    UIImage *imageHight = nil;
    switch (stateFlag)
    {
        case 0://初始化
        {
            imageNormal = [UIImage imageNamed:@"common.bundle/nce/audio_panel_record_start_nor.png"];
            [btn setImage:imageNormal forState:UIControlStateNormal];
            btn.buttonDefultString = kXTouchToRecord;
            btn.layer.borderWidth = 10.;
            btn.layer.borderColor = [UIColor whiteColor].CGColor;
        }
            break;
        case 1://ing
        {
            imageNormal = [UIImage imageNamed:@"common.bundle/nce/audio_panel_stop_nor.png"];
            [btn setImage:imageNormal forState:UIControlStateNormal];
            imageHight = [UIImage imageNamed:@"common.bundle/nce/audio_panel_stop_pre.png"];
            [btn setImage:imageHight forState:UIControlStateHighlighted];
            btn.buttonDefultString = kXTouchToRecordIng;
            btn.layer.borderWidth = 0.;
        }
            break;
        case 2://播放录音
        {
            imageNormal = [UIImage imageNamed:@"common.bundle/nce/audio_panel_play_nor.png"];
            [btn setImage:imageNormal forState:UIControlStateNormal];
            imageHight = [UIImage imageNamed:@"common.bundle/nce/audio_panel_play_pre.png"];
            [btn setImage:imageHight forState:UIControlStateHighlighted];
            btn.buttonDefultString = kXTouchToFinish;
            btn.layer.borderWidth = 0;
        }
            break;
        case 3://播放录音ing
        {
            imageNormal = [UIImage imageNamed:@"common.bundle/nce/audio_panel_stop_nor.png"];
            [btn setImage:imageNormal forState:UIControlStateNormal];
            imageHight = [UIImage imageNamed:@"common.bundle/nce/audio_panel_stop_pre.png"];
            [btn setImage:imageHight forState:UIControlStateHighlighted];
            btn.buttonDefultString = kXTouchToPlayIng;
            btn.layer.borderWidth = 0.;
        }
            break;
        default:
            break;
    }
}

@end
