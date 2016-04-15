//
//  CommonHttpRequest.m
//  waimaidan
//
//  Created by Mac-Y on 12-12-14.
//
//

#import "CommonHttpRequest.h"
#import "Global.h"
#import "Global_Url.h"

#import "Common.h"
#import "ASIFormDataRequest.h"
//#import "LoadingAnimation.h"
#import "DefauleViewController.h"
#import "AppDelegate.h"
#import <CommonCrypto/CommonDigest.h>

#import <ShareSDK/ShareSDK.h>

@implementation CommonHttpRequest

+ (CommonHttpRequest *)defaultInstance
{
    static CommonHttpRequest *sharedSingleton = nil;
    
    @synchronized(self)
    {
        if ( !sharedSingleton )
            sharedSingleton = [[CommonHttpRequest alloc] init];
        
        return sharedSingleton;
    }
}

- (BOOL)sendHttpRequest:(NSString *)urlStr
             encryptStr:(NSString *)encryptStr
               delegate:(id)delegate
             controller:(id)viewController
           actiViewFlag:(int) actiViewFlag
                  title:(NSString*)title
{
    
    NetWorkType type = [Common checkNetworkIsValidType];
    if(type == NetWorkType_None)
    {
        [Common TipDialog:@"网络请求失败，请检查您的网络设置。"];
        if (delegate&&[delegate respondsToSelector:@selector(didFinishFail:)]) {
            [delegate didFinishFail:nil];
        }
        return NO;
    }
    
    if ( actiViewFlag )
    {
        if (!title || !title.length) {
            title = @"加载中...";
        }
        [self startActiView:viewController :title];
    }
    
    NSString *netType;
    switch (type) {
        case NetWorkType_WIFI:
            netType = @"WIFI";
            break;
        case NetWorkType_2G:
            netType = @"2G";
            break;
        case NetWorkType_3G:
            netType = @"3G";
            break;
        default:
            netType = @"4G";
            break;
    }
    
    
    //    NSString *strEncrypt = [SERVER_URL stringByAppendingFormat:@"%@.xhtml?comefron=ios&clientType=0&oemid=%@&net=%@&idfa=%@&version=%@&phoneCode=%@&channelCode=%@", urlStr, [Common getMacAddress], netType, [Common getIDFA], CFBundleVersion, [Common getCurrentDeviceModel], VERSION_CHANNEL_ID];
    
    NSString * strEncrypt = urlStr;
    NSLog(@"%@", strEncrypt);
//    strEncrypt = [strEncrypt stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:strEncrypt];
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    NSMutableArray *array = [g_winDic objectForKey:[NSString stringWithFormat:@"%x", (unsigned int)delegate]];
    [array addObject:request];
    [request setDefaultResponseEncoding:NSUTF8StringEncoding];
    request.timeOutSeconds = 60;
    request.shouldAttemptPersistentConnection = NO;
    //    request.delegate = delegate;
    request.username = encryptStr;
    WSS(wweakSelf);
    __block __typeof(delegate)weakSelf = delegate;
    __block UIViewController *VCweakSelf = viewController;
    [request setCompletionBlock:^{
        if (actiViewFlag )
        {
            [wweakSelf stopActiViewWith:VCweakSelf];
        }
        @try {
            if ([g_winDic objectForKey:[NSString stringWithFormat:@"%x", (unsigned int)weakSelf]]) {
                if (weakSelf&&[weakSelf respondsToSelector:@selector(didFinishSuccess:)]) {
                    [weakSelf didFinishSuccess:request];
                }
            }
        }
        @catch (NSException *exception) {
            NSLog(@"ENCRYPT_GET_USER_ADDRESS");
        }
    }];
    [request setFailedBlock:^{
        if ( actiViewFlag )
        {
            [wweakSelf stopActiViewWith:VCweakSelf];
        }
        @try {
            if ([g_winDic objectForKey:[NSString stringWithFormat:@"%x", (unsigned int)weakSelf]]) {
                if ([weakSelf respondsToSelector:@selector(didFinishFail:)]) {
                    [weakSelf didFinishFail:request];
                }
            }
        }
        @catch (NSException *exception) {
            NSLog(@"ENCRYPT_GET_USER_ADDRESS");
        }
        //        request = nil;
    }];
    [request startAsynchronous];
    return YES;
}

