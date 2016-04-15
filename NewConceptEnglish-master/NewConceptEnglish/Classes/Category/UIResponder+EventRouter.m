//
//  UIResponder+EventRouter.m
//  meiniu
//
//  Created by jiuhao-yangshuo on 15-2-12.
//  Copyright (c) 2015年 徐国洪. All rights reserved.
//

#import "UIResponder+EventRouter.h"

@implementation UIResponder (EventRouter)

- (void)routerEventWithName:(NSString *)eventName userInfo:(id )userInfo
{
    [[self nextResponder] routerEventWithName:eventName userInfo:userInfo];
}

- (void)routerEventWithEventType:(SXEventType )eventName userInfo:(id)userInfo;
{
    [[self nextResponder] routerEventWithEventType:eventName userInfo:userInfo];
}
@end
