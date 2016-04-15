//
//  GrammarDao.h
//  newIdea1.0
//
//  Created by yangshuo on 16/1/25.
//  Copyright © 2016年 xuGuohong. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "BaicGrammerModel.h"
@class  DBOperate;

typedef enum : NSUInteger {
    GrammarDaoBasicType = 0,
    GrammarDaoWriteType,
    GrammarDaoFinderType
} GrammarDaoType;

@interface GrammarDao : NSObject

@property (nonatomic,strong) DBOperate *myDataBase;

+(void)movieGrammarDB;

//基础语法内容
- (NSString*)findBasicGrmmarInfoWithWord:(NSString *)name;

- (void)parserGrammarJsonWithSXblock:(SXBasicBlock )block withType:(GrammarDaoType )m_grammarDaoType;

//基础.写作.讲义
- (NSArray*)findWriteGrmmarInfoWithWordwithType:(GrammarDaoType)m_grammarDaoType;
//解密数据
+ (NSString *)getDecodeStrTrue:(NSString *)str;


- (NSArray*)findExamDataWithWordTitle;
@end
