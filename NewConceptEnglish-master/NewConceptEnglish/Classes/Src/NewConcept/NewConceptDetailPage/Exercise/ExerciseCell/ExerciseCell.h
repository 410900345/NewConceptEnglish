//
//  ExerciseCell.h
//  newIdea1.0
//
//  Created by yangshuo on 15/9/26.
//  Copyright (c) 2015年 xuGuohong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FileManagerModel.h"

static NSString *kTxtTopic = @"kTxtTopic";//标题
static NSString *kTxtAnswer = @"kTxtAnswer";//答案string
static NSString *kTxtCorrect = @"kTxtCorrect";//正确答案
static NSString *kTxtParse = @"kTxtParse";//解析
static NSString *kTxtAnswerArray = @"kTxtAnswerArray";//答案数据
static NSString *kTxtAnswerDetail = @"kTxtAnswerDetail";//答案内容

static NSString *kTxtAnswerSelect = @"kTxtAnswerSelect";//选择的
static NSString *kTxtAnswerIs = @"kTxtAnswerIs"; //正确答案cell
static NSString *kTxtIsAnswered = @"kTxtIsAnswered"; //已经答过
@interface ExerciseCell : UITableViewCell

@property(nonatomic,strong) NSDictionary *m_dict;

+ (float)getHightFromDict:(NSMutableDictionary *)dcit;

@end
