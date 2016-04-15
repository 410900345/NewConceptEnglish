//
//  WordListBase.m
//  newIdea1.0
//
//  Created by yangshuo on 16/3/17.
//  Copyright © 2016年 xuGuohong. All rights reserved.
//

#import "WordListBase.h"
#import "WordListCell.h"
#import "ChineseString.h"

@interface WordListBase ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation WordListBase
@synthesize m_tableView;
@synthesize m_dataArray;
@synthesize m_indexArray;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self getData];
    [self creatTableView];
}

-(void)dealloc
{
   
}

-(void)getData
{

}

-(void)handleData
{
    if (!m_dataArray.count)
    {
        [Common MBProgressTishi:@"还未添加生词" forHeight:kDeviceHeight];
    }
    [m_tableView reloadData];
}

- (void)creatTableView
{
    m_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight)style:UITableViewStylePlain];
    m_tableView.delegate = self;
    m_tableView.dataSource = self;
    m_tableView.backgroundColor = [UIColor clearColor];
    m_tableView.rowHeight = 44.0;
    [Common setExtraCellLineHidden:m_tableView];
    [self.view addSubview:m_tableView];
    if (IOS_7) {
        [m_tableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
    m_tableView.separatorColor = [CommonImage colorWithHexString:LINE_COLOR];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableView Delegate methods
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *key = [m_indexArray objectAtIndex:section];
    return key;
}
#pragma mark - Section header view
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 31)];
    view.backgroundColor = self.view.backgroundColor;
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, kDeviceWidth -30, view.height)];
    lab.text = [m_indexArray objectAtIndex:section];
    lab.font = [UIFont systemFontOfSize:13];
    lab.textColor = [CommonImage colorWithHexString:@"999999"];
    lab.textAlignment = NSTextAlignmentLeft;
    [view addSubview:lab];
    
    UIView *tline = [Common createLineLabelWithHeight:0];
    [view addSubview:tline];
    
    UIView *dline = [Common createLineLabelWithHeight:view.height];
    [view addSubview:dline];
    
    return view;
}
#pragma mark - row height
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 31;
}
#pragma mark -
#pragma mark Table View Data Source Methods
#pragma mark -设置右方表格的索引数组
-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return m_indexArray;
}
#pragma mark -
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    NSLog(@"title===%@",title);
    return index;
}

#pragma mark -允许数据源告知必须加载到Table View中的表的Section数。
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [m_indexArray count];
}
#pragma mark -设置表格的行数为数组的元素个数
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *sectionArray = m_dataArray[section];
    return sectionArray.count;
}
#pragma mark -每一行的内容为数组相应索引的值
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    WordListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[WordListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    NSString *str = [[m_dataArray objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
    [cell setUpDict:str];
    [Common setUpFullseparatorLineWithCell:cell];
    return cell;
}
#pragma mark - Select内容为数组相应索引的值
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *medicineDic = nil;
    medicineDic = m_dataArray[indexPath.section][indexPath.row];
}

#pragma mark delete
- (void)tableView:(UITableView*)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath*)indexPath
{
    [self deleteDataIndex:indexPath];
    
    NSMutableArray *array = m_dataArray[indexPath.section];
    [array removeObjectAtIndex:indexPath.row];
    // Delete the row from the data source.
    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

- (UITableViewCellEditingStyle)tableView:(UITableView*)tableView editingStyleForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

- (void)deleteDataIndex:(NSIndexPath *)indexPath
{
//    NSString *str = [[m_dataArray objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
//    [m_wordListdao deleteWordStr:str];
}
@end