- (BOOL)sendPostJsonRequest:(NSString*)url
                     values:(NSDictionary*)values
                 requestKey:(NSString *)key
                   delegate:(id)delegate
                 controller:(id)viewController
               actiViewFlag:(int)actiViewFlag
                      title:(NSString*)title
{
    NetWorkType type = [Common checkNetworkIsValidType];
    if(type == NetWorkType_None)
    {
        [Common TipDialog:@"网络请求失败，请检查您的网络设置。"];
        if (delegate&&[delegate respondsToSelector:@selector(didFinishFail:)]) {
            [delegate didFinishFail:nil];
        }
        return NO;
    }
    if ( actiViewFlag )
    {
        [self startActiView:viewController :title];
    }
    
    NSString *netType;
    switch (type) {
        case NetWorkType_WIFI:
            netType = @"WIFI";
            break;
        case NetWorkType_2G:
            netType = @"2G";
            break;
        case NetWorkType_3G:
            netType = @"3G";
            break;
        default:
            netType = @"4G";
            break;
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:values];
    NSString *strURL = url;
    NSLog(@"postURL ===  %@",strURL);
    
    NSAssert([NSJSONSerialization isValidJSONObject:dic], @"Argument must be non-nil");
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:0 error: &error];
    NSMutableData *tempJsonData = [NSMutableData dataWithData:jsonData];
    
    ASIHTTPRequest * formDataRequest = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:strURL]];
    NSMutableArray *array = [g_winDic objectForKey:[NSString stringWithFormat:@"%x", (unsigned int)delegate]];
    [array addObject:formDataRequest];
    
    [formDataRequest setRequestMethod:@"POST"];
    [formDataRequest addRequestHeader:@"Content-Type" value:@"application/json; encoding=utf-8"];
    [formDataRequest addRequestHeader:@"Accept" value:@"application/json"];
    formDataRequest.shouldAttemptPersistentConnection = NO;
    formDataRequest.username = key;
    formDataRequest.timeOutSeconds = 60;
    [formDataRequest setValidatesSecureCertificate:NO];
    [formDataRequest setPostBody:tempJsonData];

    __block __typeof(delegate)weakSelf = delegate;
    __block UIViewController *VCweakSelf = viewController;
     WSS(myWeakSelf);
    [formDataRequest setCompletionBlock:^{
        //        formDataRequest.winCloseIsNoCancle = NO;
        if ( actiViewFlag )
        {
            if ([g_winDic objectForKey:[NSString stringWithFormat:@"%x", (unsigned int)weakSelf]]){
                [myWeakSelf stopActiViewWith:VCweakSelf];
            }
        }
        @try {
            NSString* responseString = [formDataRequest responseString];
            NSDictionary* dic = [responseString KXjSONValueObject];
            NSDictionary *head = [dic objectForKey:@"head"];
            if ([head[@"state"] intValue] == 6001)
            {
                UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"" message:@"用户登录状态错误,请重新登录" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
                [av show];
                [av release];
            }
            else {
                if ([g_winDic objectForKey:[NSString stringWithFormat:@"%x", (unsigned int)weakSelf]]) {
                    if (weakSelf&&[weakSelf respondsToSelector:@selector(didFinishSuccess:)]) {
                        if (!responseString) {
                            [Common TipDialog2:@"系统错误，请稍后重试!"];
                        }else{
                            [weakSelf didFinishSuccess:formDataRequest];
                        }
                    }
                }
                NSArray *array = [head objectForKey:@"pointList"];
                //                array = @[@{@"scores":@"123"}];
                if ([array isKindOfClass:[NSArray class]]) {
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
                        for (NSDictionary *dicItem in array) {
                            @try {
                                __block DefauleViewController *myDefautVC = (DefauleViewController *)(APP_DELEGATE2.window.rootViewController);
                                dispatch_async( dispatch_get_main_queue(), ^(void){
                                    g_nowUserInfo.integral+=[dicItem[@"scores"] intValue];
                                    //                                    [[AccordingView alloc] initWithNumber:[dicItem[@"scores"] intValue] type:dicItem[@"reason"] Nav:((CommonNavViewController *)myDefautVC.m_selectedViewController)];
                                    //                                    [[NSNotificationCenter defaultCenter] postNotificationName:@"notificationToday" object:nil];
                                    //                                        if([myDefautVC respondsToSelector:@selector(tipComment)])
                                    //                                        {
                                    //                                         [myDefautVC tipComment];
                                    //                                        }
                                });
                            }
                            @catch (NSException *exception) {
                                //                            [self setAccordingView:dicItem viewController:viewController];
                            }
                            @finally {
                                
                            }
                            sleep(2);
                        }
                    });
                }
            }
        }
        @catch (NSException *exception) {
            NSLog(@"ENCRYPT_GET_USER_ADDRESS");
        }
    }];
    
    [formDataRequest setFailedBlock:^{//获取错误数据
        //        formDataRequest.winCloseIsNoCancle = NO;
        if ( actiViewFlag )
        {
            if ([g_winDic objectForKey:[NSString stringWithFormat:@"%x", (unsigned int)weakSelf]]){
                [myWeakSelf stopActiViewWith:VCweakSelf];
            }
        }
        NSLog(@"%@", formDataRequest.error);
        @try {
            if ([g_winDic objectForKey:[NSString stringWithFormat:@"%x", (unsigned int)weakSelf]]) {
                if (weakSelf&&[weakSelf respondsToSelector:@selector(didFinishFail:)]) {
                    [weakSelf didFinishFail:formDataRequest];
                }
            }
        }
        @catch (NSException *exception) {
            NSLog(@"ENCRYPT_GET_USER_ADDRESS");
        }
    }];
    
    [formDataRequest startAsynchronous];
    return YES;
}


