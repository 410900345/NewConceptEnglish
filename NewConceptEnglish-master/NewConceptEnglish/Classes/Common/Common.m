//
//  Ccommon.m
//  waimaidan
//
//  Created by 国洪 徐 on 12-12-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "Common.h"
#import <netinet/in.h>
#import <SystemConfiguration/SCNetworkReachability.h>
#import <CoreLocation/CoreLocation.h>
#import "AppDelegate.h"
#import "SSCheckBoxView.h"
#import <net/if.h>
#import <net/if_dl.h>
#import <sys/sysctl.h>
#import "zlib.h"
#import "ASIHTTPRequest.h"
//#import "JSON.h"
#import "ASIFormDataRequest.h"
//#import "AccordingView.h"
#import <AdSupport/AdSupport.h>
#import <objc/runtime.h>
#import "NSObject+KXJson.h"

static NSCharacterSet* emojiCharacterSet;


@implementation UIDevice (ALSystemVersion)

+ (float)iOSVersion {
    static float version = 0.f;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        version = [[[UIDevice currentDevice] systemVersion] floatValue];
    });
    return version;
}

@end


@implementation UIApplication (ALAppDimensions)

+ (CGSize)sizeInOrientation:(UIInterfaceOrientation)orientation {
    CGSize size = [UIScreen mainScreen].bounds.size;
    UIApplication *application = [UIApplication sharedApplication];
    if (UIInterfaceOrientationIsLandscape(orientation)) {
        size = CGSizeMake(size.height, size.width);
    }
    if (!application.statusBarHidden && [UIDevice iOSVersion] < 7.0) {
        size.height -= MIN(application.statusBarFrame.size.width, application.statusBarFrame.size.height);
    }
    return size;
}

@end


@implementation NSString(Emoji)

+ (BOOL)isContainsEmoji:(NSString *)string
{
    __block BOOL isEomji = NO;
    
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length]) options: NSStringEnumerationByComposedCharacterSequences usingBlock:
     
     ^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
         
         const unichar hs = [substring characterAtIndex:0];
         // surrogate pair
         
         if (0xd800 <= hs && hs <= 0xdbff) {
             
             if (substring.length > 1) {
                 
                 const unichar ls = [substring characterAtIndex:1];
                 const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                 
                 if (0x1d000 <= uc && uc <= 0x1f77f) {
                     isEomji = YES;
                 }
             }
         }
         else if (substring.length > 1) {
             const unichar ls = [substring characterAtIndex:1];
             
             if (ls == 0x20e3) {
                 isEomji = YES;
             }
         }
         else {
             // non surrogate
             if (0x2100 <= hs && hs <= 0x27ff && hs != 0x263b) {
                 isEomji = YES;
             } else if (0x2B05 <= hs && hs <= 0x2b07) {
                 isEomji = YES;
             } else if (0x2934 <= hs && hs <= 0x2935) {
                 isEomji = YES;
             } else if (0x3297 <= hs && hs <= 0x3299) {
                 isEomji = YES;
             } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50|| hs == 0x231a ) {
                 isEomji = YES;
             }
         }
     }];
    
    return isEomji;
}

@end


//@class OutdoorViewController,IndoorSportViewcontroller;


@implementation Common


//获得title和高度
+ (CGSize)heightForString:(NSString*)title Width:(int)width Font:(UIFont*)font
{
    CGSize constraint_remark = CGSizeMake(width, 9999.f);
    //    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys: font, NSFontAttributeName, nil];
    //    float height = [title sizeWithAttributes:attributes].height;
    //	float height = [title sizeWithFont:font constrainedToSize:constraint_remark lineBreakMode:NSLineBreakByCharWrapping].height;

    return [title sizeWithFont:font constrainedToSize:constraint_remark lineBreakMode:NSLineBreakByCharWrapping];
}

//判断邮箱格式
+ (BOOL)isValidateEmail:(NSString*)email
{
    NSString* emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate* emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

+ (BOOL)isChineseWord:(NSString *)str
{
    BOOL isChinse = NO;
    for(int i=0; i< [str length];i++){
        int a = [str characterAtIndex:i];
        if( a > 0x4e00 && a < 0x9fff)
        {
            return YES;
        }
    }
    return isChinse;
}
//判断网络
+ (BOOL)checkNetworkIsValid
{
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;

    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr*)&zeroAddress);
    SCNetworkReachabilityFlags flags;

    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);

    if (!didRetrieveFlags) {
        return NO;
    }

    BOOL isReachable = flags & kSCNetworkFlagsReachable;
    BOOL needsConnection = flags & kSCNetworkFlagsConnectionRequired;
    // = flags & kSCNetworkReachabilityFlagsIsWWAN;
    BOOL nonWifi = flags & kSCNetworkReachabilityFlagsTransientConnection;
    BOOL moveNet = flags & kSCNetworkReachabilityFlagsIsWWAN;

    return ((isReachable && !needsConnection) || nonWifi || moveNet) ? YES : NO;
}

//判断网络
+ (NetWorkType)checkNetworkIsValidType
{
	struct sockaddr_in zeroAddress;
	bzero(&zeroAddress, sizeof(zeroAddress));
	zeroAddress.sin_len = sizeof(zeroAddress);
	zeroAddress.sin_family = AF_INET;
	SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress); //创建测试连接的引用：
	SCNetworkReachabilityFlags flags;
	SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
	if ((flags & kSCNetworkReachabilityFlagsReachable) == 0)
	{
		return NetWorkType_None;
	}
	NetWorkType retVal = NetWorkType_None;
	if ((flags & kSCNetworkReachabilityFlagsConnectionRequired) == 0)
	{
		retVal = NetWorkType_WIFI;
	}
	if ((((flags & kSCNetworkReachabilityFlagsConnectionOnDemand ) != 0) ||
		 (flags & kSCNetworkReachabilityFlagsConnectionOnTraffic) != 0))
	{
		if ((flags & kSCNetworkReachabilityFlagsInterventionRequired) == 0)
		{
			retVal = NetWorkType_WIFI;
		}
	}
	if ((flags & kSCNetworkReachabilityFlagsIsWWAN) == kSCNetworkReachabilityFlagsIsWWAN)
	{
		if((flags & kSCNetworkReachabilityFlagsReachable) == kSCNetworkReachabilityFlagsReachable) {
			if ((flags & kSCNetworkReachabilityFlagsTransientConnection) == kSCNetworkReachabilityFlagsTransientConnection) {
				retVal = NetWorkType_3G;
				if((flags & kSCNetworkReachabilityFlagsConnectionRequired) == kSCNetworkReachabilityFlagsConnectionRequired) {
					retVal = NetWorkType_2G;
				}
			}
		}
	}
	return retVal;

}

//余数进一
+ (int)getJingYi:(int)chusu BeiChuShu:(int)beichushu
{
    int num = chusu / beichushu;
    num = (chusu % beichushu) > 0 ? num + 1 : num;
    return num;
}

