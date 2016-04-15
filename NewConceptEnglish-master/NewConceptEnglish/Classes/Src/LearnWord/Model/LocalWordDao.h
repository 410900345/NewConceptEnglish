//
//  LocalWordDao.h
//  newIdea1.0
//
//  Created by jiuhao-yangshuo on 15/12/10.
//  Copyright © 2015年 xuGuohong. All rights reserved.
//

#import "DAO.h"
#import "DBOperate.h"

static NSString *const kFindLocalWordMp3 = @"kFindLocalWordMp3";
@interface LocalWordDao : NSObject

- (NSArray*)findWordInfoWithWord:(NSString *)word;

- (NSArray*)findWordSentenceInfoWithWord:(NSString *)word;

@end
