//
//  AdviserInfoModel.h
//  jiuhaoHealth2.0.1
//
//  Created by 徐国洪 on 14-5-28.
//  Copyright (c) 2014年 徐国洪. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AdviserInfoModel : NSObject

@property (nonatomic, retain) NSString *accountId;
@property (nonatomic, retain) NSString *age;
@property (nonatomic, retain) NSString *begood;
@property (nonatomic, retain) NSString *bloodType;
@property (nonatomic, retain) NSString *briefIntroduction;
@property (nonatomic, retain) NSString *census;
@property (nonatomic, retain) NSString *changResidence;
@property (nonatomic, retain) NSString *city;
@property (nonatomic, retain) NSString *consultantId;
@property (nonatomic, retain) NSString *createTime;
@property (nonatomic, retain) NSString *createUser;
@property (nonatomic, retain) NSString *deletetype;
@property (nonatomic, retain) NSString *email;
@property (nonatomic, retain) NSString *fixedPhone;
@property (nonatomic, retain) NSString *fullName;;
@property (nonatomic, retain) NSString *hospitalNo;
@property (nonatomic, retain) NSString *adviserId;
@property (nonatomic, retain) NSString *idNumber;
@property (nonatomic, retain) NSString *informaticsCertificate;
@property (nonatomic, retain) NSString *informaticsTime;
@property (nonatomic, retain) NSString *level;
@property (nonatomic, assign) int grade;
@property (nonatomic, retain) NSString *marriage;
@property (nonatomic, retain) NSString *microChannel;
@property (nonatomic, retain) NSString *nation;
@property (nonatomic, retain) NSString *nature;
@property (nonatomic, retain) NSString *nickname;
@property (nonatomic, retain) NSString *number;
@property (nonatomic, retain) NSString *password;
@property (nonatomic, retain) NSString *phone;
@property (nonatomic, retain) NSString *pictureAddress;
@property (nonatomic, retain) NSString *politicalLandscape;
@property (nonatomic, retain) NSString *post;
@property (nonatomic, retain) NSString *practitionersCategory;
@property (nonatomic, retain) NSString *professionalTechnical;
@property (nonatomic, retain) NSString *province;
@property (nonatomic, retain) NSString *sex;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *updateTime;
@property (nonatomic, retain) NSString *workUnit;
@property (nonatomic, retain) NSString *zipCode;
@property (nonatomic, assign) int onlineStatus;//在线状态 0:忙碌 ;1:离开 2:正常
@property (nonatomic, retain) NSString *belongToDepartment;

- (id)initWithDic:(NSDictionary*)dic;

@end
