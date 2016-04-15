//
//  GlobalObject.m
//  NewConceptEnglish
//
//  Created by jiuhao-yangshuo on 16/4/15.
//  Copyright © 2016年 EasyEnglish. All rights reserved.
//

#import "GlobalObject.h"

@implementation GlobalObject
NSMutableDictionary *g_winDic;

UserInfoModel *g_nowUserInfo;
AdviserInfoModel *g_adviserInfo;
//SetInfoModel *g_setInfo;

NSMutableArray *g_familyList;


//数据库对象
sqlite3* g_database_;

float g_tabbarHeight;

//
NSLock *g_iconArrayLock;
NSLock *g_iconDownDelegateLock;

NSLock *g_submitData;

long g_lastLcationTime;

NSMutableDictionary *g_imageArrayDic;

UIWindow *g_statusbarWindow;

//监测的数据传递
NSMutableDictionary *m_MornitDict;
NSMutableDictionary *sendDict;
NSString *m_selectedDateString;

NSString *g_url;

long g_longTime;

//字符编码
NSStringEncoding g_GBKEncod;
@end
