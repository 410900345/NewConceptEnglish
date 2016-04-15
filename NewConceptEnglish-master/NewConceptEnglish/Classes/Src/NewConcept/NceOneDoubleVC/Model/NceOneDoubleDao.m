//
//  NceOneDoubleDao.m
//  newIdea1.0
//
//  Created by jiuhao-yangshuo on 16/3/30.
//  Copyright © 2016年 YangShuo. All rights reserved.
//

#import "NceOneDoubleDao.h"
#import "DBOperate.h"

@interface NceOneDoubleDao()

@property (nonatomic,strong) DBOperate *myDataBase;

@end

@implementation NceOneDoubleDao
@synthesize myDataBase;
-(id)init
{
    self = [super init];
    if (self)
    {
        myDataBase = [DBOperate shareInstance];
    }
    return self;
}

- (NSArray*)findAllNceOneDoubleBookFromDB
{
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM nce_content where bookid = '1'"];
    NSArray *medicinesArray = [myDataBase getDataForSQL:sql getParam:@[@"pnum",@"en",@"zh"] withDbName:kGrmmarDB];
    if (!medicinesArray.count)
    {
        medicinesArray = @[];
    }
    return medicinesArray;
}

@end
