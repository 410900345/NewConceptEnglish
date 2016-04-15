//
//  KXShareManager.h
//  jiuhaohealth4.0
//
//  Created by wangmin on 15/9/11.
//  Copyright (c) 2015年 xuGuohong. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface KXShareManager : NSObject

+ (KXShareManager *)sharedManager;

//- (void)initPlatform;

- (void)noneUIShareAllButtonClickHandler:(id)sender
                                 Content:(NSString *)contentStrings
                               ImagePath:(UIImage *)imagePath
                                AndTitle:(NSString *)titleString
                                     Url:(NSString *)url
                          haveCustomItem:(BOOL)haveCutomItem;

@end
