//
//  GlideTooltip.h
//  jiuhaohealth4.1
//
//  Created by 徐国洪 on 15-9-22.
//  Copyright (c) 2015年 xuGuohong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GlideTooltipModel : NSObject

@property (nonatomic, assign) NSString *title;
@property (nonatomic, assign) UIView *view;
@property (nonatomic, assign) NSString *key;

@end




@interface GlideTooltip : UILabel

+ (void)showInView:(GlideTooltipModel*)view;

@end


