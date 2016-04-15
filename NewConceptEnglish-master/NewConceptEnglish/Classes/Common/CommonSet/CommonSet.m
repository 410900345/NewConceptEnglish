//
//  CommonSet.m
//  newIdea1.0
//
//  Created by yangshuo on 15/11/5.
//  Copyright © 2015年 xuGuohong. All rights reserved.
//

#import "CommonSet.h"
#import "CommonUser.h"
#import "CommonDate.h"
#import "MobClick.h"
#import "AppDelegate.h"
//#import "SupportGiveViewController.h"
#import "AdvView.h"
#import "CommentManage.h"


static NSString *const kTipStr = @"kTipStr";
typedef enum : NSUInteger {
    kTipCoumntTag = 1889,
    kTipCoumntUpdate
} kTipCoumntTagType;

@interface CommonSet ()<UIAlertViewDelegate>

@end

@implementation CommonSet
{
    AppDelegate *myAppdelegate;
   
    CommentManage *m_commentManage;
}
@synthesize reflesh,notice,sp_de,donate_msg,offdata;
@synthesize m_adDict;
@synthesize m_adArray,m_noticeDict;
@synthesize homeOrder;
//@synthesize m_newIndexArray,m_newIndexArrayMeans;
@synthesize update_tip;
@synthesize m_forceUpdate,m_forceUpdateContent,m_forceNum;
@synthesize m_offDataModel;

+ (instancetype)sharedInstance
{
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

-(id)init
{
    self = [super init];
    if (self)
    {
        myAppdelegate = [Common getAppDelegate];
        m_adArray = [[NSMutableArray alloc] init];
        m_noticeDict = [[NSMutableDictionary alloc] init];
       
        m_forceUpdate = NO;
        m_forceNum = 10000;
    }
    return self;
}

#pragma mark - PrivateMethod
- (void)tipComment
{
    //ios8 以上出现键盘消失又出来的问题,sdk变化引起
    NSMutableDictionary *localDic = [CommonSet getLocalDataPListWithKeyFileName:kSetSystem];
    int kBaseStrCout = [localDic[kTipBaseStr] intValue];
//    if ([CommonSet isVipVersion])
//    {
//        kBaseStrCout = INT_MAX;
//    }
    [[self class] updateTipCount];//子增加
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        int is = [[[NSUserDefaults standardUserDefaults] objectForKey:kTipStr] intValue];
        if (!(is%kBaseStrCout))
        {
            NSString *titlt = self.donate_msg;
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:titlt message:nil delegate:self cancelButtonTitle:@"残忍拒绝" otherButtonTitles:@"大力支持", nil];
            av.tag = kTipCoumntTag;
            [av show];
        }
       else if (!(is%kCommentManageTip) && ![CommentManage havedComment])
       {
            m_commentManage =[CommentManage showCommentAlert];
       }
       else
       {
            [self handleUpdate];
        }
    });
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
//    if (alertView.tag == kTipCoumntTag)
//    {
//        if (buttonIndex == 1)
//        {
//            SupportGiveViewController * modify = [[SupportGiveViewController alloc]init];
//            [myAppdelegate.navigationVC pushViewController:modify animated:YES];
//        }
//        else
//        {
//            if ([myAppdelegate.navigationVC.topViewController isKindOfClass:[AdvView class]])
//            {
//                return;
//            }
//            NSDictionary *adDict = [CommonSet sharedInstance].m_adDict;
//            if(adDict.count)
//            {
//                AdvView* helpAdView = [[AdvView alloc] init];
//                helpAdView.m_url = adDict[kUrlKey];
//                helpAdView.title = adDict[@"title"];
//                helpAdView.m_dicInfo = adDict;
//                //                helpAdView.m_isHideNavBar = YES;
//                [myAppdelegate.navigationVC pushViewController:helpAdView animated:YES];
//                [CommonSet sharedInstance].m_adDict = nil;
//            }
//        }
//    }
//    else if (alertView.tag == kTipCoumntUpdate)
//    {
//        if(buttonIndex == 0)
//        {
//            // 此处加入应用在app store的地址，方便用户去更新，一种实现方式如下：
//            NSURL *url = [NSURL URLWithString:[CommonSet getAppStorUrl]];
//            [[UIApplication sharedApplication] openURL:url];
//        }
//    }
}

