//
//  GlobalObject.h
//  NewConceptEnglish
//
//  Created by jiuhao-yangshuo on 16/4/15.
//  Copyright © 2016年 EasyEnglish. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GlobalObject : NSObject
extern NSMutableDictionary *g_winDic;

extern UserInfoModel *g_nowUserInfo;
extern AdviserInfoModel *g_adviserInfo;
//SetInfoModel *g_setInfo;
extern NSMutableArray *g_familyList;
//数据库对象
extern sqlite3* g_database_;
extern float g_tabbarHeight;
//
extern NSLock *g_iconArrayLock;
extern NSLock *g_iconDownDelegateLock;
extern NSLock *g_submitData;
extern long g_lastLcationTime;
extern NSMutableDictionary *g_imageArrayDic;
extern UIWindow *g_statusbarWindow;
//监测的数据传递
extern NSMutableDictionary *m_MornitDict;
extern NSMutableDictionary *sendDict;
extern NSString *m_selectedDateString;
extern NSString *g_url;
extern long g_longTime;
//字符编码
extern NSStringEncoding g_GBKEncod;

@end