- (BOOL)sendPostRequest:(NSString*)url
                 values:(NSDictionary*)values
             requestKey:(NSString *)key
               delegate:(id)delegate
             controller:(id)viewController
           actiViewFlag:(int)actiViewFlag
                  title:(NSString*)title
{
    NetWorkType type = [Common checkNetworkIsValidType];
    if(type == NetWorkType_None)
    {
        [Common TipDialog:@"网络请求失败，请检查您的网络设置。"];
        if (delegate&&[delegate respondsToSelector:@selector(didFinishFail:)]) {
            [delegate didFinishFail:nil];
        }
        return NO;
    }
    if ( actiViewFlag )
    {
        [self startActiView:viewController :title];
    }
    
    NSString *netType;
    switch (type) {
        case NetWorkType_WIFI:
            netType = @"WIFI";
            break;
        case NetWorkType_2G:
            netType = @"2G";
            break;
        case NetWorkType_3G:
            netType = @"3G";
            break;
        default:
            netType = @"4G";
            break;
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:values];
    
    //    [dic setObject:@"0" forKey:@"clientType"];
    //    [dic setObject:@"ios" forKey:@"comefron"];
    //    [dic setObject:netType forKey:@"net"];
    //    [dic setObject:[Common getMacAddress] forKey:@"oemid"];
//       [dic setObject:[Common getIDFA] forKey:@"idfa"];
    //    [dic setObject:CFBundleVersion forKey:@"version"];
    //    [dic setObject:@"3" forKey:@"appVersion"];
    //    //    NSLog(@"%@",[Common getCurrentDeviceModel] );
    //    [dic setObject:[Common getCurrentDeviceModel] forKey:@"phoneCode"];//手机型号
    //    [dic setObject:VERSION_CHANNEL_ID forKey:@"channelCode"];//渠道号
    //    NSString *strURL = [NSString stringWithFormat:@"%@%@", SERVER_URL, url];
    //    NSString *strURL = [NSString stringWithFormat:@"%@%@", g_url?g_url:SERVER_URL, url];
    NSString *strURL = url;
    NSLog(@"postURL ===  %@",strURL);
    ASIFormDataRequest * formDataRequest = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:strURL]];
    NSMutableArray *array = [g_winDic objectForKey:[NSString stringWithFormat:@"%x", (unsigned int)delegate]];
    [array addObject:formDataRequest];
    //    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding (kCFStringEncodingGB_2312_80);
    [formDataRequest setDefaultResponseEncoding:NSUTF8StringEncoding];
    [formDataRequest setRequestMethod:@"POST"];
    formDataRequest.shouldAttemptPersistentConnection = NO;
    formDataRequest.username = key;
    formDataRequest.timeOutSeconds = 60;
    //    formDataRequest.delegate = delegate;
    [formDataRequest setValidatesSecureCertificate:NO];
    
    for (NSString * key in [dic allKeys]) {
        [formDataRequest addPostValue:[dic objectForKey:key] forKey:key];
    }
    [formDataRequest buildPostBody];
    __block __typeof(delegate) weakSelf = delegate;
    WSS(weakSelfF);
    __block UIViewController *VCweakSelf = viewController;
    
    [formDataRequest setCompletionBlock:^{
//        formDataRequest.winCloseIsNoCancle = NO;
        if ( actiViewFlag )
        {
            if ([g_winDic objectForKey:[NSString stringWithFormat:@"%x", (unsigned int)weakSelf]]){
                [weakSelfF stopActiViewWith:VCweakSelf];
            }
        }
        @try {
            if ([g_winDic objectForKey:[NSString stringWithFormat:@"%x", (unsigned int)delegate]]) {
                if (delegate&&[delegate respondsToSelector:@selector(didFinishSuccess:)]) {
                    NSString* responseString = [formDataRequest responseString];
                    if (!responseString) {
                        [Common TipDialog2:@"系统错误，请稍后重试!"];
                    }else{
                        [delegate didFinishSuccess:formDataRequest];
                    }
                }
            }
            NSString* responseString = [formDataRequest responseString];
            NSDictionary* dic = [responseString KXjSONValueObject];
            
            NSArray *array = [dic objectForKey:@"pointRs"];
            if (array && array.count) {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
                    for (NSDictionary *dicItem in array) {
                        @try {
                
                        }
                        @catch (NSException *exception) {
                            //                            [self setAccordingView:dicItem viewController:viewController];
                        }
                        @finally {
                            
                        }
                        sleep(2);
                    }
                });
            }
            
        }
        @catch (NSException *exception) {
            NSLog(@"ENCRYPT_GET_USER_ADDRESS");
        }
    }];
    
    [formDataRequest setFailedBlock:^{//获取错误数据
//        formDataRequest.winCloseIsNoCancle = NO;
        if ( actiViewFlag )
        {
            if ([g_winDic objectForKey:[NSString stringWithFormat:@"%x", (unsigned int)weakSelf]]){
                [weakSelfF stopActiViewWith:VCweakSelf];
            }
        }
        NSLog(@"%@", formDataRequest.error);
        @try {
            if ([g_winDic objectForKey:[NSString stringWithFormat:@"%x", (unsigned int)delegate]]) {
                if (delegate&&[delegate respondsToSelector:@selector(didFinishFail:)]) {
                    [delegate didFinishFail:formDataRequest];
                }
            }
        }
        @catch (NSException *exception) {
            NSLog(@"ENCRYPT_GET_USER_ADDRESS");
        }
    }];
    [formDataRequest startAsynchronous];
    return YES;
}