+ (NSString*)getDeviceUUId
{
    CFUUIDRef puuid = CFUUIDCreate(nil);
    CFStringRef uuidString = CFUUIDCreateString(nil, puuid);
    NSString* result = (NSString*)CFStringCreateCopy(NULL, uuidString);
    CFRelease(puuid);
    CFRelease(uuidString);
    return [result autorelease];
}

/**
 * 电话号码判断。
 * @param (NSString *)mobileNum
 */
+ (BOOL)isMobileNumber:(NSString*)mobileNum
{
    BOOL bFlag = NO;
    NSInteger length = [mobileNum length];

    if (length != 7 && length != 8 && length != 11)
        return NO;

    NSScanner* scan = [NSScanner scannerWithString:mobileNum];
    int val;
    bFlag = [scan scanInt:&val] && [scan isAtEnd];
    return bFlag;

    //    if ( [mobileNum length] == 7 || [mobileNum length] == 8 )
    //        return YES;
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString* MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString* CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString* CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189
     22         */ //0\d{2,3}-\d{5,9}|0\d{2,3}-\d{5,9}
    NSString* CT = @"^\\d{8}|\\d{4}-\\d{7,8}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";

    NSPredicate* regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate* regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate* regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate* regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];

    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES)) {
        return YES;
    } else {
        return NO;
    }
}

//判断优惠码
+ (BOOL)digistJudge:(NSString*)strInfo count:(int)count
{
    NSString* strRegex = [NSString stringWithFormat:@"[0-9]{%d}", count]; // @"[0-9]{3}";
    NSPredicate* strPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", strRegex];
    if ([strPre evaluateWithObject:strInfo]) {
        return YES;
    } else
        return NO;
}
 
/*
 dicArray：待排序的NSMutableArray。
 key：按照排序的key。
 yesOrNo：升序或降序排列，yes为升序，no为降序。
 */
+ (void)changeArray:(NSMutableArray*)dicArray orderWithKey:(NSString*)key ascending:(BOOL)yesOrNo
{
    NSSortDescriptor* distanceDescriptor = [[NSSortDescriptor alloc] initWithKey:key ascending:yesOrNo];

    NSArray* descriptors = [NSArray arrayWithObjects:distanceDescriptor, nil];

    [dicArray sortUsingDescriptors:descriptors];

    [distanceDescriptor release];
}

+ (UILabel*)createLabel:(CGRect)rect TextColor:(NSString*)color Font:(UIFont*)font textAlignment:(NSTextAlignment)alignment labTitle:(NSString*)title
{
    UILabel* lab = [[[UILabel alloc] initWithFrame:rect] autorelease];
    lab.backgroundColor = [UIColor clearColor];
    lab.textColor = [CommonImage colorWithHexString:color];
    lab.font = font;
    lab.textAlignment = alignment;
    if (title) {
        lab.text = title;
    }

    return lab;
}

+ (UILabel*)createLabel
{
    UILabel* lab = [[UILabel alloc] init];
    lab.backgroundColor = [UIColor clearColor];
    lab.textAlignment = NSTextAlignmentLeft;
    lab.text = @"";
    return lab;
}

#pragma mark  - 跳过icloud备份
+ (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL
{
    assert([[NSFileManager defaultManager] fileExistsAtPath: [URL path]]);
    
    NSError *error = nil;
    BOOL success = [URL setResourceValue: [NSNumber numberWithBool: YES]
                                  forKey: NSURLIsExcludedFromBackupKey error: &error];
    if(!success){
        NSLog(@"Error excluding %@ from backup %@", [URL lastPathComponent], error);
    }
    return success;
}
#pragma end
+(void)setUpFullseparatorLineWithCell:(UITableViewCell *)cell;
{
    if (IS_OS_8_OR_LATER)//分割线到头
    {
        cell.preservesSuperviewLayoutMargins = NO;
    }
}
//路径
+ (NSString*)datePath
{
    return [NSString stringWithString:[NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches"]];
}

+ (NSString*)datePathLibrary
{
    return [NSString stringWithString:[NSHomeDirectory() stringByAppendingPathComponent:@"Library"]];
}

//图标路径
+ (NSString*)getImagePath
{
    NSString* path = [Common datePath];

    NSString* directory = [NSString stringWithFormat:@"%@/image", path];
    NSFileManager* fileManager = [NSFileManager defaultManager];
    BOOL find = [fileManager fileExistsAtPath:directory];
    if (!find) {
        [fileManager createDirectoryAtPath:directory withIntermediateDirectories:YES attributes:nil error:nil];
    }

    return directory;
}

//音频路径
+ (NSString*)getAudioPath
{
    NSString* path = [Common datePath];
    
    NSString* directory = [NSString stringWithFormat:@"%@/audio", path];
    NSFileManager* fileManager = [NSFileManager defaultManager];
    BOOL find = [fileManager fileExistsAtPath:directory];
    if (!find) {
        [fileManager createDirectoryAtPath:directory withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    return directory;
}

//图片路径
+ (NSString*)getPicPath
{
    return [[Common getImagePath] stringByAppendingFormat:@"/%ld.jpg", [CommonDate getLongTime]];
}

+ (UILabel*)createLabel:(CGRect)rect
{
    UILabel* labTitle = [[[UILabel alloc] initWithFrame:rect] autorelease];
    //	labTitle.center = CGPointMake(160 , 22);
    //	labTitle.textAlignment = UITextAlignmentCenter;
    labTitle.backgroundColor = [UIColor clearColor];
    labTitle.font = [UIFont fontWithName:@"Arial-BoldMT" size:19];
    labTitle.textColor = [CommonImage colorWithHexString:@"#717167"];
    labTitle.shadowColor = [UIColor colorWithWhite:1.f alpha:1.f];
    labTitle.shadowOffset = CGSizeMake(0.3f, 0.8f);
    //    labTitle.shadowBlur = 2.0f;

    return labTitle;
}

+ (UIView*)createTableFooter
{
    //    UIView *myView = [UIView new];

    UIView* view = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 0)] autorelease];
    UIActivityIndicatorView* activi = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(10, 8, 30, 30)];
    activi.tag = tableFooterViewActivityTag;
    [activi startAnimating];
    activi.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    //	view.hidden = YES;
    [view addSubview:activi];
    [activi release];

    UILabel* lab = [[UILabel alloc] initWithFrame:CGRectMake(122, 0, 100, 45)];
	lab.center = CGPointMake(kDeviceWidth/2, 22);
    lab.tag = tableFooterViewLabTag;
    lab.font = [UIFont systemFontOfSize:14];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.backgroundColor = [UIColor clearColor];
    lab.textColor = [CommonImage colorWithHexString:@"#31302f"];
    lab.text = NSLocalizedString(@"加载中...", nil);
    [view addSubview:lab];
    [lab release];

    //    [myView addSubview:view];
    //    [view release];
    return view;
}

+ (MBProgressHUD*)ShowMBProgress:(UIView*)view MSG:(NSString*)msg Mode:(MBProgressHUDMode)mode
{
    MBProgressHUD* progress = [[MBProgressHUD alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, view.frame.size.height)];
    progress.mode = mode;
    //	[view bringSubviewToFront:progress_];
    progress.labelText = msg;
    [progress show:YES];
    [view addSubview:progress];

    return [progress autorelease];
}

+ (void)HideMBProgress:(MBProgressHUD*)progress
{
    if (progress) {
        [progress removeFromSuperview];
        //        [progress release];
        progress = nil;
    }
}

//提示对话框
+ (void)TipDialog2:(NSString*)aInfo
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"提示", nil)
                                                    message:aInfo
                                                   delegate:nil
                                          cancelButtonTitle:NSLocalizedString(@"确定", nil)
                                          otherButtonTitles:nil];
    [alert show];
    [alert release];
}

