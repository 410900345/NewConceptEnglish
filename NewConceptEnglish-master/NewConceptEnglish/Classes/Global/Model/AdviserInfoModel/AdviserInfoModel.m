//
//  AdviserInfoModel.m
//  jiuhaoHealth2.0.1
//
//  Created by 徐国洪 on 14-5-28.
//  Copyright (c) 2014年 徐国洪. All rights reserved.
//

#import "AdviserInfoModel.h"
//#import "Common.h"

@implementation AdviserInfoModel

- (id)initWithDic:(NSDictionary*)dic
{
//    self.accountId = [Common isNULLString:[dic objectForKey:@"accountId"]];
//    self.age = [Common isNULLString:[dic objectForKey:@"age"]];
//    self.begood = [Common isNULLString:[dic objectForKey:@"begood"]];
//    self.bloodType = [Common isNULLString:[dic objectForKey:@"bloodType"]];
//    self.briefIntroduction = [Common isNULLString:[dic objectForKey:@"briefIntroduction"]];
//    self.census = [Common isNULLString:[dic objectForKey:@"census"]];
//    self.changResidence = [Common isNULLString:[dic objectForKey:@"changResidence"]];
//    self.city = [Common isNULLString:[dic objectForKey:@"city"]];
//    self.consultantId = [Common isNULLString:[dic objectForKey:@"consultantId"]];
//    self.createTime = [Common isNULLString:[dic objectForKey:@"createTime"]];
//    self.createUser = [Common isNULLString:[dic objectForKey:@"createUser"]];
//    self.deletetype = [Common isNULLString:[dic objectForKey:@"deletetype"]];
//    self.email = [Common isNULLString:[dic objectForKey:@"email"]];
//    self.fixedPhone = [Common isNULLString:[dic objectForKey:@"fixedPhone"]];
//    self.fullName = [Common isNULLString:[dic objectForKey:@"fullName"]];
//    self.hospitalNo = [Common isNULLString:[dic objectForKey:@"hospitalNo"]];
//    self.adviserId = [Common isNULLString3:[dic objectForKey:@"id"]];
//    self.idNumber = [Common isNULLString:[dic objectForKey:@"idNumber"]];
//    self.informaticsCertificate = [Common isNULLString:[dic objectForKey:@"informaticsCertificate"]];
//    self.informaticsTime = [Common isNULLString:[dic objectForKey:@"informaticsTime"]];
//    self.level = [Common isNULLString:[dic objectForKey:@"level"]];
//    self.grade = ![[dic objectForKey:@"grade"] intValue]?5:([[dic objectForKey:@"grade"] intValue]);
//    self.marriage = [Common isNULLString:[dic objectForKey:@"marriage"]];
//    self.microChannel = [Common isNULLString:[dic objectForKey:@"microChannel"]];
//    self.nation = [Common isNULLString:[dic objectForKey:@"nation"]];
//    self.nature = [Common isNULLString:[dic objectForKey:@"nature"]];
//    self.nickname = [Common isNULLString:[dic objectForKey:@"nickName"]];
//    self.number = [Common isNULLString:[dic objectForKey:@"number"]];
//    self.password = [Common isNULLString:[dic objectForKey:@"password"]];
//    self.phone = [Common isNULLString:[dic objectForKey:@"phone"]];
//    self.pictureAddress = [Common isNULLString:[dic objectForKey:@"pictureAddresssmall"]];
//    self.politicalLandscape = [Common isNULLString:[dic objectForKey:@"politicalLandscape"]];
//    self.post = [Common isNULLString:[dic objectForKey:@"post"]];
//    self.practitionersCategory = [Common isNULLString:[dic objectForKey:@"practitionersCategory"]];
//    self.professionalTechnical = [Common isNULLString:[dic objectForKey:@"professionalTechnical"]];
//    self.province = [Common isNULLString:[dic objectForKey:@"province"]];
//    self.sex = [Common isNULLString:[dic objectForKey:@"sex"]];
//    self.title = [Common isNULLString:[dic objectForKey:@"title"]];
//    self.updateTime = [Common isNULLString:[dic objectForKey:@"updateTime"]];
//    self.workUnit = [Common isNULLString:[dic objectForKey:@"workUnit"]];
//    self.zipCode = [Common isNULLString:[dic objectForKey:@"zipCode"]];
//    self.onlineStatus = [[dic objectForKey:@"onlineStatus"] intValue]; //在线状态 0:忙碌 ;1:离开 2:正常'
//    //    所属科室
//    self.belongToDepartment = [Common isNULLString:[dic objectForKey:@"belongToDepartment"]];
//    
    return self;
}

- (void)dealloc
{
    self.accountId = nil;
    self.age = nil;
    self.begood = nil;
    self.bloodType = nil;
    self.briefIntroduction = nil;
    self.census = nil;
    self.changResidence = nil;
    self.city = nil;
    self.consultantId = nil;
    self.createTime = nil;
    self.createUser = nil;
    self.deletetype = nil;
    self.email = nil;
    self.fixedPhone = nil;
    self.fullName = nil;
    self.hospitalNo = nil;
    self.adviserId = nil;
    self.idNumber = nil;
    self.informaticsCertificate = nil;
    self.informaticsTime = nil;
    self.level = nil;
    self.marriage = nil;
    self.microChannel = nil;
    self.nation = nil;
    self.nature = nil;
    self.nickname = nil;
    self.number = nil;
    self.password = nil;
    self.phone = nil;
    self.pictureAddress = nil;
    self.politicalLandscape = nil;
    self.post = nil;
    self.practitionersCategory = nil;
    self.professionalTechnical = nil;
    self.province = nil;
    self.sex = nil;
    self.title = nil;
    self.updateTime = nil;
    self.workUnit = nil;
    self.zipCode = nil;
    self.belongToDepartment = nil;
    
}

@end
