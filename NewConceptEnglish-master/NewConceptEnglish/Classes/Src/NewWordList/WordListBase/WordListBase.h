//
//  WordListBase.h
//  newIdea1.0
//
//  Created by yangshuo on 16/3/17.
//  Copyright © 2016年 xuGuohong. All rights reserved.
//

#import "CommonViewController.h"

@interface WordListBase : CommonViewController

@property (nonatomic,strong) UITableView* m_tableView;

@property (nonatomic,strong) NSMutableArray *m_dataArray;

@property (nonatomic,strong) NSMutableArray *m_indexArray;
-(void)getData;
@end
