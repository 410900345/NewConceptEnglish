//
//  CommonDisease.m
//  jiuhaohealth4.0
//
//  Created by 徐国洪 on 15-5-24.
//  Copyright (c) 2015年 xuGuohong. All rights reserved.
//

#import "CommonUser.h"
#import "SFHFKeychainUtils.h"

static NSString *const  kIsAmEnglish= @"kIsAmEnglish";
@implementation CommonUser

+ (NSMutableArray*)getBloodSugarArray
{
    NSMutableArray *array = [NSMutableArray arrayWithArray:@[@"凌晨", @"早餐前",@"早餐后",@"午餐前",@"午餐后",@"晚餐前",@"晚餐后",@"睡前"]];
    return array;
}

+ (NSMutableArray*)getIntBloodSugarArray
{
    NSMutableArray *array = [NSMutableArray arrayWithArray:@[@"11", @"1",@"2",@"4",@"6",@"7",@"9",@"10"]];
    return array;
}

+ (NSString*)getBloodSugarType:(NSString*)str
{
    //    NSArray *array = @[早餐前, @"早餐后", @"", @"", @"", @"", @"", @"", @""]
    //凌晨:11 , 早餐前:1 , 早餐后:2 , 午餐前:4 , 午餐后:6 , 晚餐前:7 , 晚餐后:9 , 睡前:10 , 随机:12
    NSString *strValeu;
    switch ([str intValue]) {
        case 12:
            strValeu = @"随机";
            break;
        case 1:
            strValeu = @"早餐前";
            break;
        case 2:
        case 3:
            strValeu = @"早餐后";
            break;
        case 4:
            strValeu = @"午餐前";
            break;
        case 5:
        case 6:
            strValeu = @"午餐后";
            break;
        case 7:
            strValeu = @"晚餐前";
            break;
        case 8:
        case 9:
            strValeu = @"晚餐后";
            break;
        case 10:
            strValeu = @"睡前";
            break;
        case 11:
            strValeu = @"凌晨";
            break;
            
        default:
            break;
    }
    
    return strValeu;
}

+ (int)getBloodSugarIndexType:(NSString*)str
{
    //    NSArray *array = @[早餐前, @"早餐后", @"", @"", @"", @"", @"", @"", @""]
    //凌晨:11 , 早餐前:1 , 早餐后:2 , 午餐前:4 , 午餐后:6 , 晚餐前:7 , 晚餐后:9 , 睡前:10 , 随机:12
    int strValeu;
    if ([str isEqualToString:@"凌晨"]) {
        strValeu = 11;
    }
    else if ([str isEqualToString:@"早餐前"]) {
        strValeu = 1;
    }
    else if ([str isEqualToString:@"早餐后"]) {
        strValeu = 2;
    }
    else if ([str isEqualToString:@"午餐前"]) {
        strValeu = 4;
    }
    else if ([str isEqualToString:@"午餐后"]) {
        strValeu = 6;
    }
    else if ([str isEqualToString:@"晚餐前"]) {
        strValeu = 7;
    }
    else if ([str isEqualToString:@"晚餐后"]) {
        strValeu = 9;
    }
    else if ([str isEqualToString:@"睡前"]) {
        strValeu = 10;
    }
    else if ([str isEqualToString:@"随机"]) {
        strValeu = 12;
    }
    
    return strValeu;
}

+ (NSString*)getAfterTypeForTime:(NSString*)str
{
//    凌晨:11 , 早餐前:1 , 早餐后:2 , 午餐前:4 , 午餐后:6 , 晚餐前:7 , 晚餐后:9 , 睡前:10 , 随机:12
    NSArray *array = [NSArray arrayWithObjects:@"11", @"1", @"2", @"4", @"6", @"7", @"9", @"10", nil];
    int index = (int)[array indexOfObject:[NSString stringWithFormat:@"%@", str]];
    index = MIN((int)array.count-1, index+1);
    return [array objectAtIndex:index];
}

//根据预警设置颜色
+ (BOOL)setTextColor:(UILabel*)label :(NSString*)Contrast
{
    BOOL isHidden = YES;
    switch ([Contrast intValue]) {
        case 1:
            label.textColor = [CommonImage colorWithHexString:COLOR_FF5351];
            isHidden = NO;
            break;
        case 2:
            label.textColor = [CommonImage colorWithHexString:COLOR_BlUE];
            isHidden = YES;
            break;
            
        default:
            label.textColor = [CommonImage colorWithHexString:@"333333"];
            isHidden = YES;
            break;
    }
    //Contrast :1.高，2.正常，3.低
    return isHidden;
}

//根据预警设置颜色
+ (NSString*)setColorForWarningType:(NSString*)waning
{
    NSString *colorString = @"333333";
    
    if([waning intValue] == 1){//高
        colorString = COLOR_FF5351;
    }else if ([waning intValue] == 2){//低
        colorString = COLOR_BlUE;
    }
    return colorString;
}

