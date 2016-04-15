//
//  CommonHttpRequest.h
//  waimaidan
//
//  Created by Mac-Y on 12-12-14.
//
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
#import "MBProgressHUD.h"
#import "NSString+SNFoundation.h"
#import "NSObject+KXJson.h"
//#import "LoadingAnimation.h"


@interface UIViewController(ASIUIViewController)

- (void)didFinishSuccess:(ASIHTTPRequest *)loader;

- (void)didFinishFail:(ASIHTTPRequest *)loader;

@end


@interface CommonHttpRequest : NSObject
{
	MBProgressHUD *m_progress_;
//    LoadingAnimation * loadView;
}

+ (CommonHttpRequest *)defaultInstance;

- (BOOL)sendHttpRequest:(NSString *)urlStr                      // 请求URL地址
             encryptStr:(NSString *)encryptStr                  // 加密字符串
               delegate:(id)delegate                            // 接收应答代理
             controller:(id)viewController                      // 显示旋转条的controller
           actiViewFlag:(int) actiViewFlag                      // 是否显示旋转视图的标识。 0：不显示。 1：显示
                  title:(NSString*)title;

- (BOOL)sendPostJsonRequest:(NSString*)url
                     values:(NSDictionary*)values
                 requestKey:(NSString *)key
                   delegate:(id)delegate
                 controller:(id)viewController
               actiViewFlag:(int)actiViewFlag
                      title:(NSString*)title;

- (BOOL)sendPostRequest:(NSString *)url
                 values:(NSDictionary *)values
             requestKey:(NSString *)key
               delegate:(id)delegate
             controller:(id)viewController
           actiViewFlag:(int) actiViewFlag
                  title:(NSString*)title;

- (BOOL)sendNewPostRequest:(NSString*)url
                    values:(NSDictionary*)body
                requestKey:(NSString *)key
                  delegate:(id)delegate
                controller:(id)viewController
              actiViewFlag:(int)actiViewFlag
                     title:(NSString*)title;


- (BOOL)submitImage:(NSString *)url
             values:(NSDictionary *)values
               Data:(NSData *)data
         requestKey:(NSString *)key
           delegate:(id)delegate
         controller:(id)viewController
       actiViewFlag:(int) actiViewFlag
              title:(NSString*)title;

//请求web
- (BOOL)sendNewWebPostRequest:(NSString*)url
                       values:(NSDictionary*)body
                   requestKey:(NSString *)key
                     delegate:(id)delegate
                   controller:(id)viewController
                 actiViewFlag:(int)actiViewFlag
                        title:(NSString*)title;
@end
