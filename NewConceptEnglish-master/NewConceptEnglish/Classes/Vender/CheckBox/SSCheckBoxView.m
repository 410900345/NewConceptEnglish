
/*
 Copyright 2011 Ahmet Ardal
 
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */

//
//  SSCheckBoxView.m
//  SSCheckBoxView
//
//  Created by Ahmet Ardal on 12/6/11.
//  Copyright 2011 SpinningSphere Labs. All rights reserved.
//

#import "SSCheckBoxView.h"
#import "Global.h"
#import "Global_Url.h"

#define RgbHex2UIColor(r, g, b)                 [UIColor colorWithRed:((r) / 256.0) green:((g) / 256.0) blue:((b) / 256.0) alpha:1.0]

static const CGFloat kSpace = 15.0f;

@interface SSCheckBoxView(Private)
- (UIImage *) checkBoxImageForStyle:(SSCheckBoxViewStyle)s
                            checked:(BOOL)isChecked;
- (CGRect) imageViewFrameForCheckBoxImage:(UIImage *)img;
- (void) updateCheckBoxImage;
@end

@implementation SSCheckBoxView
{
    NSString *checkImageStr;
    NSString *normalImageStr;
}
@synthesize style, checked, enabled;
@synthesize stateChangedBlock;
@synthesize titleColor, titleFont;

- (id) initWithFrame:(CGRect)frame
               style:(SSCheckBoxViewStyle)aStyle
             checked:(BOOL)aChecked
{
//    frame.size.height = kHeight;
    if (!(self = [super initWithFrame:frame])) {
        return self;
    }

    stateChangedSelector = nil;
    self.stateChangedBlock = nil;
    delegate = nil;
    style = aStyle;
    checked = aChecked;
    self.enabled = YES;

    self.userInteractionEnabled = YES;
    self.backgroundColor = [UIColor clearColor];

    checkImageStr = @"common.bundle/diary/selected_on.png";
    normalImageStr = @"common.bundle/diary/selected_off.png";
    
    UIImage *img = [self checkBoxImageForStyle:style checked:checked];
    CGRect imageViewFrame = [self imageViewFrameForCheckBoxImage:img];
    UIImageView *iv = [[UIImageView alloc] initWithFrame:imageViewFrame];
	iv.contentMode = UIViewContentModeCenter;
    iv.image = img;
    [self addSubview:iv];
    checkBoxImageView = iv;

    return self;
}

//登陆初始化
- (id) initWithFrame:(CGRect)frame
               style:(SSCheckBoxViewStyle)aStyle
             checked:(BOOL)aChecked Login:(BOOL)login
{
    //    frame.size.height = kHeight;
    if (!(self = [super initWithFrame:frame])) {
        return self;
    }
    
    stateChangedSelector = nil;
    self.stateChangedBlock = nil;
    delegate = nil;
    style = aStyle;
    checked = aChecked;
    self.enabled = YES;
    
    self.userInteractionEnabled = YES;
    self.backgroundColor = [UIColor clearColor];
    _isImageType = login;
    UIImage *img = [self checkBoxImageForStyle:style checked:checked];
    CGRect imageViewFrame = [self imageViewFrameForCheckBoxImage:img];
    UIImageView *iv = [[UIImageView alloc] initWithFrame:imageViewFrame];
	iv.contentMode = UIViewContentModeBottomLeft;
    iv.image = img;
    [self addSubview:iv];
    checkBoxImageView = iv;
    
    return self;
}

- (void) dealloc
{
    self.stateChangedBlock = nil;
    [checkBoxImageView release];
    [textLabel release];
    [super dealloc];
}

- (void) setEnabled:(BOOL)isEnabled
{
    textLabel.enabled = isEnabled;
    enabled = isEnabled;
    checkBoxImageView.alpha = isEnabled ? 1.0f: 0.6f;
}

- (BOOL) enabled
{
    return enabled;
}

