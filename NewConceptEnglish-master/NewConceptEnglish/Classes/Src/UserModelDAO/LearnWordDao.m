//
//  LearnWordDao.m
//  newIdea1.0
//
//  Created by jiuhao-yangshuo on 16/3/11.
//  Copyright © 2016年 xuGuohong. All rights reserved.
//

#import "LearnWordDao.h"

static NSString *const kLearnWordDao = @"map.so";

@interface LearnWordDao ()
@property (nonatomic,strong) DBOperate *myDataBase;
@end

@implementation LearnWordDao
{
    FMDatabase *m_fmdatabase;
}

@synthesize myDataBase;
-(id)init
{
    self = [super init];
    if (self)
    {
        myDataBase = [DBOperate shareInstance];
        m_fmdatabase = [myDataBase getLocalGrammerDB] ;
        _m_listArray = [[Common getMainBundlePathFileWithName:kLearnWordDao] mutableCopy];
    }
    return self;
}

- (BOOL)tableIsExistsWithName:(NSString *)tableName
{
    __block BOOL state = NO;
    [self.databaseQueue inDatabase:^(FMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:@"select count(*) as 'count' from sqlite_master where type ='table' and name='%@';",tableName];
        FMResultSet *rs = [db executeQuery:sql];
        if(!rs){
            [rs close];
            return;
        }
        while ([rs next]) {
            NSInteger count =  [[rs stringForColumn:@"count"] integerValue];
            state = (count>0) ;
            break;
        }
    }];
    return state;
}

- (NSArray*)findReciteWordBookFromDBWithIDs:(NSArray *)ids withAllArges:(BOOL)allData
{
    NSString *idString = [ids componentsJoinedByString:@","];
//    NSString *sql = [NSString stringWithFormat:@"SELECT id,word,phon_uk,mean_zh FROM word WHERE id IN(%@)",idString];
//    NSArray *medicinesArray = [myDataBase getDataForSQL:sql getParam:;
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM word WHERE id IN(%@)",idString];
    NSArray *agresArray = allData? @[@"id",@"word",@"monic",@"mean_zh",@"mean_en",@"enme",@"sent_en",@"sent_zh",@"phon_us",@"phon_uk",@"htxt"]:@[@"id",@"word",@"phon_uk",@"mean_zh"];
    NSArray *medicinesArray = [myDataBase getDataForSQL:sql getParam:agresArray withDbName:kNcewordDb];
    
    if (!medicinesArray.count)
    {
        medicinesArray = @[];
    }
    return medicinesArray;
}

- (NSDictionary * )findReciteWordBookFromDBWithWord:(NSString *)wordStr withAllArges:(BOOL)allData
{
    if (IsStrEmpty(wordStr)) {
        return @{};
    }
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM word WHERE word = '%@' COLLATE NOCASE",wordStr];
    NSArray *agresArray = allData? @[@"id",@"word",@"monic",@"mean_zh",@"mean_en",@"enme",@"sent_en",@"sent_zh",@"phon_us",@"phon_uk",@"htxt"]:@[@"id",@"word",@"phon_uk",@"mean_zh"];
    NSArray *medicinesArray = [myDataBase getDataForSQL:sql getParam:agresArray withDbName:kNcewordDb];
    NSDictionary *dict = nil;
    if (!medicinesArray.count)
    {
        dict = @{};
    }
    dict = medicinesArray[0];
    return dict;
}

- (NSArray*)findAllWordBookFromDB
{
    NSString *sql = [NSString stringWithFormat:@"SELECT bookname,word_count,book_id FROM recite_book"];
    NSArray *medicinesArray = [myDataBase getDataForSQL:sql getParam:@[@"bookname",@"book_id",@"word_count"] withDbName:kGrmmarDB];
    if (!medicinesArray.count)
    {
        medicinesArray = @[];
    }
    return medicinesArray;
}


