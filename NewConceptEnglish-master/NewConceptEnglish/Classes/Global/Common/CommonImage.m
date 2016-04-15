//
//  CommonImage.m
//  jiuhaohealth4.0
//
//  Created by 徐国洪 on 15-5-24.
//  Copyright (c) 2015年 xuGuohong. All rights reserved.
//

#import "CommonImage.h"


@implementation CommonImage


//view生成图片
+ (UIImage*)imageWithView:(UIView*)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, [UIScreen mainScreen].scale);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage* img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

//view生成图片
+ (UIImage*)screenshotWithView:(UIView*)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, [UIScreen mainScreen].scale);
    
    if (IOS_7) {
        [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:YES];
    }
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage*)imageFromView:(UIView*)theView atFrame:(CGRect)rect
{
    UIImage* image = [CommonImage screenshotWithView:theView];
    
    rect = CGRectMake(rect.origin.x * image.scale,
                      rect.origin.y * image.scale,
                      rect.size.width * image.scale,
                      rect.size.height * image.scale);
    
    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], rect);
    UIImage* img = [UIImage imageWithCGImage:imageRef scale:image.scale orientation:image.imageOrientation];
    CGImageRelease(imageRef);
    
    return img;
}

//将屏幕区域截图 生成：
+ (UIImage*)imageWithView:(UIView*)view forSize:(CGSize)size
{
    //    UIGraphicsBeginImageContext(size);
    UIGraphicsBeginImageContextWithOptions(size, view.opaque, [UIScreen mainScreen].scale);
    CGContextRef c = UIGraphicsGetCurrentContext();
    //    CGContextTranslateCTM(c, 0, 20);
    [view.layer renderInContext:c];
    UIImage* viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return viewImage;
}

//将图片生成一个圈的图
+ (UIImage*)imageWithImage:(UIImage*)image
{
    CGFloat width = image.size.width;
    CGFloat height = image.size.height;
    
    CGFloat WH = width > height ? height : width;
    
    UIImage* img;
    if (abs((int)(width - height)) > 1) {
        CGRect rect = CGRectMake(MAX((width - height) / 2, 0), MAX((height - width) / 2, 0), WH, WH);
        CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], rect);
        img = [UIImage imageWithCGImage:imageRef];
        CGImageRelease(imageRef);
    } else {
        img = image;
    }
    
    //开始绘制图片
    UIGraphicsBeginImageContext(CGSizeMake(WH, WH));
    CGContextRef gc = UIGraphicsGetCurrentContext();
    
    //创建一个Path
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddArc(path, NULL, WH / 2, WH / 2, WH / 2, 0, DEGREES_TO_RADIANS(360), NO);
    CGContextAddPath(gc, path);
    
    //按照path截出context
    CGContextClip(gc);
    CGPathRelease(path);
    //    CGContextDrawImage(gc, CGRectMake(0, 0, width, height), [image CGImage]);
    [img drawInRect:CGRectMake(0, 0, WH, WH)];
    
    //结束绘画
    UIImage* destImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return destImg;
}

//把UIColor对象转化成UIImage对象
+ (UIImage*)createImageWithColor:(UIColor*)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage* theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return theImage;
}

//把UIColor对象转化成UIImage对象
+ (UIImage*)createImageWithColor:(UIColor *)color forAlpha:(float)alpha
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, alpha);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage* theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return theImage;
}

//#009900
+ (UIColor*)colorWithHexString:(NSString*)stringToConvert
{
    NSString* cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6)
        return [UIColor blackColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    
    if ([cString length] != 6)
        return [UIColor blackColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString* rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString* gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString* bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float)r / 255.0f)
                           green:((float)g / 255.0f)
                            blue:((float)b / 255.0f)
                           alpha:1.0f];
}

+ (UIColor*)colorWithHexString:(NSString*)stringToConvert alpha:(CGFloat)alpha
{
    NSString* cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6)
        return [UIColor blackColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    
    if ([cString length] != 6)
        return [UIColor blackColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString* rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString* gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString* bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float)r / 255.0f)
                           green:((float)g / 255.0f)
                            blue:((float)b / 255.0f)
                           alpha:alpha];
}

/**
 *  返回截图
 */
+ (void)popToNoNavigationView
{
    float y = 0;
    UIImageView* imageViewTest = [[UIImageView alloc] initWithFrame:CGRectMake(0, y, kDeviceWidth, kDeviceHeight + 44)];
    imageViewTest.image = [CommonImage imageWithView:APP_DELEGATE];
    imageViewTest.contentMode = UIViewContentModeTop;
    [APP_DELEGATE addSubview:imageViewTest];
    [imageViewTest release];
    [UIView animateWithDuration:0.35 animations:^{
        imageViewTest.frame = [Common rectWithOrigin:imageViewTest.frame x:kDeviceWidth y:0];
    } completion:^(BOOL finished) {
        [imageViewTest removeFromSuperview];
    }];
}

