//
//  WordModel.h
//  newIdea1.0
//
//  Created by yangshuo on 16/3/22.
//  Copyright © 2016年 YangShuo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WordModel : NSObject

@property (nonatomic,copy) NSString *title;//标题
@property (nonatomic,copy) NSString *content;//内容
@property (nonatomic,copy) NSString *keyWord;//关键字
@property (nonatomic,copy) NSString *readSentense;//要读的内容

+(instancetype)fillWordModelWithTitle:(NSString *)title andContent:(NSString *)content;

+(NSString *)fetchWordImageUrlWithWord:(NSString *)word;
@end
