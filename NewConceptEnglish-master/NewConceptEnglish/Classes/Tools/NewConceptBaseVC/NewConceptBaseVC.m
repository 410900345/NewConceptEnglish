//
//  NewConceptBaseVC.m
//  newIdea1.0
//
//  Created by yangshuo on 15/9/26.
//  Copyright (c) 2015年 xuGuohong. All rights reserved.
//

#import "NewConceptBaseVC.h"
#import "FileManagerModel.h"
#import "BilingualismVCCell.h"

@interface NewConceptBaseVC()<UITableViewDataSource,UITableViewDelegate>

@end
@implementation NewConceptBaseVC
@synthesize m_selectIndex;
@synthesize lastCellIndex;

#pragma mark - life cycle
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _dataArray = [[NSMutableArray alloc] init];
        [self resetSelectIndex];
        lastCellIndex = -1;
    }
    return self;
}

- (void)dealloc
{
    @try {
        [[FileManagerModel sharedFileManagerModel].durationSlider removeObserver:self
                                                                      forKeyPath:@"value"];
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    TT_RELEASE_SAFELY(_m_playEnlishView);
    TT_RELEASE_SAFELY(_myBaseBlock);
    TT_RELEASE_SAFELY(__inBlock);
    TT_RELEASE_SAFELY(_allTableView);
    TT_RELEASE_SAFELY(_dataArray);
}

-(void)resetSelectIndex
{
    m_selectIndex = -1;
     NSLog(@"-resetSelectIndex---%d",m_selectIndex);
    if (_allTableView&&_dataArray.count)
    {
        [self handleCellSelectWithIndex:[NSIndexPath indexPathForRow:0 inSection:0]];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)createTableView
{
    _allTableView = [[UITableView alloc]
                     initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight)style:UITableViewStylePlain];
    _allTableView.delegate = self;
    _allTableView.dataSource = self;
    _allTableView.backgroundColor = [UIColor clearColor];
    _allTableView.separatorColor = [CommonImage colorWithHexString:LINE_COLOR];
    [Common setExtraCellLineHidden:_allTableView];
    [self.view addSubview:_allTableView];
    if (IOS_7) {
        [_allTableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
    UIView* footerView = [Common createTableFooter];
    _allTableView.tableFooterView = footerView;
    
    [self getDataSource];
}

#pragma mark - UITableViewDataSource And UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
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
    UITableViewCell *cell =
    [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:identifier];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //    [self handleCellSelectWithIndex:indexPath];
    //    if (_myBaseBlock)
    //    {
    //        _myBaseBlock(kPlayEventNamePlaySelectSync);
    //    }
}

-(void)handleCellSelectWithIndex:(NSIndexPath *)indexPath
{
    self.m_selectIndex = indexPath.row;
    NSDictionary *medicineDic = nil;
    medicineDic = self.dataArray[self.m_selectIndex];
    float tempTime = [medicineDic[kTxtTimeNum] floatValue];
    if (self._inBlock)
    {
        self._inBlock(tempTime);
    }
    [self handleCellColorWithIndex:indexPath.row];
}

-(void)handleCellColorWithIndex:(int)index
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
     NSLog(@"handleCellColorWithIndex ----- %f   ",indexPath);
    WS(weakSelf);
    if (index != lastCellIndex)
    {
        float delayTime = 0;
        //        delayTime = 0.35;
        //串行队列
        dispatch_queue_t queueS = dispatch_queue_create("com.kangxun", DISPATCH_QUEUE_SERIAL);
        dispatch_async(queueS, ^{
            for (NSMutableDictionary *dict in _dataArray)
            {
                [dict removeObjectForKey:kTxtChangeColor];
            }
            NSMutableDictionary *dictIndex = _dataArray[index];
            [dictIndex setObject:@(1) forKey:@"kTxtChangeColor"];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                __strong __typeof(weakSelf)strongSelf = weakSelf;
                if (strongSelf.lastCellIndex >= 0 )
                {
                    UITableViewCell *lastCell = [strongSelf->_allTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:strongSelf->lastCellIndex inSection:0]];
                    if (lastCell)
                    {
                        [(BilingualismVCCell *)lastCell changeCellColorIsChange:NO];
                    }
                }
                
                BilingualismVCCell *cell = (BilingualismVCCell *)[strongSelf.allTableView cellForRowAtIndexPath:indexPath];//重新获取
                [cell changeCellColorIsChange:YES];
//                 NSLog(@"handleCellColorWithIndex ++++++ %f ==== %@",indexPath,cell);
                strongSelf->lastCellIndex = index;
                
                if ( !strongSelf->_allTableView.dragging || !strongSelf->_allTableView.tracking)
                {
                    [strongSelf->_allTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
                }
            });
        });
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float cellHight = _cellRowHeight?_cellRowHeight:44;
    return  cellHight;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //上拉加载  拖动过程中
    if(m_loadingMore == NO)
    {
        // 下拉到最底部时显示更多数据
        if( !m_loadingMore && scrollView.contentOffset.y >= ( scrollView.contentSize.height - scrollView.frame.size.height - 45) )
        {
            //            [self getDataSource];
        }
    }
    if (!_dataArray.count) {
        return;
    }
}
#pragma  mark -网络回调
-(void)getDataSource
{
    //    for (int i = 0; i < 10; i++)
    //    {
    //        [_dataArray addObject:@"123"];
    //    }
}

