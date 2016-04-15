//
//  AppUtil.h
//  MyWord
//
//  Created by 张诚 on 11-12-30.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DecodingManager.h"

static NSString *const kVOAFileDetail = @"kVOAFileDetail";
static NSString *const kVOAFileDetailText = @"kVOAFileDetailText";
static NSString *const KGetDayVOADetailUrl = @"KGetDayVOADetailUrl";//详情

static NSString *const kVOAFile = @"kVOAFileHome";//列表Voa
static NSString *const kDaySentenceDetailFile = @"DaySentenceDetailHome";//每日一句
static NSString *const kDayInfoFile = @"kDayInfoFileHome";//资讯

static NSString *const JSONFILENAME = @"HomeJson";
static NSString *const kHomeJsonAd  = @"HomeJsonAd";

static NSString *const kDayVOAMP3  = @"kDayVOAMP3";//mp3 voa 缓存


static NSString *const kMUSICMP3File = @"kMUSICMP3File";//列表mp3

static NSString *const SXRadioViewStatusNotifiation = @"SXRadioViewStatusNotifiation";
static NSString *const SXRadioViewSetSongInformationNotification= @"SXRadioViewSetSongInformationNotification";

@interface AppUtil : NSObject

+(NSString*)getAppPath;

+(NSString*)getDocPath;

+(NSString*)getTempPath;

+ (NSString *)getDocTempPath;

+ (NSString*)getBookPath;

//db位置
+ (NSString*)getDbPath;

+ (void)createCacheDir;

+ (void)cacheClean;
//音标
+ (NSString*)getDbYBPath;
//缓存目录
+ (NSString*)getCachesPath;
//双数课
+ (NSString*)getDoubleBookHtmlPath;
//缓存清除首页
+(void)clearCachesWithAsyHomeList;
//缓存所以本地
+(void)clearCachesWithAsyAllCaches;
//解析数据
+(NSString *)decodeTextWithStr:(NSString *)str;

//解压资源
+ (void)extZipResWithZipName:(NSString *)zipName withOldPath:(NSString *)oldPath withNewPath:(NSString *)newPath;

//下载地址
+(NSString*)getDocDownloadWordPath;

//获取资源
+ (NSString*)getBookPathIndex:(NSString *)bookName withResoureName:(NSString *)resoureName;

//删除文件夹和文件
+ (void)deleteFilePath:(NSString *)documentsDirectory;
+ (void)deleteSingleFilePath:(NSString *)filePath;

+(void)deleteBookFile;

//第一次首页数据
+ (void)moveHomeJsonData;


@end
