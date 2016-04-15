//
//  Ccommon.h
//  waimaidan
//
//  Created by 国洪 徐 on 12-12-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import "Global.h"
#import "Global_Url.h"
#import "MBProgressHUD.h"
#import "CommonImage.h"
#import "CommonHttpRequest.h"
#import "SSCheckBoxView.h"
//#import "LoadingAnimation.h"
#import "UIView+convenience.h"
#import "CommonSet.h"
#import "BombModel.h"
#import "UIResponder+EventRouter.h"

@interface UIDevice (ALSystemVersion)

+ (float)iOSVersion;

@end

@interface UIApplication (ALAppDimensions)

+ (CGSize)sizeInOrientation:(UIInterfaceOrientation)orientation;
@end

@interface NSString(Emoji)

+ (BOOL)isContainsEmoji:(NSString *)string;

@end

@interface UIViewController(myvc)

- (BOOL)closeNowView;

@end





@class AppDelegate;
@interface Common : NSObject

//判断网络
+ (NetWorkType)checkNetworkIsValidType;

+ (CGSize)heightForString:(NSString*)title Width:(int)width Font:(UIFont*)font;

+ (BOOL)isValidateEmail:(NSString *)email;
//为中文
+ (BOOL)isChineseWord:(NSString *)word;

//设置报告图片
+ (void)setReportPicImage:(NSString*)imgURL View:(id)imageView;

+ (void)setAssistantPicImage:(NSString*)imgURL View:(id)imageView;

+ (BOOL)checkNetworkIsValid;

+ (int)getJingYi:(int)chusu BeiChuShu:(int)beichushu;

+ (NSString *)getDeviceUUId;

+ (BOOL)isMobileNumber:(NSString *)mobileNum;

+ (BOOL)digistJudge:(NSString *)strInfo count:(int)count;

+ (void)changeArray:(NSMutableArray *)dicArray orderWithKey:(NSString *)key ascending:(BOOL)yesOrNo;

+ (UILabel*)createLabel:(CGRect)rect TextColor:(NSString*)color Font:(UIFont*)font textAlignment:(NSTextAlignment)alignment labTitle:(NSString*)title;

+ (UILabel*)createLabel;

