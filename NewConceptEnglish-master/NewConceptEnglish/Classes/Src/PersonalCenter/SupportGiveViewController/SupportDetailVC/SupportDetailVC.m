//
//  SupportDetailVC.m
//  newIdea1.0
//
//  Created by yangshuo on 15/11/14.
//  Copyright © 2015年 xuGuohong. All rights reserved.
//

#import "SupportDetailVC.h"
#import "KXPayManage.h"
#import "SupportModel.h"
#import "CommonSet.h"
//#import "WanPuPayManager.h"
#import "SupportGiveViewController.h"

static NSString *const kDefaultMoney = @"5";

@interface SupportDetailVC ()<UITextFieldDelegate,UIScrollViewDelegate>
{
    UITextField *m_textName;
    UITextField *m_textMoney;
    int m_selectIndex;
    UIScrollView *m_scrollView;
    UIButton *lastBtn;
    NSString *m_cityStr;
}
@end

@implementation SupportDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"友情赞助";
    [self creatView];
    [self getCity];
    
    UIBarButtonItem *sendItem = [[UIBarButtonItem alloc] initWithTitle:@"提交 " style:UIBarButtonItemStylePlain target:self action:@selector(butEventOK)];
    self.navigationItem.rightBarButtonItem = sendItem;
}

-(void)getCity
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *data =[NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://pv.sohu.com/cityjson?ie=utf-8"]];
        NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        if (str.length)
        {
            NSRange raneOne = [str rangeOfString:@"{"];
            NSRange raneTwo = [str rangeOfString:@"}"];
            NSString *subString = [str  substringWithRange:NSMakeRange(raneOne.location-1, raneTwo.location-raneOne.location+2)];
            NSDictionary *dict = [subString KXjSONValueObject];
            m_cityStr = dict[@"cname"];
            NSLog(@"%@",str);
        }
    });
}

- (void)creatView
{
    m_scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight-44)];
    m_scrollView.backgroundColor = [UIColor clearColor];
    m_scrollView.delegate = self;
    [self.view addSubview:m_scrollView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHeaderPicture)];
    [m_scrollView addGestureRecognizer:tap];
    
    UIView*  cleanView= [[UIView alloc] initWithFrame:CGRectMake(UI_spaceToLeft, UI_spaceToLeft, kDeviceWidth -2*UI_spaceToLeft, 90)] ;
    cleanView.backgroundColor = [UIColor whiteColor];
    cleanView.layer.borderWidth = 0.5;
    cleanView.layer.borderColor = [CommonImage colorWithHexString:VERSION_LIN_COLOR_QIAN].CGColor;
    [m_scrollView addSubview:cleanView];
    
    UILabel* labFuwu = [[UILabel alloc] initWithFrame:CGRectMake(UI_spaceToLeft, 0, 50, 45)];
    labFuwu.backgroundColor = [UIColor clearColor];
    labFuwu.textColor = [UIColor blackColor];
    labFuwu.text = NSLocalizedString(@"留名", nil);
    labFuwu.font = [UIFont systemFontOfSize:16];
    [cleanView addSubview:labFuwu];
    
    m_textName = [self createTextField:NSLocalizedString(@"做好事请留名", nil)];
    m_textName.returnKeyType = UIReturnKeyNext;
    m_textName.tag = 201;
    m_textName.clearButtonMode = YES;
    m_textName.frame = CGRectMake(labFuwu.right, 0, cleanView.width -labFuwu.right, 45);
    [cleanView addSubview:m_textName];
    
    UILabel *lineLable = [Common createLineLabelWithHeight:labFuwu.height];
    lineLable.backgroundColor = [CommonImage colorWithHexString:VERSION_LIN_COLOR_QIAN];
    [cleanView addSubview:lineLable];
    
    UILabel* labHuanjing = [[UILabel alloc] initWithFrame:CGRectMake(labFuwu.left, 45, labFuwu.width, 45)];
    labHuanjing.backgroundColor = [UIColor clearColor];
    labHuanjing.textColor = [UIColor blackColor];
    labHuanjing.text = NSLocalizedString(@"赞助", nil);
    labHuanjing.font = [UIFont systemFontOfSize:16];
    [cleanView addSubview:labHuanjing];
    
    m_textMoney = [self createTextField:NSLocalizedString(@"输入金额(元)", nil)];
    m_textMoney.returnKeyType = UIReturnKeyNext;
    m_textMoney.tag = 202;
    m_textMoney.keyboardType = UIKeyboardTypeDecimalPad;
    m_textMoney.delegate = self;
    m_textMoney.clearButtonMode = YES;
    m_textMoney.frame = CGRectMake(m_textName.left, 45, m_textName.width, 45);
    [cleanView addSubview:m_textMoney];
    
    UIView*  cleanViewBottom= [[UIView alloc] initWithFrame:CGRectMake(UI_spaceToLeft, cleanView.bottom +10, kDeviceWidth -2*UI_spaceToLeft, 137)] ;
    cleanViewBottom.backgroundColor = [UIColor whiteColor];
    cleanViewBottom.layer.borderWidth = 0.5;
    cleanViewBottom.layer.borderColor = [CommonImage colorWithHexString:VERSION_LIN_COLOR_QIAN].CGColor;
    [m_scrollView addSubview:cleanViewBottom];
    
    UILabel  *titleLab = [Common createLabel:CGRectMake(15, 0, cleanViewBottom.width -30, 45) TextColor:COLOR_333333 Font:[UIFont systemFontOfSize:16] textAlignment:NSTextAlignmentLeft labTitle:@"请选择你喜欢的颜色"];
    [cleanViewBottom addSubview:titleLab];
    
    NSArray *m_dataArr = [SupportModel getSupportArray];
    CGFloat w,h;
    int count = 5;
    UIButton * backViewBtn = nil;
    CGFloat viewW = (cleanViewBottom.width -2*UI_spaceToLeft)/count,viewH = viewW;
    for (int i = 0; i<m_dataArr.count; i++)
    {
        h = i%count;
        w = i/count;
        backViewBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        backViewBtn.tag = 100+i;
        backViewBtn.frame = CGRectMake(titleLab.left + h * viewW, w * viewH+titleLab.bottom +5, viewW, viewH);
        [cleanViewBottom addSubview:backViewBtn];
        NSString * titleBtn = m_dataArr[i];
        UIImage *backImage = [CommonImage createImageWithColor:[CommonImage colorWithHexString:titleBtn]];
        [backViewBtn setBackgroundImage:backImage forState:UIControlStateNormal];
        [backViewBtn addTarget:self action:@selector(setJumpEvents:) forControlEvents:UIControlEventTouchUpInside];
        
        UIImageView *tickImageView = [[UIImageView alloc] init];
        tickImageView.frame = CGRectMake(3, 3, 22, 22);
        tickImageView.tag = 1555;
        tickImageView.image = [UIImage imageNamed:@"common.bundle/common/selected_off.png"];
        tickImageView.hidden = YES;
        [backViewBtn addSubview:tickImageView];
        
        if (i == 0)
        {
            lastBtn = backViewBtn;
        }
    }
    cleanViewBottom.height = backViewBtn.bottom +15;
    m_scrollView.contentSize = CGSizeMake(kDeviceWidth, cleanViewBottom.bottom);
    [self createSaveBtn:kDeviceHeight -44];
    [self changeBtnSelct:lastBtn withSelect:YES];
}

