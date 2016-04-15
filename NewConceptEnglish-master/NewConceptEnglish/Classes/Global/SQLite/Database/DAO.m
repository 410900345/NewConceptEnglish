//
//  DAO.m
//  SuningEBuy
//
//  Created by liukun on 12/6/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "DAO.h"
#import "DatabaseManager.h"
#import "GrammarDao.h"

@implementation DAO

@synthesize databaseQueue = _databaseQueue;

- (id)init{
    self = [super init];
    
	if(self)
    {
        
		self.databaseQueue = [DatabaseManager currentManager].databaseQueue;
	}
    
	return self;
}


- (FMDatabaseQueue *)databaseQueue
{
    if (![[DatabaseManager currentManager] isDatabaseOpened]) {
        [[DatabaseManager currentManager] openDataBase];
        self.databaseQueue = [DatabaseManager currentManager].databaseQueue;
        if (_databaseQueue)  [DAO createTablesNeeded];
    }
    return _databaseQueue;
}

+ (void)createTablesNeeded
{
    [GrammarDao movieGrammarDB];
    @autoreleasepool {
        FMDatabaseQueue *databaseQueue = [DatabaseManager currentManager].databaseQueue;
        
        [databaseQueue inTransaction:^(FMDatabase *database, BOOL *rollBack){
            
            //信息收集的表建立
            /*info_system*/
            NSString *sql1 = [NSString stringWithFormat:@"CREATE TABLE IF NOT exists newWord (id INTEGER PRIMARY KEY AUTOINCREMENT,pid INTEGER ,word varchar ,symbol varchar,explain text,score INTEGER DEFAULT 0,count INTEGER DEFAULT 0,delete_ INTEGER DEFAULT 0,add_ INTEGER DEFAULT 0,last_see long,storeDate long)"];
            
            /*info_useinfo*/
            NSString *sql2 = [NSString stringWithFormat:@"CREATE TABLE IF NOT exists wordBook (bookid INTEGER PRIMARY KEY AUTOINCREMENT,book_name varchar,create_time long,color_position INTEGER default -1)"];
            
            /*info_search*/
            NSString *sql3 = [NSString stringWithFormat:@"CREATE TABLE IF NOT exists tranbook (id INTEGER PRIMARY KEY AUTOINCREMENT,tran_text text,src text,desc text,create_time long)"];
            
            /*聊天和机器人*/
            NSString *sql4 = [NSString stringWithFormat:@"CREATE TABLE IF NOT exists chatRoom (id INTEGER PRIMARY KEY AUTOINCREMENT,fromSelf text,content text,contentDetail text,createTime long,chatType text)"];
            
            /*info_crash*/
            NSString *sql5 = [NSString stringWithFormat:@"CREATE TABLE IF NOT exists meiwen (id INTEGER PRIMARY KEY AUTOINCREMENT,date_ INTEGER,content_ text,title_ text,author_ text,create_time long)"];
            
            //浏览历史记录的表
            /*browsing_history*/
            NSString *sql6 = @"CREATE TABLE record_all (id integer PRIMARY KEY AUTOINCREMENT,bookId varchar,recordType integer,titleEn varchar,titleZh varchar,coverPic varchar,readCount varchar,netMp3Url varchar,netLrcurl varchar,duration integer,desc text,netLrcTextEn text,netLrcTextZh text,bookIndex integer,path text,pathEn text,updateTime integer)";
            
            /*search_history*/
            NSString *sql7 = @"CREATE TABLE IF NOT exists wrong_collect (id integer NOT NULL PRIMARY KEY AUTOINCREMENT,catid varchar,pubdate varchar,title text,cntitle text,explain text,option text,optionNum integer)";
            
            /*扫描历史记录*/
            NSString *sql8 = @"CREATE TABLE IF NOT exists diary_record (id INTEGER PRIMARY KEY AUTOINCREMENT,color_ INTEGER,content_ text,title_ text,create_time long)";
            
            // 每日一句。
            //dic_sendCount
            NSString  *sql9 = @"CREATE TABLE IF NOT exists word (id integer NOT NULL PRIMARY KEY AUTOINCREMENT,sid integer,title varchar,content text,note text,translation text,picture text,tts text)";
            
            //地址表
            /*dic_province*/
            NSString *sql10 = [NSString stringWithFormat:@"CREATE TABLE personal_all (id integer PRIMARY KEY AUTOINCREMENT,bookId varchar,recordType integer,titleEn varchar,titleZh varchar,coverPic varchar,readCount varchar,netMp3Url varchar,netLrcurl varchar,duration integer,desc text,netLrcTextEn text,netLrcTextZh text,bookIndex integer,pathtext,pathEn text,updateTime integer)"];
            
            /*dic_city*/
            NSString *sql11 = [NSString stringWithFormat:@"CREATE TABLE IF NOT exists write (id INTEGER PRIMARY KEY AUTOINCREMENT,level text,content_en text,content_zh text,title_en text,title_zh text,desc text,source text,create_time long)"];
            
            //来源渠道   渠道明细  商品编码  价格---二维码销售明细
            NSString *sql12 = [NSString stringWithFormat:@"CREATE TABLE IF NOT exists word_store (id integer NOT NULL PRIMARY KEY AUTOINCREMENT,sid integer,title varchar,contenttext,note text,translation text,picture text,tts text)"];
            //生词本
            NSString *sql13 = [NSString stringWithFormat:@"create table IF NOT EXISTS  wordList (id INTEGER PRIMARY KEY AUTOINCREMENT,word text UNIQUE)"];
            //学习记录表 self.itemBook ItemBookNumOne  po self.bookIndex 1_24
            NSString *sql14 = [NSString stringWithFormat:@"create table IF NOT EXISTS  bookRead (id INTEGER PRIMARY KEY AUTOINCREMENT,kBookTxt text UNIQUE,userId text,kBookIndexDocTxt text,kBookIndexTxt text,itemBook text,loveBook text,bookIndex text,add_dttm real)"];
            
            NSString *sql15 = [NSString stringWithFormat:@"CREATE TABLE word_review (word text, user_id text, update_time text, update_status text, proficiency text, right_num integer, wrong_num integer, interval_day integer, no_show integer,  next_review_time timestamp, latest_review_time date, pron text, trans text, study_time date, PRIMARY KEY(word, user_id))"];
            
            NSString *sql16 = [NSString stringWithFormat:@"CREATE TABLE word_looked (word text,  proficiency text, PRIMARY KEY(word))"];
            
            [database executeUpdate:sql1];
            [database executeUpdate:sql2];
            [database executeUpdate:sql3];
            [database executeUpdate:sql4];
            [database executeUpdate:sql5];
            [database executeUpdate:sql6];
            [database executeUpdate:sql7];
            [database executeUpdate:sql8];
            [database executeUpdate:sql9];
            [database executeUpdate:sql10];
            [database executeUpdate:sql11];
            [database executeUpdate:sql12];
            [database executeUpdate:sql13];
            [database executeUpdate:sql14];
            [database executeUpdate:sql15];
            [database executeUpdate:sql16];
        }];
        
    } 
}

- (NSArray *)getAllObjectsFromDBForSQL:(NSString*)sql getParam:(NSArray*)params
{
    __block NSMutableArray *array = nil;
    __block NSMutableDictionary* dic;
    __block NSString *sqlStr = sql;
    __block NSArray* newArray = params;
    [self.databaseQueue inDatabase:^(FMDatabase *db){
        FMResultSet *rs = [db executeQuery:sqlStr];
        if(!rs){
            [rs close];
            return ;
        }
        array = [[NSMutableArray alloc] init];
        int newArrayCount = newArray.count;
        NSString* value;
        while ([rs next]) {
            if(newArrayCount == 1){//过滤只有一个value为null的情况
                NSString *key = newArray[0];
                NSString *value = [rs stringForColumn:key];
                if(value.length == 0){
                    continue;
                }
            }
            dic = [NSMutableDictionary dictionary];
            for (NSString* key in newArray)
            {
                value = [rs stringForColumn:key];
                if(value)
                {
                    [dic setObject:value forKey:key];
                }else
                {
                    [dic setObject:@"" forKey:key];
                }
            }
            [array addObject:dic];
        }
        [rs close];
    }];
    return array;
}

@end