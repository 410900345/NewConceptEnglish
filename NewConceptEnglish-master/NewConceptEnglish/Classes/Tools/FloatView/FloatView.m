//
//  CellFloatView.m
//  jiuhaohealth4.0
//
//  Created by jiuhao-yangshuo on 15-4-30.
//  Copyright (c) 2015年 xuGuohong. All rights reserved.
//

#import "FloatView.h"
#import "AppDelegate.h"
#import "FileManagerModel.h"
#import "DBOperate.h"
#import "LocalWordDao.h"
#import "SXManageView.h"

static NSString *const kWordTitle = @"kWordTitle";
static NSString *const kWordMeans = @"kWordMeans";
static NSString *const kWordMP3 = @"kWordMP3";

#define spaceWeight 20.0;
@interface FloatView ()

@end

@implementation FloatView
{
    CGPoint m_showPoint;
    NSString *m_dataString;
    UIView *m_contentView;
    float m_cellWeight;
    float m_cellHeight;
    
    UIButton *backView;
    CGRect m_touchItemViewFrame;
    UIImageView *  triangleImgeView;
    UIView *m_touchButton;
    NSMutableDictionary *m_dict;
    UILabel *m_subTitleLabel;
    
    LocalWordDao *mLocalWordDao;
}
@synthesize delegate;

-(void)dealloc
{
    [g_winDic removeObjectForKey:[NSString stringWithFormat:@"%x", (unsigned int)self]];
}

-(id)initWithPointButton:(UIView *)touchView withData:(NSString *)dataStr 
{
    self = [super init];
    self.backgroundColor = [UIColor clearColor];
    if (self) {
        
        [g_winDic setObject:[NSMutableArray array] forKey:[NSString stringWithFormat:@"%x", (unsigned int)self]];
        
        m_cellHeight = 30.;
        m_dataString = dataStr;
        m_cellWeight = kDeviceWidth - 2*UI_TopMargin;
        
        CGRect touchItemView = [touchView.superview convertRect:touchView.frame toView:APP_DELEGATE];
        m_touchButton = touchView;
        m_showPoint = touchItemView.origin;
        m_touchItemViewFrame = touchItemView;
        self.frame = [self getViewFrame];
        [self createTriangleImgeView];
        
        m_dict = [[NSMutableDictionary alloc] init];
        self.layer.shadowColor = [UIColor blackColor].CGColor;//shadowColor阴影颜色
        self.layer.shadowOffset = CGSizeMake(0,0);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
        self.layer.shadowOpacity = 0.2;//阴影透明度，默认0
        self.layer.shadowRadius = 4;//阴影半径，默认3
        //        self.layer.cornerRadius = 2.5;
         mLocalWordDao = [[LocalWordDao  alloc] init];
    }
    return self;
}

- (void)loadDataBegin
{
//    if ([delegate respondsToSelector:@selector(showLoadingActiview)])
//    {
//        [(CommonViewController *)delegate showLoadingActiview];
//    }
    //	[dic setObject:g_nowUserInfo.userid forKey:@"userId"];
    //    http://dict-co.iciba.com/api/dictionary.php?w=hello&key=B0B38647F972D5477755050A2C1BD8E4&type=json
    NSString *urlStr = [KGetWordurl stringByAppendingFormat:@"%@&key=B0B38647F972D5477755050A2C1BD8E4&type=json",m_dataString.lowercaseString];
    //    NSString *urlStr = [KGetWordurl stringByAppendingFormat:@"%@",m_dataString.lowercaseString];
    NSString * urlStrNew = [urlStr URLEncoding];
    [[CommonHttpRequest defaultInstance] sendHttpRequest:urlStrNew encryptStr:KGetWordurl delegate:self controller:self actiViewFlag:0 title:@"加载中"];
}

-(void)setUpDeledate:(id)delegateArg
{
    self.delegate = delegateArg;
//    [self loadDataBeginTwo];
    [self loadDataWithWord:m_dataString];
}

- (void)loadDataBeginTwo
{
//    if ([delegate respondsToSelector:@selector(showLoadingActiview)])
//    {
//        [(CommonViewController *)delegate showLoadingActiview];
//    }
    [Common MBProgressTishi:@"正在获取单词解析" forHeight:kDeviceWidth];
    NSString *urlStr = [KGetWordurlTwo stringByAppendingFormat:@"%@",m_dataString.lowercaseString];
    NSString * urlStrNew = [urlStr URLEncoding];
    [[CommonHttpRequest defaultInstance] sendHttpRequest:urlStrNew encryptStr:KGetWordurlTwo delegate:self controller:self actiViewFlag:0 title:@"加载中"];
}

