//
//  DBOperate.m
//  Mazda
//
//  Created by binfo on 12-11-7.
//  Copyright (c) 2012年 B.H. Tech Co.Ltd. All rights reserved.
//

#import "DBOperate.h"
#import "AppUtil.h"
#include <CommonCrypto/CommonCryptor.h>
#import "Encryption.h"
#import "GrammarDao.h"

@implementation DBOperate

/**
 *  健康自查表名定义
 */
#define SymptomTable "symptom_Table"
#define DiseaseTable "disease_Table"

#define KangxunDBVersion @"kangxunDBVersion"
#define KangxunLocalDBVersion @"kangxunLocalDBVersion"


#define LIMIT_SIZE 20

+ (DBOperate*)shareInstance
{
    static DBOperate* _instance = nil;
    if (!_instance) {
        _instance = [[DBOperate alloc] init];
    }
    return _instance;
}

/**
 *  数据来源库
 *
 *  @return
 */
- (FMDatabase*)getDB
{
    NSString *pathString = [[AppUtil getDbPath] stringByAppendingFormat:@"/%@",kWordDb];
    FMDatabase* db = [FMDatabase databaseWithPath:pathString];
    NSLog(@"-------%@",DB_PATH);
    if (![db open]) {
        NSLog(@"Could not open db.");
        return nil;
    }
    return db;
}
/**
 *  本地记录操作的数据库
 *
 *  @return
 */
- (FMDatabase*)getLocalRecordDB
{
    NSString *pathString = [[AppUtil getDbPath] stringByAppendingFormat:@"/%@",kSentenceDb];
    FMDatabase* db = [FMDatabase databaseWithPath:pathString];
    NSLog(@"%@",DB_PATH);
    if (![db open]) {
        NSLog(@"Could not open db.");
        return nil;
    }
    return db;
}

- (FMDatabase*)getLocalRecordDBFromeNewDBWithName:(NSString *)dbName
{
    NSString *pathString = [[AppUtil getDbPath] stringByAppendingFormat:@"/%@",dbName];
    FMDatabase* db = [FMDatabase databaseWithPath:pathString];
    NSLog(@"%@",DB_PATH);
    if (![db open]) {
        NSLog(@"Could not open db.");
        return nil;
    }
    return db;
}

- (FMDatabase*)getLocalGrammerDB
{
    NSString * pathString = [[AppUtil getDocPath]  stringByAppendingPathComponent:kGrmmarDB];
    FMDatabase* db = [FMDatabase databaseWithPath:pathString];
    NSLog(@"%@",DB_PATH);
    if (![db open]) {
        NSLog(@"Could not open db.");
        return nil;
    }
    return db;
}
- (FMDatabase*)getLocalRecordDBWord
{
    NSString *pathString = [[Common datePath] stringByAppendingPathComponent:KangxunLocalDBName];
    FMDatabase* db = [FMDatabase databaseWithPath:pathString];
    NSLog(@"%@",DB_PATH);
    if (![db open]) {
        NSLog(@"Could not open db.");
        return nil;
    }
    return db;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        [self moveDB];
    }
    return self;
}

//解密方法
- (NSString*)decryptionWithStr:(NSString*)str
{
    NSString *encrypt = [self SXdecryptUseDES:str key:kKey];
    NSLog(@"encrypt = %@", str);
    return encrypt;
}


/**
 *  服务器更新
 *
 *  @param sql 传入可执行的sql串
 *
 *  @return 返回成功失败
 */
- (BOOL)updateDataForServer:(NSString*)sql
{
    BOOL is = YES;
    if (m_db) {
        if (![m_db open]) {
            [m_db close];
            m_db = [self getDB];
        }
    }
    else {
        m_db = [self getDB];
    }
    
    if ([m_db executeUpdate:sql]) {
        NSLog(@"updateDataForServer success!");
    } else {
        NSLog(@"updateDataForServer failed!");
        is = NO;
    }
    return is;
}

- (void)closeDB
{
    [m_db close];
	m_db = nil;
}

/**
 *  插入行到表
 *
 *  @param sql 串
 *
 *  @return 返回是否成功
 */
