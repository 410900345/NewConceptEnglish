//
//  ReadBookListViewController.m
//  newIdea1.0
//
//  Created by jiuhao-yangshuo on 15/11/12.
//  Copyright © 2015年 xuGuohong. All rights reserved.
//

#import "ReadBookListViewController.h"
#import "ReadBookListCell.h"
#import "NewConceptDetailPage.h"
#import "BookReadDao.h"

@interface ReadBookListViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation ReadBookListViewController
@synthesize isLove;

-(id)init
{
    self = [super init];
    if (self)
    {
        isLove = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createTableView];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)getDataSource
{
    BookReadDao *dao = [[BookReadDao alloc] init];
    NSArray *array = [dao getallBookReadDataWihtLove:isLove];
    TT_RELEASE_SAFELY(dao);
    
    [self.dataArray removeAllObjects];
    [self.dataArray addObjectsFromArray:array];
    [self.allTableView reloadData];
    [self endOfResultList];
    
    [self handleData];
}

-(void)handleData
{
    if (!self.dataArray.count)
    {
        [Common MBProgressTishi:@"还未添加学习记录" forHeight:kDeviceHeight];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"NewConceptDetailCell";
    ReadBookListCell *cell =
    [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell)
    {
        cell = [[ReadBookListCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:identifier];
    }
    NSDictionary *detailText = self.dataArray[indexPath.row];
    if ([detailText isKindOfClass:[NSDictionary class]])
    {
        cell.m_dict = detailText;
    }
    [Common setUpFullseparatorLineWithCell:cell];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *medicineDic = nil;
    medicineDic = self.dataArray[indexPath.row];
    
    NewConceptDetailPage *newBook = [[NewConceptDetailPage alloc] init];
    newBook.itemBook = [medicineDic[@"itemBook"] intValue];
    newBook.bookIndex =  medicineDic[@"bookIndex"];
    newBook.bookIndexDict = medicineDic;
    
    BookIndexModel *model = [[BookIndexModel alloc] init];
    model.bookModelIndex = indexPath.row;
    model.bookIndexModelArray = self.dataArray;
    newBook.m_bookIndexModel = model;
    
    newBook.isShowLove = !isLove;
    [self.navigationController pushViewController:newBook animated:YES];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  kReadBookListCellHeight;
}

#pragma mark delete
//- (void)tableView:(UITableView*)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath*)indexPath
//{
//    [self deleteDataIndex:indexPath];
//    
//    NSMutableArray *array = self.dataArray[indexPath.section];
//    [array removeObjectAtIndex:indexPath.row];
//    // Delete the row from the data source.
//    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
//}
//
//- (UITableViewCellEditingStyle)tableView:(UITableView*)tableView editingStyleForRowAtIndexPath:(NSIndexPath*)indexPath
//{
//    return UITableViewCellEditingStyleDelete;
//}
//
//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return isLove;
//}
//
//- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return @"删除";
//}
//
//- (void)deleteDataIndex:(NSIndexPath *)indexPath
//{
//    NSDictionary *model  = [self.dataArray objectAtIndex:indexPath.row];
//    [SpeakingEnglishModel updateisfavoriteDataByClassid:model.idStr withInsert:YES];
//}
@end