//本地库查询
-(void)loadDataWithWord:(NSString *)word
{
    WS(weakSelf);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM wordinfo WHERE word = '%@' order by word_id ASC LIMIT 1 COLLATE NOCASE",[word lowercaseString]];
//        NSArray *medicinesArray = [myDataBase getDataForSQL:sql getParam:@[@"word_id",@"word",@"spell",@"meaning"] withDbName:kWordDb];
         NSArray *medicinesArray = [mLocalWordDao findWordInfoWithWord:word];
        NSLog(@"clss:%@",medicinesArray);
        if (medicinesArray.count)
        {
            NSDictionary *medicinesDict = [medicinesArray firstObject];
            BOOL state = [CommonUser getCurrentEnlishStateIsAmEnglish];
            NSString *titleWord = state? medicinesDict[@"spell_us"] :medicinesDict[@"spell"];
            NSString *titleMp3 = kFindLocalWordMp3;
            NSString *allString = medicinesDict[@"meaning"];
            [m_dict setObject:titleMp3 forKey:kWordMP3];
            titleWord = [NSString stringWithFormat:@"[ %@ ]",titleWord];
            [m_dict setObject:titleWord forKey:kWordTitle];
            [m_dict setObject:allString forKey:kWordMeans];
            dispatch_async(dispatch_get_main_queue(), ^{
                  [weakSelf finishFillDataToView];
            });
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                 [weakSelf loadDataBeginTwo];
            });
        }
    });
}
- (void)didFinishSuccess:(ASIHTTPRequest *)loader
{
    NSString *responseString = [loader responseString];
    NSDictionary *dict = [responseString KXjSONValueObject];
    if (dict)
    {
        if ([loader.username isEqualToString:KGetWordurl])
        {
            NSArray *symbolsArray = dict[@"symbols"];
            NSDictionary *dict = [symbolsArray firstObject];
            NSString *titleWord = [self getStringFromDict:dict andWithKeyArray:@[@"ph_am",@"wɜ:d",@"word_symbol"]];
            NSString *titleMp3 = [self getStringFromDict:dict andWithKeyArray:@[@"ph_am_mp3",@"ph_en_mp3",@"ph_tts_mp3",@"symbol_mp3"]];
            [m_dict setObject:titleMp3 forKey:kWordMP3];
            [m_dict setObject:titleWord forKey:kWordTitle];

            NSArray *parts = dict[@"parts"];
            NSString *allString = @"";
            int i = 0;
            for (NSDictionary * dict in parts)
            {
                i++;
                NSString *allMeans = @"";
                NSString *part = dict[@"part"];
                NSArray *means = dict[@"means"];
                if (part.length)
                {
                    allMeans = [means componentsJoinedByString:@","];
                }
                else
                {
                    part = @"";
                    //重起一行
                    if (allString.length)
                    {
                        allString = [allString stringByAppendingString:@"\n"];
                    }
                    NSMutableArray *newArray = [NSMutableArray array];
                    for (NSDictionary *dictItem in means)
                    {
                        [newArray addObject:dictItem[@"word_mean"]];
                    }
                    allMeans = [newArray componentsJoinedByString:@"\n"];
                }
                allString = [allString stringByAppendingFormat:@"%@%@",part,allMeans];
            }
            [m_dict setObject:allString forKey:kWordMeans];
        }
        else  if ([loader.username isEqualToString:KGetWordurlTwo])
        {
            NSDictionary *symbolsArray = dict[@"data"];
            if (symbolsArray.count)
            {
                NSString *titleWord = [self getStringFromDict:symbolsArray andWithKeyArray:@[@"pron",@"pronunciation"]];
                NSString *titleMp3 = [self getStringFromDict:symbolsArray andWithKeyArray:@[@"uk_audio",@"us_audio"]];
                NSString *allString = [self getStringFromDict:symbolsArray andWithKeyArray:@[@"definition"]];;
                [m_dict setObject:titleMp3 forKey:kWordMP3];
                [m_dict setObject:titleWord forKey:kWordTitle];
                [m_dict setObject:allString forKey:kWordMeans];
            }
            else
            {
                [self loadDataBegin];//启动第二方案
                return;
            }
        }
        [self finishFillDataToView];
        
//        if ([delegate respondsToSelector:@selector(stopLoadingActiView)])
//        {
//            [(CommonViewController *)delegate stopLoadingActiView];
//        }
    }
}

-(void)finishFillDataToView
{
    if (m_dict.count)
    {
        [self addSubview:[self createContentView]];
        [self show];
    }
}
//找出有数据的对应key
-(NSString *)getStringFromDict:(NSDictionary *)dict andWithKeyArray:(NSArray *)keyArray
{
    NSString *returnStr = @"";
    for (NSString *key in keyArray)
    {
        returnStr = dict[key];
        if (returnStr.length)
        {
            break;
        }
        else
        {
            continue;
        }
    }
    return returnStr;
}

