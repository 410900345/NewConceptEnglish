//
//  GloblePlayer.m
//  newIdea1.0
//
//  Created by jiuhao-yangshuo on 16/1/8.
//  Copyright © 2016年 xuGuohong. All rights reserved.
//

#import "GloblePlayer.h"

@implementation GloblePlayer

@synthesize isApplicationEnterBackground;

+ (instancetype)sharedInstance
{
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}
@end
