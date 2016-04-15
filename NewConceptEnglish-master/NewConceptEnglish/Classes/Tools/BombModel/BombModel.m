//
//  BombModel.m
//  newIdea1.0
//
//  Created by jiuhao-yangshuo on 15/10/14.
//  Copyright © 2015年 xuGuohong. All rights reserved.
//

#import "BombModel.h"
@implementation BombModel

+(BmobQuery *)getBombModelWothName:(NSString *)name
{
    BmobQuery *query = [BmobQuery queryWithClassName:name];
    NetWorkType type = [Common checkNetworkIsValidType];
    if(type == NetWorkType_None)
    {
        query.cachePolicy = kBmobCachePolicyCacheElseNetwork;//缓存策略
    }
    else
    {
//        query.cachePolicy = kBmobCachePolicyCacheElseNetwork;//缓存策略
          query.cachePolicy = kBmobCachePolicyNetworkElseCache;//缓存策略
    }
    query.maxCacheAge = kCachenDays;
    return query;
}

//subKeyArray  key:array
+(NSMutableDictionary *)getDataFrom:(BmobObject *)obj withParam:(NSArray*)params withDict:(NSDictionary *)subKeyDict
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    NSArray *fixeDarray = @[@"objectId",@"updatedAt",@"createdAt"];//属性取值
    for (NSString* key in params) {
        //同一方法两个字段，一个加密一个不加密，判断
        id value = [obj objectForKey:key];
        if ([fixeDarray containsObject:key])
        {
             value  = [obj valueForKey:key];//通过属性名字获取里面的属性值
        }
        else if ([value isKindOfClass:[BmobFile class]])
        {
            value  = [(BmobFile *)value url];
        }
        else  if ([value isKindOfClass:[BmobObject class]])
        {
            NSArray *subKeyArray = subKeyDict[key];
            value = [[self class] getDataFrom:value withParam:subKeyArray withDict:nil];
        }
        else  if (IsNilOrNull(value))
        {
            if ([@"sex" isEqualToString:key])
            {
                value = @0;
            }
            else
                value = @"";
        }
        @try {
            [dict setObject:value forKey:key];
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
        
    }
    return dict;
}


+(void)updatePersonInfoWithStr:(id)str andKeyStr:(NSString *)keyStr withResultBlockBLock:(SXBombModelCallBackBlock)block
{
    if (!g_nowUserInfo.userid)
    {
        return;
    }
    BmobObject *bmobObject = [BmobObject objectWithoutDatatWithClassName:@"MyUser" objectId:g_nowUserInfo.userid];
    [bmobObject setObject:str forKey:keyStr];
    [bmobObject updateInBackgroundWithResultBlock:block];
}

@end
