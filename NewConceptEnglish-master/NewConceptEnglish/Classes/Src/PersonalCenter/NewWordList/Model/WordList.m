//
//  WordList.m
//  newIdea1.0
//
//  Created by jiuhao-yangshuo on 15/11/9.
//  Copyright © 2015年 xuGuohong. All rights reserved.
//

#import "WordList.h"

@implementation WordList

- (NSMutableArray *)getWordsLsit
{
    __block NSMutableArray *array = nil;
    [self.databaseQueue inDatabase:^(FMDatabase *db){
        NSString *sql = [NSString stringWithFormat:@"select *from wordList"];
        FMResultSet *rs = [db executeQuery:sql];
        if(!rs){
            [rs close];
            return;
        }
        array = [[NSMutableArray alloc] init];
        while ([rs next]) {
            NSString *keyword = [rs stringForColumn:@"word"];
            if (NotNilAndNull(keyword)) {
                [array addObject:keyword];
            }
        }
        [rs close];
    }];
    return array;
}

-(BOOL)deleteWordStr:(NSString *)word
{
    if (!word.length)
    {
        return NO;
    }
    
    [self.databaseQueue inDatabase:^(FMDatabase *db){
        NSString *sql = [NSString stringWithFormat:@"delete from wordList WHERE word = ?;"];
       BOOL state  = [db executeUpdate:sql,word];
        NSLog(@"----state %d",state);
    }];
    return YES;
}

-(BOOL)handleExsitWithSqlite:(NSString *)sqlite
{
    __block BOOL haveData = NO;
    if (IsStrEmpty(sqlite))
    {
        return haveData;
    }
    [self.databaseQueue inDatabase:^(FMDatabase *db){
        FMResultSet *rs = [db executeQuery:sqlite];
        if(!rs)
        {
            [rs close];
            return;
        }
        while ([rs next]) {
            NSString *countString = [rs stringForColumn:@"count"];
            int count = [countString intValue];
            haveData = (count>0);
            break;
        }

        [rs close];
    }];
    return haveData;
}

+(void)createDefaultNewBook
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        WordList *wordDao = [[WordList alloc] init];
        if (![wordDao haveBookName:kDefautWordBook])
        {
            [wordDao crateWorBookWithName:kDefautWordBook];
        }
    });
}

#pragma mark - wordbook
-(void)crateWorBookWithName:(NSString *)bookName
{
    if (!bookName.length)
    {
        return;
    }
    NSString *wordText = [bookName capitalizedString];
    wordText = [wordText trim];
    NSString *sqlite  = [NSString stringWithFormat:@"insert INTO wordBook (book_name,create_time) VALUES (?,?);"];;
    [self.databaseQueue inDatabase:^(FMDatabase *db){
        BOOL state  = [db executeUpdate:sqlite,wordText,[NSDate date]];
        NSLog(@"----state %d",state);
    }];
}

- (NSMutableArray*)fetchWorBookListsData
{
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM wordBook ORDER BY create_time DESC;"];
    NSMutableArray *returnArray = [self getAllObjectsFromDBForSQL:sql getParam:@[@"bookid",@"book_name",@"create_time"]];
    return returnArray ;
}

- (NSDictionary *)fetchWorBookListsDataWithBookName:(NSString *)bookName
{
     if (IsStrEmpty(bookName))
     {
         return @{};
     }
    NSString *wordText = [bookName capitalizedString];
    wordText = [wordText trim];
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM wordBook WHERE book_name = '%@'  LIMIT 1;",wordText];
    NSMutableArray *returnArray = [self getAllObjectsFromDBForSQL:sql getParam:@[@"bookid",@"book_name",@"create_time"]];
    NSDictionary *dict  = nil;
    if (returnArray.count)
    {
        dict = returnArray[0];
    }
    else
    {
        dict = @{};
    }
    return dict ;
}

//是否存在同名的本子
-(BOOL)haveBookName:(NSString *)bookName
{
    NSString *wordText = [bookName capitalizedString];
    wordText = [wordText trim];
    BOOL haveData = NO;
//    NSString *sqlite  = [NSString stringWithFormat:@"SELECT EXISTS(SELECT * FROM wordBook  WHERE book_name = '%@')",bookName];
       NSString *sqlite  = [NSString stringWithFormat:@"SELECT COUNT(*) AS count FROM wordBook  WHERE book_name = '%@'",bookName];;
    haveData = [self handleExsitWithSqlite:sqlite];
    return haveData;
}

