//
//  LearnWordEngine.h
//  newIdea1.0
//
//  Created by jiuhao-yangshuo on 16/3/14.
//  Copyright © 2016年 xuGuohong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YYModel.h"
#import "WordPlanDayModel.h"
#import "WordPlanModel.h"

static NSString *const kBookParent = @"kBookParent";

@interface LearnWordEngine : NSObject

@property(nonatomic,strong) WordPlanDayModel *m_wordPlanDayModel;
@property(nonatomic,strong) WordPlanModel *m_WordPlanModel;
+ (instancetype)sharedInstance;

+(void)decContentWithKey:(NSString *)key andWithDict:(NSMutableDictionary *)currentDict;


@end
