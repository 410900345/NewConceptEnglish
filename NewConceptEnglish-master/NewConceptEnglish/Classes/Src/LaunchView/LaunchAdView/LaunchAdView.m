
//  LaunchAdView.m
//  newIdea1.0
//
//  Created by jiuhao-yangshuo on 15/11/18.
//  Copyright © 2015年 xuGuohong. All rights reserved.
//

#import "LaunchAdView.h"
#import "CommonSet.h"
#import "AdvView.h"
#import "WebViewController.h"
#import "AppDelegate.h"

#define YDaoLeavel     500

static float const kAdDalayTime = 5;
@interface LaunchAdView ()
@property (nonatomic, strong) UIImageView * dmImageView;
@property (nonatomic, strong) NSDictionary * m_adInfo;
@property(nonatomic,strong) AdvView *helpAdView;
@end

@implementation LaunchAdView
{
    UIButton *butClose;
     AppDelegate *myAppdelegate;
}
@synthesize m_adInfo;
@synthesize helpAdView;

- (id)init
{
    self = [super init];
    if (self) {
         myAppdelegate = [Common getAppDelegate];
    }
    return self;
}

- (void)dealloc
{
    TT_RELEASE_SAFELY(_adImageView);
    dimissBlock = nil;
}

- (void)setDismissBlock:(SXBasicBlock)block
{
    if (block != dimissBlock) {
        dimissBlock = [block copy];
    }
}

//-(UIWindow *)yinDWindow
//{
//    if (!_yinDWindow) {
//        _yinDWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
//        _yinDWindow.windowLevel = UIWindowLevelStatusBar+YDaoLeavel;
//        _yinDWindow.backgroundColor = [UIColor clearColor];
//        _yinDWindow.hidden = NO;
//        [_yinDWindow makeKeyAndVisible];
//    }
//    return _yinDWindow;
//}
//
//- (void)showOnWindow:(UIWindow *)window
//{
//    CGRect frame = [UIScreen mainScreen].bounds;
//    if (!IOS_7) {
//        frame.origin.y = 20;
//        frame.size.height-=20;
//    }
//    self.view.frame = frame;
//    [self.yinDWindow addSubview:self.view];
//}

- (void)showOnWindow:(UIWindow *)window
{
//    if (![CommonSet isVipVersion])
//    {
         [self loadtopAdWithType:AdTypeBegin];
//    }
   
    [self.view addSubview:self.dmImageView];
    [window addSubview:self.view];
    [window bringSubviewToFront:self.view];
}

- (UIImageView *)adImageView
{
    if (!_adImageView) {
        _adImageView = [[UIImageView alloc] init];
        CGRect frame = [UIScreen mainScreen].bounds;
        _adImageView.frame = frame;
        _adImageView.contentMode = UIViewContentModeScaleAspectFill;
        NSString *str = @"Default.png";
        if (kDeviceHeight+64 == 568) {
            str = @"LaunchImage-700-568h";// iphone5/5plus
        }
        else if (kDeviceHeight+64 == 667) {
            str = @"LaunchImage-800-667h";// iphone6
        }
        else if (kDeviceHeight+64 == 736) {
            str = @"LaunchImage-800-Portrait-736h";// iphone6 plus
        }
        else {
            str = @"LaunchImage-700";// iphone4 or below
        }
        _adImageView.image = [UIImage imageNamed:str];
        _adImageView.userInteractionEnabled = YES;
    }
    return _adImageView;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
  
//    WS(weakSelf);
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kAdDalayTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [weakSelf dismissAd];
//    });
    [self performSelector:@selector(dismissAd) withObject:nil afterDelay:kAdDalayTime];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.adImageView];
}

-(void)createCloseBtnWithSuperView:(UIView *)superView
{
    UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
    but.frame = CGRectMake(kDeviceWidth - 40 -20, 20, 40, 40);
    
    [but setTitle:@"跳过" forState:UIControlStateNormal];
    but.titleLabel.font = [UIFont systemFontOfSize:14.0];
    but.backgroundColor = [CommonImage colorWithHexString:Color_Nav];
    UIImage* image =  [CommonImage createImageWithColor:[CommonImage colorWithHexString:Color_Nav]];
    [but setBackgroundImage:image forState:UIControlStateNormal];
    UIImage* imageH =  [CommonImage createImageWithColor:[CommonImage colorWithHexString:Color_Nav alpha:0.6]];
    [but setBackgroundImage:imageH forState:UIControlStateHighlighted];
    but.layer.cornerRadius = but.width/2.0;
    but.layer.masksToBounds = YES;
    but.clipsToBounds = YES;
    [but addTarget:self action:@selector(dismissAd) forControlEvents:UIControlEventTouchUpInside];
    [superView addSubview:but];
}

