//
//  UIView+category.m
//  iLearning
//
//  Created by Sidney on 13-9-4.
//  Copyright (c) 2013年 iSoftstone infomation Technology (Group) Co.,Ltd. All rights reserved.
//

#import "UIView+category.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import "Common.h"

#define IS_RETINA ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] && ([UIScreen mainScreen].scale == 2.0))

CGPoint CGRectGetCenterCustom(CGRect rect)
{
    CGPoint pt;
    pt.x = CGRectGetMidX(rect);
    pt.y = CGRectGetMidY(rect);
    return pt;
}

CGRect CGRectMoveToCenter(CGRect rect, CGPoint center)
{
    CGRect newrect = CGRectZero;
    newrect.origin.x = center.x-CGRectGetMidX(rect);
    newrect.origin.y = center.y-CGRectGetMidY(rect);
    newrect.size = rect.size;
    return newrect;
}

@implementation UIView (category)


- (BOOL)createPDFfromUIView:(UIView*)aView saveToDocumentsWithFileName:(NSString*)aFilename
{
    UIWebView *webView = (UIWebView*)aView;
    
    int height = webView.scrollView.contentSize.height;
    
    CGFloat screenHeight = webView.bounds.size.height;
    
    int pages = ceil(height / screenHeight);
    
    NSMutableData *pdfData = [NSMutableData data];
    UIGraphicsBeginPDFContextToData(pdfData, webView.bounds, nil);
    CGRect frame = [webView frame];
    for (int i = 0; i < pages; i++) {
        // Check to screenHeight if page draws more than the height of the UIWebView
        if ((i+1) * screenHeight  > height) {
            CGRect f = [webView frame];
            f.size.height -= (((i+1) * screenHeight) - height);
            [webView setFrame: f];
        }
        
        UIGraphicsBeginPDFPage();
        CGContextRef currentContext = UIGraphicsGetCurrentContext();
        //      CGContextTranslateCTM(currentContext, 72, 72); // Translate for 1" margins
        
        [[[webView subviews] lastObject] setContentOffset:CGPointMake(0, screenHeight * i) animated:NO];
        [webView.layer renderInContext:currentContext];
    }
    
    UIGraphicsEndPDFContext();
    // Retrieves the document directories from the iOS device
    NSArray* documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
    
    NSString* documentDirectory = [documentDirectories objectAtIndex:0];
    NSString* documentDirectoryFilename = [documentDirectory stringByAppendingPathComponent:aFilename];
    
    // instructs the mutable data object to write its context to a file on disk
    [pdfData writeToFile:documentDirectoryFilename atomically:YES];
    [webView setFrame:frame];
    return YES;
}

- (UIImage *)webviewToImage:(UIWebView*)webView
{
    int currentWebViewHeight = webView.scrollView.contentSize.height;
    int scrollByY = webView.frame.size.height;
    
    [webView.scrollView setContentOffset:CGPointMake(0, 0)];
    
    NSMutableArray* images = [[NSMutableArray alloc] init];
    
    CGRect screenRect = webView.frame;
    
    int pages = currentWebViewHeight/scrollByY;
    if (currentWebViewHeight%scrollByY > 0) {
        pages ++;
    }
    
    for (int i = 0; i< pages; i++)
    {
        if (i == pages-1) {
            if (pages>1)
                screenRect.size.height = currentWebViewHeight - scrollByY;
        }
        
        if (IS_RETINA)
            UIGraphicsBeginImageContextWithOptions(screenRect.size, NO, 0.0f);
        else
            UIGraphicsBeginImageContext(screenRect.size);
        
        if ([webView.layer respondsToSelector:@selector(setContentsScale:)]) {
            webView.layer.contentsScale = [[UIScreen mainScreen] scale];
        }
        //UIGraphicsBeginImageContext(screenRect.size);
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        [[UIColor blackColor] set];
        CGContextFillRect(ctx, screenRect);
        
        [webView.layer renderInContext:ctx];
        
        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        if (i == 0)
        {
            scrollByY = webView.frame.size.height;
        }
        else
        {
            scrollByY += webView.frame.size.height;
        }
        [webView.scrollView setContentOffset:CGPointMake(0, scrollByY)];
        [images addObject:newImage];
    }
    
    [webView.scrollView setContentOffset:CGPointMake(0, 0)];
    
    UIImage *resultImage;
    
    if(images.count > 1) {
        //join all images together..
        CGSize size ={0,0};
        for(int i=0;i<images.count;i++) {
            
            size.width = MAX(size.width, ((UIImage*)[images objectAtIndex:i]).size.width );
            size.height += ((UIImage*)[images objectAtIndex:i]).size.height;
        }
        
        if (IS_RETINA)
            UIGraphicsBeginImageContextWithOptions(size, NO, 0.0f);
        else
            UIGraphicsBeginImageContext(size);
        if ([webView.layer respondsToSelector:@selector(setContentsScale:)]) {
            webView.layer.contentsScale = [[UIScreen mainScreen] scale];
        }
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        [[UIColor blackColor] set];
        CGContextFillRect(ctx, screenRect);
        
        int y=0;
        for(int i=0;i<images.count;i++) {
            
            UIImage* img = [images objectAtIndex:i];
            [img drawAtPoint:CGPointMake(0,y)];
            y += img.size.height;
        }
        
        resultImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    } else {
        
        resultImage = [images objectAtIndex:0];
    }
    [images removeAllObjects];
    return resultImage;
}

