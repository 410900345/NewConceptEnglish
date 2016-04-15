//
//  BaseTableViewController.m
//  newIdea1.0
//
//  Created by jiuhao-yangshuo on 16/1/28.
//  Copyright © 2016年 xuGuohong. All rights reserved.
//

#import "BaseTableViewController.h"
#import "FileManagerModel.h"

@interface BaseTableViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation BaseTableViewController
@synthesize m_dataArray;
@synthesize m_tableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    m_dataArray = [[NSMutableArray alloc] init];
    // Do any additional setup after loading the view.
}

-(BOOL)closeNowView
{
    [[FileManagerModel sharedFileManagerModel] setUpNilDelegate];
    return [super closeNowView];
}

-(void)createTableView
{
    // Do any additional setup after loading the view.
    m_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight) style:UITableViewStylePlain];
    m_tableView.dataSource = self;
    m_tableView.delegate = self;
    m_tableView.rowHeight = 44.0;
    m_tableView.backgroundColor = [UIColor clearColor];
//    m_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [Common setExtraCellLineHidden:m_tableView];
    [self.view addSubview:m_tableView];
    m_tableView.separatorColor = [CommonImage colorWithHexString:LINE_COLOR];
    if (IOS_7) {
        [m_tableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
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

#pragma mark - UITableView Delegate methods
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
    static NSString *identifier = @"checkCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] ;
    }
    if (m_dataArray.count)
    {
      
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return m_dataArray.count ;
    //    return 10;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