#pragma mark - PrivateMethod
- (void)dismissAd
{
    [self dismissAdWithAnimation:YES];
}

-(void)dismissAdWithAnimation:(BOOL)animation
{
    WS(weakSelf);
    if (helpAdView)
    {
        [helpAdView setUpNilDelegate];
    }
    int timer = animation?0.5:0;
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(dismissAd) object:nil];
    [UIView animateWithDuration:timer
                     animations:^{
                         weakSelf.view.alpha = 0.0;
                     }completion:^(BOOL isFinish){
                         __strong __typeof(weakSelf)strongSelf = weakSelf;
                         if (strongSelf&& strongSelf->dimissBlock) {
                             strongSelf->dimissBlock(nil);
                         }
                         [strongSelf.view removeFromSuperview];
                     }];
}
#pragma mark - NetDelegate
-(void)loadtopAdWithType:(int)adType
{
    WS(weakSelf);
    //创建BmobQuery实例，指定对应要操作的数据表名称
    BmobQuery *query = [BombModel getBombModelWothName:@"WealthAdBean"];
    [query whereKey:@"iosShow" equalTo:@0];
    [query whereKey:@"adType" equalTo:@(adType)];
    
    [query orderByAscending:@"showOrder"];
    query.limit = 1;
    //执行查询
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        //处理查询结果
        [weakSelf handleTopAdWithArray:array withError:error];
    }];
}

-(NSString *)getRandomAdStr
{
    NSArray *adArray = [CommonSet sharedInstance].m_adArray;
    NSString *adStr = @"1KcXde";
    if (adArray.count)
    {
        NSInteger count = adArray.count;
        NSInteger random = arc4random()%count;
        adStr = adArray[random];
    }
    adStr = [CommonSet handleUrlWithStr:adStr];
    return adStr;
}

-(void)handleTopAdWithArray:(NSArray *)array withError:(NSError *)error
{
    if (!array.count)
    {
        NSString *strAd = [self getRandomAdStr];
        [self createAdvertising:strAd];
        return;
    }
    WS(weakSelf);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //存关注的圈子
        NSDictionary *dict =nil;
        if (array.count)
        {
            BmobObject *obj = array[0];
            NSArray *arraySub = [AdvView createAdItemArray];;
            dict = [BombModel getDataFrom:obj withParam:arraySub withDict:nil];
//            [CommonSet saveLoginInfo:dict withKey:kSetAdUrlInfo];
            self.m_adInfo = dict;
            if ([dict[@"fromAd"] boolValue])
            {
                 [CommonSet sharedInstance].m_adDict = dict;
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf createAdvertising:dict[@"imagePath"]];
        });
    });
}

-(void)createAdvertising:(NSString *)url
{
    if (url.length)
    {
        CGRect frame = [UIScreen mainScreen].bounds;
        UIImageView *imageV = [[UIImageView alloc] initWithFrame:frame];
        imageV.userInteractionEnabled = YES;
        [self.view addSubview:imageV];
        
        float offSet = [CommonSet getFrameHightWith6H:100];
        UIImage *placeholderImage = [CommonImage  imageWithView:_adImageView forSize:CGSizeMake(kDeviceWidth, frame.size.height -offSet)];
        
        [imageV sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:placeholderImage];
        imageV.height =frame.size.height -offSet;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissAdAnimation)];//goToAdView
        [imageV addGestureRecognizer:tap];
        
        [self createCloseBtnWithSuperView:self.view];
    }
}

-(void)dismissAdAnimation
{
    [self goToAdView];
    [self dismissAdWithAnimation:NO];
}
//屏蔽加载广告
-(void)goToAdView
{
    if(self.m_adInfo.count)
    {
        helpAdView = [[AdvView alloc] init];
        helpAdView.m_url = self.m_adInfo[kUrlKey];
        helpAdView.title = self.m_adInfo[@"title"];
        helpAdView.m_dicInfo = self.m_adInfo;
        [myAppdelegate.navigationVC pushViewController:helpAdView animated:YES];
        //        [self.view addSubview:helpAdView.view];
        //        [self createCloseBtnWithSuperView:helpAdView.view];
//        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(dismissAd) object:nil];
//        WS(weakSelf);
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kAdDalayTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [weakSelf dismissAd];
//        });
    }
    
}
@end