+(void)updateTipCount
{
    int is = [[[NSUserDefaults standardUserDefaults] objectForKey:kTipStr] intValue];
    is++;
    [[NSUserDefaults standardUserDefaults] setObject:@(is) forKey:kTipStr];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)fillData
{
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        @try {
            NSDictionary *dict =  [MobClick getConfigParams];
            NSLog(@"------%@",dict);
            self.reflesh = dict[@"reflesh"];
            self.notice = dict[@"notice"];
            self.sp_de = dict[@"sp_de"];
            self.donate_msg = dict[@"donate_msg"];
            self.offdata = dict[@"offdata"];
            self.homeOrder = dict[@"homeOrder"];
            self.update_tip = dict[@"update_tip"];
//            self.m_checkInAppStore = [dict[@"checkInAppStore"] boolValue];
            self.m_checkInAppStoreStr = dict[@"checkInAppStore"];
            self.double_url = dict[@"double_url"];

            NSMutableDictionary *localDic = [CommonSet getLocalDataPListWithKeyFileName:kSetSystem];
            if (self.reflesh.length)
            {
                NSArray *refleshArraykey = [self.reflesh componentsSeparatedByString:@"@"];
                NSArray *refleshArray = [[self class] getRefrlehKeyArray];
                
                NSInteger count = MIN(refleshArraykey.count, refleshArray.count);
                for (int i= 0; i< count; i++)
                {
                    [localDic setObject:refleshArraykey[i] forKey:refleshArray[i]];
                }
            }
            [self handleHomeOder];
            [self handleAdStr];
            [self handleNoticeStr];
            [self handleOffDataOrder];
            //初始化数据点击的
            int kBaseStrCout = [localDic[kTipBaseStr] intValue];
            if (kBaseStrCout == 0)
            {
                kBaseStrCout = kTipBeginNum;
            }
            [localDic setObject:@(kBaseStrCout) forKey:kTipBaseStr];
            [CommonSet writeToPlist:localDic withFielName:kSetSystem];
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
//    });
}

-(BOOL)m_checkVersionAppStore
{
    BOOL vip = [CommonSet isVipVersion];
    NSArray *titleArray = [self.m_checkInAppStoreStr componentsSeparatedByString:@"@"];
    if (titleArray.count == 3)
    {
        BOOL isAppStoreing = [titleArray[0] boolValue];
        NSInteger versionInfo = !vip?[titleArray[1] integerValue]:[titleArray[2] integerValue];
        NSInteger currentVersion = [CFBundleVersion integerValue];
        if (versionInfo <= currentVersion)
        {
            return YES;
        }
    }
    return NO;
}

-(void)handleOffDataOrder
{
    if (self.offdata.length)
    {
        m_offDataModel = [OffDataModel fillDataWitOffDataString:self.offdata];
    }
}

-(void)handleHomeOder
{
//    _m_homeModel = [HomeModel fillDataWithOrderString:self.homeOrder];
//    if (self.homeOrder.length)
//    {
////        @TODO("123");
//        self.homeOrder = @"1@3@2@4";
//        NSArray *allArray = [self.homeOrder componentsSeparatedByString:@"@"];//大分割
//        [m_newIndexArray removeAllObjects];
//        [m_newIndexArrayMeans removeAllObjects];
//        for (int i= 0; i<allArray.count; i++)
//        {
//            NSString *indexKey = allArray[i];
//            int index = indexKey.intValue-1;
//            NSString *indexTitle = m_indexArray[index];
//            NSString *indexTitleMeans = m_indexArrayMeans[index];
//            [m_newIndexArray addObject:indexTitle];
//            [m_newIndexArrayMeans addObject:indexTitleMeans];
//        }
//    }
//    if (!m_newIndexArray.count)
//    {
//        [m_newIndexArray addObjectsFromArray:m_indexArray];
//        [m_newIndexArrayMeans addObjectsFromArray:m_indexArrayMeans];
//    }
}

//广告地址
-(void)handleAdStr
{
    if (self.sp_de.length)
    {
        NSArray *allArray = [self.sp_de componentsSeparatedByString:@"#&#"];//大分割
        if (allArray.count >= 2)
        {
            NSString *adStr = allArray[1];
            NSArray *subArray = [adStr componentsSeparatedByString:@"@"];//小分割
            [m_adArray removeAllObjects];
            [m_adArray addObjectsFromArray:subArray];
        }
    }
}

-(void)handleUpdate
{
    if (self.update_tip.length)
    {
         NSArray *allArray = [self.update_tip componentsSeparatedByString:@"@"];//大分割
//        版本号@版本名称@强制升级(1强制,0不强制)@提示内容
        if (allArray.count == 5)
        {
            NSString *versinNum = allArray[0];
            NSString *versinName = allArray[1];
            NSString *forceUpdate = allArray[2];
            NSString *versinTipNum = allArray[3];
            m_forceNum = versinTipNum.intValue;
            NSString *versinContent = allArray[4];
            NSString *versonStr = CFBundleVersion;
            if (versinNum.floatValue >versonStr.floatValue)
            {
                int is_force_update = forceUpdate.intValue;
                m_forceUpdate = is_force_update;
                m_forceUpdateContent = versinContent;
                int is = [[[NSUserDefaults standardUserDefaults] objectForKey:kTipStr] intValue];
                if (m_forceNum == 0 || (is%m_forceNum) == 0)
                {
                    [self handleUpdateAlert];
                }
            }
        }
    }
}

-(void)handleUpdateAlert 
{
    NSString *cancle;
    if (m_forceUpdate) {
        //强制升级标签
        cancle = nil;
    }
    else {
        cancle = @"取消";
    }
    NSString *versinContent = m_forceUpdateContent?m_forceUpdateContent:@"";
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"升级提示",nil) message:versinContent delegate:self cancelButtonTitle:NSLocalizedString(@"去更新",nil) otherButtonTitles:cancle, nil];
    av.tag = kTipCoumntUpdate;
    [av show];
}

