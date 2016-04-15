//
//  FlySpeechEvaluator.h
//  newIdea1.0
//
//  Created by yangshuo on 15/10/13.
//  Copyright (c) 2015年 xuGuohong. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString const * kSpeechEvaluator = @"kSpeechEvaluatorIng";
static NSString const * kSpeechEvaluatorError = @"kSpeechEvaluatorError";
static NSString const * kSpeechEvaluatorSuccess = @"kSpeechEvaluatorSuccess";

@interface FlySpeechEvaluator : NSObject

@property(nonatomic,copy) SXBasicBlock m_block;

@property(nonatomic,copy) NSString *speechEvaluatorContent;
@property (nonatomic, copy) NSString *recordPath;

-(id)initWithAudioName:(NSString *)audioName;

- (void)onBtnStart;

- (void)onBtnCancel;

- (void)onBtnStop;

- (void)playUriAudioWithUrl:(NSString *)urlPath;

- (void)setM_block:(SXBasicBlock)block;

- (void)playUriAudioStop;

@end
