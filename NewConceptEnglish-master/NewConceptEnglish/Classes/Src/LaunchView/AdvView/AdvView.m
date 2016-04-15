//
//  AdvView.m
//  jiuhaohealth2.1
//
//  Created by 徐国洪 on 14-10-16.
//  Copyright (c) 2014年 xuGuohong. All rights reserved.
//

#import "AdvView.h"
#import "CommonSet.h"

static NSString *const kNotAllowUrl  = @"https://itunes.apple.com";

@interface AdvView ()<UIWebViewDelegate>

@end

@implementation AdvView
{
    UIWebView *newsWebView;
}
@synthesize deledate;
@synthesize m_dicInfo;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
//        self.title = @"详情";
        self.log_pageID = 61;
    }
    return self;
}

- (void)dealloc
{
    m_dicInfo = nil;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [CommonImage colorWithHexString:VERSION_BACKGROUD_COLOR2];
//    if (self.m_isHideNavBar) {
//        [self createCustomNavigation];
//    }
    [self updateEnterNum];//点击量+
    self.m_webView.scalesPageToFit = YES;
}

- (void)updateEnterNum
{
    BmobObject *bmobObject = [BmobObject objectWithoutDatatWithClassName:@"WealthAdBean" objectId:m_dicInfo[@"objectId"]];;
    [bmobObject incrementKey:@"enterIOS"];
    [bmobObject updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            //修改成功后的动作 登陆
            NSLog(@"%@",error);
//            [Common MBProgressTishi:@"修改成功" forHeight:kDeviceHeight];
        } else if (error){
            NSLog(@"%@",error);
        } else {
            NSLog(@"UnKnow error");
        }
    }];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    BOOL isContent = [request.URL.absoluteString containsString:kNotAllowUrl];//识别跳转appstore
    if (m_dicInfo.count && [m_dicInfo[@"download"] intValue] == 0 && UIWebViewNavigationTypeLinkClicked == navigationType &&isContent)//0.是无反应
    {
        return NO;
    }
    return [super webView:webView shouldStartLoadWithRequest:request navigationType:navigationType];
}
//- (void)butEventWebClose
//{
//    if ([deledate respondsToSelector:@selector(removeAdWithDelay:)])
//    {
//        [deledate removeAdWithDelay:NO];
//    }
//}
//
//-(void)createCloseBtn
//{
//    UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
//    but.frame = CGRectMake(newsWebView.width - 40 -20, 20, 40, 40);
//    [but setTitle:@"跳过" forState:UIControlStateNormal];
//    but.titleLabel.font = [UIFont systemFontOfSize:14.0];
//    but.backgroundColor = [CommonImage colorWithHexString:Color_Nav];
//    UIImage* image =  [CommonImage createImageWithColor:[CommonImage colorWithHexString:Color_Nav]];
//    [but setBackgroundImage:image forState:UIControlStateNormal];
//    UIImage* imageH =  [CommonImage createImageWithColor:[CommonImage colorWithHexString:@"155cbb"]];
//    [but setBackgroundImage:imageH forState:UIControlStateHighlighted];
//    but.layer.cornerRadius = but.width/2.0;
//    but.layer.masksToBounds = YES;
//    but.clipsToBounds = YES;
//    [but addTarget:self action:@selector(butEventWebClose) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:but];
//}
//
//- (void)webViewDidFinishLoad:(UIWebView*)webView
//{
//    [self createCloseBtn];
//}

+ (NSArray *)createAdItemArray
{
    NSArray *arraySub =@[@"url",@"imagePath",@"objectId",@"title",@"adType",@"enterNum",@"download"];
    return arraySub;
}
@end