-(CGRect)getViewFrame
{
    CGRect frame = CGRectZero;
    //    frame.size.height =  MIN([m_dataArray count] * m_cellHeight ,kDeviceHeight);
    frame.size.height =  m_contentView.height ? m_contentView.height:0.1;
    frame.size.width = m_cellWeight;
    frame.origin.x = UI_TopMargin;
    frame.origin.y = m_touchItemViewFrame.origin.y +m_touchItemViewFrame.size.height + triangleImgeView.height;
    return frame;
}

-(UIView *)createContentView
{
    if (m_contentView != nil) {
        return m_contentView;
    }
    
    CGRect rect = self.frame;
    rect.origin.x = 0;
    rect.origin.y = 0;
    rect.size.width = m_cellWeight;
    rect.size.height = 0;
    
    m_contentView = [[UIView alloc]initWithFrame:rect];
    m_contentView.backgroundColor = [UIColor whiteColor];
    m_contentView.layer.cornerRadius = 2.0;
    m_contentView.clipsToBounds = YES;
    
    NSString *subString  = m_dict[kWordTitle];//音标
    NSString *str = [NSString stringWithFormat:@"%@   %@ ",m_dataString,subString];
    NSMutableAttributedString *newStr = [NSString replaceRedColorWithNSString:str andUseKeyWord:m_dataString andWithCsutomFont:[UIFont fontWithName:M_FONT_TYPESX size: M_FRONT_SIXTEEN] andWithFrontColor:Color_Nav];
    UILabel *titleLabel  =[Common createLabel:CGRectMake(UI_TopMargin, UI_TopMargin, m_cellWeight -2*UI_TopMargin, 20) TextColor:COLOR_333333 Font:[UIFont systemFontOfSize:M_FRONT_SIXTEEN] textAlignment:NSTextAlignmentLeft labTitle:@""];
    [m_contentView addSubview:titleLabel];
    titleLabel.attributedText = newStr;
    
    NSArray *imageArray = @[@"common.bundle/book/learn_addword_nor.png",@"common.bundle/book/learn_voice_nor.png"];
    float buttonWeight = 30;
    UIButton *firstBtn;
    for(int i= 0;i<2;i++)
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(m_cellWeight- (2-i)*(buttonWeight +UI_leftMargin) ,titleLabel.top - (buttonWeight-titleLabel.height)/2.0, buttonWeight,buttonWeight);
        btn.tag = 1000 + i;
        [btn setImage:[UIImage imageNamed:imageArray[i]] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [m_contentView addSubview:btn];
        if (i == 0)
        {
            firstBtn = btn;
        }
    }
    
    BOOL isChina = [Common isChineseWord:m_dataString];
    firstBtn.hidden = isChina;
    
    NSString *allString = m_dict[kWordMeans];
    CGSize size = [Common sizeForAllString:allString andFont:M_FRONT_SIXTEEN andWight:titleLabel.width];
    m_subTitleLabel  =[Common createLabel:CGRectMake(UI_TopMargin, titleLabel.bottom+5, titleLabel.width, ceil(size.height)) TextColor:COLOR_333333 Font:[UIFont systemFontOfSize:M_FRONT_SIXTEEN] textAlignment:NSTextAlignmentLeft labTitle:allString];
    m_subTitleLabel.numberOfLines = 0;
    [m_contentView addSubview:m_subTitleLabel];
    
    m_contentView.height = m_subTitleLabel.bottom +UI_TopMargin;
    return m_contentView;
}

-(void )createTriangleImgeView
{
    backView = [UIButton buttonWithType:UIButtonTypeCustom];
    [backView setFrame:[UIScreen mainScreen].bounds];
    [backView setBackgroundColor:[UIColor clearColor]];
    [backView addSubview:self];
    backView.frameY = IOS_7? -64:-44;
    
    AppDelegate * myAppdelegate = [Common getAppDelegate];
    CommonViewController *topView = (CommonViewController *)myAppdelegate.navigationVC.topViewController;
    
    //    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [topView.view addSubview:backView];
    
    UIImage *normalImage =[UIImage  createImageWithFillColor:[UIColor whiteColor] andWithStrokeColor:nil withWeigt:16.0/2.0 andWithHeight:4.0 andWithStrokeWeight:0.5];//非高亮
    //    UIImage *rotationNormal = [UIImage imageWithCGImage:normalImage.CGImage scale:2 orientation:UIImageOrientationLeft];
    triangleImgeView = [[UIImageView alloc]initWithImage:normalImage];
    triangleImgeView.frame = CGRectMake(m_touchItemViewFrame.origin.x + m_touchItemViewFrame.size.width/2.0 - normalImage.size.width/2.0 - UI_TopMargin, -normalImage.size.height, normalImage.size.width, normalImage.size.height);
    [self addSubview:triangleImgeView];
    triangleImgeView.hidden = YES;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [backView addTarget:self action:@selector(dismissButton:) forControlEvents:UIControlEventTouchUpInside];
    });
}