-(void)handleNoticeStr
{
    if (self.notice.length)
    {
        NSArray *allArray = [self.notice componentsSeparatedByString:@"@"];//大分割
        NSArray *keyArray = @[@"content",@"title",@"noticeUrl",@"canClick",@"showVerson"];
        int cout = MIN(allArray.count, keyArray.count);
        for (int i = 0; i < cout ; i++)
        {
            [m_noticeDict setObject:allArray[i] forKey:keyArray[i]];
        }
        NSString *showVerson = m_noticeDict[@"showVerson"];
        if (showVerson.length)
        {
            NSArray *array = [showVerson componentsSeparatedByString:@","];
            NSString *bundleIn =   CFBundleVersion;
            BOOL isShow = [array containsObject:bundleIn];
            [m_noticeDict setObject:@(isShow) forKey:@"show"];
        }
    }
}

//处理链接地址
+(NSString *)handleUrlWithStr:(NSString *)urlStr
{
    NSString *strNew = urlStr;
    if (![urlStr hasPrefix:@"http:"])
    {
        strNew = [HEALP_SERVER_AdUrl stringByAppendingString:strNew];
    }
    return strNew;
}

#pragma mark - plist
- (BOOL)needRefreshWithKey:(RefreshType)type
{
    BOOL needRefresh = NO;
    NSMutableDictionary *localDic = [CommonSet getLocalDataPListWithKeyFileName:kSetSystem];
    NSString *keyStr = [[self class] getRefleshKey:type];
    NSString *requestTime = localDic[keyStr];//总是取上一次时间
    needRefresh = ![requestTime hasSuffix:@"0-0"];
    return needRefresh;
}

