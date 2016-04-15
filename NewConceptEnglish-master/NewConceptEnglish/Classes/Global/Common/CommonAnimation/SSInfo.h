/**
 * PPInfo.h
 * PPKit
 *
 * @author Created by 闫鹏 on 16/3/9.
 * @copyright  Copyright © 2016年 pp. All rights reserved.
 *
 * @email top_yp@126.com
 * @qq    724198635
 */

#import <Foundation/Foundation.h>

@interface SSInfo : NSObject

+(void)debugLogAppInformation;

+(NSString *)deviceOSVersion;
+(NSString *)deviceModel;
+(NSString *)deviceUUID;
+(NSString *)deviceIP;
+(NSString *)localIP;

+(NSString *)appName;
+(NSString *)appVersion;
+(NSString *)appBuildVersion;
+(NSString *)appBundleIdentifier;
+(NSString *)appHomeDirectory;

@end
