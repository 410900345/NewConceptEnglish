//
//  CommonDate.m
//  jiuhaohealth4.0
//
//  Created by 徐国洪 on 15-5-24.
//  Copyright (c) 2015年 xuGuohong. All rights reserved.
//

#import "CommonDate.h"
#import "UMOpenMacros.h"

@implementation CommonDate

//按照生日得年龄
+ (NSString*)getAgeWithBirthday:(NSString*)birthday
{
    NSDate* currentDate = [NSDate date];
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* components = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:currentDate];
    int currentYear = (int)[components year];
    
    int birthYear;
    if (birthday.length > 5) {
        birthYear = (int)[[birthday substringToIndex:4] integerValue];
        //更新年龄
        return [NSString stringWithFormat:@"%d", currentYear - birthYear];
    } else {
        //更新年龄
        return [NSString stringWithFormat:NSLocalizedString(@"未知", nil)];
    }
}

+ (NSString*)formatCreatetTime:(NSDate*)time
{
    if ((NSNull*)time == [NSNull null]) {
        return @"";
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    //    formateDate
    NSString *dateString = [formatter stringFromDate:time];
    [formatter release];
    return dateString;
}

+ (NSString*)formatCreatetTimeTwo:(NSDate*)time
{
    if ((NSNull*)time == [NSNull null]) {
        return @"";
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //    formateDate
    NSString *dateString = [formatter stringFromDate:time];
    [formatter release];
    return dateString;
}

+ (NSDate*)convertDateFromString:(NSString*)uiDate
{
    if (![uiDate rangeOfString:@":"].length) {
        uiDate = [uiDate stringByAppendingString:@" 00:00:00"];
    }
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate* date = [formatter dateFromString:uiDate];
    [formatter release];
    return date;
}

+ (int)getMonthDay:(NSDate*)date
{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd"];
    NSString* currentDateStr = [dateFormatter stringFromDate:date];
    [dateFormatter release];
    return [currentDateStr intValue];
}

+ (int)getMonth:(NSDate*)date
{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"M"];
    NSString* currentDateStr = [dateFormatter stringFromDate:date];
    [dateFormatter release];
    return [currentDateStr intValue];
}

//服务器返回时间戳进行转换
+ (NSString*)getServerTime:(long long)timeLine type:(int)type
{
    NSString *time1 = [NSString stringWithFormat:@"%lld", timeLine];
    if (time1.length>10) {
        timeLine = [[time1 substringToIndex:10] longLongValue];
    }
    NSTimeInterval time = timeLine;
    NSDate* detaildate = [NSDate dateWithTimeIntervalSince1970:time];
    //NSLog(@"date:%@",[detaildate description]);
    //转换为当前时区时间，这里好像没用，在上面的即时时间获取可以用到，转换时差
    //    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    //    NSInteger interval = [zone secondsFromGMTForDate: detaildate];
    //    NSDate *localeDate = [detaildate  dateByAddingTimeInterval: interval];
    // NSLog(@"before:%@\nTimeNow:%@",detaildate,localeDate);
    
    //设定时间格式,这里可以设置成自己需要的格式为：2010-10-27 10:22
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    NSString* currentDateStr = nil;
    
    switch (type) {
        case 1:
            [dateFormatter setDateFormat:@"HH:mm"];
            currentDateStr = [dateFormatter stringFromDate:detaildate];
            [dateFormatter release];
            break;
        case 2:
            [dateFormatter setDateFormat:@"MM月dd号"];
            currentDateStr = [dateFormatter stringFromDate:detaildate];
            [dateFormatter release];
            break;
        case 3:
            [dateFormatter setDateFormat:@"MM-dd HH:mm"];
            currentDateStr = [dateFormatter stringFromDate:detaildate];
            [dateFormatter release];
            break;
        case 4:
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            currentDateStr = [dateFormatter stringFromDate:detaildate];
            [dateFormatter release];
            break;
        case 5:
            [dateFormatter setAMSymbol:@"上午"];
            [dateFormatter setPMSymbol:@"下午"];
            [dateFormatter setDateFormat:@"MM月dd日,EEE aHH:mm"];
            currentDateStr = [dateFormatter stringFromDate:detaildate];
            [dateFormatter release];
            break;
        case 6:
            [dateFormatter setDateFormat:@"yyyy年MM月"];
            currentDateStr = [dateFormatter stringFromDate:detaildate];
            [dateFormatter release];
            break;
        case 7:
            [dateFormatter setDateFormat:@"dd"];
            currentDateStr = [dateFormatter stringFromDate:detaildate];
            [dateFormatter release];
            break;
        case 8:
            [dateFormatter setDateFormat:@"yyyy.MM.dd"];
            currentDateStr = [dateFormatter stringFromDate:detaildate];
            [dateFormatter release];
            break;
        case 9:
            [dateFormatter setDateFormat:@"yyyy.MM.dd HH:mm"];
            currentDateStr = [dateFormatter stringFromDate:detaildate];
            [dateFormatter release];
            break;
        case 10:
            [dateFormatter setDateFormat:@"yyyy年MM月dd日 HH:mm"];
            currentDateStr = [dateFormatter stringFromDate:detaildate];
            [dateFormatter release];
            break;
        case 11:
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
            currentDateStr = [dateFormatter stringFromDate:detaildate];
            [dateFormatter release];
            break;
        case 13:
            [dateFormatter setDateFormat:@"MM-dd"];
            currentDateStr = [dateFormatter stringFromDate:detaildate];
            [dateFormatter release];
            break;
        case 12:
            [dateFormatter setDateFormat:@"yyyy/MM/dd HH:mm"];
            currentDateStr = [dateFormatter stringFromDate:detaildate];
            [dateFormatter release];
            break;
        default:
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            currentDateStr = [dateFormatter stringFromDate:detaildate];
            [dateFormatter release];
            break;
    }
    return currentDateStr;
}

+ (NSMutableDictionary*)getYearMonthDay:(NSDate*)date
{
    NSDateFormatter* formatter = [[[NSDateFormatter alloc] init] autorelease];
    //    NSDate *date = [NSDate date];
    [formatter setTimeStyle:NSDateFormatterMediumStyle];
    NSCalendar* calendar = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] autorelease];
    NSDateComponents* comps = nil;
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | kCFCalendarUnitWeek;
    
    comps = [calendar components:unitFlags fromDate:date];
    
    NSArray* arrayKey = [NSArray arrayWithObjects:@"year", @"month", @"day", nil];
    NSArray* arrayValue = [NSArray arrayWithObjects:[NSNumber numberWithLong:comps.year], [NSNumber numberWithLong:comps.month], [NSNumber numberWithLong:comps.day], nil];
    NSMutableDictionary* dic = [NSMutableDictionary dictionaryWithObjects:arrayValue forKeys:arrayKey];
    
    return dic;
}

