//
//  KXPayManageView.h
//  jiuhaohealth4.2
//
//  Created by jiuhao-yangshuo on 15/12/21.
//  Copyright © 2015年 xuGuohong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SXManageViewCell.h"
#import "WordListModel.h"

@interface SXManageView : UIView

@property(nonatomic,retain) NSArray *m_dataArray;

+(void )fillModelWithWord:(NSString *)word andSymbol:(NSString *)symbol andExplain:(NSString *)explain;

+ (void)showSXManageViewWithBlock:(SXBasicBlock)block;

// 插入数据
+ (void)inserIntoDBWithDict:(NSDictionary *)dict;

+ (void)inserIntoDBWithModel:(WordListModel *)wordListModel;

@end
