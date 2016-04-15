//
//  DBOperate.h
//  Mazda
//
//  Created by binfo on 12-11-7.
//  Copyright (c) 2012年 B.H. Tech Co.Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "Global.h"
#import "Global_Url.h"
#import "LearnWordDao.h"

static NSString *const kWordDb = @"wordinfo.eng";
static NSString *const kSentenceDb = @"sentence.eng";
static NSString *const KangxunLocalDBName = @"kangxunLocal.db";
static NSString *const KWordName = @"KWordName";
static NSString *const kGrmmarDB = @"grmmar.db";

@interface DBOperate : NSObject
{
    FMDatabase* m_db;
}

+ (DBOperate*)shareInstance;

/**
 *  根据sql串查询表中符合的数据
 *
 *  @param sql    串
 *  @param params 获取的字段
 *
 *  @return 数组
 */
- (NSArray*)getDataForSQL:(NSString*)sql getParam:(NSArray*)params withDbName:(NSString *)dbName;

/**
 *  插入行到表
 *
 *  @param sql 串
 *
 *  @return 返回是否成功
 */
- (BOOL)insertDataForSQL:(NSString*)sql;

//创建聊天表
- (BOOL)createDBWithTable;

- (void)moveDB;
/**
 *  服务器更新
 *
 *  @param sql 传入可执行的sql串
 *
 *  @return 返回成功失败
 */
- (BOOL)updateDataForServer:(NSString*)sql;

/**
 *  插入行到表
 *
 *  @param sql 串
 *
 *  @return 返回是否成功
 */
- (BOOL)insertLocalDataForSQL:(NSString*)sql;

//解密字符串 
- (NSString*)decryptionWithStr:(NSString*)str;

- (void)closeDB;

- (BOOL)insertSingleDataToDBWithData:(NSMutableDictionary*)data;

- (int)getLocalRecordDBWordCount;
- (FMDatabase*)getLocalGrammerDB;
- (FMDatabase*)getLocalRecordDBWord;
@end
