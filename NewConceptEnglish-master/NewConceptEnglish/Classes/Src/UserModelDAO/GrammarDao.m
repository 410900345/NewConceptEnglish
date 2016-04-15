//
//  GrammarDao.m
//  newIdea1.0
//
//  Created by yangshuo on 16/1/25.
//  Copyright © 2016年 xuGuohong. All rights reserved.
//

#import "GrammarDao.h"
#import "AppUtil.h"
#import "DBOperate.h"

static NSString *const kGrmmarDBOrigel = @"times.ttf";
static NSString *const kArraysXML =@"arrays.json";

@interface GrammarDao ()<NSXMLParserDelegate>
{
    SXBasicBlock m_callBackBlock;
    NSDictionary *m_dictionary;
}
@end

@implementation GrammarDao
@synthesize myDataBase;

-(void)dealloc
{
    TT_RELEASE_SAFELY(m_callBackBlock);
}

//+ (instancetype)sharedInstance
//{
//    static id sharedInstance = nil;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        sharedInstance = [[self alloc] init];
//    });
//    return sharedInstance;
//}

-(id)init
{
    self = [super init];
    if (self)
    {
        myDataBase = [DBOperate shareInstance];
    }
    return self;
}

+(void)movieGrammarDB
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString * dbFile = [[AppUtil getDocPath] stringByAppendingPathComponent:kGrmmarDB];
    if(![fileManager fileExistsAtPath:dbFile])
    {
        NSError *error = nil;
        NSString *dbEmpty = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:kGrmmarDBOrigel];
        NSString * dbFileNew = [[AppUtil getDocPath]  stringByAppendingPathComponent:@"kGrmmarDB"];
        [fileManager copyItemAtPath:dbEmpty toPath:dbFileNew error:&error];
        [[NSFileManager defaultManager] removeItemAtPath:dbEmpty error:NULL];
        [AppUtil extZipResWithZipName:@"kGrmmarDB" withOldPath:[AppUtil getDocPath] withNewPath:[AppUtil getDocPath]];
    }
}

//基础语法内容
- (NSString*)findBasicGrmmarInfoWithWord:(NSString *)name;
{
    NSString *returnStr = @"";
    NSString *typeStr = [DecodingManager SXEncryptionWithStr:name];
    NSString *sql = [NSString stringWithFormat:@"SELECT _id,type,name,content FROM grammer_index WHERE  name like'%%%@%%' order by _id ASC LIMIT 1 ",typeStr];
    NSArray *medicinesArray = [myDataBase getDataForSQL:sql getParam:@[@"_id",@"type",@"name",@"content"] withDbName:kGrmmarDB];
    if (medicinesArray.count)
    {
        returnStr = [medicinesArray firstObject][@"content"];
    }
    return returnStr;
}

//基础语法内容
- (NSArray*)findWriteGrmmarInfoWithWordwithType:(GrammarDaoType)m_grammarDaoType;
{
    NSString *returnStr = @"";
    switch (m_grammarDaoType) {
        case GrammarDaoWriteType:
            returnStr = @"写作";
            break;
        case GrammarDaoFinderType:
            returnStr = @"讲义";
            break;
        default:
            break;
    }
    NSString *sql = [NSString stringWithFormat:@"SELECT _id,type,name,content FROM grammer_index WHERE  type like'%%%@%%' order by _id ASC ",returnStr];
    NSArray *medicinesArray = [myDataBase getDataForSQL:sql getParam:@[@"_id",@"type",@"name",@"content"] withDbName:kGrmmarDB];
    if (!medicinesArray.count)
    {
        medicinesArray = @[];
    }
    return medicinesArray;
}

- (void)parserGrammarJsonWithSXblock:(SXBasicBlock)block withType:(GrammarDaoType)m_grammarDaoType
{
//    m_callBackBlock = nil;
//    m_callBackBlock = [block copy];
//    
//    if (!m_dictionary.count)
//    {
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//            m_dictionary = [Common getMainBundlePathFileWithName:kArraysXML];
//            [self fetchDataArrayWtihDict:m_dictionary withType:m_grammarDaoType];
//        });
//    }
//    else
//    {
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//            [self fetchDataArrayWtihDict:m_dictionary withType:m_grammarDaoType];
//        });
//    }
}

/*
-(void)fetchDataArrayWtihDict:(NSDictionary *)dict withType:(GrammarDaoType)m_grammarDaoType
{
    __block  NSMutableArray *basicArray = nil;
    basicArray = [[NSMutableArray alloc] init];
    switch (m_grammarDaoType) {
        case GrammarDaoBasicType:
        {
            NSArray *titleArray = m_dictionary[@"father_title"];
            for (int i = 0; i<titleArray.count; i++)
            {
                BaicGrammerModel *model = [[BaicGrammerModel alloc] init];
                model.title = titleArray[i];
                NSString *childStr = [@"child_" stringByAppendingFormat:@"%02d",i+1];
                model.contentArray = m_dictionary[childStr];
                [basicArray addObject:model];
            }
        }
            break;
        case GrammarDaoWriteType:
        {
            NSArray *titleArray = m_dictionary[@"father_title"];
            for (int i = 0; i<titleArray.count; i++)
            {
                BaicGrammerModel *model = [[BaicGrammerModel alloc] init];
                model.title = titleArray[i];
                NSString *childStr = [@"child_" stringByAppendingFormat:@"%02d",i+1];
                model.contentArray = m_dictionary[childStr];
                [basicArray addObject:model];
            }
        }
            break;
        default:
            break;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (m_callBackBlock)
        {
            m_callBackBlock(basicArray);
        }
    });
}
*/

+ (NSString *)getDecodeStrTrue:(NSString *)str
{
    return [DecodingManager SXdecryptionWithStr:str];
}

#pragma mark - question
- (NSArray*)findExamDataWithWordTitle
{
    FMDatabase* db = [self.myDataBase getLocalGrammerDB];
    NSString *sql = [NSString stringWithFormat:@"SELECT distinct(_type) FROM grammer_exam"];
    FMResultSet * rs = [db executeQuery:sql];//, g_nowUserInfo.userid, 0];
    NSMutableArray* data = [[NSMutableArray alloc] init];
    NSMutableDictionary* dic;
    NSString *keyStr = @"_type";
    while ([rs next]) {
        dic = [NSMutableDictionary dictionary];
        NSString *value = [rs stringForColumn:keyStr];
        if(value.length){
            [dic setObject:value forKey:keyStr];
        }else{
            [dic setObject:@"" forKey:keyStr];
        }
        [data addObject:dic];
    }
    [db close];
    return data;
}

@end