- (void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self performSelector:@selector(qweqwe) withObject:nil afterDelay:0.35];
}

- (void)qweqwe
{
    //    if (g_familyList)
    //    {
    //        [g_familyList release];
    //        g_familyList = nil;
    //    }
    //    DefauleViewController *myDefautVC = (DefauleViewController *)(APP_DELEGATE2.window.rootViewController);
    //    if (![myDefautVC isKindOfClass:[DefauleViewController class]])
    //    {
    //        return;
    //    }
    //    if (g_nowUserInfo.thirdLogin)
    //    {
    //        [ShareSDK cancelAuthWithType:ShareTypeSinaWeibo];
    //        [ShareSDK cancelAuthWithType:ShareTypeQQSpace];
    //        [ShareSDK cancelAuthWithType:ShareTypeWeixiSession];
    //        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"thirdUserInfo"];
    //        [[NSUserDefaults standardUserDefaults] synchronize];
    //        g_nowUserInfo.thirdLogin = NO;
    //    }
    //    g_nowUserInfo = nil;
    //
    //    LoginViewController* LoginViewCon = [[LoginViewController alloc] init];
    //    UIImage* loginViewImage = [CommonImage imageWithView:LoginViewCon.view];
    //    UIImageView* loginView = [[UIImageView alloc] initWithImage:loginViewImage];
    //    loginView.frame = CGRectMake(0, kDeviceHeight + 64, kDeviceWidth, kDeviceHeight + 64);
    //
    //    [((CommonNavViewController *)myDefautVC.m_selectedViewController).view addSubview:loginView];
    //    [loginView release];
    //
    //    [UIView animateWithDuration:0.35
    //                     animations:^{
    //                         CGRect rect = loginView.frame;
    //                         rect.origin.y = 0;
    //                         loginView.frame = rect;
    //                     }
    //                     completion:^(BOOL finished) {
    //                         [loginView removeFromSuperview];
    //                         CommonNavViewController* view1 = [[CommonNavViewController alloc] initWithRootViewController:LoginViewCon];
    //                         [LoginViewCon release];
    //                         APP_DELEGATE.rootViewController = view1;
    //                         [view1 release];
    //                     }];
}