+ (UIBarButtonItem*)CreateNavBarButton:(id)target setEvent:(SEL)sel setTitle:(NSString*)title
{
    UIButton* but = [[UIButton alloc] init];
    but.tag = 130;
    UIImage* image =  [CommonImage createImageWithColor:[CommonImage colorWithHexString:COLOR_FF5351]];
    [but setBackgroundImage:[image stretchableImageWithLeftCapWidth:5 topCapHeight:5] forState:UIControlStateNormal];
    [but setTitle:title forState:UIControlStateNormal];
    but.layer.cornerRadius = 4;
    but.layer.borderColor = [UIColor colorWithWhite:0 alpha:0.2].CGColor;
    but.layer.borderWidth = .5f;
    [but setTintColor:[CommonImage colorWithHexString:VERSION_TEXT_COLOR]];
    but.titleLabel.font = [UIFont systemFontOfSize:14];
    NSDictionary* attributes = [NSDictionary dictionaryWithObjectsAndKeys:but.titleLabel.font, NSFontAttributeName, nil];
    float widht = 0;
    if (IOS_7) {
        widht = [title sizeWithAttributes:attributes].width + 8;
    } else {
        widht = [Common sizeForString:title andFont:14].width + 8;
    }
    but.frame = CGRectMake(0, 0, MAX(widht, 50), 27);

    [but addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* backBar = [[[UIBarButtonItem alloc] initWithCustomView:but] autorelease];
    [but release];

    return backBar;
}

/**
 *  导航加图片
 *
 *  @param target        目标
 *  @param sel           方法
 *  @param normalImge    正常
 *  @param HighlightImge 高亮
 *
 *  @return UIBarButtonItem
 */
+ (UIBarButtonItem*)createNavBarButton:(id)target setEvent:(SEL)sel withNormalImge:(NSString*)normalImge andHighlightImge:(NSString*)HighlightImge
{
    UIButton* but = [UIButton buttonWithType:UIButtonTypeCustom];
    but.tag = 130;
    but.frame = CGRectMake(0, 0, 31, 44);
    [but addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
    [but setImage:[UIImage imageNamed:normalImge] forState:UIControlStateNormal];
    [but setImage:[UIImage imageNamed:HighlightImge] forState:UIControlStateHighlighted];
    UIBarButtonItem* navBar = [[[UIBarButtonItem alloc] initWithCustomView:but] autorelease];
    return navBar;
}

+ (UIBarButtonItem*)CreateNavBarButton3:(id)target setEvent:(SEL)sel setTitle:(NSString*)title
{
    UIButton* but = [[UIButton alloc] init];
    but.tag = 130;
    [but setTitle:title forState:UIControlStateNormal];
    [but setTitleColor:[CommonImage colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
    but.titleLabel.font = [UIFont systemFontOfSize:17];
    NSDictionary* attributes = [NSDictionary dictionaryWithObjectsAndKeys:but.titleLabel.font, NSFontAttributeName, nil];
    float widht = 0;
    if (IOS_7) {
        widht = [title sizeWithAttributes:attributes].width;
    } else {
        widht = [Common sizeForString:title andFont:17].width;
    }
    but.frame = CGRectMake(0, 0, widht, 44);
    [but addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* backBar = [[[UIBarButtonItem alloc] initWithCustomView:but] autorelease];
    [but release];
    
    return backBar;
}

+ (UIBarButtonItem*)CreateNavBarButton:(id)target setEvent:(SEL)sel background:(NSString*)imageName setTitle:(NSString*)title
{
    UIButton* but = [[UIButton alloc] init];
    but.tag = 130;

    if (imageName) {
        UIImage* image = [UIImage imageNamed:imageName];
        but.frame = CGRectMake(10, 0, image.size.width, 40);

        [but setImage:image forState:UIControlStateNormal];
    } else if (title.length > 0) {
        [but setTitle:title forState:UIControlStateNormal];
        but.layer.cornerRadius = 4;
        [but setTintColor:[CommonImage colorWithHexString:@"#ffffff"]];
        but.titleLabel.font = [UIFont systemFontOfSize:14];
        NSDictionary* attributes = [NSDictionary dictionaryWithObjectsAndKeys:but.titleLabel.font, NSFontAttributeName, nil];
        float height = [title sizeWithAttributes:attributes].height;
        but.frame = CGRectMake(0, 0, height + 5, 40);
    }

    [but addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* backBar = [[[UIBarButtonItem alloc] initWithCustomView:but] autorelease];
    [but release];

    return backBar;
}

+ (UIBarButtonItem*)CreateNavBarButton:(id)target setEvent:(SEL)sel setImage:(NSString*)imageName setTitle:(NSString*)title
{
    UIButton* but = [[UIButton alloc] init];
    but.tag = 130;

    if (imageName) {
        UIImage* image = [UIImage imageNamed:imageName];

        [but setImage:image forState:UIControlStateNormal];
        but.frame = CGRectMake(0, 0, 30, 44);
    }
    if (title.length > 0) {
        [but setTitle:title forState:UIControlStateNormal];
        [but setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [but setTintColor:[CommonImage colorWithHexString:@"#ffffff"]];
        but.titleLabel.font = [UIFont systemFontOfSize:14];
        but.frame = CGRectMake(0, 0, [title sizeWithFont:but.titleLabel.font].width, 27);
    }

    [but addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* backBar = [[[UIBarButtonItem alloc] initWithCustomView:but] autorelease];
    [but release];

    return backBar;
}

+ (int)unicodeLengthOfString:(NSString*)text
{
    NSUInteger asciiLength = 0;

    for (NSUInteger i = 0; i < text.length; i++) {
        unichar uc = [text characterAtIndex:i];
        asciiLength += isascii(uc) ? 1 : 2;
    }

    //    NSUInteger unicodeLength = [text length];

    return (int)asciiLength;
}

+ (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize Image:(UIImage*)image
{
    UIImage* sourceImage = image;
    UIImage* newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);

    if (CGSizeEqualToSize(imageSize, targetSize) == NO) {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;

        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth = width * scaleFactor;
        scaledHeight = height * scaleFactor;

        // center the image
        if (widthFactor > heightFactor) {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        } else if (widthFactor < heightFactor) {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }

    UIGraphicsBeginImageContext(targetSize); // this will crop

    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width = scaledWidth;
    thumbnailRect.size.height = scaledHeight;

    [sourceImage drawInRect:thumbnailRect];

    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if (newImage == nil)
        NSLog(@"could not scale image");

    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}

+ (AppDelegate*)getAppDelegate
{
    return (AppDelegate*)[[UIApplication sharedApplication] delegate];
}

+ (UITextField*)createTextField:(NSString*)title setDelegate:(id)delegate setFont:(float)size
{
    UITextField* text = [[[UITextField alloc] init] autorelease];
    text.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    text.autocapitalizationType = UITextAutocapitalizationTypeNone;
    text.placeholder = title;
    text.delegate = delegate;
    //    text.textAlignment = NSTextAlignmentCenter;
    [text setTextColor:[CommonImage colorWithHexString:@"#666666"]];
    [text setFont:[UIFont systemFontOfSize:size]];

    return text;
}

+ (UserInfoModel*)initWithUserInfoDict:(NSDictionary*)dic
{
    NSLog(@"%@", dic);
    UserInfoModel* userInfomodel = [[UserInfoModel alloc] initWithDic:dic];
    return userInfomodel;
}

//+ (SetInfoModel*)initWithSetInfoDict:(NSDictionary*)dic
//{
//    SetInfoModel* setInfo = [[SetInfoModel alloc] initWithDic:dic];
//    return setInfo;
//}

//yangshuo
+ (CGSize)sizeForString:(NSString*)title andFont:(int)frontSize
{
    UIFont* front = [UIFont systemFontOfSize:frontSize];
    CGSize size;
    if (IOS_7) {
        NSDictionary* attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                                     front,
                                                     NSFontAttributeName,
                                                     nil];
        size = [title sizeWithAttributes:attributes];
    } else {
        size = [title sizeWithFont:front constrainedToSize:CGSizeMake(kDeviceWidth - 50, CGFLOAT_MAX) lineBreakMode:NSLineBreakByCharWrapping];
    }
    return size;
}

+ (CGSize)sizeForAllString:(NSString*)title andFont:(int)frontSize andWight:(int)weight
{
    UIFont* front = [UIFont systemFontOfSize:frontSize];
    CGSize size;
    if (IOS_7) {
        NSDictionary* attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                                     front,
                                                     NSFontAttributeName,
                                                     nil];
        //        size = [title sizeWithAttributes:attributes];
        CGRect rect = [title boundingRectWithSize:CGSizeMake(weight, CGFLOAT_MAX)
                                          options:NSStringDrawingUsesLineFragmentOrigin
                                       attributes:attributes
                                          context:nil];
        size = rect.size;
    } else {
        size = [title sizeWithFont:front constrainedToSize:CGSizeMake(weight, CGFLOAT_MAX) lineBreakMode:NSLineBreakByCharWrapping];
    }
    return size;
}

+ (CGSize)sizeForAllString:(NSString*)title andUIFont:(UIFont *)frontSize andWight:(int)weight
{
    UIFont* front = frontSize;
    CGSize size;
    if (IOS_7) {
        NSDictionary* attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                    front,
                                    NSFontAttributeName,
                                    nil];
        //        size = [title sizeWithAttributes:attributes];
        CGRect rect = [title boundingRectWithSize:CGSizeMake(weight, CGFLOAT_MAX)
                                          options:NSStringDrawingUsesLineFragmentOrigin
                                       attributes:attributes
                                          context:nil];
        size = rect.size;
    } else {
        size = [title sizeWithFont:front constrainedToSize:CGSizeMake(weight, CGFLOAT_MAX) lineBreakMode:NSLineBreakByCharWrapping];
    }
    return size;
}

+ (UILabel*)createLineLabelWithHeight:(int)lineHeight
{
    UILabel* labelLine = [[[UILabel alloc] initWithFrame:CGRectMake(0, lineHeight - 0.5, kDeviceWidth, 0.5)] autorelease];
    labelLine.backgroundColor = [CommonImage colorWithHexString:LINE_COLOR];
//    labelLine.alpha = 0.2f;
    return labelLine;
}

+ (NSMutableArray*)createArrayWithBeginInt:(int)number andWithOverInt:(int)overNumber haveZero:(BOOL)preZero;
{
    NSMutableArray* array = [[[NSMutableArray alloc] init] autorelease];
    for (int i = number; i <= overNumber; i++) {
        NSString* str = nil;
        if (i < 10 && preZero) {
            str = [NSString stringWithFormat:@"0%d", i];
        } else {
            str = [NSString stringWithFormat:@"%d", i];
        }
        [array addObject:str];
    }
    return array;
}

+ (NSDictionary*)getDocPathFileWithName:(NSString*)fileName
{
//    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    //找出文件下所有文件目录
//    NSString* docPath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    NSString* docPath = [Common datePath];
    //找到Docutement目录
    NSString* jsonFile = nil;
    //    NSLog(@"_docPath is %@",docPath);
    if (docPath) {
        jsonFile = [docPath stringByAppendingPathComponent:fileName];
    }
    NSDictionary* dic = nil;
    if ([[NSFileManager defaultManager] fileExistsAtPath:jsonFile]) {
        //==Json数据
        //        NSData *data=[NSData dataWithContentsOfFile:jsonFile];
        NSString* jsonString = [NSString stringWithContentsOfFile:jsonFile encoding:NSUTF8StringEncoding error:nil];
        //        NSString* jsonString = [[NSString alloc] initWithContentsOfFile:jsonFile encoding:NSUTF8StringEncoding error:nil];
        //将字符串写到缓冲区。
        NSData* jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        //解析json数据，使用系统方法 JSONObjectWithData:  options: error:
        dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:nil];
        if (![dic isKindOfClass:[NSDictionary class]])
        {
             dic = [NSDictionary dictionary];
        }
    }
    else
    {
        dic = [NSDictionary dictionary];
    }
    return dic;
}

+ (NSDictionary*)getMainBundlePathFileWithName:(NSString*)fileName
{
    NSString* docPath = [[NSBundle mainBundle] resourcePath];
    //找到Docutement目录
    NSString* jsonFile = nil;
    if (docPath) {
        jsonFile = [docPath stringByAppendingPathComponent:fileName];
    }
    NSDictionary* dic = nil;
    if ([[NSFileManager defaultManager] fileExistsAtPath:jsonFile]) {
        //==Json数据
        NSString* jsonString = [NSString stringWithContentsOfFile:jsonFile encoding:NSUTF8StringEncoding error:nil];
        //将字符串写到缓冲区。
        NSData* jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        //解析json数据，使用系统方法 JSONObjectWithData:  options: error:
        dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:nil];
        if ([dic isKindOfClass:[NSArray class]])
        {
            return dic;
        }
        if (![dic isKindOfClass:[NSDictionary class]])
        {
            dic = [NSDictionary dictionary];
        }
    }
    else
    {
        dic = [NSDictionary dictionary];
    }
    return dic;
}

+ (NSString*)getDocPathFileStringWithName:(NSString*)fileName
{
    NSString* docPath = [Common datePath];
    //找到Docutement目录
    NSString* jsonFile = nil;
    if (docPath) {
        jsonFile = [docPath stringByAppendingPathComponent:fileName];
    }
    NSString* jsonString =@"";
    if ([[NSFileManager defaultManager] fileExistsAtPath:jsonFile]) {
        //==Json数据
        jsonString = [NSString stringWithContentsOfFile:jsonFile encoding:NSUTF8StringEncoding error:nil];
    }
    return jsonString;
}

+ (void)saveFileToDoc:(NSString*)docData  withFileName:(NSString *)fileName
{
//    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString* docPath = [Common datePath];
        //    NSString* docPath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
        NSLog(@"%@", docPath);
        NSString* Json_path = [docPath stringByAppendingPathComponent:fileName];
        //==写入文件
        NSData* contentData = [docData dataUsingEncoding:NSUTF8StringEncoding];
        if ([contentData writeToFile:Json_path atomically:YES]) {
            NSLog(@"写入文件成功 %@", Json_path);
        } else {
            NSLog(@"写入文件失败 %@", Json_path);
        }
    });
}
//yangshuo

+ (NSString*)isNULLString:(NSString*)aString
{
    if ([aString isKindOfClass:[NSString class]]) {
        
        if (!aString || [aString isEqualToString:@"<null>"] || aString.length == 0) {
            return NSLocalizedString(@"无", nil);
        } else {
            return aString;
        }
    }
    else {
        return NSLocalizedString(@"无", nil);
    }
}

+ (NSString*)isNULLString2:(NSString*)aString
{
    if (![aString intValue]) {
        return @"无";
    } else {
        return @"有";
    }
}

+ (NSString*)isNULLString3:(NSString*)aString
{
    if ( [aString isKindOfClass:[NSNull class]] || !aString  || [aString isEqualToString:@"(null)"]) {
        return @"";
    } else {
        return aString;
    }
}

+ (NSString*)isNULLString4:(NSString*)aString
{
    if (!aString || aString.length == 0 || [aString isEqualToString:@"(null)"]) {
        return @"未设置";
    } else {
        return aString;
    }
}

+ (NSString*)isNULLString5:(NSString*)aString
{
    if (!aString || aString.length == 0 || [aString isEqualToString:@"(null)"] || [aString isEqualToString:@"0"]) {
        return @"未记录";
    } else {
        return aString;
    }
}

+ (NSString*)isNULLString7:(NSString*)aString
{
    if ( [aString isKindOfClass:[NSNull class]] || !aString  || [aString isEqualToString:@"(null)"]) {
        return @"0";
    } else {
        return aString;
    }
}


/**
 *  糖尿病类型
 *
 *  @param aString 糖尿病类型
 *
 *  @return 内容
 */

+ (NSString*)isNULLString6:(NSString*)aString
{
    if (!aString || aString.length == 0) {
        return @"未记录";
    }
    NSDictionary* dataDic = [CommonUser getBloodSugarDic1];
    NSString *content = dataDic[aString];
    if (!content.length)
    {
        content = @"无糖尿病";
    }
    return content;
}

+ (NSString*)dataWithString:(NSString*)aString
{
    NSArray * arr = [aString componentsSeparatedByString:@","];
    NSString *content = @"";
    NSDictionary * dic = @{@"FH00001":@"高血压",
                           @"FH00002":@"心脏病",
                           @"FH00003":@"高血糖",
                           @"FH00004":@"低血糖",
                           @"FH00005":@"高血脂",
                           @"FH00006":@"冠心病",
                           @"FH00007":@"糖尿病",
                           @"IH00001":@"心脑血管病",
                           @"IH00002":@"糖尿病",
                           @"IH00003":@"肝炎",
                           @"IH00004":@"肺炎",
                           @"IH00005":@"呼吸道感染"};

    for (int i = 0; i<arr.count; i++) {
        if (!i) {
            if ([[dic allKeys] containsObject:arr[i]]) {
                content = dic[arr[i]];
            }else{
                content = arr[i];
            }
        }else{
            if ([[dic allKeys] containsObject:arr[i]]) {
                content = [NSString stringWithFormat:@"%@,%@",content,dic[arr[i]]];
            }else{
                content = [NSString stringWithFormat:@"%@,%@",content,arr[i]];
            }
        }
    }
    content = [content stringByReplacingOccurrencesOfString:@"definde" withString:@""];

    return content;
}


+ (AdviserInfoModel*)initWithAdviserInfoDict:(NSDictionary*)dic
{
    AdviserInfoModel* adviserInfo = [[AdviserInfoModel alloc] initWithDic:dic];
    return adviserInfo;
}

+ (NSString*)getIDFA
{
    static NSString* gadId = nil;
    if (!gadId) {
        gadId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    }
	return gadId;
}

+ (NSString*)getMacAddress
{
    static NSString* macAddress = nil;
    if (macAddress) {
        return macAddress;
    }

    UIDevice *device = [[UIDevice alloc]init];
    macAddress = device.identifierForVendor.UUIDString;
    [device release];
    
    return macAddress;
}

//过滤标签
+ (NSString*)formatHtmlString:(NSString*)content
{
    //    content是根据网址获得的网页源码字符串
    if (content == nil) {
        return nil;
    } //\\u003cbr/\\u003e
    NSRegularExpression* regularExpretion = [NSRegularExpression regularExpressionWithPattern:@"<[^>]*>"
                                                                                      options:0
                                                                                        error:nil];
    content = [regularExpretion stringByReplacingMatchesInString:content options:NSMatchingReportProgress range:NSMakeRange(0, content.length) withTemplate:@"_"]; //替换所有html和换行匹配元素为"-"
    regularExpretion = [NSRegularExpression regularExpressionWithPattern:@"_{1,}" options:0 error:nil];
    content = [regularExpretion stringByReplacingMatchesInString:content options:NSMatchingReportProgress range:NSMakeRange(0, content.length) withTemplate:@"_"]; //把多个"-"匹配为一个"-"
    //根据"-"分割到数组
    NSArray* arr = [NSArray array];
    content = [NSString stringWithString:content];
    arr = [content componentsSeparatedByString:@"_"];
    NSMutableArray* marr = [NSMutableArray arrayWithArray:arr];
    [marr removeObject:@""];
    NSString* returnString = @"";
    for (NSString* str in marr) {
        returnString = [NSString stringWithFormat:@"%@%@", returnString, str];
    }
    return returnString;
}

+ (void)createAlertViewWithString:(NSString*)tipString withDeleagte:(id)delegate
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"提示", nil)
                                                    message:tipString
                                                   delegate:delegate
                                          cancelButtonTitle:NSLocalizedString(@"确定", nil)
                                          otherButtonTitles:nil];
    [alert show];
    [alert release];
}

