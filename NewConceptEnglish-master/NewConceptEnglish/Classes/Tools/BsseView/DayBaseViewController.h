//
//  DayBaseViewController.h
//  newIdea1.0
//
//  Created by jiuhao-yangshuo on 15/11/10.
//  Copyright © 2015年 xuGuohong. All rights reserved.
//

#import "CommonViewController.h"

@interface DayBaseViewController : CommonViewController

@property(nonatomic,strong) UITableView *m_tableView;
@property(nonatomic,strong) NSMutableArray *m_dataArray;

- (void)getDataSource;
- (void)getDataSourceFromLocal;//本地
- (void)refreshData;

- (void)creatTableView;
- (void)endOfResultList;
- (void)finishRefresh;

@end