+ (NSString*)getContentWithType:(NSString*)type
{
    int typeNum = [type intValue];
    NSString* typeString = nil;
    switch (typeNum) {
        case 2:
            typeString = @"血糖";
            break;
        case 3:
            typeString = @"心率";
            break;
        case 4:
            typeString = @"血压";
            break;
        case 5:
            typeString = @"体温";
            break;
        case 6:
            typeString = @"血氧";
            break;
        case 7:
            typeString = @"bmi";
            break;
        case 12:
            typeString = @"whr";
            break;
        case 10:
            typeString = @"心电";
            break;
        case 14:
            typeString = @"血脂";
            break;
        case 15:
            typeString = @"糖化血红蛋白";
            break;
        case 16:
            typeString = @"总胆固醇";
            break;
        case 17:
            typeString = @"甘油三酯";
            break;
        case 18:
            typeString = @"高胆固醇";
            break;
        case 19:
            typeString = @"低胆固醇";
            break;
            
        default:
            break;
    }
    return typeString;
}

//获取糖尿病类型
+ (NSMutableArray*)getBloodSugar
{
    NSMutableArray *array = [NSMutableArray arrayWithObjects:@"糖尿病前期(IFG+IGT)", @"Ⅱ型糖尿病", @"Ⅰ型糖尿病",@"妊娠糖尿病",@"无糖尿病",  nil];
    return array;
}

//获取家人关系
+ (NSMutableArray*)getFmalyRelationship
{
    NSMutableArray *array = [NSMutableArray arrayWithObjects:@"父母", @"配偶", @"子女",@"祖父母",@"其他",  nil];
    return array;
}

//获取糖尿病类型,数字编码为Key
+ (NSDictionary*)getBloodSugarDic1
{
    NSDictionary* dataDic = @{ @"3" : @"糖尿病前期(IFG+IGT)",
                               @"2" : @"Ⅱ型糖尿病",
                               @"1" : @"Ⅰ型糖尿病",
                               @"4" : @"妊娠糖尿病",
                               @"5" : @"无糖尿病"
                               };
    
    return dataDic;
}

//获取糖尿病类型,名称为Key
+ (NSString*)getSexStringWithSex:(NSString *)sex
{
    NSString *data = @"0";
    if ([sex isEqualToString:@"男"])
    {
        data = @"1";
    }
    return data;
}

+ (NSString*)getSex:(NSString*)str
{
    NSString *returnStr = @"女";//1 男 0女
    int sex = str.intValue;
    switch (sex)
    {
        case 0:
            returnStr = @"女";
            break;
        case 1:
            returnStr = @"男";
            break;
        default:
            break;
    }
    return returnStr;
}

//获取既往病史
+ (NSArray*)getuserInfoArray
{
    NSArray *subArray= @[@"avatar",@"nick",@"username",@"objectId",@"sex"];
    return subArray;
}

+ (NSString*)getRelationship:(NSString*)str
{
    NSString * type = nil;
    if ([str  isEqualToString:@"父母"]) {
        type = @"401";
    }else if ([str  isEqualToString:@"配偶"]) {
        type = @"402";
    }else if ([str  isEqualToString:@"子女"]) {
        type = @"403";
    }else if ([str  isEqualToString:@"祖父母"]) {
        type = @"404";
    }else if ([str  isEqualToString:@"其他"]) {
        type = @"400";
    }else{
        type = @"400";
    }
    return type;
}

+ (void)setUpSexImageView:(UIImageView *)view withSexString:(NSString *)sexString
{
    //性别(1:男；2:女)
    if (! sexString.intValue)
    {
        sexString = @"1";
    }
    UIImage *sexImge= nil;
    if (view)
    {
        if ([sexString intValue] == 0)
        {
            sexImge = [UIImage imageNamed:@"common.bundle/community/man.png"];
        }
        else
        {
             sexImge = [UIImage imageNamed:@"common.bundle/community/women.png"];
        }
        view.image = sexImge;
    }
}

//英音和美音切换
+ (BOOL)getCurrentEnlishStateIsAmEnglish
{
   NSString *number =  [[NSUserDefaults standardUserDefaults]objectForKey:kIsAmEnglish];
   return [number boolValue];
}

+ (void)saveCurrentEnlishStateWith:(BOOL)isAmEnglish
{
    NSString *number = @"0";
    if (isAmEnglish)
    {
        number = @"1";
    }
    [[NSUserDefaults standardUserDefaults] setObject:number forKey:kIsAmEnglish];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(BOOL)isLoginSuccess
{
    BOOL state = YES;
    if (!g_nowUserInfo.userid.length)
    {
//        [Common MBProgressTishi:@"请先登录!" forHeight:kDeviceHeight];
        state = NO;
    }
    return state;
}

+(BOOL)isVip
{
    return (g_nowUserInfo.vip == 1)?YES:NO;
}

/**
 *  获取保存的帐号
 *
 *  @return 帐号
 */
+ (NSString*)getUserName
{
    NSUserDefaults* userDefault = [NSUserDefaults standardUserDefaults];
    NSString* username = [userDefault objectForKey:@"username"];
    return username;
}

/**
 *  获取保存的密码
 *
 *  @return 密码
 */
+ (NSString*)getUserPswd
{
    NSUserDefaults* userDefault = [NSUserDefaults standardUserDefaults];
    NSString* username = [userDefault objectForKey:@"username"];
    NSString* userpswd = [SFHFKeychainUtils getPasswordForUsername:username andServiceName:BUNDLE_IDENTIFIER error:NULL];
    return userpswd;
}
@end