//获得当前时间
+ (long)getLongTime
{
    NSDate* now = [NSDate date];
    //    NSLog(@"%@",now);
    unsigned long test = (long)[now timeIntervalSince1970];
    return test;
}

//获得当前时间
+ (long long)getLonglongTime
{
    NSDate* now = [NSDate date];
    long long test = (long long)([now timeIntervalSince1970]*1000);
    return test;
}

#pragma mark time
+ (NSString*)getLongTimeWithDate:(NSString*)dateString
{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss +0000"];
    NSDate* date = [dateFormatter dateFromString:dateString];
    [dateFormatter release];
    unsigned long long test = (long long)[date timeIntervalSince1970];
    NSString* returnString = [NSString stringWithFormat:@"%llu", test * 1000];
    return returnString;
}

#pragma mark time
+ (unsigned long)getLongTimeWithDate1:(NSString*)dateString
{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss +0000"];
    NSDate* date = [dateFormatter dateFromString:dateString];
    [dateFormatter release];
    unsigned long test = (unsigned long)[date timeIntervalSince1970];
    return test;
}

// 获得当前时间前numDay天的日期
+ (NSDate*)offsetDay:(int)numDay
{
    NSTimeInterval secondsPerDay = numDay * 24 * 60 * 60;
    
    NSDate* yesterday;
    
    yesterday = [[NSDate date] dateByAddingTimeInterval:secondsPerDay];
    
    return yesterday;
}

+ (BOOL)isCurrentDay:(NSString *)aDate
{
    if (aDate==nil || ![aDate isKindOfClass:[NSString class]]) return NO;
    aDate = [aDate substringToIndex:10];
    NSDate * bdate =  [CommonDate convertDateFromString:aDate];
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:(NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit) fromDate:[NSDate date]];
    NSDate *today = [cal dateFromComponents:components];
    components = [cal components:(NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit) fromDate:bdate];
    NSDate *otherDate = [cal dateFromComponents:components];
    if([today isEqualToDate:otherDate]){
        return YES;
    }
    return NO;
}

+ (BOOL)isTheSameData:(long)timeLine1 :(long)timeLine2
{
    NSDate* detaildate1 = [NSDate dateWithTimeIntervalSince1970:timeLine1];
    NSDate* detaildate2 = [NSDate dateWithTimeIntervalSince1970:timeLine2];
    
    NSCalendar* calendar = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] autorelease];
    NSDateComponents* comps1 = nil;
    NSDateComponents* comps2 = nil;
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
    
    comps1 = [calendar components:unitFlags fromDate:detaildate1];
    comps2 = [calendar components:unitFlags fromDate:detaildate2];
    
    if ([comps1 year] == [comps2 year] && [comps1 month] == [comps2 month] && [comps1 day] == [comps2 day]) {
        return YES;
    } else {
        return FALSE;
    }
}