//等比例缩放
+ (UIImage *)zoomImage:(UIImage *)image toScale:(CGSize)size
{
    //开始绘制图片
    //    UIGraphicsBeginImageContext(size);
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    CGContextRef gc = UIGraphicsGetCurrentContext();
    
    //创建一个Path
    CGMutablePathRef path = CGPathCreateMutable();
    
    //按照path截出context
    CGContextClip(gc);
    CGPathRelease(path);
    //    CGContextDrawImage(gc, CGRectMake(0, 0, width, height), [image CGImage]);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    //结束绘画
    UIImage* destImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return destImg;
}

+ (UIImageView*)creatRightArrowX:(CGFloat)x Y:(CGFloat)y cell:(id)cell
{
    UIImageView*rightView = [[[UIImageView alloc]initWithFrame:CGRectMake(x,y, 13/2, 21/2)]autorelease];
    rightView.image = [UIImage imageNamed:@"common.bundle/common/right_normal.png"];
    //    [cell addSubview:rightView];
    return rightView;
}

//+ (UIView *)setUpAccessoryType:(UITableViewCellAccessoryType)accessoryType andWithColor:(UIColor *)color
//{
//    UIView *view = nil;
//    if(accessoryType == UITableViewCellAccessoryCheckmark){
//        view = [[SXCustomCheckmark alloc] initWithFrame:CGRectMake(0, 0, 15, 15)];
//        [(SXCustomCheckmark *)view setColor:color];
//    }
//    else
//    {
//        view = [[SXDisclosureIndicator alloc] initWithFrame:CGRectMake(0, 0, 10, 14)];
//        [(SXDisclosureIndicator *)view setColor:color];
//    }
//    return view;
//}
//设置图片
+ (void)setPicImageQiniu:(NSString*)imgURL View:(id)imageView Type:(int)type Delegate:(getServerPicBlock)block
{
    CGSize imageSize;
    NSString *dimage = @"";
    if (type == 3) {
        dimage = @"common.bundle/common/conversation_logo.png";
    }
    else {
        switch (type) {
            case 0:
                imageSize = CGSizeMake(80, 80);
                dimage = @"common.bundle/common/center_my-family_head_icon.png";
                break;
            case 1:
                imageSize = ((UIView*)imageView).size;
                dimage = @"common.bundle/common/data_icon_plus.png";
                break;
            case 2:
                imageSize = ((UIView*)imageView).size;
                dimage = @"common.bundle/common/conversation_logo.png";
                break;
            case 4:
                imageSize = ((UIView*)imageView).size;
                dimage = @"common.bundle/common/center_icon_nor.png";
                break;
        }
        
        if ([imgURL length]) {
            imgURL = [Common getImagePath:imgURL Widht:imageSize.width * 2 Height:imageSize.height * 2];
        }
    }
    
    UIImage* image;
    if (![imgURL length]) {
        image = [UIImage imageNamed:dimage];
    } else {
        NSString* strCon = [imgURL stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
        //        NSString * st = [[Common getImagePath] stringByAppendingFormat:@"/%@", strCon];
        image = [UIImage imageWithContentsOfFile:[[Common getImagePath] stringByAppendingFormat:@"/%@", strCon]];
        
        if (!image) {
            image = [UIImage imageNamed:dimage];
            if (strCon) {
                //网络图片 请使用ego异步图片库
                
                UIActivityIndicatorView *activi = [[UIActivityIndicatorView alloc] init];
                activi.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
                activi.tag = 1201;
                UIView *view = imageView;
                activi.center = CGPointMake(view.width/2, view.height/2);
                [activi startAnimating];
                [view addSubview:activi];
                [activi release];
                
                NSString *rul = [imgURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                
                ASIHTTPRequest *dRequest = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:rul]];
                [dRequest setTimeOutSeconds:600];
                [dRequest setCompletionBlock:^{
                    
                    @try {
                        UIActivityIndicatorView *activi = (UIActivityIndicatorView*)[imageView viewWithTag:1201];
                        [activi removeFromSuperview];
                        
                        
                        NSData* data = [dRequest responseData];
                        UIImage *image = [UIImage imageNamed:dimage];
                        if (data) {
                            if (data.length > 10) {
                                [data writeToFile:[[Common getImagePath] stringByAppendingFormat:@"/%@", strCon] atomically:YES];
                                
                                if (block) {
                                    block(strCon);
                                    return ;
                                }
                                else {
                                    image = [UIImage imageWithData:data];
                                    [CommonImage setViewImageQiniu:imageView :image];
                                }
                            }
                        }
                        [CommonImage setViewImageQiniu:imageView :image];
                        
                    }
                    @catch (NSException *exception) {
                        NSLog(@"ENCRYPT_GET_USER_ADDRESS");
                    }
                    //        request = nil;
                }];
                [dRequest setFailedBlock:^{
                    
                    @try {
                        UIActivityIndicatorView *activi = (UIActivityIndicatorView*)[imageView viewWithTag:1201];
                        [activi removeFromSuperview];
                        
                    }
                    @catch (NSException *exception) {
                        NSLog(@"ENCRYPT_GET_USER_ADDRESS");
                    }
                    //        request = nil;
                }];
                //                    [dRequest startSynchronous];
                [dRequest startAsynchronous];

            }
        } else {
            if (block) {
                block(strCon);
            }
        }
    }
    [CommonImage setViewImageQiniu:imageView :image];
}

