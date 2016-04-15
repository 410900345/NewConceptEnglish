//
//  BaseTableViewController.h
//  newIdea1.0
//
//  Created by jiuhao-yangshuo on 16/1/28.
//  Copyright © 2016年 xuGuohong. All rights reserved.
//

#import "CommonViewController.h"

@interface BaseTableViewController : CommonViewController

@property (nonatomic,strong)  NSMutableArray *m_dataArray;
@property (nonatomic,strong)  UITableView *m_tableView;

-(void)createTableView;

- (void)endOfResultList;

@end
