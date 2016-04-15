//
//  UserInfoModel.m
//  jiuhaoHealth2.0.1
//
//  Created by 徐国洪 on 14-5-28.
//  Copyright (c) 2014年 徐国洪. All rights reserved.
//

#import "UserInfoModel.h"
//#import "Common.h"
#import "AppDelegate.h"
//#import "CommonSet.h"

@implementation UserInfoModel
/*
- (id)initWithDic:(NSDictionary*)dic
{
    self.userToken               = [Common isNULLString:[dic objectForKey:@"token"]];           //当前用户id
    return self;
}

//基本信息赋值
- (void)setMyBasicInformation:(NSDictionary*)dic
{
    //基本信息赋值
    self.nickName             = [Common isNULLString4:[dic objectForKey:@"nick"]];//用户名
    self.mobilePhone          = [Common isNULLString3:[dic objectForKey:@"mobilePhone"]];      //手机号
    self.totalunreadMsgCount  = [[dic objectForKey:@"totalunreadMsgCount"] intValue];//未读消息总数量
    self.birthday             = [Common isNULLString:[dic objectForKey:@"birthday"]];         //生日
    self.filePath             = [Common isNULLString:[dic objectForKey:@"avatar"]];         //用户头像地址
    self.email             = [Common isNULLString:[dic objectForKey:@"email"]];
    self.level             = [Common isNULLString:[dic objectForKey:@"level"]];
    self.sex                  = [NSString stringWithFormat:@"%@",[dic objectForKey:@"sex"] ];              //性别 0 男 1女
    self.isActive             = [Common isNULLString:[dic objectForKey:@"isactive"]] ;
    self.fraction             = 0;
    self.isfinishAanswerQuestion          = [Common isNULLString:[dic objectForKey:@"isfinishAanswerQuestion"]];
    self.status               = [[dic objectForKey:@"status"] intValue];           //状态
    self.identity             = [Common isNULLString:[dic objectForKey:@"identity"]];         //身份证
    self.isBind               = [[dic objectForKey:@"is_bind"] intValue];        //1绑定 ,0 未绑定
    self.userid  = [Common isNULLString:[dic objectForKey:@"objectId"]]; //用户编号
    self.username  = [Common isNULLString:[dic objectForKey:@"username"]]; //用户名字
    self.thirdLogin = NO;
    self.myWord = [Common isNULLString:[dic objectForKey:@"myword"]];
    self.weight = [[dic objectForKey:@"weight"] floatValue]; //体重 --- kg
    self.height = [[dic objectForKey:@"height"] floatValue]; //身高 --- cm
    self.maxSpeed = [[dic objectForKey:@"maxSpeed"] floatValue]; //最大速度 --- m/s
    self.learnLevel = [dic objectForKey:@"learnLevel"]; 

    self.vip = [[dic objectForKey:@"vip"] intValue]; //1 会员   0和其它非会员
    self.isPush = [dic[@"is_push"] boolValue];
    self.isBindEquipment = dic[@"is_bind_equipment"];
    self.check_code = [dic[@"vip_level"] intValue];//会员等级
    g_nowUserInfo.integral =0;
    g_nowUserInfo.money = @"0";

    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%f",[[dic objectForKey:@"step"] floatValue]/100] forKey:[NSString stringWithFormat:@"stepLength%@",[dic objectForKey:@"user_no"]]];
    [[NSUserDefaults standardUserDefaults] setObject:[dic objectForKey:@"weight"] forKey:[NSString stringWithFormat:@"weight%@",[dic objectForKey:@"user_no"]]];
    [[NSUserDefaults standardUserDefaults] setObject:[dic objectForKey:@"head_img"] forKey:[NSString stringWithFormat:@"%@_loadingImage",self.mobilePhone]];//头像缓存
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self performSelector:@selector(refreshStepLogicData) withObject:nil afterDelay:0.2];
    
    [CommonSet setCommonUserDay];
}

- (void)refreshStepLogicData
{
    AppDelegate *myAppDelegate = [Common getAppDelegate];
//    [myAppDelegate.stepCounterObj refreshData];
}


- (void)removeAllKeyValue
{
    self.birthday = nil;         //生日
    self.filePath = nil;         //用户头像地址
    self.userid = nil;           //当前用户id
    self.mobilePhone = nil;      //手机号
    self.nickName = nil;         //用户名
    self.isActive = nil;
    self.isfinishAanswerQuestion = nil;
    self.identity = nil;         //身份证
    self.userToken = nil;
    self.myWord = nil;
    self.sex = nil;
    self.money = nil;
    
}

+(NSArray *)fetchObjectUserInfoKeysArray
{
    NSArray *subArray= @[@"age",@"avatar",@"createdAt",@"email",@"myword",@"mobilePhone",
                         @"nick",@"objectId",@"updatedAt",@"userNo",@"username",
                         @"sex",@"grade",@"level",@"userNo",@"vip",@"openid",@"learnLevel"
                         ];
    return subArray;
}

- (void)dealloc
{
    [self removeAllKeyValue];
}
*/
@end
