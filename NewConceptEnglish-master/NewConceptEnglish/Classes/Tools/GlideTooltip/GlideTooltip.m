//
//  GlideTooltip.m
//  jiuhaohealth4.1
//
//  Created by 徐国洪 on 15-9-22.
//  Copyright (c) 2015年 xuGuohong. All rights reserved.
//

#import "GlideTooltip.h"

@implementation GlideTooltipModel

//- (void)dealloc
//{
//    self.title = nil;
//    [super dealloc];
//}

@end

@implementation GlideTooltip

- (id)initWithTitle:(NSString*)title
{
    self = [super init];
    if (self) {
        self.backgroundColor = [CommonImage colorWithHexString:@"ff5232" alpha:0.8];
        self.font = [UIFont fontWithName:@"Arial-BoldMT" size:16];
        self.text = title;
        self.textColor = [UIColor whiteColor];
        self.textAlignment = NSTextAlignmentCenter;
    }
    
    return self;
}

+ (void)showInView:(GlideTooltipModel*)view
{
    int count = [[[NSUserDefaults standardUserDefaults] objectForKey:view.key] intValue];
    if (count < 3) {
        
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:++count] forKey:view.key];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        GlideTooltip *labTitle = [[GlideTooltip alloc] initWithTitle:view.title];
        labTitle.tag = 5658;
        if ([view.view viewWithTag:5658])
        {
            return;
        }
        [view.view addSubview:labTitle];
   
        float height = [Common heightForString:view.title Width:kDeviceWidth Font:labTitle.font].height+12;
        height = MAX(height, 40);
        labTitle.frame = CGRectMake(0, -height, kDeviceWidth, height);
        
        [UIView animateWithDuration:0.5 animations:^{
            labTitle.transform = CGAffineTransformMakeTranslation(0, labTitle.height);
        } completion:^(BOOL f) {
            [UIView animateWithDuration:0.3 delay:3 options:UIViewAnimationOptionCurveLinear animations:^{
                labTitle.transform = CGAffineTransformIdentity;
            } completion:^(BOOL f) {
                [labTitle removeFromSuperview];
            }];
        }];
    }
}

@end