+ (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL;

+ (NSString*)datePath;

+ (NSString*)getPicPath;

+ (NSString*)datePathLibrary;

//店铺图标路径
+ (NSString*)getImagePath;

//图片路径
+ (NSString*)getAudioPath;

+ (UILabel*)createLabel:(CGRect)rect;

+ (UIView*)createTableFooter;

+ (MBProgressHUD*)ShowMBProgress:(UIView*)view MSG:(NSString*)msg Mode:(MBProgressHUDMode)mode;

+ (void)HideMBProgress:(MBProgressHUD*)progress;

//提示对话框
+ (void)TipDialog:(NSString*)aInfo;

+ (UIBarButtonItem*)CreateNavBarButton:(id)target setEvent:(SEL)sel background:(NSString*)imageName setTitle:(NSString*)title;

+ (UIBarButtonItem*)CreateNavBarButton:(id)target setEvent:(SEL)sel setImage:(NSString*)imageName setTitle:(NSString*)title;

+ (UIBarButtonItem*)CreateNavBarButton:(id)target setEvent:(SEL)sel setTitle:(NSString*)title;

+ (UIBarButtonItem*)CreateNavBarButton3:(id)target setEvent:(SEL)sel setTitle:(NSString*)title;

+ (UIBarButtonItem*)createNavBarButton:(id)target setEvent:(SEL)sel withNormalImge:(NSString *)normalImge andHighlightImge:(NSString *)HighlightImge;

//获得text的字节数
+ (int)unicodeLengthOfString:(NSString*)text;

+ (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize Image:(UIImage*)image;

//+ (BOOL)isTheSameData:(long)timeLine1 :(long)timeLine2;

+ (AppDelegate*)getAppDelegate;

+ (UITextField*)createTextField:(NSString*)title setDelegate:(id)delegate setFont:(float)size;

//获得宽和高
+ (CGSize)sizeForAllString:(NSString*)title andFont:(int)frontSize andWight:(int)weight;

+ (CGSize)sizeForAllString:(NSString*)title andUIFont:(UIFont *)frontSize andWight:(int)weight;

+ (CGSize)sizeForString:(NSString*)title andFont:(int)frontSize;

+ (UILabel *)createLineLabelWithHeight:(int)lineHeight;

+(void)setUpFullseparatorLineWithCell:(UITableViewCell *)cell;

+ (NSMutableArray*)createArrayWithBeginInt:(int)number andWithOverInt:(int)overNumber haveZero:(BOOL)preZero;

//存入数据
+ (void)saveFileToDoc:(NSString *)docData withFileName:(NSString *)fileName;

//读取数据为dict
+ (NSDictionary *)getDocPathFileWithName:(NSString *)fileName;
+ (NSDictionary*)getMainBundlePathFileWithName:(NSString*)fileName;
//读取数据为nstring
+ (NSString*)getDocPathFileStringWithName:(NSString*)fileName;
//yangshuo
+ (void)setViewImage:(id)view :(UIImage*)image;

//+ (SetInfoModel*)initWithSetInfoDict:(NSDictionary*)dic;

+ (UserInfoModel*)initWithUserInfoDict:(NSDictionary *)dic;

+ (AdviserInfoModel*)initWithAdviserInfoDict:(NSDictionary *)dic;

+ (NSString*)getIDFA;

+ (NSString *)getMacAddress;

//1990-2-3得到年龄
+ (NSString *)getAgeWithBirthday:(NSString *)birthday;

+ (NSString *)formatHtmlString:(NSString *)content;

//提示
+ (void)createAlertViewWithString:(NSString*)tipString withDeleagte:(id)delegate;

+ (NSString *)isNULLString:(NSString *)aString;

+ (NSString *)isNULLString2:(NSString *)aString;

+ (NSString *)isNULLString3:(NSString *)aString;

+ (NSString *)isNULLString4:(NSString *)aString;

+ (NSString *)isNULLString5:(NSString *)aString;
+ (NSString *)isNULLString7:(NSString *)aString;

+ (NSString*)dataWithString:(NSString*)aString;
/**
 *  糖尿病类型
 *
 *  @param aString 糖尿病类型
 *
 *  @return 内容
 */
+ (NSString*)isNULLString6:(NSString*)aString;


+ (BOOL)validateIDCardNumber:(NSString *)value;
+ (BOOL)stringContainsEmoji:(NSString *)string;

+ (NSData *)uncompressZippedData:(NSData *)compressedData;

+ (void)TipDialog2:(NSString *)aInfo;

+ (int)getVersionWithString:(NSString *)versionString;
//是否纯数字
+ (BOOL)isPureInt:(NSString*)string;

+ (BOOL)isValidPassword:(NSString *)pass;
+ (BOOL)isValidEnglish:(NSString*)pass;

+ (CGRect)rectWithSize:(CGRect)rect width:(CGFloat)width height:(CGFloat)height;

+ (CGRect)rectWithOrigin:(CGRect)rect x:(CGFloat)x y:(CGFloat)y;

///转json
+ (NSString *)convertJsonStringWithDict:(NSDictionary *)map;


+ (NSString*)getJibingshiStr:(NSString*)sttr;


/**
 *  隐藏多余的分割线
 *
 *  @param tableView 隐藏之后的tableview
 */
+ (void)setExtraCellLineHidden:(UITableView*)tableView;

+ (void)playAnimated:(UILabel*)labValue :(float)begin :(float)end :(float)unit :(BOOL)is;

/**
 *  根据code返回预警类型
 *
 *  @param type type
 *
 *  @return 预警相关
 */
//+ (NSString *)getContentWithType:(NSString *)type;

+ (NSString*)getImagePath:(NSString*)path Widht:(float)widht Height:(float)height;

//创建右箭头
+ (UIImageView*)creatRightArrowX:(CGFloat)x Y:(CGFloat)y cell:(id)cell;
//创建cell点击背景图
+(UIView*)creatCellBackView;

+ (NSString *)getCurrentDeviceModel;

+ (void)creatLandingAnimation;

+ (void)MBProgressTishi:(NSString*)title forHeight:(float)height;

+ (BOOL)textField:(UITextField*)textField replacementString:(NSString*)string;

+ (UIButton*)createKeyboardClean;

@end



