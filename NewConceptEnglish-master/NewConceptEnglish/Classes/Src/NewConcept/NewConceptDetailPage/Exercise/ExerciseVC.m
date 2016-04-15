//
//  ExerciseVC.m
//  newIdea1.0
//
//  Created by yangshuo on 15/9/26.
//  Copyright (c) 2015年 xuGuohong. All rights reserved.
//

#import "ExerciseVC.h"
#import "ExerciseCell.h"
//#import "NSArray+SNFoundation.h"

static float const kNextBtnHight = 40;
@interface ExerciseVC()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *_dataArray;
    NSMutableArray *m_dataArray;
    UITableView *_allTableView;
    float m_currentPage;
    
    UIButton *freButton;
    UIButton *nextButton;
    BOOL showAnswer;
}
@end

@implementation ExerciseVC

#pragma mark - life cycle
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _dataArray = [[NSMutableArray alloc] init];
        m_dataArray = [[NSMutableArray alloc] init];
        showAnswer = NO;
    }
    return self;
}

- (void)dealloc
{
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _allTableView = [[UITableView alloc]
                     initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight)style:UITableViewStyleGrouped];
    _allTableView.delegate = self;
    _allTableView.dataSource = self;
    _allTableView.backgroundColor = [UIColor clearColor];
    _allTableView.separatorColor = [CommonImage colorWithHexString:LINE_COLOR];
    [Common setExtraCellLineHidden:_allTableView];
    [self.view addSubview:_allTableView];
    if (IOS_7) {
        [_allTableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
}

#pragma mark - UITableViewDataSource And UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    NSString *foorString = [self getFooterStringIsHeader:YES];
    CGSize size = [Common sizeForAllString:foorString andFont:M_FRONT_SIXTEEN andWight:kDeviceWidth - UI_leftMargin*2];
    float headerHeight = ceil(size.height) + 2*UI_TopMargin;
    return headerHeight;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    float kLeftTopHeight = 50;
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, kLeftTopHeight)];
    headerView.backgroundColor = [UIColor clearColor];
    NSString *foorString = [self getFooterStringIsHeader:YES];
    
    CGSize size = [Common sizeForAllString:foorString andFont:M_FRONT_SIXTEEN andWight:kDeviceWidth - UI_leftMargin*2];
    UILabel *m_titleLabel = [Common createLabel:CGRectMake(UI_leftMargin, UI_leftMargin, kDeviceWidth -2*UI_TopMargin, ceil(size.height)) TextColor:COLOR_333333 Font:[UIFont systemFontOfSize:M_FRONT_SIXTEEN] textAlignment:NSTextAlignmentLeft labTitle:foorString];
    [headerView addSubview:m_titleLabel];
    m_titleLabel.numberOfLines = 0;
    
    headerView.height = m_titleLabel.bottom + UI_leftMargin;
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    NSString *foorString = [self getFooterStringIsHeader:NO];
    BOOL showAnswerDe = NO;
    if (_dataArray.count)
    {
        NSMutableDictionary *indexDict = _dataArray[(int)m_currentPage];
        showAnswerDe =  [indexDict[kTxtIsAnswered] boolValue];
    }
    CGSize size = [Common sizeForAllString:foorString andFont:M_FRONT_SIXTEEN andWight:kDeviceWidth - UI_leftMargin*2];
    float headerHeight =  (showAnswerDe ? ceil(size.height):0) + 2*UI_TopMargin + kNextBtnHight + 2*UI_TopMargin ;
    return headerHeight;
}

