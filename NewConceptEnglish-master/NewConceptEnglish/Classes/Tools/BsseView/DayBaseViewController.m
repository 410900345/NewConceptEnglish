//
//  DayBaseViewController.m
//  newIdea1.0
//
//  Created by jiuhao-yangshuo on 15/11/10.
//  Copyright © 2015年 xuGuohong. All rights reserved.
//

#import "DayBaseViewController.h"
#import "EGORefreshTableHeaderView.h"
//#import "DayBaseCell.h"

@interface DayBaseViewController ()<UITableViewDataSource, UITableViewDelegate,EGORefreshTableHeaderDelegate>
{
    EGORefreshTableHeaderView *m_headView;
    BOOL m_isloading;
}
@end

@implementation DayBaseViewController
@synthesize m_tableView,m_dataArray;

- (void)viewDidLoad
{
    [super viewDidLoad];
    m_dataArray = [[NSMutableArray alloc]init];
    // Do any additional setup after loading the view.
    [self creatTableView];
    [self getDataSourceFromLocal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)getDataSourceFromLocal
{

}

- (void)creatTableView
{
    m_tableView = [[UITableView alloc]
                   initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight)
                   style:UITableViewStylePlain];
    m_tableView.delegate = self;
    m_tableView.dataSource = self;
    m_tableView.backgroundColor = [UIColor whiteColor];
    [Common setExtraCellLineHidden:m_tableView];
    [self.view addSubview:m_tableView];
    
//    m_tableView.separatorColor = [CommonImage colorWithHexString:LINE_COLOR];
//    if (IOS_7) {
//        [m_tableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
//    }
    m_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //创建加载更多
    UIView* footerView = [Common createTableFooter];
    m_tableView.tableFooterView = footerView;
    
    m_headView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0, -460, kDeviceWidth, 460)];
    m_headView.delegate = self;
    m_headView.backgroundColor = [UIColor clearColor];
    [m_tableView addSubview:m_headView];
    [m_headView egoRefreshScrollViewDidScroll:m_tableView];
    [m_headView egoRefreshScrollViewDidEndDragging:m_tableView];
}

#pragma mark - UITableViewDataSource And UITableViewDelegate
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
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
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *medicineDic = nil;
    //    medicineDic = dataArray[indexPath.row];
    //    NewConceptDetailPage *step = [[NewConceptDetailPage alloc] init];
    //    [self.navigationController popToViewController:step animated:YES];
}

//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    float cellHight = KimageHeight +2*UI_spaceToLeft + KSpceHeight;
//    return  cellHight;
//}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //上拉加载  拖动过程中
    if(m_loadingMore == NO)
    {
        // 下拉到最底部时显示更多数据
        if( !m_loadingMore && scrollView.contentOffset.y >= ( scrollView.contentSize.height - scrollView.frame.size.height - 45) )
        {
            [self getDataSource];
        }
    }
    if (!m_dataArray.count) {
        return;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [m_headView egoRefreshScrollViewDidScroll:scrollView];
}

-(void)getDataSource
{
    for (int i = 0; i < 10; i++)
    {
        [m_dataArray addObject:@"123"];
    }
}

- (void)endOfResultList
{
    UILabel *lab = (UILabel*)[m_tableView.tableFooterView viewWithTag:tableFooterViewLabTag];
    lab.text = @"已到底部";
    lab.frame = CGRectMake(0, 0, kDeviceWidth, 45);
    UIActivityIndicatorView *activi = (UIActivityIndicatorView*)[m_tableView.tableFooterView viewWithTag:tableFooterViewActivityTag];
    [activi removeFromSuperview];
}

- (void)didFinishFail:(ASIHTTPRequest *)loader
{
    NSLog(@"fail");
    [self finishRefresh];
    [self endOfResultList];
}

#pragma mark - EGORefreshTableHeaderDelegate
//收起刷新
- (void)finishRefresh{
    
    [m_headView egoRefreshScrollViewDataSourceDidFinishedLoading:m_tableView];
    m_isloading = NO;
}

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView *)view
{
    if (m_isloading) {
        return;
    }
    m_isloading = YES;
    [self refreshData];
}

-(void)refreshData
{
    //下拉刷新 开始请求新数据 ---原数据清除
    m_nowPage = 1;//复位
    [self getDataSource];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [m_headView egoRefreshScrollViewDidEndDragging:scrollView];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView *)view
{
    return m_isloading;
}

- (NSDate *)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView *)view
{
    return [NSDate date];
}

@end
