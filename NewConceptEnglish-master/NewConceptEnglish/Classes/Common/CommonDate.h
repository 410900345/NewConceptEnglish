//
//  CommonDate.h
//  jiuhaohealth4.0
//
//  Created by 徐国洪 on 15-5-24.
//  Copyright (c) 2015年 xuGuohong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommonDate : NSObject

//按照生日得年龄
+ (NSString*)getAgeWithBirthday:(NSString*)birthday;

+ (NSString*)formatCreatetTime:(NSDate*)time;

+ (NSString*)formatCreatetTimeTwo:(NSDate*)time;

+ (NSDate*)convertDateFromString:(NSString*)uiDate;

+ (int)getMonthDay:(NSDate*)date;

+ (int)getMonth:(NSDate*)date;

//服务器返回时间戳进行转换
+ (NSString*)getServerTime:(long long)timeLine type:(int)type;

+ (NSMutableDictionary*)getYearMonthDay:(NSDate*)date;

//获得当前时间
+ (long)getLongTime;

//获得当前时间
+ (long long)getLonglongTime;

#pragma mark time
+ (NSString*)getLongTimeWithDate:(NSString*)dateString;

#pragma mark time
+ (unsigned long)getLongTimeWithDate1:(NSString*)dateString;

// 获得当前时间前numDay天的日期
+ (NSDate*)offsetDay:(int)numDay;

//判段aDate是否为今天
+ (BOOL)isCurrentDay:(NSString *)aDate;

//两个时间是否一样
+ (BOOL)isTheSameData:(long)timeLine1 :(long)timeLine2;

//服务器返回时间进行转换
+ (NSString*)getServerTimeForStr:(NSString*)dateString type:(int)type;

//获取当前时间
+ (NSString *)getCurrentDayStr;

//今天,昨天,明天
+ (NSString *)setTimeWithDate:(NSDate*)timeDate;

//今天,昨天,明天
+ (NSString *)humanableInfoFromDate: (NSDate *) theDate;

@end
