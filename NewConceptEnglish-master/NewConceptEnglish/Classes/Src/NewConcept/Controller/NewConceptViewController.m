//
//  NewConceptViewController.m
//  newIdea1.0
//
//  Created by yangshuo on 15/9/26.
//  Copyright (c) 2015年 xuGuohong. All rights reserved.
//

#import "NewConceptViewController.h"
#import "KXSlideView.h"
#import "NewConceptItemVC.h"

@interface NewConceptViewController()<SlideViewDelegate>

@end

@implementation NewConceptViewController
{
    KXSlideView *slideView;
    NSMutableArray *viewArray;
    int currentPage;//当前选中的下标
    
    UIButton *keyBordButton;
}

#pragma mark -life cycle
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"新概念英语";
        
//        UIBarButtonItem *rightBar = [[UIBarButtonItem alloc] initWithTitle:@"图表 " style:UIBarButtonItemStylePlain target:self action:@selector(butEventQushyi)];
//        self.navigationItem.rightBarButtonItem = rightBar;
        viewArray = [@[]mutableCopy];
    }
    return self;
}

-(void)createKeyBordButton
{
    //用于遮挡操作
    keyBordButton = [UIButton buttonWithType:UIButtonTypeCustom];
    keyBordButton.frame = CGRectMake(0, 0, kDeviceWidth, kDeviceHeight);
    keyBordButton.backgroundColor = [UIColor clearColor];
    [self.view addSubview:keyBordButton];
//    [keyBordButton addTarget:self action:@selector(btnClickHiden:) forControlEvents:UIControlEventTouchUpInside];
    keyBordButton.hidden = YES;
}

- (void)dealloc
{

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.log_pageID = 412;
    // Do any additional setup after loading the view.
    NSArray *titleArray = @[@"第一册",@"第二册",@"第三册",@"第四册"];
    WS(weakSelf);
    for (int i= 0; i< titleArray.count; i++)
    {
        NewConceptItemVC *itemVC= [[NewConceptItemVC alloc] init];
        itemVC.itemBook = i;
        [itemVC setUpNewConceptItemVCBlock:^(id content) {
            [weakSelf changeEnbleSlidView:content];
        }];
        [viewArray addObject:itemVC];
    }
    
    slideView = [[KXSlideView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight) titleScrollViewFrame:
                 CGRectMake(0, 0, kDeviceWidth, 40)];
    slideView.delegate = self;
    slideView.theSlideType = NormalType;
    [slideView setTitleArray:titleArray SourcesArray:viewArray SetDefault:0];
    [self.view addSubview:slideView];
    
    [self createKeyBordButton];
}

-(void)changeEnbleSlidView:(NSString *)objec
{
    BOOL isLoading = YES;
    if (objec.intValue == 0)
    {
        isLoading = NO;
    }
    keyBordButton.hidden = !isLoading;
}
#pragma mark - PrivateMethod
- (BOOL)closeNowView
{
    for (CommonViewController *vc in viewArray)
    {
        [g_winDic removeObjectForKey:[NSString stringWithFormat:@"%x", (unsigned int)vc]];
    }
    return [super closeNowView];
}

- (void)selPageScrollView:(int)page
{
//    currentPage = page;
//    NewConceptItemVC *currentVC = viewArray[page];
//    currentVC.isShowing = YES;
//    if( currentVC.hasLoadSuccessFlag == NO)
//    {
//        [currentVC getDataSource];
//    }
}

@end