//----------------------------

// Retrieve and set the origin
- (CGPoint) origin
{
	return self.frame.origin;
}

- (void) setOrigin: (CGPoint) aPoint
{
	CGRect newframe = self.frame;
	newframe.origin = aPoint;
	self.frame = newframe;
}


// Retrieve and set the size
- (CGSize) size
{
	return self.frame.size;
}

- (void) setSize: (CGSize) aSize
{
	CGRect newframe = self.frame;
	newframe.size = aSize;
	self.frame = newframe;
}

// Query other frame locations
- (CGPoint) bottomRight
{
	CGFloat x = self.frame.origin.x + self.frame.size.width;
	CGFloat y = self.frame.origin.y + self.frame.size.height;
	return CGPointMake(x, y);
}

- (CGPoint) bottomLeft
{
	CGFloat x = self.frame.origin.x;
	CGFloat y = self.frame.origin.y + self.frame.size.height;
	return CGPointMake(x, y);
}

- (CGPoint) topRight
{
	CGFloat x = self.frame.origin.x + self.frame.size.width;
	CGFloat y = self.frame.origin.y;
	return CGPointMake(x, y);
}

// Retrieve and set height, width, top, bottom, left, right
//获得视图的高
- (CGFloat) height
{
	return self.frame.size.height;
}

- (void) setHeight: (CGFloat) newheight
{
	CGRect newframe = self.frame;
	newframe.size.height = newheight;
	self.frame = newframe;
}

//获得视图的宽
- (CGFloat) width
{
	return self.frame.size.width;
}

- (void) setWidth: (CGFloat) newwidth
{
	CGRect newframe = self.frame;
	newframe.size.width = newwidth;
	self.frame = newframe;
}

//获得视图的顶部y
- (CGFloat) top
{
	return self.frame.origin.y;
}

- (void) setTop: (CGFloat) newtop
{
	CGRect newframe = self.frame;
	newframe.origin.y = newtop;
	self.frame = newframe;
}

//获得视图的左部x
- (CGFloat) left
{
	return self.frame.origin.x;
}

- (void) setLeft: (CGFloat) newleft
{
	CGRect newframe = self.frame;
	newframe.origin.x = newleft;
	self.frame = newframe;
}

//获得视图的底部y
- (CGFloat) bottom
{
	return self.frame.origin.y + self.frame.size.height;
}

- (void) setBottom: (CGFloat) newbottom
{
	CGRect newframe = self.frame;
	newframe.origin.y = newbottom - self.frame.size.height;
	self.frame = newframe;
}

//获得视图的右部x
- (CGFloat) right
{
	return self.frame.origin.x + self.frame.size.width;
}

- (void) setRight: (CGFloat) newright
{
	CGFloat delta = newright - (self.frame.origin.x + self.frame.size.width);
	CGRect newframe = self.frame;
	newframe.origin.x += delta ;
	self.frame = newframe;
}

// Move via offset
- (void) moveBy: (CGPoint) delta
{
	CGPoint newcenter = self.center;
	newcenter.x += delta.x;
	newcenter.y += delta.y;
	self.center = newcenter;
}

// Scaling
- (void) scaleBy: (CGFloat) scaleFactor
{
	CGRect newframe = self.frame;
	newframe.size.width *= scaleFactor;
	newframe.size.height *= scaleFactor;
	self.frame = newframe;
}

// Ensure that both dimensions fit within the given size by scaling down
- (void) fitInSize: (CGSize) aSize
{
	CGFloat scale;
	CGRect newframe = self.frame;
	
	if (newframe.size.height && (newframe.size.height > aSize.height))
	{
		scale = aSize.height / newframe.size.height;
		newframe.size.width *= scale;
		newframe.size.height *= scale;
	}
	
	if (newframe.size.width && (newframe.size.width >= aSize.width))
	{
		scale = aSize.width / newframe.size.width;
		newframe.size.width *= scale;
		newframe.size.height *= scale;
	}
	
	self.frame = newframe;
}

//------------事件效应者-----------
-(UIViewController*)viewController
{
    //找到控制器这个响应者
    UIResponder* nextRes = [self nextResponder];
    do{
        if([nextRes isKindOfClass:[UIViewController class]]){
            return (UIViewController*)nextRes;
        }
        nextRes = [nextRes nextResponder];
        
    }while (nextRes != nil);
    return nil;
}

- (void)removeAllSubviews {
	while (self.subviews.count) {
		UIView* child = self.subviews.lastObject;
		[child removeFromSuperview];
	}
}

@end

//yangshuo
@implementation UIButton (NSIndexPath)
@dynamic buttonDefultString;
@dynamic dicInfo;

