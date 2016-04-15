//
//  UIResponder+EventRouter.h
//  meiniu
//
//  Created by jiuhao-yangshuo on 15-2-12.
//  Copyright (c) 2015年 徐国洪. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, SXEventType) {
    SXEventTypeBtn,
    SXEventTypeTitle,
    SXEventTypeTouch
};
@interface UIResponder (EventRouter)

/**
 *  发送一个路由器消息, 对eventName感兴趣的 UIResponsder 可以对消息进行处理
 *
 *  @param eventName 发生的事件名称
 *  @param userInfo  传递消息时, 携带的数据, 数据传递过程中, 会有新的数据添加
 *
 */
- (void)routerEventWithName:(NSString *)eventName userInfo:(id)userInfo;

- (void)routerEventWithEventType:(SXEventType )eventName userInfo:(id)userInfo;
@end
