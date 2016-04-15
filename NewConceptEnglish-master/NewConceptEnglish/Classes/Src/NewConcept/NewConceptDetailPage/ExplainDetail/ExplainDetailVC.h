//
//  ExplainDetailVC.h
//  newIdea1.0
//
//  Created by yangshuo on 15/9/26.
//  Copyright (c) 2015年 xuGuohong. All rights reserved.
//

#import "CommonViewController.h"

@interface ExplainDetailVC : CommonViewController

//刷新数据
-(void)refrehTableViewWithData:(NSArray *)array;

-(void)showTip;

-(void)adjustContentViewWithIsAdjust:(float)adjust;

-(void)refrehGrammarViewWithData:(NSString *)allstring;

@end