-(void)updateSubvieSize
{
    CGPoint endTopPoint = [self convertPoint:CGPointMake(m_contentView.width, 0) toView:APP_DELEGATE];
    CGPoint endBottomPoint = [self convertPoint:CGPointMake(0,m_contentView.height) toView:APP_DELEGATE];
    CGFloat endTopPointX = endTopPoint.x;
    CGFloat endBottomPointY = endBottomPoint.y;
    
    if (endBottomPointY > kDeviceHeight+64)//高度超过边界
    {
        self.frameY = m_touchItemViewFrame.origin.y - triangleImgeView.height - m_contentView.height;
        triangleImgeView.frameY = m_contentView.height;
        UIImage *rotationNormal = [UIImage imageWithCGImage:triangleImgeView.image.CGImage scale:2 orientation:UIImageOrientationDownMirrored];
        triangleImgeView.image = rotationNormal;
    }
    //    if (endBottomPointY > kDeviceHeight+64)//高度超过边界
    //    {
    //        self.frameY = kDeviceHeight- m_contentView.height+64;//底边
    //        CGRect point = [APP_DELEGATE convertRect:m_touchItemViewFrame toView:self];//坐标系转换
    //        triangleImgeView.frameY = m_touchItemViewFrame.size.height/2.0-triangleImgeView.height/2.0 + point.origin.y;
    //    }
}

-(void)show
{
    //    CGPoint midPoint = CGPointMake(m_touchItemViewFrame.origin.x +m_touchItemViewFrame.size.width/2.0, m_touchItemViewFrame.origin.y +m_touchItemViewFrame.size.height/2.0);
    triangleImgeView.hidden = NO;
    CGPoint arrowPoint = [self convertPoint:m_showPoint fromView:backView];
    //    CGPoint arrowPoint = [triangleImgeView convertPoint:convertPoint:m_showPoint fromView:self];
    self.layer.anchorPoint = CGPointMake(arrowPoint.x / self.frame.size.width, 0);
    self.frame = [self getViewFrame];
    [self updateSubvieSize];
    [self bringSubviewToFront:triangleImgeView];
    
    self.alpha = 0.f;
    self.transform = CGAffineTransformMakeScale(0.1f, 0.1f);
    [UIView animateWithDuration:0.2f delay:0.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.transform = CGAffineTransformMakeScale(1.05f, 1.05f);
        self.alpha = 1.f;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.08f delay:0.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.transform = CGAffineTransformIdentity;
        } completion:nil];
    }];
}

-(void)dismissButton:(UIButton *)btn
{
    if ([delegate respondsToSelector:@selector(dismissView)])
    {
        [delegate dismissView];
    }
    btn.enabled = NO;
    [self resetButton];
    [self dismiss:YES];
}

-(void)dismiss:(BOOL)animate
{
    [g_winDic removeObjectForKey:[NSString stringWithFormat:@"%x", (unsigned int)self]];
    if (!animate) {
        [backView removeFromSuperview];
        return;
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        self.transform = CGAffineTransformMakeScale(0.1f, 0.1f);
        self.alpha = 0.f;
    } completion:^(BOOL finished) {
        [backView removeFromSuperview];
        backView = nil;
    }];
}

-(void)resetButton
{
    //    if (m_touchButton)
    //    {
    //         [DiaryHistoryCell actionbuttonAnamationWithButton:m_touchButton];
    //    }
}

-(void)btnClick:(UIButton *)btn
{
    NSString *txtDetail = m_dataString;
    switch (btn.tag -1000) {
        case 0:
        {
            NSLog(@"1213");
              NSString *subString  = m_dict[kWordTitle];//音标
              NSString *wordMeans  = m_dict[kWordMeans];//意思
//            [[DBOperate shareInstance] insertSingleDataToDBWithData:@{KWordName :m_dataString}];
            [SXManageView fillModelWithWord:m_dataString andSymbol:subString andExplain:wordMeans];
            break;
        }
        case 1:
        {
            NSString *str = m_dict[kWordMP3];
            if ([kFindLocalWordMp3 isEqualToString:str])
            {
                [[FileManagerModel sharedFileManagerModel]readWordFromResoure:txtDetail withIsUk:NO withUrl:nil];//发音地址
            }
            else
            {
                 [[FileManagerModel sharedFileManagerModel]readWordFromResoure:m_dataString withIsUk:YES withUrl:str];//网站
            }
            break;
        }
        default:
            break;
    }
}
@end
