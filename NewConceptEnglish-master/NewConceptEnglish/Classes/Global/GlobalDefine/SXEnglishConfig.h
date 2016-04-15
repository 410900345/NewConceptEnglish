//
//  SXEnglishConfig.h
//  newIdea1.0
//
//  Created by jiuhao-yangshuo on 15/12/1.
//  Copyright © 2015年 xuGuohong. All rights reserved.
//

#ifndef SXEnglishConfig_h
#define SXEnglishConfig_h


#if DISTRIBUTION_APPSTORE ==0    //----------------普通版

#define VERSION_INFO            0
//友盟appkey
#define  UMENG_APPKEY         @"564d894d67e58e1465000fc7"

#define  kWXAppKey           @"wx6b8d7aa7e03a90ca"
#define  kWXAppSecret        @"d4624c36b6795d1d99dcf0547af5443d"
#define  kSinaWeiAppKey      @"2832531015"
#define  kSinaWeiAppSecret   @"2926e0820250c76923576f41aeb8b317"
#define  kSinaWeiAppURL      @"https://openapi.baidu.com/social/oauth/2.0/receiver"//后期更改成一致
#define  kQQAppKey           @"1101198179"
#define  kQQAppSecret        @"Z67UFCRLNuHs61sa"

#define kURLSchemes          @"com.xiaobin.ncenglish"
#define VERSION_APPID        @"1060419460"
#define VERSION_CHANNEL_ID   @"appStore"

#elif DISTRIBUTION_APPSTORE  == 1 //----------------Vip

#define VERSION_INFO            1
//友盟appkey
#define  UMENG_APPKEY        @"564d894d67e58e1465000fc7"

#define  kWXAppKey           @"wx7463d4377f1da4f2"
#define  kWXAppSecret        @"d4624c36b6795d1d99dcf0547af5443d"
#define  kSinaWeiAppKey      @"2187082097"
#define  kSinaWeiAppSecret   @"3179ffa03cc10305679297aa44513cce"
#define  kSinaWeiAppURL      @"http://www.sharesdk.cn"
#define  kQQAppKey           @"1101198179"
#define  kQQAppSecret        @"Z67UFCRLNuHs61sa"

#define  kURLSchemes         @"com.xiaobin.ncevp"
#define VERSION_APPID        @"1065517371"
#define VERSION_CHANNEL_ID   @"appStoreVIP"
#endif

#endif /* SXEnglishConfig_h */