- (BOOL)updateReciteWords:(NSArray *)words withTableName:(NSString *)tableName
{
    __block BOOL isSuccess = NO;
    [self.databaseQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *insertSql = [NSString stringWithFormat: @"insert into %@(wordId,word,yb,ybEn,wordZh)values(?,?,?,?,?)",tableName];
        for (NSDictionary *dto in words)
        {
            if (![db executeUpdate:insertSql, dto[@"id"], dto[@"word"], dto[@"phon_uk"],dto[@"phon_en"],dto[@"mean_zh"]])
            {
                *rollback = YES;
                return;
            }
        }
        isSuccess = YES;
    }];
    return isSuccess;
}

-(void)createTablesNeededWithNewDBName:(NSString *)newtableID
{
    @autoreleasepool {
        [self.databaseQueue inTransaction:^(FMDatabase *database, BOOL *rollBack){
            //计划数据
            NSString *sql1 = [NSString stringWithFormat:@"CREATE TABLE IF NOT exists word_plan (id INTEGER PRIMARY KEY AUTOINCREMENT,userId varchar,bookCount INTEGER,bookName text,bookRem text,learn INTEGER,onLearn INTEGER,sync INTEGER,lastTime long)"];
            
            /*info_useinfo*/
            NSString *sql2 = [NSString stringWithFormat:@"CREATE TABLE IF NOT exists word_plan_day (id INTEGER PRIMARY KEY AUTOINCREMENT,dayIndex varchar,userId varchar,bookId INTEGER,learn INTEGER,learn_end INTEGER,pk INTEGER,today INTEGER,recite INTEGER,right INTEGER,wrong INTEGER,exceed INTEGER,sync INTEGER,lastTime long)"];
            
            /*info_search*/
            NSString *sql3 = [NSString stringWithFormat:@"CREATE TABLE IF NOT exists %@ (id INTEGER PRIMARY KEY AUTOINCREMENT,userId varchar,wordId INTEGER,word varchar,yb varchar,ybEn varchar,wordZh text,count INTEGER,right INTEGER,wrong INTEGER,hard INTEGER,easy INTEGER,sync INTEGER,reciteTime long,lastTime long)",newtableID];
            [database executeUpdate:sql1];
            [database executeUpdate:sql2];
            [database executeUpdate:sql3];
        }];
    }
}

#pragma mark - PrivateMethod
//总计划
-(BOOL)insertWordPlandatawithData:(NSDictionary *)dict
{
     NSLog(@"----------%@",dict);
    __block BOOL state;
    [self.databaseQueue inDatabase:^(FMDatabase *db) {
        NSString *insertSql = [NSString stringWithFormat:@"REPLACE into word_plan(bookCount,bookName,bookRem,onLearn,learn,sync,lastTime)values(?,?,?,?,?,?,?);"];
        state = [db executeUpdate:insertSql,
                 dict[@"word_count"],dict[@"bookname"],[dict KXjSONString],@1,dict[@"learn"]
                 ,@0,[NSDate date]];
    }];
    NSLog(@"state----%d",state);
    return state;
}

-(NSDictionary *)findWordPlandataNew
{
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM word_plan where onLearn = 1 order by lastTime DESC limit 1"];
     NSDictionary *returnDict;
    NSArray *medicinesArray = [myDataBase getDataForSQL:sql getParam:@[@"bookName",@"bookCount",@"bookRem",@"learn"] withDbName:KangxunLocalDBName];
    if (!medicinesArray.count)
    {
        returnDict = @{};
    }
    else
    {
        returnDict = [medicinesArray firstObject];
    }
    return returnDict;
}

//每日计划
-(BOOL)insertWordPlanDaydatawithData:(NSDictionary *)dict
{
     NSLog(@"----------%@",dict);
    __block BOOL state;
    [self.databaseQueue inDatabase:^(FMDatabase *db) {
        NSString *insertSql = [NSString stringWithFormat:@"REPLACE into word_plan_day(dayIndex,bookId, learn,learn_end,pk,today,recite,right,wrong,exceed,lastTime)values(?,?,?,?,?,?,?,?,?,?,?);"];
        state = [db executeUpdate:insertSql, dict[@"dayIndex"],dict[@"book_id"],dict[@"learn"],dict[@"learn_end"],@1,
                 dict[@"today"],dict[@"recite"],dict[@"right"],dict[@"wrong"],dict[@"exceed"],
                 [NSDate date]];
    }];
    NSLog(@"state----%d",state);
    return state;
}

