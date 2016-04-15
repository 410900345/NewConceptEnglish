//
//  WordBookListCell.h
//  newIdea1.0
//
//  Created by jiuhao-yangshuo on 16/3/29.
//  Copyright © 2016年 YangShuo. All rights reserved.
//

#import <UIKit/UIKit.h>

static float kWordBookListCell = 130;

static NSString *const kBookWordCount = @"kBookWordCount";

@interface WordBookListCell : UITableViewCell
@property (nonatomic,retain)  NSMutableDictionary *dicInfo;
+(void)goToListWordViewWithDict:(NSDictionary *)dict;

@end
