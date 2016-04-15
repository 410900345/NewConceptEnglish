//
//  CommentManage.h
//  newIdea1.0
//
//  Created by jiuhao-yangshuo on 16/2/2.
//  Copyright © 2016年 xuGuohong. All rights reserved.
//

#import <Foundation/Foundation.h>

static const NSInteger kCommentManageTip = 7;//频率

@interface CommentManage : NSObject

+(id)showCommentAlert;

+(BOOL)havedComment;

+(id)showPayCancelAlert;

@end