-(UIButton *)createItemButton
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *normalImage = [CommonImage createImageWithColor:[CommonImage colorWithHexString: Color_Nav]];
    UIImage *selectImage = [CommonImage createImageWithColor:[CommonImage colorWithHexString: Color_Nav]];
    UIImage *higlihtImage = [CommonImage createImageWithColor:[CommonImage colorWithHexString: Color_Nav] forAlpha:0.5];
    
    [button setBackgroundImage:normalImage forState:UIControlStateNormal];
    [button setBackgroundImage:higlihtImage forState:UIControlStateHighlighted];
    [button setBackgroundImage:selectImage  forState:UIControlStateSelected];
    [button setBackgroundImage:higlihtImage  forState:UIControlStateDisabled];
    [button addTarget:self action:@selector(btnclick:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    float kLeftBottomHeight = 50;
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, kLeftBottomHeight)];
    footerView.backgroundColor = self.view.backgroundColor;
    
    float kLeftBtnWight = (kDeviceWidth - 3*UI_leftMargin)/2.0;
    
    freButton = [self createItemButton];
    freButton.frame = CGRectMake(UI_leftMargin,UI_TopMargin, kLeftBtnWight, kNextBtnHight);
    [freButton setTitle:@"上一题" forState:UIControlStateNormal];
    freButton.tag = 100001;
    [footerView addSubview:freButton];
    
    nextButton = [self createItemButton];
    nextButton.frame = CGRectMake(kDeviceWidth - UI_leftMargin - kLeftBtnWight, freButton.top, kLeftBtnWight, kNextBtnHight);
    [nextButton setTitle:@"下一题" forState:UIControlStateNormal];
    [nextButton addTarget:self action:@selector(btnclick:) forControlEvents:UIControlEventTouchUpInside];
    nextButton.tag = 100002;
    [footerView addSubview:nextButton];
    
    NSString *foorString = [self getFooterStringIsHeader:NO];
    CGSize size = [Common sizeForAllString:foorString andFont:M_FRONT_SIXTEEN andWight:kDeviceWidth - UI_leftMargin*2];
    
    UILabel *m_titleLabel = [Common createLabel:CGRectMake(UI_leftMargin, nextButton.bottom + UI_TopMargin, kDeviceWidth -2*UI_TopMargin, ceil(size.height)) TextColor:COLOR_333333 Font:[UIFont systemFontOfSize:M_FRONT_SIXTEEN] textAlignment:NSTextAlignmentLeft labTitle:foorString];
    [footerView addSubview:m_titleLabel];
    m_titleLabel.numberOfLines = 0;
    footerView.height = m_titleLabel.bottom + UI_TopMargin;
    
    m_titleLabel.hidden = YES;
    if (_dataArray.count)
    {
        NSMutableDictionary *indexDict = _dataArray[(int)m_currentPage];
        if ([indexDict[kTxtIsAnswered] boolValue])
        {
            m_titleLabel.hidden = NO;
        }
        else
        {
            footerView.height -= m_titleLabel.height;//缩小距离
        }
    }
    freButton.enabled = (m_currentPage == 0)? NO:YES;
    nextButton.enabled = (m_currentPage == _dataArray.count-1)? NO:YES;
    return footerView;
}

