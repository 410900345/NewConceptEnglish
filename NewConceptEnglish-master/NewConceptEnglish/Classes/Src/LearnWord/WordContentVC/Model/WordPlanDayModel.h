//
//  WordPlanDayModel.h
//  newIdea1.0
//
//  Created by yangshuo on 16/3/24.
//  Copyright © 2016年 YangShuo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WordPlanDayModel : NSObject
@property (nonatomic,copy) NSString *wordPlanDayId;
@property (nonatomic,copy) NSString *dayIndex;
@property (nonatomic,copy) NSString *bookId;
@property (nonatomic,copy) NSString *learn;
@property (nonatomic,copy) NSString *learn_end;
@property (nonatomic,copy) NSString *lastTime;
@property (nonatomic,copy) NSString *today;
@property (nonatomic,copy) NSString *recite;
@property (nonatomic,copy) NSString *right;
@property (nonatomic,copy) NSString *wrong;
@property (nonatomic,copy) NSString *exceed;
@end
