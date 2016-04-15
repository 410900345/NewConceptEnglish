//
//  BombModel.h
//  newIdea1.0
//
//  Created by jiuhao-yangshuo on 15/10/14.
//  Copyright © 2015年 xuGuohong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BmobSDK/Bmob.h>

#define kCachenDays	3
#define kCachenMonthDays	30
#define kCachen3MonthDays	90
#define kCachen6MonthDays	180

typedef void (^SXBombModelCallBackBlock)(BOOL isSuccessful, NSError *error);

@interface BombModel : NSObject

//做一些通用的策略
+(BmobQuery *)getBombModelWothName:(NSString *)name;

/**
 *  获取数据
 *
 *  @param obj    元数据
 *  @param params 数据数组
 *
 *  @return 字典
 */
+(NSMutableDictionary *)getDataFrom:(BmobObject *)obj withParam:(NSArray*)params withDict:(NSDictionary *)subKeyArray;

+(void)updatePersonInfoWithStr:(id)str andKeyStr:(NSString *)keyStr withResultBlockBLock:(SXBombModelCallBackBlock)block;

@end