+(NSArray *)getRefrlehKeyArray
{
    NSArray *array = @[@"RefreshNCE",@"RefreshMW",@"RefreshDayOffData",@"RefreshDayApp",
                       @"RefreshDayTest",@"RefreshDaySong"];
    return array;
}
//获取索引
+(NSString *)getRefleshKey:(RefreshType )key
{
    NSArray *array = [[self class] getRefrlehKeyArray];
    NSInteger keyIndex = MIN(key, array.count-1);
    NSString *reflreshKey = array[keyIndex];
    return reflreshKey;
}
//参数
+ (void)setCommonUserDay
{
    NSMutableDictionary *localDic = [CommonSet getLocalDataPListWithKeyFileName:kSetCommonUserDay];
    NSString *requestTime = localDic[kSetCommonUserDay];//总是取上一次时间
    if (!requestTime.length)
    {
        requestTime = [NSString stringWithFormat:@"%ld",[CommonDate getLongTime]];
        [localDic setObject:requestTime forKey:kSetCommonUserDay];
        [CommonSet writeToPlist:localDic withFielName:kSetCommonUserDay];
    }
    
}

+ (NSString *)getCommonUserDay;
{
    NSMutableDictionary *localDic = [CommonSet getLocalDataPListWithKeyFileName:kSetCommonUserDay];
    NSString *requestTime = localDic[kSetCommonUserDay];//总是取上一次时间
    if (IsStrEmpty(requestTime))
    {
        return @"0";
    }
    long recordTime = [requestTime longLongValue];
    long nowTime = [CommonDate getLongTime];
    
    int day = ceill((nowTime - recordTime)/(60*60*24));
    NSString *dayNum = [NSString stringWithFormat:@"%d",day];
    return dayNum;
}

+(NSString *)getTimeWithKey:(NSString *)keyStr
{
    NSString *postTime = @"";
    NSString *kLastTime = keyStr;
    postTime = [[NSUserDefaults standardUserDefaults] objectForKey:kLastTime];
    if (!postTime.length)
    {
        postTime = @"";
    }
    return postTime;
}

+(void)saveTimeWithKey:(NSString *)keyStr withTimeStr:(NSString *)timeStr
{
    if (keyStr.length)
    {
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@",timeStr] forKey:keyStr];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

+ (void)writeToPlist:(id)object withFielName:(NSString *)fileName
{
    
    NSString * filePath = [[self class] getPlistFilePathWithFileName:fileName];
    NSLog(@"filePath:%@",filePath);
    [object writeToFile:filePath atomically:YES];
}

+(NSString *)getPlistFilePathWithFileName:(NSString *)fileName
{
    NSString * path =  [Common datePath];
    NSString *flleNameLast = fileName;
    if ([kSetCommonUserDay isEqualToString:fileName])
    {
        flleNameLast = [NSString stringWithFormat:@"%@%@",g_nowUserInfo.userid,fileName];
    }
    NSString * filePath = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",flleNameLast]];
    return filePath;
}
//本地配置文件
+ (NSMutableDictionary *)getLocalDataPListWithKeyFileName:(NSString *)fileName;//本地list
{
    NSString * filePath = [[self class] getPlistFilePathWithFileName:fileName];
    BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
    if(!isExist){
        //不存在创建
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:0];
        [dic writeToFile:filePath atomically:YES];
        return dic;
    }
    //存在直接返回
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithContentsOfFile:filePath];
    return dic;
    
}

+(void)checkAppUpdate
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
        NSString *nowVersion = [infoDict objectForKey:@"CFBundleVersion"];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://itunes.apple.com/lookup?id=%@", VERSION_APPID]];
        NSString * file =  [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
        
        NSRange substr = [file rangeOfString:@"\"version\":\""];
        NSRange range1 = NSMakeRange(substr.location+substr.length,10);
        NSRange substr2 =[file rangeOfString:@"\"" options:nil range:range1];
        NSRange range2 = NSMakeRange(substr.location+substr.length, substr2.location-substr.location-substr.length);
        NSString *newVersion =[file substringWithRange:range2];
        dispatch_async(dispatch_get_main_queue(), ^{
            if(![nowVersion isEqualToString:newVersion])
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"版本有更新"delegate:self cancelButtonTitle:@"取消"otherButtonTitles:@"更新",nil];
                [alert show];
            }
        });
    });
}

