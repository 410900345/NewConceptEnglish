//
//  WordList.h
//  newIdea1.0
//
//  Created by jiuhao-yangshuo on 15/11/9.
//  Copyright © 2015年 xuGuohong. All rights reserved.
//

#import "DAO.h"
#import "WordListModel.h"

static NSString * const kDefautWordBook = @"默认生词本";

@interface WordList : DAO

- (NSMutableArray *)getWordsLsit;

-(BOOL)deleteWordStr:(NSString *)word;

-(BOOL )handleExsitWithSqlite:(NSString *)sqlite;

-(void)crateWorBookWithName:(NSString *)bookName;

-(NSMutableArray*)fetchWorBookListsData;

-(BOOL)haveBookName:(NSString *)bookName;

-(BOOL)deleteWordBookBookID:(NSString *)bookid;

-(void)renameWordBookWithBookID:(NSString *)bookid withNewName:(NSString *)name;
//某一本书的详情
- (NSDictionary *)fetchWorBookListsDataWithBookName:(NSString *)bookName;

//book
-(void)updateWordBookDateWithBookID:(NSString *)bookid;

-(NSMutableArray*)fetchWordsDataFromBookWithBookId:(NSString *)bookid;
//有数据
-(BOOL)haveWord:(NSString *)word inBookID:(NSString *)bookID;
//插入数据
-(void)insertBookWithWordListModel:(WordListModel *)wordModel;

//获取单词总数
-(int)fetchLocalNewBookWordCountWithBookID:(NSString *)bookID;

//默认的词库
+(void)createDefaultNewBook;

//删除单词
-(BOOL)deleteNewWordStr:(NSString *)word inBookID:(NSString *)bookID;

@end
