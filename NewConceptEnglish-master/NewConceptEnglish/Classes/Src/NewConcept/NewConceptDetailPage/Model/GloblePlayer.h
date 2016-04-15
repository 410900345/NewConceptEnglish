//
//  GloblePlayer.h
//  newIdea1.0
//
//  Created by jiuhao-yangshuo on 16/1/8.
//  Copyright © 2016年 xuGuohong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GloblePlayer : NSObject

@property (nonatomic,assign) BOOL isApplicationEnterBackground;

+ (instancetype)sharedInstance;

@end
