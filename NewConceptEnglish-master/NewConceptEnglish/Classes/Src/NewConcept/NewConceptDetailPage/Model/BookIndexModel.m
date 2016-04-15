//
//  BookIndexModel.m
//  newIdea1.0
//
//  Created by jiuhao-yangshuo on 16/1/5.
//  Copyright © 2016年 xuGuohong. All rights reserved.
//

#import "BookIndexModel.h"

@implementation BookIndexModel

@synthesize bookIndexModelArray,bookModelIndex;

@synthesize m_playerModelType;

+(NSArray *)fetchPlayerModelTitleArray
{
    NSArray *titleArray = @[@"仅播一次",@"单曲循环",@"顺序播放",@"随机播放",@"列表循环"];
    return titleArray;
}

+(NSString *)fetchPlayerModelTitleWithPlayerModelType:(PlayerModelType)type
{
    NSArray *titleArray = [BookIndexModel fetchPlayerModelTitleArray];
    NSInteger typeIndex = MIN(titleArray.count -1, type);
    NSString *title = titleArray[typeIndex];
    return title;
}

+(NSString *)fetchPlayerModelPlayViewTitleWithPlayerModelType:(PlayerModelType)type
{
    NSArray *titleArray = @[@"一次",@"单曲",@"顺序",@"随机",@"列表"];
    NSInteger typeIndex = MIN(titleArray.count -1, type);
    NSString *title = titleArray[typeIndex];
    return title;
}
@end