+(NSString *)convertFilePathStringWithStr:(NSString *)str
{
    NSString *m_dataString = [str stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
    m_dataString = [m_dataString stringByReplacingOccurrencesOfString:@":" withString:@""];
    return m_dataString;
}

+(void)setAdUrlInfoWithUrl:(NSString *)url
{
    if (url.length)
    {
        url = [url stringByReplacingOccurrencesOfString:@"/" withString:@"^"];
        url = [url stringByReplacingOccurrencesOfString:@":" withString:@"~"];
        [[self class] saveTimeWithKey:kSetAdUrlInfo withTimeStr:url];
    }
}
+ (NSString *)getAdUrlInfoWithUrl
{
    
    NSString *url  = [[self class] getTimeWithKey:kSetAdUrlInfo];
    url = [url stringByReplacingOccurrencesOfString:@"^" withString:@"/"];
    url = [url stringByReplacingOccurrencesOfString:@"~" withString:@":"];
    return url;
}

+(void)saveLoginInfo:(NSDictionary *)dict withKey:(NSString *)keyStr;
{
    if (keyStr.length)
    {
        [[NSUserDefaults standardUserDefaults] setObject:dict forKey:keyStr];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

+(NSDictionary *)getLoginInfowithKey:(NSString *)keyStr;
{
    NSDictionary *postTime = nil;
    NSString *kLastTime = keyStr;
    postTime = [[NSUserDefaults standardUserDefaults] objectForKey:kLastTime];
    if (!postTime.count)
    {
        postTime = @{};
    }
    return postTime;
}

+(NSString *)getAppStorUrl
{
    NSString  *codeProduceStr = [NSString stringWithFormat:@"https://itunes.apple.com/cn/app/id%@?mt=8", VERSION_APPID];
    return codeProduceStr;
}

+(NSString *)getAppStorCommentUrl
{
    NSString  *codeProduceStr = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/cn/app/id%@?mt=8", VERSION_APPID];
    return codeProduceStr;
}

+(float)getFrameHightWith6H:(float)floatH
{
    float kfloatH = floatH;
    float standardh = [UIScreen mainScreen].bounds.size.height;
    kfloatH = standardh*floatH/667.0;
    return kfloatH;
}

+(BOOL)isVipVersion
{
    int vipTag = VERSION_INFO;
    BOOL isVip = vipTag?YES:NO;
    return isVip;
}

+ (NSString *)createBmobUrlString:(NSDictionary *)fileDict
{
    NSString *str = fileDict[@"url"];
    NSString *fileUrl = [HEALP_SERVER_bmob stringByAppendingString:str];
    return fileUrl;
}

#pragma mark --get -- set plist
-(void)saveValue:(NSString *)value forKey:(NSString *)key toPlistFileName:(NSString *)fileName
{
    NSMutableDictionary *localDic = [CommonSet getLocalDataPListWithKeyFileName:fileName];
    [localDic setObject:value forKey:key];
    [CommonSet writeToPlist:localDic withFielName:fileName];
}

-(void)saveSystemPlistValue:(NSString *)value forKey:(NSString *)key
{
    [self saveValue:value forKey:key toPlistFileName:kSetSystem];
}

-(void)saveUserPlistValue:(NSString *)value forKey:(NSString *)key
{
    [self saveValue:value forKey:key toPlistFileName:kSetCommonUserDay];
}

//get
-(id)getValueforKey:(NSString *)key toPlistFileName:(NSString *)fileName
{
    NSMutableDictionary *localDic = [CommonSet getLocalDataPListWithKeyFileName:fileName];
    id object = nil;
    if ([localDic.allKeys containsObject:key])
    {
        object = localDic[key];
    }
    return object;
}

-(id)fetchSystemPlistValueforKey:(NSString *)key
{
    return [self getValueforKey:key toPlistFileName:kSetSystem];
}

-(id)fetchUserPlistValueforKey:(NSString *)key
{
    return [self getValueforKey:key toPlistFileName:kSetCommonUserDay];
}
@end
