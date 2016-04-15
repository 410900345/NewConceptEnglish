//
//  NewConceptDetailVC.m
//  newIdea1.0
//
//  Created by yangshuo on 15/9/26.
//  Copyright (c) 2015年 xuGuohong. All rights reserved.
//

#import "NewConceptDetailVC.h"
#import "NewConceptDetailCell.h"
#import "NewConceptDetailPage.h"
#import "AppUtil.h"
#import "NetAccess.h"
#import "BookReadDao.h"
#import "BookIndexModel.h"

@interface NewConceptDetailVC()<UITableViewDataSource,UITableViewDelegate,NetAccessDelegate>
{
    NetAccess *myNetAccess;
}
@end

@implementation NewConceptDetailVC

#pragma mark - life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createTableView];
    // Do any additional setup after loading the view.
}

-(void)getDataSource
{
//    [super getDataSource];
    NSString *convertStr = self.bookIndex ;
    NSString *indexBookStr = [NSString stringWithFormat:@"%d_%@",(int)(self.itemBook+1),convertStr];
    NSString *bookPath = [AppUtil getBookPathIndex:indexBookStr withResoureName:[NSString stringWithFormat:@"NCE%d",(int)(self.itemBook+1)]];
    NSString *fileName = [NSString stringWithFormat:@"NCE%dlist",(int)(self.itemBook+1)];
    myNetAccess = [[NetAccess alloc]init];
    [myNetAccess importTextLineWithFilePath:bookPath withFileName:[NSString stringWithFormat:@"%@.bat",fileName] withDelegate:self];
}

-(void)analysisFinishWithData:(NSArray *)dataArray
{
    NSArray *subArray = [self handleData:dataArray];
    [self.dataArray removeAllObjects];
    [self.dataArray addObjectsFromArray:subArray];
    WS(weakSelf);
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
          __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf.allTableView reloadData];
        [strongSelf endOfResultList];
    }];
}

//加工数据
-(NSArray *)handleData:(NSArray *)dataArray
{
    NSArray *subArray= nil;
    NSArray *indexArray = [self.bookIndex componentsSeparatedByString:@"_"];// 1- 24
    NSInteger startIndex = [[indexArray firstObject] integerValue];//起点 1
    NSInteger endIndx = [[indexArray lastObject] integerValue];//终点 24
    NSInteger lenth = endIndx - startIndex +1;//长度
    NSInteger newStartIndex = startIndex - 1;
    NSRange rangeIndex ;
    if (self.itemBook == ItemBookNumOne)
    {
        lenth = 12;
        newStartIndex = (startIndex-1)/2.0;
    }
    rangeIndex = NSMakeRange(newStartIndex, lenth);
    subArray = [dataArray  subarrayWithRange:rangeIndex];
    NSMutableArray *newArray = [NSMutableArray array];
    for (int i = 0; i < subArray.count;i++)
    {
        NSString *detailText = subArray[i];//内容
        NSString *indexTxt = [NSString stringWithFormat:@"%d",(int)(i+startIndex)];//索引
        if (self.itemBook == ItemBookNumOne)
        {
            indexTxt = [NSString stringWithFormat:@"%d",(int)(i+newStartIndex +1)];
        }
        NSString *bookIndexDocTxt = indexTxt; //文件标记
        
        if (self.itemBook == ItemBookNumOne)
        {
            indexTxt = [NSString stringWithFormat:@"%d-%d",(int)(i*2+startIndex),(int)(i*2+startIndex+1)]; ;
        }
        NSDictionary *dict = @{kBookTxt:detailText,
                               kBookIndexTxt:indexTxt,
                               kBookIndexDocTxt:bookIndexDocTxt
                               };
        [newArray addObject:dict];
    }
    return newArray;
}

#pragma mark - UITableViewDataSource And UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"NewConceptDetailCell";
    NewConceptDetailCell *cell =
    [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell)
    {
        cell = [[NewConceptDetailCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:identifier];
    }
    NSDictionary *detailText = self.dataArray[indexPath.row];
    if ([detailText isKindOfClass:[NSDictionary class]])
    {
        cell.m_dict = detailText;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSMutableDictionary *medicineDic = nil;
    medicineDic = [self.dataArray[indexPath.row] mutableCopy];
    
    NewConceptDetailPage *newBook = [[NewConceptDetailPage alloc] init];
    newBook.itemBook = self.itemBook;
    newBook.bookIndex = self.bookIndex;
//    newBook.title = medicineDic[kBookTxt];
    newBook.bookIndexDict = medicineDic;
    
    BookIndexModel *model = [[BookIndexModel alloc] init];
    model.bookModelIndex = indexPath.row;
    model.bookIndexModelArray = self.dataArray;
    newBook.m_bookIndexModel = model;
    [self.navigationController pushViewController:newBook animated:YES];
    
    NSMutableDictionary *newDict = [NSMutableDictionary dictionaryWithDictionary:medicineDic];
    [newDict setObject:[NSString stringWithFormat:@"%d",self.itemBook] forKey:@"itemBook"];
    [newDict setObject:self.bookIndex forKey:@"bookIndex"];
    [self btnReadBookIntoDBWithDict:newDict];
}


-(void)btnReadBookIntoDBWithDict:(NSDictionary *)dict
{
    BookReadDao *dao = [[BookReadDao alloc] init];
    BOOL state = [dao writeBookReadToDB:dict];
    TT_RELEASE_SAFELY(dao);
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  kNewConceptDetailCellHeight;
}
@end
