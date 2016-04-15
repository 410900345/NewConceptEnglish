//
//  LearnWordDao.h
//  newIdea1.0
//
//  Created by jiuhao-yangshuo on 16/3/11.
//  Copyright © 2016年 xuGuohong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DBOperate.h"
#import "DAO.h"

static NSString *const kNcewordDb = @"nceword.db";

static NSInteger const kMaxWordNum = 6;
@interface LearnWordDao : DAO

@property (nonatomic,strong) NSMutableArray *m_listArray;

- (NSArray*)findAllWordBookFromDB;

- (void)createTablesNeededWithNewDBName:(NSString *)newtableID;

- (BOOL)tableIsExistsWithName:(NSString *)tableName;

- (NSArray*)findReciteWordBookFromDBWithIDs:(NSArray *)ids withAllArges:(BOOL)allData;

- (BOOL)updateReciteWords:(NSArray *)words withTableName:(NSString *)tableName;
- (BOOL)insertWordPlandatawithData:(NSDictionary *)dict;
- (NSDictionary *)findWordPlandataNew;
- (BOOL)insertWordPlanDaydatawithData:(NSDictionary *)dict;
- (NSDictionary *)findWordPlanDaydataWtihBookID:(NSString *)bookID andDayStr:(NSString *)dayString;

//找到数据库全部数据内容
- (NSDictionary*)findReciteWordBookFromDBWithWord:(NSString *)wordStr withAllArges:(BOOL)allData;
//查出数据库单词分批
- (NSArray*)findDayLernWordBookFromBook:(NSString *)bookID withIndexID:(NSString *)startID;
//生成计划
- (void)createPlanDayWithInfo:(NSDictionary *)bookRem;

- (NSArray*)findDayLernWordCountTypeFromBook:(NSString *)bookID withType:(int )type;

@end
