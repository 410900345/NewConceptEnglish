//
//  BookReadDao.h
//  newIdea1.0
//
//  Created by jiuhao-yangshuo on 15/11/12.
//  Copyright © 2015年 xuGuohong. All rights reserved.
//

#import "DAO.h"

@interface BookReadDao : DAO

//阅读浏览记录
- (BOOL)writeBookReadToDB:(NSDictionary *)data;

//阅读数量
- (int)getReadBookCount;

- (NSArray *)getallBookReadDataWihtLove:(BOOL)isLvoe;

@end