- (void)didFinishSuccess:(ASIHTTPRequest *)loader
{
    NSString *responseString = [loader responseString];
    NSDictionary *dic = [responseString KXjSONValueObject];
    if ([dic[@"head"][@"state"] isEqualToString:@"0000"])
    {
        if ([loader.username isEqualToString:kGetUserRecord]){
            NSMutableArray *resultList = dic[@"body"][@"recordList"];
            self.hasLoadSuccessFlag = YES;
            if (resultList.count == 0)
            {
                [self endOfResultList];
            }
            else
            {
                [self endOfResultList];
                m_loadingMore = NO;
            }
            [self handlerNetWrokDataWithArray:resultList];
        }
    }
    else
    {
        [Common TipDialog:[dic[@"head"] objectForKey:@"msg"]];
    }
}

- (void)didFinishFail:(ASIHTTPRequest *)loader
{
    NSLog(@"fail");
    self.hasLoadSuccessFlag = NO;
    [self endOfResultList];
}

- (void)endOfResultList
{
    UILabel *lab = (UILabel*)[_allTableView.tableFooterView viewWithTag:tableFooterViewLabTag];
    lab.text = @"已到底部";
    lab.frame = CGRectMake(0, 0, kDeviceWidth, 45);
    UIActivityIndicatorView *activi = (UIActivityIndicatorView*)[_allTableView.tableFooterView viewWithTag:tableFooterViewActivityTag];
    [activi removeFromSuperview];
}

-(void)refrehTableViewWithData:(NSArray *)array
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        @synchronized(self) {
            [_dataArray removeAllObjects];
            [self handlerNetWrokDataWithArray:array];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.allTableView reloadData];
            [self endOfResultList];
            if (_myBaseBlock)
            {
                _myBaseBlock(kParseDataFinish);
            }
        });
    });
}

#pragma mark - PrivateMethod
- (void)notificationSelectIndex:(NSNumber *)index
{
    
}

-(void)handlerNetWrokDataWithArray:(NSMutableArray *)resutArray
{
    [_dataArray addObject:resutArray];
}

-(void)adjustContentViewWithIsAdjust:(float)adjust
{
    _allTableView.frameHeight = adjust;
}

-(void)handleLoopPlayWithIndex:(int)index
{
    //处理循环时的处理
}

#pragma mark - observeValueForKeyPath
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    //    NSLog(@"---KEYPATH:%@,OBJECT:%@,CHANGE:%@",keyPath,object,change);
    __block  NSValue *newString = nil;
    newString = [change objectForKey:@"new"];
    WS(weakSelf);

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        float newCurrentTime = [[NSString stringWithFormat:@"%@",newString] floatValue];
        if (!weakSelf.dataArray.count)
        {
            return;
        }
        float currentTime = [weakSelf.dataArray[0][kTxtTimeNum] floatValue];//当前的选择
        if (newCurrentTime< currentTime)
        {
            m_selectIndex = 0;
        }
        NSInteger nextIndex =  MIN(m_selectIndex+1, weakSelf.dataArray.count-1);
        float nextCurrentime = [weakSelf.dataArray[nextIndex][kTxtTimeNum] floatValue];//下一次的开始时间
        //最后一次的判断
        weakSelf.m_playEnlishView.isLastSentence = NO;
        if(m_selectIndex ==  weakSelf.dataArray.count-1 && weakSelf.m_playEnlishView.isLooping)//最后一个处理
        {
            nextCurrentime =  weakSelf.m_playEnlishView.durationSlider.maximumValue  - kLastPlaySpaceTime;
            weakSelf.m_playEnlishView.isLastSentence = YES;
            NSLog(@"newCurrentTime-----%f,nextCurrentime---%f",newCurrentTime,nextCurrentime);
        }
        if (newCurrentTime > nextCurrentime -kDelyTime)
        {
            if (m_selectIndex <= weakSelf.dataArray.count -1)
            {
                m_selectIndex = MIN(m_selectIndex+1, weakSelf.dataArray.count-1);//下一句
                [self handleLoopPlayWithIndex:m_selectIndex];
            }
        }
        else
        {
            if (m_selectIndex != 0)
                return;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            //获得新值
            [self handleCellColorWithIndex:MAX(0, m_selectIndex)];
        });
    });
}


@end