+ (void)setImageFromServer:(NSString*)imgUrl View:(id)imageView Type:(int)type
{
    //    NSString *imagePath = [imgUrl stringByAppendingString:@"?imageView2/1/w/100/h/100"];
    if (!imgUrl.length)
    {
        imgUrl = @"";
    }
    CGSize imageSize;
    NSString *dimage = @"";
    switch (type) {
        case 0:
           imageSize = ((UIView*)imageView).size;
            dimage = kDefaultImage;
            break;
        case 1:
            imageSize = ((UIView*)imageView).size;
            dimage = @"common.bundle/common/loading_logo.png";
            break;
        case 2:
            imageSize = ((UIView*)imageView).size;
            dimage = @"common.bundle/common/loading_logo.png";
            break;
        case 3:
            imageSize = ((UIView*)imageView).size;
            dimage = kDefaultImage;
            break;
        case 4:
            imageSize = ((UIView*)imageView).size;
            dimage = @"common.bundle/common/center_icon_nor.png";
            break;
        default:
            imageSize = ((UIView*)imageView).size;
            dimage = kDefaultImage;
            break;
    }
    
    
    UIImage *define = [UIImage imageNamed:dimage];
    
    if ([imageView isKindOfClass:[UIButton class]]) {
        [(UIButton*)imageView sd_setImageWithURL:[NSURL URLWithString:imgUrl] forState:UIControlStateNormal placeholderImage:define];
    }
    else{
        [(UIImageView*)imageView sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:define];
    }
}

+ (void)setViewImageQiniu:(id)view :(UIImage*)image
{
    ((UIView*)view).clipsToBounds = YES;
    //    NSLog(@"%@", [view class]);
    if ([view isKindOfClass:[UIButton class]]) {
        UIButton* but = (UIButton*)view;
        
        //        if (but.tag == 100 || but.tag == 101)
        //        {
        [but setImage:image forState:UIControlStateNormal];
        //        }
        //        else
        //        {
        //            [but setBackgroundImage:image forState:UIControlStateNormal];
        //        }
        
    } else if ([view isKindOfClass:[UIImageView class]]) {
        [view setImage:image];
    }
    
}

+ (BOOL)isMedia
{
    NSString *mediaType = AVMediaTypeVideo;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    
    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
        
        NSLog(@"相机权限受限");
        return NO;
    }
    return YES;
}

+ (void)setUpViewImage:(id)view andWithImagePath:(NSString*)imagePath
{
    NSAssert(imagePath.length, @"Argument must be non-nil");
    UIImage *defaul = [UIImage imageNamed:@"common.bundle/common/conversation_logo.png"];
    NSString *imgePath = @"";
    if ([view isKindOfClass:[UIButton class]])
    {
        UIButton* but = (UIButton*)view;
        [but sd_setImageWithURL:[NSURL URLWithString:imgePath] forState:UIControlStateNormal placeholderImage:defaul];
    }
    else if ([view isKindOfClass:[UIImageView class]])
    {
        [view sd_setImageWithURL:[NSURL URLWithString:imgePath] placeholderImage:defaul];
    }
}

+(UIImage*)ninePatchImageByCroppingImage:(UIImage *)image
{
    UIImage *newImage = [[self class] imageByCroppingImage:image WithRect:CGRectMake(0.5, 0.5, image.size.width-1, image.size.height-1)];
    return newImage;
}

+(UIImage*)imageByCroppingImage:(UIImage *)copyImage WithRect:(CGRect)rect
{
    rect = CGRectMake(rect.origin.x * copyImage.scale,
                      rect.origin.y * copyImage.scale,
                      rect.size.width * copyImage.scale,
                      rect.size.height * copyImage.scale);
    
    CGImageRef imageRef = CGImageCreateWithImageInRect([copyImage CGImage], rect);
    UIImage* img = [UIImage imageWithCGImage:imageRef scale:copyImage.scale orientation:copyImage.imageOrientation];
    CGImageRelease(imageRef);
    return img;
}

@end