+ (BOOL)validateIDCardNumber:(NSString*)value
{
    value = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

    int length = 0;

    if (!value) {
        return NO;
    } else {
        length = (int)value.length;
        if (length != 15 && length != 18) {
            return NO;
        }
    }

    // 省份代码
    NSArray* areasArray = @[ @"11", @"12", @"13", @"14", @"15", @"21", @"22", @"23", @"31", @"32", @"33", @"34", @"35", @"36", @"37", @"41", @"42", @"43", @"44", @"45", @"46", @"50", @"51", @"52", @"53", @"54", @"61", @"62", @"63", @"64", @"65", @"71", @"81", @"82", @"91" ];

    NSString* valueStart2 = [value substringToIndex:2];
    BOOL areaFlag = NO;

    for (NSString* areaCode in areasArray) {
        if ([areaCode isEqualToString:valueStart2]) {
            areaFlag = YES;
            break;
        }
    }

    if (!areaFlag) {
        return false;
    }

    NSRegularExpression* regularExpression;
    NSUInteger numberofMatch;
    int year = 0;

    switch (length) {
    case 15:
        year = [value substringWithRange:NSMakeRange(6, 2)].intValue + 1900;
        if (year % 4 == 0 || (year % 100 == 0 && year % 4 == 0)) {
            regularExpression = [[NSRegularExpression alloc] initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}$"
                                                                     options:NSRegularExpressionCaseInsensitive
                                                                       error:nil]; // 测试生日的合法性
        } else {
            regularExpression = [[NSRegularExpression alloc] initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}$"
                                                                     options:NSRegularExpressionCaseInsensitive
                                                                       error:nil]; // 测试生日的合法性
        }

        numberofMatch = [regularExpression numberOfMatchesInString:value
                                                           options:NSMatchingReportProgress
                                                             range:NSMakeRange(0, value.length)];
        [regularExpression release];

        if (numberofMatch > 0) {
            return YES;
        } else {
            return NO;
        }

    case 18:
        year = [value substringWithRange:NSMakeRange(6, 4)].intValue;
        if (year % 4 == 0 || (year % 100 == 0 && year % 4 == 0)) {
            regularExpression = [[NSRegularExpression alloc] initWithPattern:@"^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}[0-9Xx]$"
                                                                     options:NSRegularExpressionCaseInsensitive
                                                                       error:nil]; // 测试生日的合法性
        } else {
            regularExpression = [[NSRegularExpression alloc] initWithPattern:@"^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}[0-9Xx]$"
                                                                     options:NSRegularExpressionCaseInsensitive
                                                                       error:nil]; // 测试生日的合法性
        }

        numberofMatch = [regularExpression numberOfMatchesInString:value
                                                           options:NSMatchingReportProgress
                                                             range:NSMakeRange(0, value.length)];
        [regularExpression release];

        if (numberofMatch > 0) {
            int S = ([value substringWithRange:NSMakeRange(0, 1)].intValue + [value substringWithRange:NSMakeRange(10, 1)].intValue) * 7 + ([value substringWithRange:NSMakeRange(1, 1)].intValue + [value substringWithRange:NSMakeRange(11, 1)].intValue) * 9 + ([value substringWithRange:NSMakeRange(2, 1)].intValue + [value substringWithRange:NSMakeRange(12, 1)].intValue) * 10 + ([value substringWithRange:NSMakeRange(3, 1)].intValue + [value substringWithRange:NSMakeRange(13, 1)].intValue) * 5 + ([value substringWithRange:NSMakeRange(4, 1)].intValue + [value substringWithRange:NSMakeRange(14, 1)].intValue) * 8 + ([value substringWithRange:NSMakeRange(5, 1)].intValue + [value substringWithRange:NSMakeRange(15, 1)].intValue) * 4 + ([value substringWithRange:NSMakeRange(6, 1)].intValue + [value substringWithRange:NSMakeRange(16, 1)].intValue) * 2 + [value substringWithRange:NSMakeRange(7, 1)].intValue * 1 + [value substringWithRange:NSMakeRange(8, 1)].intValue * 6 + [value substringWithRange:NSMakeRange(9, 1)].intValue * 3;

            int Y = S % 11;
            NSString* M = @"F";
            NSString* JYM = @"10X98765432";
            M = [JYM substringWithRange:NSMakeRange(Y, 1)]; // 判断校验位
            NSString* lastString = [value substringWithRange:NSMakeRange(17, 1)];
            if ([lastString isEqualToString:@"x"]) {
                //                     大小x 都通过
                lastString = @"X";
            }
            if ([M isEqualToString:lastString]) {
                return YES; // 检测ID的校验位
            } else {
                return NO;
            }
        } else {
            return NO;
        }

    default:
        return NO;
    }
}