- (void)setIndexPath:(NSIndexPath *)indexPath {
    objc_setAssociatedObject(self, kYFJLeftSwipeDeleteTableViewCellIndexPathKey, indexPath, OBJC_ASSOCIATION_RETAIN);
}

- (NSIndexPath *)indexPath {
    id obj = objc_getAssociatedObject(self, kYFJLeftSwipeDeleteTableViewCellIndexPathKey);
    if([obj isKindOfClass:[NSIndexPath class]]) {
        return (NSIndexPath *)obj;
    }
    return nil;
}

- (NSString *)buttonDefultString
{
    return objc_getAssociatedObject(self, cachesIDKey);
}

- (void)setButtonDefultString:(NSString *)buttonDefultString
{
    objc_setAssociatedObject(self, cachesIDKey, buttonDefultString, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setDicInfo:(id)dicInfo
{
    objc_setAssociatedObject(self, cachesIDKey2, dicInfo, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id)dicInfo
{
    return objc_getAssociatedObject(self, cachesIDKey2);
}

@end





@implementation UINavigationItem (Spacing)

//-16 靠边
#define Offset -6
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_6_1
- (void)setLeftBarButtonItem:(UIBarButtonItem *)_leftBarButtonItem
{
    UIBarButtonItem *spaceButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spaceButtonItem.width =Offset;
    
    if (_leftBarButtonItem)
    {
        if (IOS_7)
        {
            [self setLeftBarButtonItems:@[spaceButtonItem, _leftBarButtonItem]];
        }
        else
        {
            [self setLeftBarButtonItems:@[_leftBarButtonItem]];
        }
    }
    else
    {
        [self setLeftBarButtonItems:@[spaceButtonItem]];
    }
}

- (void)setRightBarButtonItem:(UIBarButtonItem *)_rightBarButtonItem
{
        UIBarButtonItem *spaceButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        spaceButtonItem.width = Offset;
        if (_rightBarButtonItem)
        {
            if (IOS_7)
            {
                [self setRightBarButtonItems:@[spaceButtonItem, _rightBarButtonItem]];

            }
            else
            {
                 [self setRightBarButtonItems:@[_rightBarButtonItem]];
            }
        }
        else
        {
            [self setRightBarButtonItems:@[spaceButtonItem]];
        }
}
#endif

@end


@implementation NSString (contain)

-(BOOL)containsString:(NSString *)astring
{
    BOOL haveString = [self rangeOfString:astring].location != NSNotFound;
    return haveString;
}

+(NSMutableAttributedString *)replaceRedColorWithNSString:(NSString *)str andUseKeyWord:(NSString *)keyWord andWithFontSize:(float )size andWithFrontColor:(NSString *)frontColor
{
    NSMutableAttributedString *attrituteString = [[NSMutableAttributedString alloc] initWithString:str] ;
    NSRange range = [str rangeOfString:keyWord];
    [attrituteString setAttributes:@{NSForegroundColorAttributeName : [CommonImage colorWithHexString:frontColor], NSFontAttributeName : [UIFont systemFontOfSize:size]} range:range];
    return attrituteString;
}

+(NSMutableAttributedString *)replaceRedColorWithNSString:(NSString *)str andUseKeyWord:(NSString *)keyWord andWithCsutomFont:(UIFont*)font andWithFrontColor:(NSString *)frontColor
{
    NSMutableAttributedString *attrituteString = [[NSMutableAttributedString alloc] initWithString:str] ;
    NSRange range = [str rangeOfString:keyWord];
    [attrituteString setAttributes:@{NSForegroundColorAttributeName : [CommonImage colorWithHexString:frontColor], NSFontAttributeName :font} range:range];
    return attrituteString;
}
@end

@implementation UIImage(triangle)

+ (UIImage*)createImageWithFillColor:(UIColor*)fillColor andWithStrokeColor:(UIColor*)strokeColor withWeigt:(float)weight andWithHeight:(float)height andWithStrokeWeight:(float)strokeWeight
{
    CGRect rect = CGRectMake(0.0f, 0.0f, weight, height);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (fillColor)
    {
        CGContextSetFillColorWithColor(context, [fillColor CGColor]);
    }
    if (strokeColor)
    {
         CGContextSetStrokeColorWithColor(context, [strokeColor CGColor]);
    }
   
    CGContextSetLineWidth(context, strokeWeight);
    CGContextMoveToPoint(context, 0,height);
    CGContextAddLineToPoint(context, rect.size.width,height);
    CGContextAddLineToPoint(context, rect.size.width/2.0,0);
    CGContextClosePath(context);
    if (fillColor)
    {
         CGContextFillPath(context);
    }
    if (strokeColor)
    {
         CGContextStrokePath(context);
//        CGContextDrawPath(context, kCGPathFillStroke);
    }
    UIImage* theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}


@end

@implementation NSMutableDictionary (KAKeyRenaming)
- (void)replaceOldKeyy:(id)oldKey withNewKey:(id)newKey
{
    id value = [self objectForKey:oldKey];
    if (value) {
        [self setObject:value forKey:newKey];
        [self removeObjectForKey:oldKey];
    }
}
@end
