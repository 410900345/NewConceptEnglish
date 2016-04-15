//
//  CommonImage.h
//  jiuhaohealth4.0
//
//  Created by 徐国洪 on 15-5-24.
//  Copyright (c) 2015年 xuGuohong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
//#import "SXCustomCheckmark.h"

@interface CommonImage : NSObject


typedef void (^getServerPicBlock)(NSString *dic);

//view生成图片
+ (UIImage*)imageWithView:(UIView*)view;

//view生成图片
+ (UIImage*)screenshotWithView:(UIView*)view;

+ (UIImage*)imageFromView:(UIView*)theView atFrame:(CGRect)rect;

//将屏幕区域截图 生成：
+ (UIImage*)imageWithView:(UIView*)view forSize:(CGSize)size;

//将图片生成一个圈的图
+ (UIImage*)imageWithImage:(UIImage*)image;

//把UIColor对象转化成UIImage对象
+ (UIImage*)createImageWithColor:(UIColor*)color;

//把UIColor对象转化成UIImage对象
+ (UIImage*)createImageWithColor:(UIColor *)color forAlpha:(float)alpha;

//#009900
+ (UIColor*)colorWithHexString:(NSString*)stringToConvert;

+ (UIColor*)colorWithHexString:(NSString*)stringToConvert alpha:(CGFloat)alpha;

/**
 *  返回截图
 */
+ (void)popToNoNavigationView;

//等比例缩放
+ (UIImage *)zoomImage:(UIImage *)image toScale:(CGSize)size;

+ (UIImageView*)creatRightArrowX:(CGFloat)x Y:(CGFloat)y cell:(id)cell;

//设置转折
+ (UIView *)setUpAccessoryType:(UITableViewCellAccessoryType)accessoryType andWithColor:(UIColor *)color;

+ (void)setUpViewImage:(id)view andWithImagePath:(NSString*)imagePath;

+ (void)setImageFromServer:(NSString*)imgUrl View:(id)imageView Type:(int)type;

//设置图片
+ (void)setPicImageQiniu:(NSString*)imgURL View:(id)imageView Type:(int)type Delegate:(getServerPicBlock)block;

+ (void)setViewImageQiniu:(id)view :(UIImage*)image;
+ (BOOL)isMedia;//相机是否允许

//.9 图片转化
+(UIImage*)ninePatchImageByCroppingImage:(UIImage *)image;
@end