+ (BOOL)stringContainsEmoji:(NSString*)string
{

    //    if(!emojiCharacterSet){
    NSCharacterSet* doNotWant = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    string = [[string componentsSeparatedByCharactersInSet:doNotWant] componentsJoinedByString:@" "];
    emojiCharacterSet = [NSCharacterSet characterSetWithCharactersInString:@"😄😊😃☺😉😍😘😚😳😌😁😜😝😒😏😓😔😞😖😥😰😨😣😢😭😂😲😱😠😡😪😷👿👽💛💙💜💗💚❤💔💓💘✨🌟💢❕❔💤💨💦🎶🎵🔥💩👍👎👌👊✊✌👋✋👐👆👇👉👈🙌🙏☝👏💪🚶🏃👫💃👯🙆🙅💁🙇💏💑💆💇💅👦👧👩👨👶👵👴👱👲👳👷👮👼👸💂💀👣💋👄👂👀👃☀☔☁⛄🌙⚡🌀🌊🐱🐶🐭🐹🐰🐺🐸🐯🐨🐻🐷🐮🐗🐵🐒🐴🐎🐫🐑🐘🐍🐦🐤🐔🐧🐛🐙🐠🐟🐳🐬💐🌸🌷🍀🌹🌻🌺🍁🍃🍂🌴🌵🌾🐚🎍💝🎎🎒🎓🎏🎆🎇🎐🎑🎃👻🎅🎄🎁🔔🎉🎈💿📀📷🎥💻📺📱📠☎💽📼🔊📢📣📻📡➿🔍🔓🔒🔑✂🔨💡📲📩📫📮🛀🚽💺💰🔱🚬💣🔫💊💉🏈🏀⚽⚾🎾⛳🎱🏊🏄🎿♠♥♣♦🏆👾🎯🀄🎬📝📖🎨🎤🎧🎺🎷🎸〽👟👡👠👢👕👔👗👘👙🎀🎩👑👒🌂💼👜💄💍💎☕🍵🍺🍻🍸🍶🍴🍔🍟🍝🍛🍱🍣🍙🍘🍚🍜🍲🍞🍳🍢🍡🍦🍧🎂🍰🍎🍊🍉🍓🍆🍅🏠🏫🏢🏣🏥🏦🏪🏩🏨💒⛪🏬🌇🌆🏧🏯🏰⛺🏭🗼🗻🌄🌅🌃🗽🌈🎡⛲🎢🚢🚤⛵✈🚀🚲🚙🚗🚕🚌🚓🚒🚑🚚🚃🚉🚄🚅🎫⛽🚥⚠🚧🔰🎰🚏💈♨🏁🎌🇯🇵🇰🇷🇨🇳🇺🇸🇫🇷🇪🇸🇮🇹🇷🇺🇬🇧🇩🇪1⃣2⃣3⃣4⃣5⃣6⃣7⃣8⃣9⃣0⃣#⃣⬆⬇⬅➡↗↖↘↙◀▶⏪⏩🆗🆕🔝🆙🆒🎦🈁📶🈵🈳🉐🈹🈯🈺🈶🈚🈷🈸🈂🚻🚹🚺🚼🚭🅿♿🚇🚾㊙㊗🔞🆔✳✴💟🆚📳📴💹💱♈♉♊♋♌♍♎♏♐♑♒♓⛎🔯🅰🅱🆎🅾🔲🔴🔳🕛🕐🕑🕒🕓🕔🕕🕖🕗🕘🕙🕚⭕❌☀️🌞🌛©®™"];

    //	}

    NSRange range = [string rangeOfCharacterFromSet:emojiCharacterSet options:NSLiteralSearch range:NSMakeRange(0, string.length)];
    if (range.location != NSNotFound) {

        return YES;
    } else {

        return NO;
    }
}