//服务器返回时间进行转换
+ (NSString*)getServerTimeForStr:(NSString*)dateString type:(int)type
{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss +0000"];
//    NSDate* detaildate = [dateFormatter dateFromString:dateString];
    NSDate* detaildate = dateString;
    NSString* currentDateStr = nil;
    
    switch (type) {
        case 1:
            [dateFormatter setDateFormat:@"HH:mm"];
            currentDateStr = [dateFormatter stringFromDate:detaildate];
            [dateFormatter release];
            break;
        case 2:
            [dateFormatter setDateFormat:@"MM月dd号"];
            currentDateStr = [dateFormatter stringFromDate:detaildate];
            [dateFormatter release];
            break;
        case 3:
            [dateFormatter setDateFormat:@"MM-dd HH:mm"];
            currentDateStr = [dateFormatter stringFromDate:detaildate];
            [dateFormatter release];
            break;
        case 4:
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            currentDateStr = [dateFormatter stringFromDate:detaildate];
            [dateFormatter release];
            break;
        case 5:
            [dateFormatter setAMSymbol:@"上午"];
            [dateFormatter setPMSymbol:@"下午"];
            [dateFormatter setDateFormat:@"MM月dd日,EEE aHH:mm"];
            currentDateStr = [dateFormatter stringFromDate:detaildate];
            [dateFormatter release];
            break;
        case 6:
            [dateFormatter setDateFormat:@"yyyy年MM月"];
            currentDateStr = [dateFormatter stringFromDate:detaildate];
            [dateFormatter release];
            break;
        case 7:
            [dateFormatter setDateFormat:@"dd"];
            currentDateStr = [dateFormatter stringFromDate:detaildate];
            [dateFormatter release];
            break;
        case 8:
            [dateFormatter setDateFormat:@"yyyy.MM.dd"];
            currentDateStr = [dateFormatter stringFromDate:detaildate];
            [dateFormatter release];
            break;
        case 9:
            [dateFormatter setDateFormat:@"yyyy.MM.dd HH:mm"];
            currentDateStr = [dateFormatter stringFromDate:detaildate];
            [dateFormatter release];
            break;
        case 10:
            [dateFormatter setDateFormat:@"yyyy年MM月dd日 HH:mm"];
            currentDateStr = [dateFormatter stringFromDate:detaildate];
            [dateFormatter release];
            break;
        case 11:
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
            currentDateStr = [dateFormatter stringFromDate:detaildate];
            [dateFormatter release];
            break;
        case 13:
            [dateFormatter setDateFormat:@"MM-dd"];
            currentDateStr = [dateFormatter stringFromDate:detaildate];
            [dateFormatter release];
            break;
        case 12:
            [dateFormatter setDateFormat:@"yyyy/MM/dd HH:mm"];
            currentDateStr = [dateFormatter stringFromDate:detaildate];
            [dateFormatter release];
            break;
        default:
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            currentDateStr = [dateFormatter stringFromDate:detaildate];
            [dateFormatter release];
            break;
    }
    return currentDateStr;
}

//获取当前时间
+ (NSString *)getCurrentDayStr
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSString *dateString = [formatter stringFromDate:[NSDate date]];
    [formatter release];
    return dateString;
}

+ (NSString *)setTimeWithDate:(NSDate*)timeStr
{
    NSString *flagTime = [[self class] humanableInfoFromDate:timeStr];
    
//    NSCalendar *myCalendar = [NSCalendar currentCalendar];
//    // 当前日期
//    unsigned int unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
//    
//    long long timeLong = [timeStr timeIntervalSince1970];
//    NSString *timeString = [CommonDate getServerTime:timeLong type:4];
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    [formatter setDateFormat:@"yyyy-MM-dd"];
//    NSDate *selectDate = [formatter dateFromString:timeString];
//    NSString *curuunet = [formatter stringFromDate: [NSDate date]]; //统一时间点
//    NSDate *currentDate = [formatter dateFromString:curuunet];
//    [formatter release];
//    
//    NSDateComponents *comps = [myCalendar components:unitFlags fromDate:currentDate toDate:selectDate options:0];
//    int diff = (int)comps.day;
//    
//    if (diff==0) {
//        flagTime = [CommonDate  getServerTime:timeLong type:1];
//    } else if (diff==-2) {
//        flagTime = @"前天";
//    } else if (diff==-1) {
//        flagTime = @"昨天";
//    } else {
//        flagTime = timeString;
//    }
    
    return flagTime;
}


+ (NSString *)humanableInfoFromDate: (NSDate *) theDate
{
    NSString *info;
    
    NSTimeInterval delta = - [theDate timeIntervalSinceNow];
    if (delta < 60) {
        // 1分钟之内
        info = UM_Local(@"Just now");
    } else {
        delta = delta / 60;
        if (delta < 60) {
            // n分钟前
            info = [NSString stringWithFormat:UM_Local(@"%d minutes ago"), (NSUInteger)delta];
        } else {
            delta = delta / 60;
            if (delta < 24) {
                // n小时前
                info = [NSString stringWithFormat:UM_Local(@"%d hours ago"), (NSUInteger)delta];
            } else {
                delta = delta / 24;
                if ((NSInteger)delta == 1) {
                    //昨天
                    info = UM_Local(@"Yesterday");
                } else if ((NSInteger)delta == 2) {
                    info = UM_Local(@"The day before yesterday");
                } else {
                    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
                    info = [dateFormatter stringFromDate:theDate];
                    //                    info = [NSString stringWithFormat:@"%d天前", (NSUInteger)delta];
                }
            }
        }
    }
    return info;
}
@end
