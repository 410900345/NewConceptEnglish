//
//  SupportModel.h
//  newIdea1.0
//
//  Created by yangshuo on 15/11/14.
//  Copyright © 2015年 xuGuohong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SupportModel : NSObject

//颜色索引
+(NSString *)getIndexColorWithIndex:(NSInteger)index;

//颜色数组
+(NSArray *)getSupportArray;

//颜色索引值
+(NSInteger )getIndexWithColorStr:(NSString *)colorStr;

//来自于的客服端
+(NSString *)getSourcePlatformFormTag:(NSInteger)index;

@end
