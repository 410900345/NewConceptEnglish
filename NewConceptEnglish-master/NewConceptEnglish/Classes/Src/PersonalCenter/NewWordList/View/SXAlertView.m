//
//  SXAlertView.m
//  newIdea1.0
//
//  Created by jiuhao-yangshuo on 16/3/29.
//  Copyright © 2016年 YangShuo. All rights reserved.
//

#import "SXAlertView.h"

@interface SXAlertView()<UIAlertViewDelegate>

@end

@implementation SXAlertView
{
    SXBasicBlock    _cancelBlock;
    SXBasicBlock    _confirmBlock;
    UIView *m_view;
    UILabel *titleLabel;
    float m_viewBottomH;//原始的
}

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    }
    return self;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setCancelBlock:(SXBasicBlock)block
{
    _cancelBlock = [block copy];
}

- (void)setConfirmBlock:(SXBasicBlock)block
{
    _confirmBlock = [block copy];
}

- (void)butEventClose
{
    [self hide];
}

- (void)handleSingleTap:(UITapGestureRecognizer *)tap
{
    [self hide];
}

- (void)keyboardWillChangeFrame:(NSNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    // 动画的持续时间
    double duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    // 键盘的frame
    CGRect keyboardF = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGRect keyboardB = [userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    float chengeH =  keyboardB.origin.y -  keyboardF.origin.y;
    //>0 出现键盘 消失键盘
    
    [UIView animateWithDuration:duration animations:^{
        if (chengeH>0 && m_view.bottom > keyboardF.origin.y)
        {
            m_view.bottom =  keyboardF.origin.y;
        }
        if (chengeH < 0) {
            m_view.bottom = m_viewBottomH;
        }
    }];
}

- (void)hide
{
    [UIView animateWithDuration:0.3 animations:^{
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
        m_view.alpha = 0;
        m_view.transform = CGAffineTransformMakeScale(0.5, 0.5);
    } completion:^(BOOL finished) {
        [m_view removeFromSuperview];
        m_view = nil;
        [self removeFromSuperview];
    }];
}

- (void )createShowView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(UI_leftMargin, 0, kDeviceWidth-2*UI_leftMargin, 280)];
    view.backgroundColor = [CommonImage colorWithHexString:@"f5f5f5"];
    view.layer.cornerRadius = 4.0f;
    m_view.userInteractionEnabled = YES;
    m_view = view;
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(butEventClose)];
    [m_view addGestureRecognizer:tap];
    
    //标题
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, view.width-40, 44)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont systemFontOfSize:18];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.text = _alertTitle;
    [view addSubview:titleLabel];
    
    
    UITextField *pwdTextField = [[UITextField alloc]init];
    pwdTextField.frame = CGRectMake(15, titleLabel.bottom+10, view.width-30, 30);
//    pwdTextField.borderStyle = UITextBorderStyleLine;
//    pwdTextField.layer.borderColor = [CommonImage colorWithHexString:COLOR_999999].CGColor;
//    pwdTextField.layer.borderWidth = 0.5;
//    pwdTextField.layer.masksToBounds = YES;
    pwdTextField.backgroundColor = [UIColor whiteColor];
    pwdTextField.placeholder = @"请输入生词本名称(最多20个字符)";
    pwdTextField.font = [UIFont systemFontOfSize:18.0];
    [view addSubview:pwdTextField];
    _contentTextField = pwdTextField;
    [self createFooterViewWithY:pwdTextField.bottom+10];
    
    __weak UITextField *weakSelf = pwdTextField;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf becomeFirstResponder];
    });
}

-(void)createFooterViewWithY:(float)pointY
{
    float buttonW = 60;
    NSArray *titleArr = @[@"取消",@"保存"];
    float pointX = m_view.width-2*buttonW - 20;
    float  buttonH = 44;
    UIButton * determine = nil;
    for (int i = 0; i< 2; i++)
    {
        determine = [UIButton buttonWithType:UIButtonTypeCustom];
        determine.tag = 110+i;
        determine.frame = CGRectMake(pointX + buttonW*i,pointY, buttonW, buttonH);
        [determine addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [determine setTitle:titleArr[i] forState:UIControlStateNormal];
        determine.titleLabel.font = [UIFont systemFontOfSize:18.0];
        [determine setTitleColor:[CommonImage colorWithHexString:Color_Nav] forState:UIControlStateNormal];
        //        determine.layer.cornerRadius = 4;
        //        determine.clipsToBounds = YES;
        [m_view addSubview:determine];
    }
    m_view.frameHeight = determine.bottom + 10;
}

- (void)show
{
    [self createShowView];
    m_view.center = CGPointMake(kDeviceWidth/2, (kDeviceHeight+44)/2);
    m_view.alpha = 0.2;
    m_view.transform = CGAffineTransformMakeScale(0.7, 0.7);
    [self addSubview:m_view];
    
    UIWindow *window = APP_DELEGATE;
    [window addSubview:self];
    
    [UIView animateWithDuration:0.2 animations:^{
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        m_view.alpha = 1;
        m_view.transform = CGAffineTransformMakeScale(1.05, 1.05);
    } completion:^(BOOL f){
        [UIView animateWithDuration:0.1 animations:^{
            m_view.transform = CGAffineTransformIdentity;
            m_viewBottomH = m_view.bottom;
        }];
    }];
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self butEventClose];
}

-(void)btnClick:(UIButton *)btn
{
    switch (btn.tag) {
        case 110:
            [self butEventClose];
            break;
        case 111:
            [self saveDataFunc];
            break;
        default:
            break;
    }
}

+(void)showAlertViewWithTitle:(NSString *)title andConfirmBlock:(SXBasicBlock)confirmBlock andWithCancelBlock:(SXBasicBlock)cancelBlock
{
    SXAlertView *payView = [[self alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight+64)];
    [payView setConfirmBlock:confirmBlock];
    [payView setCancelBlock:cancelBlock];
    payView.alertTitle = title;
    [APP_DELEGATE addSubview:payView];
    [payView show];
}

-(void)saveDataFunc
{
    NSString * content = self.contentTextField.text;
    content =[content trim];
    if (content.length >20)
    {
         [Common MBProgressTishi:@"生词本名称最多20个字" forHeight:kDeviceWidth];
        return;
    }
    if (IsStrEmpty(content))
    {
        [Common MBProgressTishi:@"请输入内容" forHeight:kDeviceWidth];
        return;
    }
    if (_confirmBlock)
    {
        _confirmBlock(content);
    }
    [self hide];
}

@end