- (void) setText:(NSString *)text
{
    CGRect labelFrame = CGRectMake(checkBoxImageView.image.size.width +kSpace, 0.0f, self.frame.size.width - 32, self.frame.size.height);
    UILabel *l = [[UILabel alloc] initWithFrame:labelFrame];
    l.textAlignment = NSTextAlignmentLeft;
    l.backgroundColor = [UIColor clearColor];
    l.font = titleFont;
    l.numberOfLines = 0;
    l.textColor = titleColor;
    l.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    l.shadowColor = [UIColor whiteColor];
    l.shadowOffset = CGSizeMake(0, 1);
    [self addSubview:l];
    textLabel = l;
	
    [textLabel setText:text];
}

- (void) setChecked:(BOOL)isChecked
{
    checked = isChecked;
    [self updateCheckBoxImage];
}

- (void) setStateChangedTarget:(id<NSObject>)target
                      selector:(SEL)selector
{
    delegate = target;
    stateChangedSelector = selector;
}


#pragma mark -
#pragma mark Touch-related Methods

- (void) touchesBegan:(NSSet *)touches
            withEvent:(UIEvent *)event
{
    if (!enabled) {
        return;
    }

    self.alpha = 0.8f;
    [super touchesBegan:touches withEvent:event];
}

- (void) touchesCancelled:(NSSet *)touches
                withEvent:(UIEvent *)event
{
    if (!enabled) {
        return;
    }

    self.alpha = 1.0f;
    [super touchesCancelled:touches withEvent:event];
}

- (void) touchesEnded:(NSSet *)touches
            withEvent:(UIEvent *)event
{
    if (!enabled) {
        return;
    }

    // restore alpha
    self.alpha = 1.0f;

    // check touch up inside
    if ([self superview]) {
        UITouch *touch = [touches anyObject];
        CGPoint point = [touch locationInView:[self superview]];
        CGRect validTouchArea = CGRectMake((self.frame.origin.x - 5),
                                           (self.frame.origin.y - 10),
                                           (self.frame.size.width + 5),
                                           (self.frame.size.height + 10));
        if (CGRectContainsPoint(validTouchArea, point)) {
            checked = !checked;
            [self updateCheckBoxImage];
            if (delegate && stateChangedSelector) {
                [delegate performSelector:stateChangedSelector withObject:self];
            }
            else if (stateChangedBlock) {
                stateChangedBlock(self);
            }
        }
    }

    [super touchesEnded:touches withEvent:event];
}

- (BOOL) canBecomeFirstResponder
{
    return YES;
}


#pragma mark -
#pragma mark Private Methods

- (UIImage *) checkBoxImageForStyle:(SSCheckBoxViewStyle)s checked:(BOOL)isChecked
{
    NSString *imageName;
    if (s == kSSCheckBoxViewStyleGlossy)
    {
        _isImageType = YES;
    }
    
    if (isChecked) {
        if (_isImageType) {
            imageName = @"common.bundle/diary/login_icon_radiobutton_pressed.png";
        }else{
            imageName = checkImageStr;
        }
    }
    else
    {
        if (_isImageType) {
        imageName = @"common.bundle/diary/login_icon_radiobutton_normal.png";
        }else{
         imageName = normalImageStr;
        }
    }
//  imageName = [NSString stringWithFormat:@"%@", imageName];
    return [UIImage imageNamed:imageName];
}

- (CGRect) imageViewFrameForCheckBoxImage:(UIImage *)img
{
    CGFloat y = floorf((self.frame.size.height - img.size.height) / 2.0f);
    return CGRectMake(0.0f, y, img.size.width, img.size.height);
}

- (void) updateCheckBoxImage
{
    checkBoxImageView.image = [self checkBoxImageForStyle:style
                                                  checked:checked];
    UIImage *img = [self checkBoxImageForStyle:style checked:checked];
    CGRect imageViewFrame = [self imageViewFrameForCheckBoxImage:img];
    checkBoxImageView.frame = imageViewFrame;
}

- (void)setUpCheckImage:(NSString *)mCheckImageStr andWithNormalImage:(NSString *)mNormalImageStr
{
    if (mCheckImageStr.length && mNormalImageStr.length)
    {
        checkImageStr = mCheckImageStr;
        normalImageStr = mNormalImageStr;
        [self updateCheckBoxImage];
    }
    else
    {
        NSAssert(mCheckImageStr.length && mNormalImageStr.length, @"Argument must be non-nil");
    }
}

@end