+ (NSData*)uncompressZippedData:(NSData*)compressedData
{
    if ([compressedData length] == 0)
        return compressedData;

    unsigned full_length = (int)[compressedData length];

    unsigned half_length = (int)[compressedData length] / 2;
    NSMutableData* decompressed = [NSMutableData dataWithLength:full_length + half_length];
    BOOL done = NO;
    int status;
    z_stream strm;
    strm.next_in = (Bytef*)[compressedData bytes];
    strm.avail_in = (int)[compressedData length];
    strm.total_out = 0;
    strm.zalloc = Z_NULL;
    strm.zfree = Z_NULL;
    if (inflateInit2(&strm, (15 + 32)) != Z_OK)
        return nil;
    while (!done) {
        // Make sure we have enough room and reset the lengths.
        if (strm.total_out >= [decompressed length]) {
            [decompressed increaseLengthBy:half_length];
        }
        strm.next_out = [decompressed mutableBytes] + strm.total_out;
        strm.avail_out = [decompressed length] - strm.total_out;
        // Inflate another chunk.
        status = inflate(&strm, Z_SYNC_FLUSH);
        if (status == Z_STREAM_END) {
            done = YES;
        } else if (status != Z_OK) {
            break;
        }
    }
    if (inflateEnd(&strm) != Z_OK)
        return nil;
    // Set real length.
    if (done) {
        [decompressed setLength:strm.total_out];
        return [NSData dataWithData:decompressed];
    } else {
        return nil;
    }
}