- (BOOL)insertDataForSQL:(NSString*)sql
{
    FMDatabase* db = [self getDB];
    if ([db executeUpdate:sql]) {

        NSLog(@"insert success!");
        [db close];
        return YES;
    } else {
        NSLog(@"insert failed!");
        [db close];
        return NO;
    }
}

/**
 *  插入行到表
 *
 *  @param sql 串
 *
 *  @return 返回是否成功
 */
- (BOOL)insertDataForLocalSQL:(NSString*)sql withDbName:(FMDatabase *)dbName
{
    FMDatabase* db = dbName;
    NSAssert(db != nil, @"Argument must be non-nil");
    if ([db executeUpdate:sql]) {
        
        NSLog(@"insert success!");
        [db close];
        return YES;
    } else {
        NSLog(@"insert failed!");
        [db close];
        return NO;
    }
}

/**
 *  插入行到表
 *
 *  @param sql 串
 *
 *  @return 返回是否成功
 */
- (BOOL)insertLocalDataForSQL:(NSString*)sql
{
    FMDatabase* db = [self getLocalRecordDB];
    if ([db executeUpdate:sql]) {
        
        NSLog(@"insert success!");
        [db close];
        return YES;
    } else {
        NSLog(@"insert failed!");
        [db close];
        return NO;
    }
}

/**
 *  根据sql串查询表中符合的数据
 *
 *  @param sql    串
 *  @param params 获取的字段
 *
 *  @return 数组
 */
- (NSArray*)getDataForSQL:(NSString*)sql getParam:(NSArray*)params withDbName:(NSString *)dbName
{
    @try {
    FMDatabase* db = nil;
    if ([kWordDb isEqualToString:dbName])
    {
        db = [self getDB];
    }
    else if ([kSentenceDb isEqualToString:dbName])
    {
        db = [self getLocalRecordDB];
    }
    else if ([kGrmmarDB isEqualToString:dbName])
    {
        db = [self getLocalGrammerDB];
    }
    else if ([kNcewordDb isEqualToString:dbName])
    {
        db = [self getLocalRecordDBFromeNewDBWithName:kNcewordDb];
    }
    else if ([KangxunLocalDBName isEqualToString:dbName])
    {
        db = [self getLocalRecordDBWord];
    }
        //    FMDatabase* db = [self getDB];
    FMResultSet* rs = [db executeQuery:sql];
    NSMutableArray* data = [[NSMutableArray alloc] init];
    NSString* value;
    NSMutableDictionary* dic;

    int paramsCount = params.count;
    while ([rs next]) {

        if(paramsCount == 1){//过滤只有一个value为null的情况
            NSString *key = params[0];
            NSString *value = [rs stringForColumn:key];
            if(value.length == 0){
                continue;
            }
        }
        dic = [NSMutableDictionary dictionary];

        for (NSString* key in params) {
            
            if([key isEqualToString:@"treatment"] | [key isEqualToString:@"mechanism"] | [key isEqualToString:@"applicable"] | [key isEqualToString:@"PRACTICE"])
            {
                //解密
            value = [self decryptionWithStr:[rs stringForColumn:key]];
            }else{
                //同一方法两个字段，一个加密一个不加密，判断
            if ([key isEqualToString:@"introduction"]) {
                NSString * introStr = [rs stringForColumn:key];
            value = [self decryptionWithStr:introStr];
            if (value.length<1) {
                value = introStr;
            }
            }else{
            value = [rs stringForColumn:key];
            }
            }
            
            if(value.length){
                [dic setObject:value forKey:key];
            }else{

                [dic setObject:@"" forKey:key];
            }
        }

        
        [data addObject:dic];
    }
    [db close];
    return [data autorelease];
    }
    @catch (NSException *exception) {
        NSMutableArray* data = [[NSMutableArray alloc] init];
        return [data autorelease];
    }
    @finally {
        
    }
}