-(BOOL)deleteWordBookBookID:(NSString *)bookid
{
    if (!bookid.length)
    {
        return NO;
    }
    
    [self.databaseQueue inDatabase:^(FMDatabase *db){
        NSString *sql = [NSString stringWithFormat:@"delete from wordBook WHERE bookid = ?;"];
        BOOL state  = [db executeUpdate:sql,bookid];
        
        if (state)
        {
            NSString *sqlite = [NSString stringWithFormat:@"delete from newWord WHERE pid = ?;"];
            state  = [db executeUpdate:sqlite,bookid];
        }
        NSLog(@"----state %d",state);
    }];
    return YES;
}

-(void)renameWordBookWithBookID:(NSString *)bookid withNewName:(NSString *)name
{
    if (!bookid.length && name.length)
    {
        return;
    }
    [self.databaseQueue inDatabase:^(FMDatabase *db){
        NSString *sql = [NSString stringWithFormat:@"UPDATE wordBook SET  book_name = ? WHERE bookid = ?;"];
        BOOL state  = [db executeUpdate:sql,bookid,name];
        NSLog(@"----state %d",state);
    }];
}

-(void)updateWordBookDateWithBookID:(NSString *)bookid
{
    if (!bookid.length)
    {
        return;
    }
    [self.databaseQueue inDatabase:^(FMDatabase *db){
        NSString *sql = [NSString stringWithFormat:@"UPDATE wordBook SET  create_time = ? WHERE bookid = ?;"];
        BOOL state  = [db executeUpdate:sql,[NSDate date],bookid];
        NSLog(@"----state %d",state);
    }];
}


#pragma mark -  newWord newWord
- (NSMutableArray*)fetchWordsDataFromBookWithBookId:(NSString *)bookid
{
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM newWord WHERE pid = '%@' ORDER BY storeDate DESC;",bookid];
    NSArray *array = [self getAllObjectsFromDBForSQL:sql getParam:@[@"id",@"pid",@"word",@"symbol",@"explain"]];
    NSMutableArray *returnArray = [[[array reverseObjectEnumerator] allObjects] mutableCopy];//倒序
    return returnArray ;
}
-(BOOL)haveWord:(NSString *)word inBookID:(NSString *)bookID
{
    NSString *wordText = [word capitalizedString];
    wordText = [wordText trim];
    BOOL haveData = NO;
    NSString *sqlite  = [NSString stringWithFormat:@"SELECT COUNT(*) AS count FROM newWord  WHERE pid = %@ and word = '%@'",bookID,word];
    haveData = [self handleExsitWithSqlite:sqlite];
    return haveData;
}

-(void)insertBookWithWordListModel:(WordListModel *)wordModel
{
    NSString *word = wordModel.word;
    NSString *symbol = wordModel.symbol;
    NSString *explain = wordModel.explain;
    NSString *bookID = wordModel.pid;
    if (IsStrEmpty(word) ||
        IsStrEmpty(symbol) ||
        IsStrEmpty(explain) ||
        IsStrEmpty(word) )
    {
        return;
    }
    NSString *wordText = [[word lowercaseString] capitalizedString];
    wordText = [wordText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([self haveWord:wordText inBookID:bookID])
    {
        [Common MBProgressTishi:@"单词已经存在" forHeight:kDeviceHeight];
        return;
    }
    
    NSString *sqlite  = [NSString stringWithFormat:@"insert INTO newWord (pid,word,symbol,explain,storeDate) VALUES (?,?,?,?,?);"];;
    [self.databaseQueue inDatabase:^(FMDatabase *db){
        BOOL state  = [db executeUpdate:sqlite,bookID,wordText,symbol,explain,[NSDate date]];
        NSLog(@"----state %d",state);
    }];
    [Common MBProgressTishi:@"单词保存成功!" forHeight:kDeviceHeight];
}


- (int)fetchLocalNewBookWordCountWithBookID:(NSString *)bookID
{
   __block int count = 0;
    NSString *sqlite = [NSString stringWithFormat:@"SELECT COUNT(*) AS count FROM newWord where pid = ?"];
    [self.databaseQueue inDatabase:^(FMDatabase *db){
        FMResultSet *rs = [db executeQuery:sqlite,bookID];
        if(!rs)
        {
            [rs close];
            return;
        }
        while ([rs next]) {
            NSString *countString = [rs stringForColumn:@"count"];
            count = [countString intValue];
            break;
        }
        [rs close];
    }];
    return count;
}

-(BOOL)deleteNewWordStr:(NSString *)word inBookID:(NSString *)bookID
{
    if (IsStrEmpty(word) && IsStrEmpty(bookID))
    {
        return NO;
    }
    
    [self.databaseQueue inDatabase:^(FMDatabase *db){
        NSString *sql = [NSString stringWithFormat:@"delete from newWord WHERE pid = ? and word = ?;"];
        BOOL state  = [db executeUpdate:sql,bookID,word];
        NSLog(@"----state %d",state);
    }];
    return YES;
}

@end
