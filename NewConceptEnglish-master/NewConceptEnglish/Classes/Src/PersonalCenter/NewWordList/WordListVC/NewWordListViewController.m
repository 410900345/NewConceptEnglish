//
//  NewWordListViewController.m
//  newIdea1.0
//
//  Created by jiuhao-yangshuo on 15/11/9.
//  Copyright © 2015年 xuGuohong. All rights reserved.
//

#import "NewWordListViewController.h"
#import "ChineseString.h"
#import "WordList.h"
//#import "WordDetailViewController.h"
#import "WordListCell.h"
//#import "FindWordViewController.h"
#import "WordContentVC.h"
#import "WordListCell.h"

@interface NewWordListViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    WordList *m_wordListdao;
     NSMutableDictionary *m_wordInfo;
}
@end

@implementation NewWordListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = self.m_superDic[@"book_name"];
    self.m_tableView.rowHeight = KWordListCellH;
}

-(void)dealloc
{
     TT_RELEASE_SAFELY(m_wordListdao);
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.m_tableView endEditing:YES];
    [super viewWillDisappear:animated];
}

-(void)getData
{

    dispatch_queue_t queue = dispatch_queue_create("com.yang", NULL);
    dispatch_async(queue, ^{
       m_wordListdao = [[WordList alloc] init];
        m_wordInfo = [[NSMutableDictionary alloc] init];
        NSArray *array = [m_wordListdao fetchWordsDataFromBookWithBookId:self.m_superDic[@"bookid"]];
        NSMutableArray *stringsToSort = [[NSMutableArray alloc] init];
        for (NSDictionary *dict in array) {
            NSString *str = dict[@"word"];
            NSString *filterStr = [ChineseString RemoveSpecialCharacter:str];
            [m_wordInfo setObject:dict forKey:filterStr];
            [stringsToSort addObject:filterStr];
        }
        self.m_indexArray = [ChineseString IndexArray:stringsToSort];
        self.m_dataArray = [ChineseString LetterSortArray:stringsToSort];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self handleData];
        });
    });
}

-(void)handleData
{
    if (!self.m_dataArray.count)
    {
        [Common MBProgressTishi:@"还未添加生词" forHeight:kDeviceHeight];
    }
    [self.m_tableView reloadData];
}

#pragma mark - Select内容为数组相应索引的值
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *medicineDic = nil;
    medicineDic = self.m_dataArray[indexPath.section][indexPath.row];
    NSDictionary *dict = m_wordInfo[medicineDic];
    
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    for(NSArray *subArray in  self.m_dataArray)
    {
        for (NSString *subStr in  subArray) {
            NSString *filterStr = [ChineseString RemoveSpecialCharacter:subStr];
            NSDictionary *dict = m_wordInfo[filterStr];
            [dataArray addObject:dict];
        }
    }
    WordContentVC *newBook = [[WordContentVC alloc] init];
    newBook.isShowContent = YES;
    newBook.wordIndex = [dataArray indexOfObject:dict];//位置
    newBook.m_dataArray = dataArray;
    [self.navigationController pushViewController:newBook animated:YES];

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    WordListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[WordListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    NSString *str = [[self.m_dataArray objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
    NSString *filterStr = [ChineseString RemoveSpecialCharacter:str];
    NSDictionary *dict = m_wordInfo[filterStr];
    [cell setUpDict:dict];
    [Common setUpFullseparatorLineWithCell:cell];
    return cell;
}

#pragma mark delete
- (void)tableView:(UITableView*)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath*)indexPath
{
    [self deleteDataIndex:indexPath];
    NSMutableArray *array = self.m_dataArray[indexPath.section];
    [array removeObjectAtIndex:indexPath.row];
    // Delete the row from the data source.
    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
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
    NSString *str = [[self.m_dataArray objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
    [m_wordListdao deleteNewWordStr:str inBookID:self.m_superDic[@"bookid"]];
}


@end