- (NSString *)md5:(NSString *)str isByApp:(BOOL)isBy
{
    //    NSString *dataUTF8 = [[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] stringByAppendingString:@"461de5b941e9622585cc8c184f65aef6"];
    //    dataUTF8 = [dataUTF8 stringByReplacingOccurrencesOfString:@":" withString:@"%3A"];
    //    dataUTF8 = [dataUTF8 stringByReplacingOccurrencesOfString:@"," withString:@"%2C"];
    
    NSString *encodedString = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)str,
                                                              NULL,
                                                              (CFStringRef)@"!'();:@&=+$,/?%#[]",
                                                              kCFStringEncodingUTF8));
    if (isBy) {
        encodedString = [encodedString stringByAppendingString:@"461de5b941e9622585cc8c184f65aef6"];
    }
    
    int length = (int)encodedString.length;
    unsigned char result[16];
    CC_MD5(encodedString.UTF8String, length, result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

- (BOOL)sendNewPostRequest:(NSString*)url
                    values:(NSDictionary*)body
                requestKey:(NSString *)key
                  delegate:(id)delegate
                controller:(id)viewController
              actiViewFlag:(int)actiViewFlag
                     title:(NSString*)title
{
    NetWorkType type = [Common checkNetworkIsValidType];
    if(type == NetWorkType_None)
    {
        [Common TipDialog:@"网络请求失败，请检查您的网络设置。"];
        if (delegate&&[delegate respondsToSelector:@selector(didFinishFail:)]) {
            [delegate didFinishFail:nil];
        }
        return NO;
    }
    if ( actiViewFlag )
    {
        [self startActiView:viewController :title];
    }
    
    NSString *netType;
    switch (type) {
        case NetWorkType_WIFI:
            netType = @"WIFI";
            break;
        case NetWorkType_2G:
            netType = @"2G";
            break;
        case NetWorkType_3G:
            netType = @"3G";
            break;
        default:
            netType = @"4G";
            break;
    }
    
    NSString *sign = [body.KXjSONString stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *md5 = [self md5:sign isByApp:YES];
    
    NSMutableDictionary *head = [NSMutableDictionary dictionary];
    [head setObject:@"IOS" forKey:@"platform"];
    [head setObject:netType forKey:@"net"];
    [head setObject:[Common getMacAddress] forKey:@"oemid"];
    [head setObject:[Common getIDFA] forKey:@"idfa"];
    [head setObject:CFBundleVersion forKey:@"version"];
    [head setObject:md5 forKey:@"sign"];
    [head setObject:[Common getCurrentDeviceModel] forKey:@"phone_code"];//手机型号
    [head setObject:VERSION_CHANNEL_ID forKey:@"partner"];//渠道号
    if ([g_nowUserInfo.userToken length]) {
        [head setObject:g_nowUserInfo.userToken forKey:@"token"];
    }
    
    NSMutableDictionary *dicServer = [[NSMutableDictionary alloc]init];
    [dicServer setObject:head forKey:@"head"];
    [dicServer setObject:body forKey:@"body"];
    
    NSString *strURL = [NSString stringWithFormat:@"%@%@", g_url?g_url:SERVER_URL, url];
    ASIFormDataRequest * formDataRequest = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:strURL]];
    NSMutableArray *array = [g_winDic objectForKey:[NSString stringWithFormat:@"%x", (unsigned int)delegate]];
    [array addObject:formDataRequest];
    [formDataRequest setDefaultResponseEncoding:NSUTF8StringEncoding];
    [formDataRequest setRequestMethod:@"POST"];
    formDataRequest.shouldAttemptPersistentConnection = NO;
    formDataRequest.username = key;
    formDataRequest.timeOutSeconds = 60;
    [formDataRequest setValidatesSecureCertificate:NO];
    [formDataRequest appendPostData:[dicServer.KXjSONString dataUsingEncoding:NSUTF8StringEncoding]];
    [formDataRequest buildPostBody];
    
    __block __typeof(delegate)weakSelf = delegate;
    __block UIViewController *VCweakSelf = viewController;
    //    WS(myWeakSelf);
    [formDataRequest setCompletionBlock:^{
//        formDataRequest.winCloseIsNoCancle = NO;
        if ( actiViewFlag )
        {
            if ([g_winDic objectForKey:[NSString stringWithFormat:@"%x", (unsigned int)weakSelf]]){
                [self stopActiViewWith:VCweakSelf];
            }
        }
        @try {
            NSString* responseString = [formDataRequest responseString];
            NSDictionary* dic = [responseString KXjSONValueObject];
            NSDictionary *head = [dic objectForKey:@"head"];
            if ([head[@"state"] intValue] == 6001)
            {
                UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"" message:@"用户登录状态错误,请重新登录" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
                [av show];
                [av release];
            }
            else {
                if ([g_winDic objectForKey:[NSString stringWithFormat:@"%x", (unsigned int)weakSelf]]) {
                    if (weakSelf&&[weakSelf respondsToSelector:@selector(didFinishSuccess:)]) {
                        if (!responseString) {
                            [Common TipDialog2:@"系统错误，请稍后重试!"];
                        }else{
                            [weakSelf didFinishSuccess:formDataRequest];
                        }
                    }
                }
                NSArray *array = [head objectForKey:@"pointList"];
                //                array = @[@{@"scores":@"123"}];
                if ([array isKindOfClass:[NSArray class]]) {
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
                        for (NSDictionary *dicItem in array) {
                            @try {
                                __block DefauleViewController *myDefautVC = (DefauleViewController *)(APP_DELEGATE2.window.rootViewController);
                                dispatch_async( dispatch_get_main_queue(), ^(void){
                                    g_nowUserInfo.integral+=[dicItem[@"scores"] intValue];
                                    //                                    [[AccordingView alloc] initWithNumber:[dicItem[@"scores"] intValue] type:dicItem[@"reason"] Nav:((CommonNavViewController *)myDefautVC.m_selectedViewController)];
                                    //                                    [[NSNotificationCenter defaultCenter] postNotificationName:@"notificationToday" object:nil];
                                    //                                        if([myDefautVC respondsToSelector:@selector(tipComment)])
                                    //                                        {
                                    //                                         [myDefautVC tipComment];
                                    //                                        }
                                });
                            }
                            @catch (NSException *exception) {
                                //                            [self setAccordingView:dicItem viewController:viewController];
                            }
                            @finally {
                                
                            }
                            sleep(2);
                        }
                    });
                }
            }
        }
        @catch (NSException *exception) {
            NSLog(@"ENCRYPT_GET_USER_ADDRESS");
        }
    }];
    
    [formDataRequest setFailedBlock:^{//获取错误数据
//        formDataRequest.winCloseIsNoCancle = NO;
        if ( actiViewFlag )
        {
            if ([g_winDic objectForKey:[NSString stringWithFormat:@"%x", (unsigned int)weakSelf]]){
                [self stopActiViewWith:VCweakSelf];
            }
        }
        NSLog(@"%@", formDataRequest.error);
        @try {
            if ([g_winDic objectForKey:[NSString stringWithFormat:@"%x", (unsigned int)weakSelf]]) {
                if (weakSelf&&[weakSelf respondsToSelector:@selector(didFinishFail:)]) {
                    [weakSelf didFinishFail:formDataRequest];
                }
            }
        }
        @catch (NSException *exception) {
            NSLog(@"ENCRYPT_GET_USER_ADDRESS");
        }
    }];
    
    [formDataRequest startAsynchronous];
    
    return YES;
}

