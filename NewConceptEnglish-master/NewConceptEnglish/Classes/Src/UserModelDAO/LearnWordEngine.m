//
//  LearnWordEngine.m
//  newIdea1.0
//
//  Created by jiuhao-yangshuo on 16/3/14.
//  Copyright © 2016年 xuGuohong. All rights reserved.
//

#import "LearnWordEngine.h"
#import "DecodingManager.h"

static NSString *const errorSr = @"AcDaJxi92CQ=";
@implementation LearnWordEngine

+ (instancetype)sharedInstance
{
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

+(void)decContentWithKey:(NSString *)key andWithDict:(NSMutableDictionary *)currentDict
{
    NSString *wordZh = currentDict[key];
    NSString *decString = [DecodingManager SXdecryptionWithStr:wordZh];
    if (decString.length)
    {
        [currentDict setObject:decString forKey:key];
//        if ([decString containsString:errorSr])
//        {
//            [currentDict removeObjectForKey:key];
//        }
    }
    else
    {
        [currentDict removeObjectForKey:key];
    }
}
@end
