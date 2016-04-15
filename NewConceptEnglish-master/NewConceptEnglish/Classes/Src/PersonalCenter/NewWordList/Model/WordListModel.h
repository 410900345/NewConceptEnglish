//
//  WordListModel.h
//  newIdea1.0
//
//  Created by jiuhao-yangshuo on 16/3/29.
//  Copyright © 2016年 YangShuo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WordListModel : NSObject

@property (nonatomic, copy) NSString *word;

@property (nonatomic, copy) NSString *wordListId;

@property (nonatomic, copy) NSString *symbol;

@property (nonatomic, copy) NSString *explain;

@property (nonatomic, copy) NSString *pid;

+(instancetype)fillModelWithWord:(NSString *)word andSymbol:(NSString *)symbol andExplain:(NSString *)explain;
@end