- (BOOL)sendNewWebPostRequest:(NSString*)url
                       values:(NSDictionary*)body
                   requestKey:(NSString *)key
                     delegate:(id)delegate
                   controller:(id)viewController
                 actiViewFlag:(int)actiViewFlag
                        title:(NSString*)title
{
    NetWorkType type = [Common checkNetworkIsValidType];
    if(type == NetWorkType_None)
    {
        [Common TipDialog:@"网络请求失败，请检查您的网络设置。"];
        if (delegate&&[delegate respondsToSelector:@selector(didFinishFail:)]) {
            [delegate didFinishFail:nil];
        }
        return NO;
    }
    
    if ( actiViewFlag )
    {
        [self startActiView:viewController :title];
    }
    
    long longTime = [CommonDate getLongTime];
    
    NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"@／：；（）¥「」＂、[]{}#%-*+=_\\|~＜＞$€^•'@#$%^&*()_+'\""];
    NSString *trimmedString = [g_nowUserInfo.nickName stringByTrimmingCharactersInSet:set];
    
    NSMutableString *nickname = [[[NSMutableString alloc] initWithString:trimmedString]autorelease];
    NSString *nickname1 = trimmedString;
    if ([Common isChineseWord:nickname1]) {
        if (CFStringTransform((__bridge CFMutableStringRef)nickname, 0, kCFStringTransformMandarinLatin, NO))
        {
            
        }
        if (CFStringTransform((__bridge CFMutableStringRef)nickname, 0, kCFStringTransformStripDiacritics, NO))
        {
            nickname1  = [nickname uppercaseString];
            nickname1 = [nickname1 stringByReplacingOccurrencesOfString:@" " withString:@""];
        }
    }
    
    NSString *str = [NSString stringWithFormat:@"7lk_third%@%@%ld",g_nowUserInfo.userid,nickname1,longTime];
    NSString *dataUTF8 = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *md5 = [self md5:dataUTF8 isByApp:NO];
    
    NSMutableDictionary *dicServer = [NSMutableDictionary dictionary];
    [dicServer setObject:nickname1 forKey:@"nickname"];
    [dicServer setObject:g_nowUserInfo.userid forKey:@"uuid"];
    [dicServer setObject:[NSString stringWithFormat:@"%ld",longTime] forKey:@"time"];
    [dicServer setObject:md5 forKey:@"sign"];
    [dicServer setObject:g_nowUserInfo.sex forKey:@"sex"];
    
    NSString *strURL = @"http://wap.7lk.com/third/kangxunLogin";
    ASIFormDataRequest * formDataRequest = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:strURL]];
    NSMutableArray *array = [g_winDic objectForKey:[NSString stringWithFormat:@"%x", (unsigned int)delegate]];
    [array addObject:formDataRequest];
    [formDataRequest setDefaultResponseEncoding:NSUTF8StringEncoding];
    [formDataRequest setRequestMethod:@"POST"];
    formDataRequest.shouldAttemptPersistentConnection = NO;
    formDataRequest.username = key;
    formDataRequest.timeOutSeconds = 60;
    [formDataRequest setValidatesSecureCertificate:NO];
    for (NSString * key in [dicServer allKeys]) {
        [formDataRequest addPostValue:[dicServer objectForKey:key] forKey:key];
    }
    
    [formDataRequest buildPostBody];
    
    __block UIViewController *VCweakSelf = viewController;
    [formDataRequest setCompletionBlock:^{
//        formDataRequest.winCloseIsNoCancle = NO;
        if ( actiViewFlag )
        {
            [self stopActiViewWith:VCweakSelf];
        }
        @try {
            if ([g_winDic objectForKey:[NSString stringWithFormat:@"%x", (unsigned int)delegate]]) {
                if (delegate&&[delegate respondsToSelector:@selector(didFinishSuccess:)]) {
                    NSString* responseString = [formDataRequest responseString];
                    if (!responseString) {
                        [Common TipDialog2:@"系统错误，请稍后重试!"];
                    }else{
                        [delegate didFinishSuccess:formDataRequest];
                    }
                }
            }
            NSString* responseString = [formDataRequest responseString];
            NSDictionary* dic = [responseString KXjSONValueObject];
            NSDictionary *head = [dic objectForKey:@"head"];
            NSArray *array = [head objectForKey:@"pointList"];
            if (array && array.count) {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
                    for (NSDictionary *dicItem in array) {
                        @try {
                            DefauleViewController *myDefautVC = (DefauleViewController *)(APP_DELEGATE2.window.rootViewController);
                            dispatch_async( dispatch_get_main_queue(), ^(void){
                                //                                [[AccordingView alloc] initWithNumber:[dicItem[@"point"] intValue] type:dicItem[@"content"] Nav:((CommonNavViewController *)myDefautVC.m_selectedViewController)];
                                //                                [[NSNotificationCenter defaultCenter] postNotificationName:@"notificationToday" object:nil];
                            });
                        }
                        @catch (NSException *exception) {
                            //                            [self setAccordingView:dicItem viewController:viewController];
                        }
                        @finally {
                            
                        }
                        sleep(2);
                    }
                });
            }
            
        }
        @catch (NSException *exception) {
            NSLog(@"ENCRYPT_GET_USER_ADDRESS");
        }
        [delegate release];
    }];
    
    [formDataRequest setFailedBlock:^{//获取错误数据
//        formDataRequest.winCloseIsNoCancle = NO;
        if ( actiViewFlag )
        {
            [self stopActiViewWith:VCweakSelf];
        }
        NSLog(@"%@", formDataRequest.error);
        @try {
            if ([g_winDic objectForKey:[NSString stringWithFormat:@"%x", (unsigned int)delegate]]) {
                if (delegate&&[delegate respondsToSelector:@selector(didFinishFail:)]) {
                    [delegate didFinishFail:formDataRequest];
                }
            }
        }
        @catch (NSException *exception) {
            NSLog(@"ENCRYPT_GET_USER_ADDRESS");
        }
        [delegate release];
    }];
    [delegate release];
    
    [formDataRequest startAsynchronous];
    
    return YES;
}



