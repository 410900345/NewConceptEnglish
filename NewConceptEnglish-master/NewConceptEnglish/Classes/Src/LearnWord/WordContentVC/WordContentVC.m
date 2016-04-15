//
//  WordContentVC.m
//  newIdea1.0
//
//  Created by jiuhao-yangshuo on 16/3/9.
//  Copyright © 2016年 xuGuohong. All rights reserved.
//

#import "WordContentVC.h"
#import "FileManagerModel.h"
#import "LearnWordDao.h"
#import "LearnWordEngine.h"
#import "WordModel.h"
#import "BackContentView.h"

@implementation WordContentVC
{
    UIScrollView *m_scrollView;
    UILabel *wordLabel;
    UIImageView *m_picImage;
    LearnWordDao *m_learnWordDao;
    
    UIView *m_topView;//顶部
    UIView *m_butView;//按钮
    UIView *m_newxtView;//下一个
    NSMutableArray *m_viewsArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"省心背单词";
    m_learnWordDao = [[LearnWordDao alloc] init];
    //    m_dataArray = [[NSMutableArray alloc] init];
    m_viewsArray = [[NSMutableArray alloc] init];
    
    m_scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight)];
    m_scrollView.backgroundColor = [UIColor clearColor];
    m_scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:m_scrollView];
    
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(5,5, kDeviceWidth-10, 120)];
    topView.backgroundColor = [CommonImage colorWithHexString:kBackColor];
    //    topView.layer.cornerRadius = 4.0;
    //    topView.layer.masksToBounds = YES;
    [m_scrollView addSubview:topView];
    m_topView = topView;
    
    wordLabel = [Common createLabel: CGRectMake(UI_TopMargin,UI_TopMargin, 90,30) TextColor:Color_Nav Font:[UIFont systemFontOfSize:25.] textAlignment:NSTextAlignmentLeft labTitle:@"word"];
    [topView addSubview:wordLabel];
    
    float btnH = 35.;
    for (int i = 0; i<2; i++)
    {
        UIImage *rightImage = [UIImage imageNamed:@"common.bundle/book/bar_voice.png"];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(wordLabel.left ,wordLabel.bottom + btnH*i, topView.width,btnH);
        btn.tag = 1000 + i;
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [topView addSubview:btn];
        btn.titleLabel.font = [UIFont systemFontOfSize:17.0];
        btn.contentEdgeInsets = UIEdgeInsetsMake(0, 30, 0, -30);
        [btn setTitleColor:[CommonImage colorWithHexString:COLOR_333333] forState:UIControlStateNormal];
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        btn.titleLabel.adjustsFontSizeToFitWidth = YES;
        
        float imageW = 20;
        UIImageView * m_vocImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, imageW,imageW)];
        m_vocImage.contentMode = UIViewContentModeScaleAspectFill;
        m_vocImage.image = [rightImage imageWithNavTintColor];
        m_vocImage.centerY = btn.height/2.0;
        [btn addSubview:m_vocImage];
    }
    
    float iconImageH = (topView.height-2*15);
    float iconImageW = iconImageH*1.2;
    m_picImage = [[UIImageView alloc] initWithFrame:CGRectMake(topView.width-iconImageW-10, 20, iconImageW, iconImageH)];
    m_picImage.contentMode = UIViewContentModeScaleAspectFit;
    m_picImage.clipsToBounds = YES;
    [topView addSubview:m_picImage];
    m_picImage.centerY = topView.height/2.0;
    
    wordLabel.width = m_picImage.left - wordLabel.left;
    wordLabel.adjustsFontSizeToFitWidth = YES;
    UIView *butView = [self createSaveBut];
    butView.frameY = kDeviceHeight -butView.height;
    [self.view addSubview:butView];
    m_butView = butView;
    
    m_scrollView.height -= m_butView.height;
    if (_isShowContent)
    {
        [self showNextButton:YES];
    }
    else
    {
        [self changeButtonContent];
    }
    //    [self fillData];
    [self updateDataToUI];
}

