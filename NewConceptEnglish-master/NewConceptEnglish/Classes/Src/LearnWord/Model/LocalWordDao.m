//
//  LocalWordDao.m
//  newIdea1.0
//
//  Created by jiuhao-yangshuo on 15/12/10.
//  Copyright © 2015年 xuGuohong. All rights reserved.
//

#import "LocalWordDao.h"


@implementation LocalWordDao
{
      DBOperate *myDataBase;
}

-(id)init
{
    self = [super init];
    if (self)
    {
            myDataBase = [DBOperate shareInstance];
    }
    return self;
}

- (NSArray*)findWordInfoWithWord:(NSString *)word
{
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM wordinfo WHERE word = '%@' order by word_id ASC LIMIT 1 COLLATE NOCASE",[word lowercaseString]];
    NSArray *medicinesArray = [myDataBase getDataForSQL:sql getParam:@[@"word_id",@"word",@"spell",@"meaning",@"spell_us"] withDbName:kWordDb];
    return medicinesArray ;
}

- (NSArray*)findWordSentenceInfoWithWord:(NSString *)word
{
    NSString *sqlTwo = [NSString stringWithFormat:@"SELECT * FROM sentence WHERE english like '%%%@%%' order by sentence_id ASC LIMIT 3 COLLATE NOCASE",[word lowercaseString]];
    NSArray *m_sentenceArray = [myDataBase getDataForSQL:sqlTwo getParam:@[@"sentence_id",@"english",@"chinese"] withDbName:kSentenceDb];
    return m_sentenceArray ;
}
@end