- (BOOL)submitImage:(NSString *)url
             values:(NSDictionary *)values
               Data:(NSData *)data
         requestKey:(NSString *)key
           delegate:(id)delegate
         controller:(id)viewController
       actiViewFlag:(int) actiViewFlag
              title:(NSString*)title
{
    if(![Common checkNetworkIsValid])
    {
        [Common TipDialog:@"网络请求失败，请检查您的网络设置。"];
        return NO;
    }
    if ( actiViewFlag )
    {
        if (!title || !title.length) {
            title = @"加载中...";
        }
        [self startActiView:viewController :title];
    }
    
    NSString *strurl = [SERVER_URL stringByAppendingString:url];
    NSLog(@"%@", strurl);
    strurl = [strurl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    ASIFormDataRequest *dRequest = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:strurl]];
    [dRequest setTimeOutSeconds:60];
    dRequest.username = key;
    [dRequest setDefaultResponseEncoding:NSUTF8StringEncoding];
    
    for (int i = 0; i < [values allKeys].count; i++) {
        [dRequest setPostValue:[[values allValues] objectAtIndex:i] forKey:[[values allKeys] objectAtIndex:i]];
    }
    __block UIViewController *VCweakSelf = viewController;
    [dRequest addData:data withFileName:@"123.png" andContentType:@"multipart" forKey:@"phto"];
    [dRequest setRequestMethod:@"POST"];
    [dRequest buildPostBody];
    [dRequest setCompletionBlock:^{
        if ( actiViewFlag )
        {
            [self stopActiViewWith:VCweakSelf];
        }
        @try {
            if ([g_winDic objectForKey:[NSString stringWithFormat:@"%x", (unsigned int)delegate]]) {
                if (delegate&&[delegate respondsToSelector:@selector(didFinishSuccess:)]) {
                    [delegate didFinishSuccess:dRequest];
                }
                
                NSString* responseString = [dRequest responseString];
                NSDictionary* dic = [responseString KXjSONValueObject];
                
                NSArray *array = [dic objectForKey:@"pointRs"];
                if (array && array.count) {
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
                        for (NSDictionary *dicItem in array) {
                            @try {
                                DefauleViewController *myDefautVC = (DefauleViewController *)(APP_DELEGATE2.window.rootViewController);
                                dispatch_async( dispatch_get_main_queue(), ^(void){
                                    //                                    [[AccordingView alloc] initWithNumber:[dicItem[@"point"] intValue] type:dicItem[@"content"] Nav:((CommonNavViewController *)myDefautVC.m_selectedViewController)];
                                    //                                    [[NSNotificationCenter defaultCenter] postNotificationName:@"notificationToday" object:nil];
                                });
                            }
                            @catch (NSException *exception) {
                                //                                [self setAccordingView:dicItem viewController:viewController];
                            }
                            @finally {
                                
                            }
                            sleep(2);
                        }
                    });
                }
            }
        }
        @catch (NSException *exception) {
            NSLog(@"ENCRYPT_GET_USER_ADDRESS");
        }
        [delegate release];
        //        dRequest = nil;
    }];
    [dRequest setFailedBlock:^{//获取错误数据
        if ( actiViewFlag )
        {
            [self stopActiViewWith:VCweakSelf];
        }
        NSLog(@"%@", dRequest.error);
        @try {
            if ([g_winDic objectForKey:[NSString stringWithFormat:@"%x", (unsigned int)delegate]]) {
                if ([delegate respondsToSelector:@selector(didFinishFail:)]) {
                    [delegate didFinishFail:dRequest];
                }
            }
        }
        @catch (NSException *exception) {
            NSLog(@"ENCRYPT_GET_USER_ADDRESS");
        }
        [delegate release];
        //        dRequest = nil;
    }];
    [dRequest startAsynchronous];
    [delegate release];
    
    return YES;
}

