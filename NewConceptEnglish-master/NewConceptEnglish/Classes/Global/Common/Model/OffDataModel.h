//
//  OffDataModel.h
//  newIdea1.0
//
//  Created by yangshuo on 15/12/31.
//  Copyright © 2015年 xuGuohong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OffDataModel : NSObject

@property(nonatomic,copy) NSString *wordVoice;//单词语音,
@property(nonatomic,copy) NSString *speakingVoice;//口语语音
@property(nonatomic,copy) NSString *phonogramVoice;//音标语音
@property(nonatomic,copy) NSString *CTE46;//四六级
@property(nonatomic,copy) NSString *sentenceInfo;//单词句子
@property(nonatomic,copy) NSString *wordInfo;//离线词典
@property(nonatomic,copy) NSString *recommendWord;//推荐词库
@property(nonatomic,copy) NSString *backWordVoice;//背单词

+ (OffDataModel *)fillDataWitOffDataString:(NSString *)offData;

@end