-(NSDictionary *)findWordPlanDaydataWtihBookID:(NSString *)bookID andDayStr:(NSString *)dayString
{
     NSString *sql = @"";
    NSDictionary *returnDict;
    sql = [NSString stringWithFormat:@"SELECT * FROM word_plan_day where bookId = %@",bookID];
    if (!IsStrEmpty(dayString))
    {
        sql = [sql  stringByAppendingFormat: @" AND dayIndex =%@",dayString];
    }
    NSArray *medicinesArray = [myDataBase getDataForSQL:sql getParam:@[@"dayIndex",@"bookId",@"learn",@"learn_end",@"today"
                                                                       ,@"recite",@"right",@"wrong",@"exceed",@"lastTime"] withDbName:KangxunLocalDBName];
    if (!medicinesArray.count)
    {
        returnDict = @{};
    }
    else
    {
        returnDict = [medicinesArray firstObject];
    }
    return returnDict;
}

- (NSArray*)findDayLernWordBookFromBook:(NSString *)bookID withIndexID:(NSString *)startID
{
    NSString *newtable = [NSString stringWithFormat:@"recite_word_%@",bookID];
    NSString *sql = @"";
    NSInteger max = 6;
    NSInteger pageNum = 20;
    if (startID.intValue < 0)
    {
        sql= [NSString stringWithFormat:@"SELECT *FROM %@ WHERE (easy isnull or easy =0)  ORDER BY id LIMIT %d OFFSET %d",newtable,(int)kMaxWordNum,(int)max*pageNum];
    }
    else
    {
        sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE (easy isnull or easy =0)  ORDER BY id LIMIT %d OFFSET %d",newtable,(int)kMaxWordNum,startID.intValue];
    }
    NSArray *medicinesArray = [myDataBase getDataForSQL:sql getParam:@[@"wordId",@"word",@"yb",@"ybEn",@"wordZh"] withDbName:KangxunLocalDBName];
    if (!medicinesArray.count)
    {
        medicinesArray = @[];
    }
    return medicinesArray;
}

-(void)createPlanDayWithInfo:(NSDictionary *)bookRem
{
    [self insertWordPlandatawithData:bookRem];
    NSDictionary *planDayDict;
    if (!planDayDict.count)
    {
        planDayDict = @{@"dayIndex":@0,@"book_id":bookRem[@"book_id"],@"learn_end":bookRem[@"ed"],
                        @"recite":@0,@"today":@0,@"learn":@1};
    }
    [self insertWordPlanDaydatawithData:planDayDict];
}

//今天,简单,
- (NSArray*)findDayLernWordCountTypeFromBook:(NSString *)bookID withType:(int )type
{
    NSString *newtable = [NSString stringWithFormat:@"recite_word_%@",bookID];
    NSString *sql = [NSString stringWithFormat:@"SELECT *FROM %@ ",newtable];
    
    switch (type) {
        case 1:// 今日新词
            sql = [sql stringByAppendingFormat:@"where easy isnull or easy =0  LIMIT 30"];
            break;
        case 2:// 已学过的单词
            sql = [sql stringByAppendingFormat:@""];
            break;
        case 3:// 未学的单词
            sql = [sql stringByAppendingFormat:@""];
            break;
        case 4:// 重难词汇
            sql = [sql stringByAppendingFormat:@""];
            break;
        case 5:// 简单词汇
            sql = [sql stringByAppendingFormat:@""];
            break;
        case 6:// 今日复习
            sql = [sql stringByAppendingFormat:@""];
            break;
        case 7:// 已掌握
            sql = [sql stringByAppendingFormat:@""];
            break;
            
        default:
            break;
    }

    NSArray *medicinesArray = [myDataBase getDataForSQL:sql getParam:@[@"wordId",@"word",@"yb",@"ybEn",@"wordZh"] withDbName:KangxunLocalDBName];
    if (!medicinesArray.count)
    {
        medicinesArray = @[];
    }
    return medicinesArray;
}

@end