- (void)setAccordingView:(NSDictionary*)dicItem viewController:(id)viewController
{
    //    UIViewController * viewC = viewController;
    //    dispatch_async( dispatch_get_main_queue(), ^(void){
    //        [[AccordingView alloc] initWithNumber:[dicItem[@"point"] intValue] type:dicItem[@"content"] Nav:(CommonNavViewController *)viewC.navigationController];
    //    });
    
}

/**
 * 发送网络请求时，显示旋转轮盘。
 * @param nil
 */
- (void)startActiView:(id)viewController :(NSString*)title
{
    UIView *view = viewController;
    if ([viewController isKindOfClass:[CommonViewController class]]) {
//        view = ((UIViewController*)viewController).view;
        [(CommonViewController *)viewController showLoadingActiview];
    }
    //    if (!m_progress_ )
    //    {
    //        m_progress_ = [Common ShowMBProgress:view MSG:title Mode:MBProgressHUDModeIndeterminate];
    //        m_progress_.alpha = 0.8;
    //    }
//    if(!loadView){
//        loadView = [[LoadingAnimation alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, view.frame.size.height)];
//        loadView.tag = 13333333;
//        [view addSubview:loadView];
//        [loadView release];
//    }
}

/**
 * 停止旋转。
 * @param nil
 */
- (void)stopActiViewWith:(id)viewController
{
    //    if([m_progress_ isKindOfClass:[MBProgressHUD class]] && m_progress_)
    //        [Common HideMBProgress:m_progress_];
    //	m_progress_ = nil;
//    @try {
        UIView *view = viewController;
        if ([viewController isKindOfClass:[UIViewController class]]) {
//            view = ((UIViewController*)viewController).view;
            [(CommonViewController *)viewController stopLoadingActiView];
        }
//        if ([view isKindOfClass:[UIView class]])
//        {
//            loadView = (LoadingAnimation *)[view viewWithTag:13333333];
//            if ( loadView && [loadView isKindOfClass:[LoadingAnimation class]]) {
//                [loadView stopAnimating];
//                //    load.hidden = YES;
//                [loadView removeFromSuperview];
//                loadView = nil;
//            }
//        }
//    }
//    @catch (NSException *exception) {
//        
//    }
//    @finally {
//    }
}

@end
