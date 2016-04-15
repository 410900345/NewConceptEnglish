//
//  CommonSet.h
//  newIdea1.0
//
//  Created by yangshuo on 15/11/5.
//  Copyright © 2015年 xuGuohong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OffDataModel.h"
//#import "HomeModel.h"

//新概念@美文@离线资源@应用@ 考试资讯 @歌曲
typedef enum : NSUInteger {
    RefreshNCE = 0,
    RefreshDayMW,
    RefreshDayOffData,
    RefreshDayApp,
    RefreshDayTest,
    RefreshDaySong
} RefreshType;

static NSString *const kPlayAuto= @"kPlayAuto";//自动播放
static NSString *const kPlaySound= @"kPlaySound";//自动声音大小
static NSString *const kPlayRate= @"kPlayRate";//频率

static NSString *const kSetSystem = @"kSetSystem";//系统设置
static NSString *const kSetCommonUserDay = @"kSetCommonUserDay";//根据人记录
static NSString *const kSetAdUrlInfo = @"kSetAdUrlInfo";
static NSString *const kTipBaseStr = @"kTipBaseStr";//基数
static NSString *const kUserLoginlInfo = @"kUserLoginlInfo";
static NSString *const kUserLoginlInfoUserId = @"kUserLoginlInfoUserId";

static int const kTipBeginNum = 6;

static NSString *const kRobotReadAutomatic = @"kRobotReadAutomatic";//自动读
static NSString *const kRobotShowChinaAutomatic = @"kRobotShowChinaAutomatic";//自动中文

@interface CommonSet : NSObject

typedef enum : NSUInteger {
    AdTypeBegin = 0,//开屏
    AdTypeBeginTwo,//保留
    AdTypeBeginThree,//保留2
    AdTypeBanner,//banner
} AdType;

@property (nonatomic,copy) NSString *donate_msg;//提示语
@property (nonatomic,copy) NSString *notice;//公告,
@property (nonatomic,copy) NSString *offdata;//音,四六
@property (nonatomic,copy) NSString *reflesh;//刷新
@property (nonatomic,copy) NSString *sp_de;//是否显示广
@property (nonatomic,copy) NSString *update_tip;//更新提示
@property(nonatomic,strong) NSDictionary *m_adDict;
@property(nonatomic,strong) NSMutableArray *m_adArray;

@property(nonatomic,strong) NSMutableDictionary *m_noticeDict;

@property (nonatomic,copy) NSString *homeOrder;//是否显示广
//@property(nonatomic,strong) HomeModel *m_homeModel;//排序
//@property(nonatomic,strong) NSMutableArray *m_newIndexArrayMeans;//意思

@property (nonatomic,assign) BOOL m_forceUpdate;
@property (nonatomic,copy) NSString *m_forceUpdateContent;
@property (nonatomic,assign) int m_forceNum;


@property (nonatomic,strong) OffDataModel *m_offDataModel;
//@property (nonatomic,assign) BOOL m_checkInAppStore;//修改版本提交信息
@property (nonatomic,copy) NSString *m_checkInAppStoreStr;
@property (nonatomic,assign) BOOL m_checkVersionAppStore;//检查版本信息是否在为审核
@property (nonatomic,copy) NSString *double_url;//双数课
+ (instancetype)sharedInstance;
- (void)fillData;
//是否刷新
- (BOOL)needRefreshWithKey:(RefreshType)type;

//使用天数
+ (void)setCommonUserDay;
+ (NSString *)getCommonUserDay;
+(void)checkAppUpdate;//更新
+ (NSMutableDictionary *)getLocalDataPListWithKeyFileName:(NSString *)fileName;//本地list
//更新启动次数
+(void)updateTipCount;

+(NSString *)convertFilePathStringWithStr:(NSString *)str;

+(void)setAdUrlInfoWithUrl:(NSString *)url;
+ (NSString *)getAdUrlInfoWithUrl;

//登录信息缓存
+(void)saveLoginInfo:(NSDictionary *)dict withKey:(NSString *)key;
+(NSDictionary *)getLoginInfowithKey:(NSString *)key;
+(void)writeToPlist:(id)object withFielName:(NSString *)fileName;//写入数据

//下载地址
+(NSString *)getAppStorUrl;
//评价地址
+(NSString *)getAppStorCommentUrl;

//获取比例高度
+(float)getFrameHightWith6H:(float)floatH;

//评论
- (void)tipComment;

//更新
- (void)handleUpdate;

-(void)handleOffDataOrder;

//处理链接地址
+ (NSString *)handleUrlWithStr:(NSString *)urlStr;

//是否vip版本
+ (BOOL)isVipVersion;

//bmob str
+ (NSString *)createBmobUrlString:(NSDictionary *)fileDict;

//修改plist
-(void)saveSystemPlistValue:(NSString *)value forKey:(NSString *)key;
-(void)saveUserPlistValue:(NSString *)value forKey:(NSString *)key;
-(id)fetchSystemPlistValueforKey:(NSString *)key;
-(id)fetchUserPlistValueforKey:(NSString *)key;
@end