#pragma mark 更改这里
- (void)moveDB
{
    //本地标示
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *kangxunDBVersion = [userDefaults objectForKey:KangxunDBVersion];
    NSString *kangxunLocalDBVersion = [userDefaults objectForKey:KangxunLocalDBVersion];
    
    //plist-标示
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *newKangxunDBVersion = [infoDic objectForKey:KangxunDBVersion];
    NSString *newKangxunLocalDBVersion = [infoDic objectForKey:KangxunLocalDBVersion];
    
    
    NSString * dbFile = [[Common datePath] stringByAppendingPathComponent:@"kangxun.db"];
    NSString * dbLocalRecordFile = [[Common datePath] stringByAppendingPathComponent:@"kangxunLocal.db"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if(kangxunDBVersion && ![kangxunDBVersion isEqualToString:newKangxunDBVersion]){
        //本地为非空 且  本地版本与info不一致，移除数据库
        [fileManager removeItemAtPath:dbFile error:nil];
    }
    if(kangxunLocalDBVersion && ![kangxunLocalDBVersion isEqualToString:newKangxunLocalDBVersion]){
        //本地为非空 且  本地版本与info不一致，移除数据库
        [fileManager removeItemAtPath:dbLocalRecordFile error:nil];
    }
    
    if(![fileManager fileExistsAtPath:dbFile])
    {
        NSError *error = nil;
        NSString *dbEmpty = [[self getAppPath] stringByAppendingPathComponent:@"kangxun.db"];
        [fileManager copyItemAtPath:dbEmpty toPath:dbFile error:&error];
        [[NSFileManager defaultManager] removeItemAtPath:dbEmpty error:NULL];
        if(!error){
            [userDefaults setObject:newKangxunDBVersion forKey:KangxunDBVersion];
        }
//        [self createDBWithTable];
    }
    if(![fileManager fileExistsAtPath:dbLocalRecordFile])
    {
        NSError *error = nil;
        NSString *dbEmpty = [[self getAppPath] stringByAppendingPathComponent:@"kangxunLocal.db"];
        [fileManager copyItemAtPath:dbEmpty toPath:dbLocalRecordFile error:&error];
        [[NSFileManager defaultManager] removeItemAtPath:dbEmpty error:NULL];
        if(!error){
            [userDefaults setObject:newKangxunLocalDBVersion forKey:KangxunLocalDBVersion];
        }
    }
}

//-(NSString*)getDocPath//得到数据库文件在Doc目录下的路径
//{
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    //找出文件下所有文件目录
//    NSString *docPath = ([paths count] > 0)?[paths objectAtIndex:0]:nil;
//    //找到Docutement目录
//    return docPath;
//}

-(NSString*)getAppPath//得到数据库文件在App目录下的路径
{
    return [[NSBundle mainBundle] resourcePath];
}

//插入生词
- (BOOL)insertSingleDataToDBWithData:(NSMutableDictionary*)data
{
    FMDatabase* db = [self getLocalRecordDBWord];
    if (![db open])
    {
        NSLog(@"打开数据库失败");
        return NO;
    }
    NSString *recordTable = @"wordList";
    NSString *wordText = [data[KWordName] capitalizedString];
    wordText = [wordText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *sqlite  = [NSString stringWithFormat:@"replace into %@(word) VALUES ('%@')",recordTable,wordText];;
    return [self insertDataForLocalSQL:sqlite withDbName:db];
}

//- (int)getLocalRecordDBWordCount
//{
//    FMDatabase* db = [self getLocalRecordDBWord];
//    int count = 0;
//    NSString *sql = [NSString stringWithFormat:@"SELECT COUNT(*) AS count FROM wordList"];
//    
//    FMResultSet * rs = [db executeQuery:sql];//, g_nowUserInfo.userid, 0];
//    while ([rs next]) {
//        count = [rs intForColumn:@"count"];
//    }
//    [db close];
//    return count;
//}
//获取生词数量
- (int)getLocalRecordDBWordCount
{
    FMDatabase* db = [self getLocalRecordDBWord];
    int count = 0;
    NSString *sql = [NSString stringWithFormat:@"SELECT COUNT(*) AS count FROM newWord"];
    
    FMResultSet * rs = [db executeQuery:sql];//, g_nowUserInfo.userid, 0];
    while ([rs next]) {
        count = [rs intForColumn:@"count"];
    }
    [db close];
    return count;
}

@end
