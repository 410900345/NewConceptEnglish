//
//  CommonHttpManager.m
//  newIdea1.0
//
//  Created by yangshuo on 16/2/2.
//  Copyright © 2016年 xuGuohong. All rights reserved.
//

#import "CommonHttpManager.h"

@implementation CommonHttpManager
+(BOOL)isWifiUse
{
    BOOL state = NO;
    NetWorkType type = [Common checkNetworkIsValidType];
    if(type == NetWorkType_WIFI)
    {
        state = YES;
    }
    return state;
}

+(ASIFormDataRequest *)fetchAsiRequestWithObejct:(NSObject *)object
{
    NSMutableArray *array = [g_winDic objectForKey:[NSString stringWithFormat:@"%x", (unsigned int)object]];
    ASIFormDataRequest *asi = nil;
    if (array.count)
    {
        asi = [array objectAtIndex:array.count-1];
    }
    return asi;
}

+ (void)cancelHtttpRequestWithObejct:(NSObject *)object
{
    NSString *add = [NSString stringWithFormat:@"%x", (unsigned int)object];
    NSMutableArray* array = [g_winDic objectForKey:add];
    for (ASIHTTPRequest* asi in array) {
        [asi clearDelegatesAndCancel];
    }
    [g_winDic removeObjectForKey:add];
}

@end