-(NSString *)getFooterStringIsHeader:(BOOL)isHead
{
    NSString *foorString = @"省心工作室";
    if (! _dataArray.count)
    {
        return foorString;
    }
    if (isHead)
    {
        foorString = _dataArray[(int)m_currentPage][kTxtTopic];
        foorString = [foorString substringFromIndex:1];
        foorString = [NSString stringWithFormat:@"%d. %@",(int)m_currentPage + 1,foorString];
    }
    else
    {
        foorString = _dataArray[(int)m_currentPage][kTxtParse];
    }
    return foorString;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return m_dataArray.count;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"sosCell";
    ExerciseCell *cell =
    [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell)
    {
        cell = [[ExerciseCell alloc] initWithStyle:UITableViewCellStyleDefault
                                   reuseIdentifier:identifier];
        cell.selectedBackgroundView = [Common creatCellBackView];
    }
    cell.m_dict = m_dataArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (!showAnswer)
    {
        NSMutableDictionary *indexDict = _dataArray[(int)m_currentPage];
        if (![indexDict[kTxtIsAnswered] boolValue])
        {
            NSMutableArray *answerArray = indexDict[kTxtAnswerArray];
            int iskTxtCorrect = [indexDict[kTxtCorrect] intValue] -1;
            int iskTxtAnswerSelect = indexPath.row;
            //改变状态
            NSMutableDictionary *dict = answerArray[iskTxtCorrect];
            [dict setObject:@1 forKey:kTxtAnswerIs];
            
            dict = answerArray[iskTxtAnswerSelect];
            [dict setObject:@1 forKey:kTxtAnswerSelect];
            [indexDict setObject:@1 forKey:kTxtIsAnswered];
            for (NSMutableDictionary *dict in answerArray)
            {
                [dict setObject:@1 forKey:kTxtIsAnswered];
            }
            showAnswer = YES;
            [_allTableView reloadData];
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary *medicineDic = nil;
    medicineDic = m_dataArray[indexPath.row];
    float height = [ExerciseCell getHightFromDict:medicineDic];
    return  height;
}

-(NSString *)fetchContentIndex:(NSInteger)index fromDataArray:(NSArray *)resutArray
{
    NSString *content = @"";
    if (index < resutArray.count)
    {
        content = resutArray[index];
    }
    return content;
}
#pragma  mark -网络回调
//刷新数据
-(void)refrehTableViewWithData:(NSArray *)resutArray
{
    //串行队列
    dispatch_queue_t queueS = dispatch_queue_create("com.kangxun", DISPATCH_QUEUE_SERIAL);
    dispatch_async(queueS, ^{
        NSMutableArray *newArray = [NSMutableArray array];
        for (int i = 0 ; i < resutArray.count ;i++)
        {
            NSString *str1 = resutArray[i];
            if ([str1 hasPrefix:@"@"])
            {
                NSString *str2 = [self fetchContentIndex:i+1 fromDataArray:resutArray];;
                NSString *str3 = [self fetchContentIndex:i+2 fromDataArray:resutArray];;
                NSString *str4 = [self fetchContentIndex:i+3 fromDataArray:resutArray];
                
                str1 = [str1 stringByReplacingOccurrencesOfString:@"[br]" withString:@"\n"];
                str1 = [str1 stringByReplacingOccurrencesOfString:@"-" withString:@""];
                str4 = [str4 stringByReplacingOccurrencesOfString:@"[br]" withString:@"\n"];
                str4 = [str4 stringByReplacingOccurrencesOfString:@"-" withString:@""];
                NSDictionary *dict = @{kTxtTopic:str1,
                                       kTxtAnswer:str2,
                                       kTxtCorrect:str3,
                                       kTxtParse:str4
                                       };
                [newArray addObject:[dict mutableCopy]];
            }
        }
        @synchronized(self) {
            [_dataArray removeAllObjects];
            [_dataArray addObjectsFromArray:newArray];
            [self txtParseAnswer];
        }
    });
}

-(void)txtParseAnswer
{
    [m_dataArray removeAllObjects];
    NSMutableDictionary *indexDict = _dataArray[(int)m_currentPage];
    NSMutableArray *answerArray = indexDict[kTxtAnswerArray];
    if (!answerArray.count)
    {
        NSString *answer = indexDict[kTxtAnswer];
        if (answer.length)
        {
            answerArray = [NSMutableArray array];
            NSArray *array = [answer componentsSeparatedByString:@"|"];
            for (NSString *str in array)
            {
                [answerArray addObject:[@{kTxtAnswerDetail:str} mutableCopy]];
            }
            [indexDict setObject:answerArray forKey:kTxtAnswerArray];
            [self randomSortArrayWithDict:indexDict];
        }
    }
    dispatch_async(dispatch_get_main_queue(), ^{
         [m_dataArray addObjectsFromArray:answerArray];
         [_allTableView reloadData];
    });
}

-(void)randomSortArrayWithDict:(NSMutableDictionary *)indexDict
{
    //乱序
    NSMutableArray *answerArray = indexDict[kTxtAnswerArray];
    NSInteger iskTxtCorrect = [indexDict[kTxtCorrect] intValue] -1;
    NSDictionary *corretAnwerDict = answerArray[iskTxtCorrect];
//    [NSMutableArray randomSortArrayWithArray:answerArray];
    iskTxtCorrect = [answerArray indexOfObject:corretAnwerDict];
    [indexDict setObject:[NSString stringWithFormat:@"%d",iskTxtCorrect+1] forKey:kTxtCorrect];
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
        if (m_currentPage > _dataArray.count-1)
        {
            m_currentPage = _dataArray.count-1;
            nextButton.enabled = NO;
            return;
        }
    }
    [self txtParseAnswer];
    showAnswer = NO;
}

#pragma mark - PrivateMethod
-(void)adjustContentViewWithIsAdjust:(float)adjust
{
    _allTableView.frameHeight = adjust;
}
@end
