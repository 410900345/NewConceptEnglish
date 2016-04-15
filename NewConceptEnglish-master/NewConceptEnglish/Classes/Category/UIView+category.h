//
//  UIView+category.h
//  iLearning
//
//  Created by Sidney on 13-9-4.
//  Copyright (c) 2013年 iSoftstone infomation Technology (Group) Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

CGPoint CGRectGetCenterCustom(CGRect rect);
CGRect  CGRectMoveToCenter(CGRect rect, CGPoint center);

@interface UIView (category)

- (BOOL)createPDFfromUIView:(UIView*)aView saveToDocumentsWithFileName:(NSString*)aFilename;
//- (UIImage *)viewToImage:(UIWebView*)webView;
//- (UIImage*)imageWithUIView:(UIView*)view;


//－－－－－－－－－－ frame－－－－－－－－－－－－－－－
@property CGPoint origin;//获得视图的起点坐标
@property CGSize size;//获得视图的宽和高

@property (readonly) CGPoint bottomLeft;
@property (readonly) CGPoint bottomRight;
@property (readonly) CGPoint topRight;

@property CGFloat height;//获得视图的高
@property CGFloat width;//获得视图的宽

@property CGFloat top;//获得视图的顶部y
@property CGFloat left;//获得视图的左部x

@property CGFloat bottom;//获得视图的底部y
@property CGFloat right;//获得视图的右部x


- (void) moveBy: (CGPoint) delta;
- (void) scaleBy: (CGFloat) scaleFactor;
- (void) fitInSize: (CGSize) aSize;

-(UIViewController*)viewController;//------------事件效应者-----------
- (void)removeAllSubviews;
@end

//yangshuo
const static char * kYFJLeftSwipeDeleteTableViewCellIndexPathKey = "YFJLeftSwipeDeleteTableViewCellIndexPathKey";
static const void * cachesIDKey = &cachesIDKey;
static const void * cachesIDKey2 = &cachesIDKey2;
@interface UIButton (NSIndexPath)

- (void)setIndexPath:(NSIndexPath *)indexPath;
- (NSIndexPath *)indexPath;
@property (nonatomic ,copy) NSString *buttonDefultString;

@property (nonatomic, assign) id dicInfo;

@end

//移动导航位置
@interface UINavigationItem (Spacing)

@end

@interface NSString(contain)

-(BOOL)containsString:(NSString *)astring;
//替换字体颜色
+(NSMutableAttributedString *)replaceRedColorWithNSString:(NSString *)str andUseKeyWord:(NSString *)keyWord andWithFontSize:(float )size andWithFrontColor:(NSString *)frontColor;
//替换字体颜色和样式
+(NSMutableAttributedString *)replaceRedColorWithNSString:(NSString *)str andUseKeyWord:(NSString *)keyWord andWithCsutomFont:(UIFont*)font andWithFrontColor:(NSString *)frontColor;

@end

@interface UIImage(triangle)
///  实心三角(颜色2选一)
///
///  @param fillColor    填充颜色
///  @param strokeColor  画笔颜色
///  @param weight       长
///  @param height       高
///  @param strokeWeight 画笔宽
///
///  @return 正三角形
+ (UIImage*)createImageWithFillColor:(UIColor*)fillColor andWithStrokeColor:(UIColor*)strokeColor withWeigt:(float)weight andWithHeight:(float)height andWithStrokeWeight:(float)strokeWeight;
@end

@interface NSMutableDictionary (KKeyRenaming)
- (void)replaceOldKeyy:(id)oldKey withNewKey:(id)newKey;
@end