+ (void)TipDialog:(NSString*)aInfo
{
    [Common TipDialog2:aInfo];
}

+ (int)getVersionWithString:(NSString*)versionString
{
    NSArray* versionArray = [versionString componentsSeparatedByString:@"."];
    if (versionArray.count != 3) {

        return -1;
    }

    int version = [versionArray[0] intValue] * 100 + [versionArray[1] intValue] * 10 + [versionArray[2] intValue];

    return version;
}

//yangshuo
+ (BOOL)isPureInt:(NSString*)string
{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}
//yangshuo

+ (BOOL)isValidPassword:(NSString*)pass
{
    NSCharacterSet* cs;
    cs = [[NSCharacterSet characterSetWithCharactersInString:ONLYALPHANUM] invertedSet];
    NSString* filtered = [[pass componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    BOOL basic = [pass isEqualToString:filtered];
    return basic;
}

//英语
+ (BOOL)isValidEnglish:(NSString*)pass
{
    NSCharacterSet* cs;
    cs = [[NSCharacterSet characterSetWithCharactersInString:ONLYALENGLISH] invertedSet];
    NSString* filtered = [[pass componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    BOOL basic = [pass isEqualToString:filtered];
    return basic;
}

/**
 *  改变frame的size大小
 *
 *  @param rect   原frame
 *  @param width  新的width
 *  @param height 新的height
 *
 *  @return 改变之后的frame
 */
+ (CGRect)rectWithSize:(CGRect)rect width:(CGFloat)width height:(CGFloat)height
{

    CGRect r = rect;
    if (width) {
        r.size.width = width;
    }
    if (height) {
        r.size.height = height;
    }
    return r;
}

/**
 *  改变frame的Origin大小
 *
 *  @param rect   原frame
 *  @param width  新的x
 *  @param height 新的y
 *
 *  @return 改变之后的frame
 */
+ (CGRect)rectWithOrigin:(CGRect)rect x:(CGFloat)x y:(CGFloat)y
{
    CGRect r = rect;
    if (x) {
        r.origin.x = x;
    }
    if (y) {
        r.origin.y = y;
    }
    return r;
}

//+ (NSString*)convertJsonStringWithDict:(NSDictionary*)map
//{
//    SBJsonWriter* writer = [[SBJsonWriter alloc] init];
//    NSString* mapString = [writer stringWithObject:map];
//    [writer release];
//    return mapString;
//}

+ (NSString*)getJibingshiStr:(NSString*)sttr
{
    //FH00002|2012-8-9,FH00002|2013-08-08,definde自定义病|2013-08-08
    if (!sttr | [sttr isEqualToString:@""]) {
        return @"";
    }
    NSLog(@"%@",sttr);
    NSString* pathname = [[NSBundle mainBundle] pathForResource:@"keyValue" ofType:@"txt" inDirectory:@"/"];
    NSString* str = [NSString stringWithContentsOfFile:pathname encoding:NSUTF8StringEncoding error:nil];
    NSDictionary* dic = [str KXjSONValueObject][0];
    NSArray* array = [sttr componentsSeparatedByString:@","];

    NSString* jibing = [NSString string];
    for (NSString* str in array) {
        str = [[str componentsSeparatedByString:@"|"] objectAtIndex:0];
        if (!str.length) {
            continue;
        }
        NSRange ran = [str rangeOfString:@"definde"];
        if (ran.length) {
            str = [str substringFromIndex:ran.length];
            jibing = [jibing stringByAppendingFormat:@"%@,", str];
        } else {
            jibing = [jibing stringByAppendingFormat:@"%@,", [dic objectForKey:str]];
        }
    }
    if([[jibing substringFromIndex:[jibing length]-1] isEqualToString:@","])
    {
        jibing = [jibing substringToIndex:[jibing length]-1];
    }
    return jibing;
}


/**
 *  隐藏多余的分割线
 *
 *  @param tableView 隐藏之后的tableview
 */
+ (void)setExtraCellLineHidden:(UITableView*)tableView
{
    UIView* view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
    [view release];
}

+ (void)playAnimated:(UILabel*)labValue :(float)begin :(float)end :(float)unit :(BOOL)is
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
                       float bg = begin;
                       while (bg < end) {
                           [NSThread sleepForTimeInterval:0.02];
                           //                           sleep(0.5);
                           dispatch_async( dispatch_get_main_queue(), ^(void){
                               if (is) {
                                   labValue.text = [NSString stringWithFormat:@"%.1f", bg];
                               }
                               else {
                                   labValue.text = [NSString stringWithFormat:@"%d", (int)bg];
                               }
                           });
                           bg += unit;
                       }
                       dispatch_async( dispatch_get_main_queue(), ^(void){
                           if (is) {
                               labValue.text = [NSString stringWithFormat:@"%.1f", end];
                           }
                           else {
                               labValue.text = [NSString stringWithFormat:@"%d", (int)end];
                           }
                       });
    });
}

+ (NSString*)getImagePath:(NSString*)path Widht:(float)widht Height:(float)height
{
    NSString* nowPath = [path stringByAppendingString:[NSString stringWithFormat:@"?imageView2/1/w/%.f/h/%.f", widht, height]];
    return nowPath;
}

+(UIView*)creatCellBackView
{
    UIView* imageView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
    imageView.backgroundColor = [CommonImage colorWithHexString:VERSION_LIN_COLOR_QIAN];
    return imageView;
}

//获得设备型号
+ (NSString *)getCurrentDeviceModel
{
    NSString *platform = nil;
    if (!platform) {
        
        int mib[2];
        size_t len;
        
        char *machine;
        
        mib[0] = CTL_HW;
        mib[1] = HW_MACHINE;
        sysctl(mib, 2, NULL, &len, NULL, 0);
        machine = malloc(len);
        sysctl(mib, 2, machine, &len, NULL, 0);
        
        platform = [NSString stringWithCString:machine encoding:NSASCIIStringEncoding];
        free(machine);
        
        if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 2G (A1203)";
        if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G (A1241/A1324)";
        if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS (A1303/A1325)";
        if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4 (A1332)";
        if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone 4 (A1332)";
        if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4 (A1349)";
        if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S (A1387/A1431)";
        if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5 (A1428)";
        if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5 (A1429/A1442)";
        if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5c (A1456/A1532)";
        if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5c (A1507/A1516/A1526/A1529)";
        if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5s (A1453/A1533)";
        if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5s (A1457/A1518/A1528/A1530)";
        if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus (A1522/A1524)";
        if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6 (A1549/A1586)";
        
        if ([platform isEqualToString:@"iPod1,1"])   return @"iPod Touch 1G (A1213)";
        if ([platform isEqualToString:@"iPod2,1"])   return @"iPod Touch 2G (A1288)";
        if ([platform isEqualToString:@"iPod3,1"])   return @"iPod Touch 3G (A1318)";
        if ([platform isEqualToString:@"iPod4,1"])   return @"iPod Touch 4G (A1367)";
        if ([platform isEqualToString:@"iPod5,1"])   return @"iPod Touch 5G (A1421/A1509)";
        
        if ([platform isEqualToString:@"iPad1,1"])   return @"iPad 1G (A1219/A1337)";
        
        if ([platform isEqualToString:@"iPad2,1"])   return @"iPad 2 (A1395)";
        if ([platform isEqualToString:@"iPad2,2"])   return @"iPad 2 (A1396)";
        if ([platform isEqualToString:@"iPad2,3"])   return @"iPad 2 (A1397)";
        if ([platform isEqualToString:@"iPad2,4"])   return @"iPad 2 (A1395+New Chip)";
        if ([platform isEqualToString:@"iPad2,5"])   return @"iPad Mini 1G (A1432)";
        if ([platform isEqualToString:@"iPad2,6"])   return @"iPad Mini 1G (A1454)";
        if ([platform isEqualToString:@"iPad2,7"])   return @"iPad Mini 1G (A1455)";
        
        if ([platform isEqualToString:@"iPad3,1"])   return @"iPad 3 (A1416)";
        if ([platform isEqualToString:@"iPad3,2"])   return @"iPad 3 (A1403)";
        if ([platform isEqualToString:@"iPad3,3"])   return @"iPad 3 (A1430)";
        if ([platform isEqualToString:@"iPad3,4"])   return @"iPad 4 (A1458)";
        if ([platform isEqualToString:@"iPad3,5"])   return @"iPad 4 (A1459)";
        if ([platform isEqualToString:@"iPad3,6"])   return @"iPad 4 (A1460)";
        
        if ([platform isEqualToString:@"iPad4,1"])   return @"iPad Air (A1474)";
        if ([platform isEqualToString:@"iPad4,2"])   return @"iPad Air (A1475)";
        if ([platform isEqualToString:@"iPad4,3"])   return @"iPad Air (A1476)";
        if ([platform isEqualToString:@"iPad4,4"])   return @"iPad Mini 2G (A1489)";
        if ([platform isEqualToString:@"iPad4,5"])   return @"iPad Mini 2G (A1490)";
        if ([platform isEqualToString:@"iPad4,6"])   return @"iPad Mini 2G (A1491)";
        
        if ([platform isEqualToString:@"i386"])      return @"iPhone Simulator";
        if ([platform isEqualToString:@"x86_64"])    return @"iPhone Simulator";
        platform = @"iphone";
    }
    
    return platform;
}

+ (void)MBProgressTishi:(NSString*)title forHeight:(float)height
{
    __block UIView *view = [[UIApplication sharedApplication].windows lastObject];
    __block MBProgressHUD* progress_ = [view viewWithTag:4554];
    if (progress_)
    {
        [progress_ removeFromSuperview];
    }
    progress_ = [[MBProgressHUD alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, height)];
    progress_.labelText = title;
    progress_.mode = MBProgressHUDModeText;
    progress_.userInteractionEnabled = NO;
    [view addSubview:progress_];
    progress_.tag = 4554;
    [progress_ show:YES];
    [progress_ showAnimated:YES whileExecutingBlock:^{
        sleep(1);
    } completionBlock:^{
        [progress_ removeFromSuperview];
        progress_ = nil;
    }];
}

+ (BOOL)textField:(UITextField*)textField replacementString:(NSString*)string
{
    if ([textField.text containsString:@"."]&&[string isEqualToString:@"."]) {
        return NO;
    }
    if ([textField.text isEqualToString:@"0"] && ![string isEqualToString:@"."]) {
        textField.text = string;
        return NO;
    }
    return YES;
}

+ (UIButton*)createKeyboardClean
{
    UIButton*cleanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cleanBtn.frame = CGRectMake(kDeviceWidth-50, kDeviceHeight, 50, 50);
    [cleanBtn setImage:[UIImage imageNamed:@"common.bundle/common/keyClean.png"] forState:UIControlStateNormal];
//    [view.view addSubview:cleanBtn];
    
    return cleanBtn;
}


@end
