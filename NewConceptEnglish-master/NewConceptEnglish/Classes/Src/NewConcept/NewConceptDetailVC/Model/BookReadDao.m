//
//  BookReadDao.m
//  newIdea1.0
//
//  Created by jiuhao-yangshuo on 15/11/12.
//  Copyright © 2015年 xuGuohong. All rights reserved.
//

#import "BookReadDao.h"
#import "FileManagerModel.h"


@interface BookReadDao()

@end


@implementation BookReadDao


- (BOOL)writeBookReadToDB:(NSDictionary *)data
{
    if (data == nil )
    {
        return NO;
    }
    [self.databaseQueue inDatabase:^(FMDatabase *db)
    {
        NSString *strLove = data[@"loveBook"];
        int  strLoveInt = [strLove intValue];
        NSString *sql = @"";
        if (strLoveInt == 0)
        {
            strLove = @"0";
             sql = [NSString stringWithFormat:@"INSERT into bookRead(kBookTxt,kBookIndexTxt,kBookIndexDocTxt,itemBook,bookIndex,add_dttm,loveBook)values(?,?,?,?,?,?,?);"];
            
        }
        else
        {
             strLove = @"1";//已经收藏
             sql = [NSString stringWithFormat:@"replace into bookRead(kBookTxt,kBookIndexTxt,kBookIndexDocTxt,itemBook,bookIndex,add_dttm,loveBook)values(?,?,?,?,?,?,?);"];
        }
     
        BOOL success = [db executeUpdate:sql,data[kBookTxt],data[kBookIndexTxt],data[kBookIndexDocTxt],data[@"itemBook"],data[@"bookIndex"],[NSDate date],strLove];
        NSLog(@"------success == %d",success);
    }];
    return YES;
}

-(int)getReadBookCount
{
    __block int count = 0;
    //这是表中的总行数。
    [self.databaseQueue inDatabase:^(FMDatabase *db){
        NSString *sql = [NSString stringWithFormat:@"SELECT count(*) AS count FROM bookRead ;"];
        FMResultSet *rs = [db executeQuery:sql];
        
        if(!rs){
            [rs close];
            count = -2;
            return;
        }
        count = -1;
        
        while ([rs next]) {
            NSString *countString = [rs stringForColumn:@"count"];
            count = [countString intValue];
            break;
        }
        //DLog(@"Province -- the size of the array :%d",array.count);
        [rs close];
    }];
    return count;
}

- (NSArray *)getallBookReadDataWihtLove:(BOOL)isLvoe
{
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM bookRead"];
    if (isLvoe)
    {
        sql = [sql stringByAppendingFormat:@" where loveBook = '1';"];
    }
    NSArray *array = [self getAllObjectsFromDBForSQL:sql getParam:@[@"kBookTxt",@"kBookIndexDocTxt",@"kBookIndexTxt",@"itemBook",@"bookIndex",@"id"]];
    return array;
}

//+(BOOL)updateisfavoriteBookByClassid:(NSString*)classid withInsert:(BOOL)insert
//{
//    FMDatabase * db = [[DBOperate shareInstance] getLocalGrammerDB];
//    if ([db executeUpdate:@"UPDATE records SET isfavorite = '%d' WHERE id = ?",(int)insert,classid]) {
//        NSLog(@"updata success!");
//        [db close];
//        return YES;
//    }else{
//        NSLog(@"updata failed!");
//        [db close];
//        return NO;
//    }
//    NSString *titleStr = insert?@"收藏成功":@"取消收藏";
//    [Common MBProgressTishi:titleStr forHeight:kDeviceHeight];
//}


@end
