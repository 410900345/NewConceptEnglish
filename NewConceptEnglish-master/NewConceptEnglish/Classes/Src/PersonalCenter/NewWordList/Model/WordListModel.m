//
//  WordListModel.m
//  newIdea1.0
//
//  Created by jiuhao-yangshuo on 16/3/29.
//  Copyright © 2016年 YangShuo. All rights reserved.
//

#import "WordListModel.h"

@implementation WordListModel
+ (NSDictionary *)modelCustomPropertyMapper
{
    return @{@"wordListId" : @"id"};
}

+(instancetype)fillModelWithWord:(NSString *)word andSymbol:(NSString *)symbol andExplain:(NSString *)explain
{
    WordListModel *model = [[self alloc] init];
    model.word = word;
    model.symbol = symbol;
    model.explain = explain;
    return model;
}
@end
