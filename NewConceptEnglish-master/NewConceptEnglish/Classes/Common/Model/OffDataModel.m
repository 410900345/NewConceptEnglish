//
//  OffDataModel.m
//  newIdea1.0
//
//  Created by yangshuo on 15/12/31.
//  Copyright © 2015年 xuGuohong. All rights reserved.
//

#import "OffDataModel.h"
#import <objc/runtime.h>

@implementation OffDataModel

@synthesize wordInfo,wordVoice,speakingVoice,phonogramVoice,CTE46,recommendWord,backWordVoice;

+(OffDataModel *)fillDataWitOffDataString:(NSString *)offData
{
     NSArray *allArray = [offData componentsSeparatedByString:@"@"];//大分割
     NSArray *keyArray = @[@"wordVoice",@"speakingVoice",@"phonogramVoice",@"CTE46",
                           @"sentenceInfo",@"wordInfo",@"recommendWord",@"backWordVoice"];//大分割
    OffDataModel *model = [[OffDataModel alloc]init];
    
    for (int i=0 ;i < allArray.count; i++)
    {
        NSString *value = allArray[i];
        NSString *key = keyArray[i];
        [model setValue:value forKey:key];
    }
    return model;
}
@end