-(BOOL)closeNowView
{
    if (!_isShowContent) {
        //         [self saveProgress];
    }
    return  [super closeNowView];
}

-(void)saveProgress
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:@"" forKey:@"dayIndex"];
    [dict setObject:self.m_superDic[@"book_id"] forKey:@"book_id"];
    [dict setObject:@"" forKey:@"learn_end"];
    [dict setObject:@"" forKey:@"ed"];
    [dict setObject:@"" forKey:@"recite"];
    [dict setObject:@"" forKey:@"today"];
    [m_learnWordDao insertWordPlanDaydatawithData:dict];
}

-(void)changeButtonContent
{
    NSString *title = @"收藏";
    
    float kLeftW = 44;//视频
    float kRightW = 60;
    UIView* navaView = [[UIView alloc] initWithFrame:CGRectMake(kDeviceWidth - kRightW-kLeftW-5, 0, kRightW+kLeftW, 44)];
    UIBarButtonItem* rightBar = [[UIBarButtonItem alloc] initWithCustomView:navaView];
    
    UIButton  *m_right2 = [UIButton buttonWithType:UIButtonTypeCustom];
    m_right2.frame = CGRectMake(kLeftW, 0, kRightW, 44);
    m_right2.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [m_right2 addTarget:self action:@selector(butEventRight) forControlEvents:UIControlEventTouchUpInside];
    [m_right2 setTitle:title forState:UIControlStateNormal];
    [navaView addSubview:m_right2];
    
    UIButton* right2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [right2 setTitle:@"删除" forState:UIControlStateNormal];
    right2.frame = CGRectMake(0, 0, kLeftW, 44);
    [right2 addTarget:self action:@selector(playDelete) forControlEvents:UIControlEventTouchUpInside];
    [navaView addSubview:right2];
    self.navigationItem.rightBarButtonItem = rightBar;
}

-(void)butEventRight
{
    
}

-(void)playDelete
{
    
}

-(void)showNextButton:(BOOL)show
{
    UIButton *btnOne = [m_butView viewWithTag:5000];
    UIButton *btnTwo = [m_butView viewWithTag:5001];
    UIButton *btnNext = [m_butView viewWithTag:5002];
     float buttonSpaceH = 10.;
    if (show)
    {
        btnOne.hidden = YES;
        btnTwo.hidden = YES;
        btnNext.hidden = NO;
        btnNext.superview.height = btnNext.height+2*buttonSpaceH;
        btnNext.top = buttonSpaceH;
    }
    else
    {
        btnOne.hidden = NO;
        btnTwo.hidden = NO;
        btnNext.hidden = YES;
    
        btnNext.superview.height = btnNext.height*2+2*buttonSpaceH;
        btnOne.top = buttonSpaceH;
        btnTwo.top = buttonSpaceH;
    }
      btnNext.superview.bottom = kDeviceHeight;
}

