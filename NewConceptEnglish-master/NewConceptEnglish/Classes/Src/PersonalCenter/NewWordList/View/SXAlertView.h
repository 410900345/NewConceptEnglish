//
//  SXAlertView.h
//  newIdea1.0
//
//  Created by jiuhao-yangshuo on 16/3/29.
//  Copyright © 2016年 YangShuo. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, SXAlertViewType) {
    SXAlertViewTypeText,
    SXAlertViewTypeCus,
};
@interface SXAlertView : UIView

@property (nonatomic, assign) SXAlertViewType style;
@property (nonatomic, copy)  NSString *alertTitle;
@property (nonatomic, strong)  UITextField *contentTextField;
/*!
 @abstract      点击取消按钮的回调
 @discussion    如果你不想用代理的方式来进行回调，可使用该方法
 @param         block  点击取消后执行的程序块
 */
- (void)setCancelBlock:(SXBasicBlock)block;

/*!
 @abstract      点击确定按钮的回调
 @discussion    如果你不想用代理的方式来进行回调，可使用该方法
 @param         block  点击确定后执行的程序块
 */
- (void)setConfirmBlock:(SXBasicBlock)block;


+ (void)showAlertViewWithTitle:(NSString *)title andConfirmBlock:(SXBasicBlock)confirmBlock andWithCancelBlock:(SXBasicBlock)cancelBlock;

@end