-(void)tapHeaderPicture
{
    [self HideKeyboard];
}

- (BOOL)textFieldShouldReturn:(UITextField*)textField
{
    switch (textField.tag) {
        case 201:
            [m_textMoney becomeFirstResponder];
            break;
        case 202:
            [self HideKeyboard];
            break;
    }
    return YES;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
     [self HideKeyboard];
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
     [self HideKeyboard];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField*)textField
{
    return YES;
}

- (void)setJumpEvents:(UIButton*)btn
{
    if (btn != lastBtn)
    {
        [self changeBtnSelct:lastBtn withSelect:NO];
        [self changeBtnSelct:btn withSelect:YES];
        lastBtn = btn;
    }
}

-(void)changeBtnSelct:(UIButton *)btn withSelect:(BOOL)select
{
    UIImageView *tickImageView = [btn viewWithTag:1555];
    tickImageView.hidden = !select;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createSaveBtn:(CGFloat)h
{
    UIButton* btn_save = [UIButton buttonWithType:UIButtonTypeCustom];
    btn_save.frame = CGRectMake(0, h, kDeviceWidth, 44);
    [btn_save setTitleColor:[CommonImage colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    [btn_save setTitle:NSLocalizedString(@"提交赞助信息", nil) forState:UIControlStateNormal];
    btn_save.titleLabel.font = [UIFont systemFontOfSize:20];
//    btn_save.layer.cornerRadius = 4;
//    btn_save.clipsToBounds = YES;
    UIImage* image =  [CommonImage createImageWithColor:[CommonImage colorWithHexString:Color_Nav]];
    [btn_save setBackgroundImage:image forState:UIControlStateNormal];
    [btn_save addTarget:self action:@selector(butEventOK) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn_save];
}

- (UITextField*)createTextField:(NSString*)title
{
    UITextField* text = [[UITextField alloc] init];
    text.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    text.contentMode = UIViewContentModeCenter;
    text.autocapitalizationType = UITextAutocapitalizationTypeNone;
    text.placeholder = title;
    //    text.backgroundColor = [UIColor whiteColor];
    text.clearButtonMode = YES;
    text.delegate = self;
    [text setTextColor:[CommonImage colorWithHexString:@"#666666"]];
    [text setFont:[UIFont systemFontOfSize:14]];
    
    return text;
}

- (BOOL)butEventOK
{
    [self HideKeyboard];
    NSString *price = [self handlePrice];
    NSString *versionInfo = [BundleVersion stringByReplacingOccurrencesOfString:@"." withString:@"_"];
    NSString *titleStr = [NSString stringWithFormat:@"赞助%@%@",AppDisplayName,versionInfo];
    WS(weakSelf);
//    [weakSelf handleSupportInfo];return YES;
//    price = @"0.01";
    [[KXPayManage sharePayEngine] paymentWithPrice:price andWithProductName:titleStr andWithDescription:titleStr result:^(id resultDict)
     {
         [weakSelf handleSupportInfo];
    }];
    
//    SXPayObject *wanpu = [[SXPayObject alloc] init];
//    wanpu.goodsInfo = titleStr;
//    wanpu.goodsName = titleStr;
//    wanpu.goodsPrice = price;
//    [[WanPuPayManager sharedInstance] payGoods:wanpu withViewController:self withSXOperationCallBackBlock:^(BOOL isSuccess, NSString *errorMsg) {
//        [weakSelf handleSuccess:isSuccess];
//        NSLog(@"---%d---%@",isSuccess,errorMsg);
//    }];
    
    return YES;
}

-(void)handleSuccess:(BOOL)success
{
    if (!success)
    {
        return;
    }
    else
    {
       [self handleSupportInfo];
    }
//    NSArray *array = self.navigationController.viewControllers;
//    for (CommonViewController *view in array)
//    {
//        if ([view isKindOfClass:[SupportGiveViewController class]])
//        {
//            [self.navigationController popViewControllerAnimated:YES];
//        }
//    }
}

-(NSString *)handlePrice
{
    NSString *price = m_textMoney.text.floatValue ==0? kDefaultMoney:m_textMoney.text;
    if (m_textMoney.text.floatValue <[kDefaultMoney intValue])
    {
        price = kDefaultMoney;
    }
    return price;
}
-(void)handleSupportInfo
{
    BmobObject  *post = [BmobObject objectWithClassName:@"donate"];
    NSString *price = [self handlePrice];
    WS(weakSelf);
    //设置帖子的标题和内容
    [post setObject:[NSNumber numberWithFloat:price.floatValue] forKey:@"money"];
    NSString *nameStr = m_textName.text.length?m_textName.text:@"活雷锋";
    if (m_textName.text.length >60)
    {
        nameStr = [m_textName.text substringToIndex:60];
    }
    NSString *m_cityStrNew = m_cityStr.length?m_cityStr:@"火星";
    [post setObject:nameStr forKey:@"username"];
    [post setObject:m_cityStrNew forKey:@"city"];
    [post setObject:@(SXPlatform) forKey:@"tag"];
     NSString *strOnly=  [Common getMacAddress];
    if (strOnly.length)
    {
        [post setObject:strOnly forKey:@"onlyid"];
    }
    [post setObject:@(lastBtn.tag -100) forKey:@"bgColor"];
    if ([CommonUser isLoginSuccess])
    {
        BmobObject *author = [BmobObject objectWithoutDatatWithClassName:@"MyUser" objectId:g_nowUserInfo.userid];
        [post setObject:author forKey:@"userInfo"];
    }
    //异步保存
    [post saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            //创建成功，返回objectId，updatedAt，createdAt等信息
            //打印objectId
            [weakSelf backView];
            NSLog(@"objectid :%@",post.objectId);
        }else{
            if (error) {
                NSLog(@"%@",error);
            }
        }
    }];
}

-(void)backView
{
    NSMutableDictionary *localDic = [CommonSet getLocalDataPListWithKeyFileName:kSetSystem];
    //初始化数据点击的
    int kBaseStrCout = [localDic[kTipBaseStr] intValue];
    int priceCount =  m_textMoney.text.intValue;
    
    int newBaseCount = kTipBeginNum;
    if (priceCount >= 10 && priceCount < 20)
    {
        newBaseCount = 10;
    }
    else  if (priceCount >= 20 && priceCount < 49)
    {
        newBaseCount = 20;
    }
    else  if (priceCount >= 50)
    {
        newBaseCount = priceCount;
    }
    kBaseStrCout = MAX(newBaseCount, kBaseStrCout);
    [localDic setObject:@(kBaseStrCout) forKey:kTipBaseStr];
    [CommonSet writeToPlist:localDic withFielName:kSetSystem];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)HideKeyboard
{
    [m_textName resignFirstResponder];
    [m_textMoney resignFirstResponder];
}


@end