- (UIView*)createSaveBut
{
    float buttonH = 40.;
    float buttonSpaceH = 10.;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth,buttonH*2+buttonSpaceH)];
    view.backgroundColor = [UIColor clearColor];
    
    NSArray *titleArray = @[@"认识",@"不认识"];
    for (int i = 0; i < 2; i++)
    {
        UIImage* backImage = [CommonImage createImageWithColor:[CommonImage colorWithHexString:@"f2f2e8"]];
        UIButton * delBut = [UIButton buttonWithType:UIButtonTypeCustom];
        delBut.frame = CGRectMake(15,(buttonH+buttonSpaceH)*i , view.width-30, buttonH);
        delBut.tag = 5000 +i;
        [delBut addTarget:self action:@selector(savebtn:) forControlEvents:UIControlEventTouchUpInside];
        [delBut setTitle:titleArray[i] forState:UIControlStateNormal];
        delBut.titleLabel.font = [UIFont systemFontOfSize:18.];
        [delBut setTitleColor:[CommonImage colorWithHexString:COLOR_333333] forState:UIControlStateNormal];
        [delBut setBackgroundImage:backImage forState:UIControlStateNormal];
        [view addSubview:delBut];
    }
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(15,buttonSpaceH , view.width-30, buttonH);
    [button setTitle:@"NEXT ONE" forState:UIControlStateNormal];
    button.tag = 5000 +2;
    button.backgroundColor = [CommonImage colorWithHexString:Color_Nav];
    [button addTarget:self action:@selector(savebtn:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitleColor:[CommonImage colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:M_FRONT_EIGHTEEN];
    [view addSubview:button];
    button.layer.cornerRadius = button.frameHeight/2.0;
    button.clipsToBounds = YES;
    UIImage *imageBack =  [CommonImage createImageWithColor:[CommonImage colorWithHexString:Color_Nav]];
    [button setBackgroundImage:imageBack forState:UIControlStateNormal];
    button.centerY = view.height/2.0;
    
    return view;
}

//-(void)fillData
//{
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        NSString *bookID = self.m_superDic[@"book_id"];
//        NSString *startID = [NSString stringWithFormat:@"%d",_wordIndex];
//        NSArray *wordsArray =  [m_learnWordDao findDayLernWordBookFromBook:bookID withIndexID:startID];
//        NSMutableArray *wrodidArray = [[NSMutableArray alloc] init];
//        for (NSDictionary *dict in wordsArray)
//        {
//            [wrodidArray addObject:dict[@"wordId"]];
//        }
//        NSArray *idsArray = [m_learnWordDao findReciteWordBookFromDBWithIDs:wrodidArray withAllArges:YES];
//        if (idsArray.count)
//        {
//            [m_dataArray addObjectsFromArray:idsArray];
//        }
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [self updateDataToUI];
//        });
//    });
//}
//
//-(void)fillData
//{
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        NSString *wordStr = _m_dataArray[_wordIndex];
//        NSDictionary *wordContent = [m_learnWordDao findReciteWordBookFromDBWithWord:wordStr withAllArges:YES];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [self updateDataToUI];
//        });
//    });
//}


-(void)createContentViewWithDict:(NSDictionary *)currentDict
{
    NSMutableArray *contentArray = [[NSMutableArray alloc] init];
    NSString *means = [currentDict[@"mean_zh"] stringByAppendingFormat:@"\n%@=%@",currentDict[@"word"],currentDict[@"mean_en"]];
    WordModel *wrodModel1 = [WordModel fillWordModelWithTitle:@"" andContent:means];
    [contentArray addObject:wrodModel1];
    NSString *monic = currentDict[@"monic"];
    if (monic.length)
    {
        WordModel *wrodModel2 = [WordModel fillWordModelWithTitle:@"派生联想" andContent:monic];
        [contentArray addObject:wrodModel2];
    }
    
    NSString *htxt = currentDict[@"htxt"];
    if (!IsStrEmpty(htxt))
    {
        WordModel *wrodModel3 = [WordModel fillWordModelWithTitle:@"趣味助记" andContent:htxt];
        [contentArray addObject:wrodModel3];
    }
    
    if (!IsStrEmpty(htxt))
    {
        NSString *sent_en = [currentDict[@"sent_zh"] stringByAppendingFormat:@"\n%@",currentDict[@"sent_en"]];
        WordModel *wrodModel4 = [WordModel fillWordModelWithTitle:@"例句" andContent:sent_en];
        wrodModel4.readSentense = currentDict[@"sent_en"];
        [contentArray addObject:wrodModel4];
    }
    float space = 5.0;
    float contentH = m_topView.bottom;
    for (int i = 0;i < contentArray.count;i++) {
        WordModel *model = contentArray[i];
        model.keyWord = currentDict[@"word"];
        BackContentView *contentView;
        if (m_viewsArray.count > i)
        {
            contentView = m_viewsArray[i];
        }
        if (!contentView)
        {
            contentView = [[BackContentView alloc] initWithFrame:CGRectMake(space, space+contentH+1.0, kDeviceWidth-2*space, 0.1)];
            [m_viewsArray addObject:contentView];
        }
        else
        {
            contentView.top = space+contentH+1.0;
        }
        [contentView createContentViewWithWordModel:model];
        [m_scrollView addSubview:contentView];
        contentH += contentView.height;
        
    }
    m_scrollView.contentSize = CGSizeMake(kDeviceWidth, contentH+10);
    //    m_butView.hidden = YES;
}

-(void)updateContentView
{
    NSMutableDictionary *currentDict = _m_dataArray[_wordIndex];
    [self createContentViewWithDict:currentDict];
    [self showNextButton:YES];
}

-(void)updateDataToUI
{
    if (_m_dataArray.count > _wordIndex)
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            //            NSMutableDictionary *currentDict = m_dataArray[_wordIndex];
            NSMutableDictionary *currentDictIndex = _m_dataArray[_wordIndex];
            NSString *wordStr = currentDictIndex[@"word"];
            NSMutableDictionary *currentDict = [m_learnWordDao findReciteWordBookFromDBWithWord:wordStr withAllArges:YES];
            
            NSString *ybUK  = nil;
            NSString *ybEN = nil;
            if (currentDict.count)
            {
                ybUK = currentDict[@"phon_uk"];
                ybEN = currentDict[@"phon_us"];
                NSArray *desArray = @[@"htxt",@"mean_en",@"monic",@"enme",@"mean_zh"];
                for (NSString *key in desArray) {
                    [LearnWordEngine decContentWithKey:key andWithDict:currentDict];
                }
            }
            else
            {
                currentDict = currentDictIndex;
                ybUK = currentDictIndex[@"symbol"];
                ybEN = currentDictIndex[@"symbol"];
                [currentDict setObject:currentDictIndex[@"explain"] forKey:@"mean_zh"];
                
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                wordLabel.text = currentDict[@"word"];
                NSString *picUrl = [WordModel fetchWordImageUrlWithWord:wordLabel.text];
                [CommonImage setImageFromServer:picUrl View:m_picImage Type:2];
                m_scrollView.contentSize = CGSizeMake(kDeviceWidth, m_topView.bottom);
                //                [self showNextButton:NO];
                for (UIView *view in m_viewsArray) {
                    [view removeFromSuperview];
                }
                [self createContentViewWithDict:currentDict];
                UIButton *btnAm = [self.view viewWithTag:1000];
                if (btnAm)
                {
                    [btnAm setTitle:ybUK forState:UIControlStateNormal];
                }
                UIButton *btnEng = [self.view viewWithTag:1001];
                if (btnEng)
                {
                    [btnEng setTitle:ybEN forState:UIControlStateNormal];
                }
            });
            
        });
    }
    else
    {
        [Common MBProgressTishi:@"已到最后单词" forHeight:kDeviceHeight];
    }
}

-(void)btnClick:(UIButton *)btn
{
    NSString *title = wordLabel.text;
    [[FileManagerModel sharedFileManagerModel] readWordFromResoure:title withIsUk:YES withUrl:nil];
}

- (void)savebtn:(UIButton*)btn
{
    switch (btn.tag) {
        case 5000:
            //            认识
            [self updateContentView];
            _wordIndex++;
            break;
        case 5001:
            //            不认识
            break;
        case 5002:
            //            if (!(_wordIndex%kMaxWordNum))
            //            {
            ////                [self fillData];
            //            }
            //            else
            //            {
            _wordIndex++;
            [self updateDataToUI];
            //            }
            break;
        default:
            break;
    }
}
@end
