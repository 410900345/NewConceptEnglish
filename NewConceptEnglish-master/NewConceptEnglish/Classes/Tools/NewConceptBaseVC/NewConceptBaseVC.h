//
//  NewConceptBaseVC.h
//  newIdea1.0
//
//  Created by yangshuo on 15/9/26.
//  Copyright (c) 2015年 xuGuohong. All rights reserved.
//

#import "CommonViewController.h"
#import "PlayEnlishView.h"


static NSString *const kParseDataFinish = @"kParseDataFinish";
static NSString *const kLoopSenstence = @"kLoopSenstence";
static NSString *const kPlayEventNamePlaySelectSync = @"kPlayEventNamePlaySelectSync";//页面同步

typedef void (^NewConceptBaseVCBlock)(float time);
@interface NewConceptBaseVC : CommonViewController

@property(nonatomic, assign)float cellRowHeight;
@property(nonatomic,strong)  UITableView *allTableView;
@property(nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,assign) BOOL hasLoadSuccessFlag;//已经加载成功标志位，下次滑到此处不进行自动加载
@property(nonatomic,copy) NewConceptBaseVCBlock _inBlock;
@property (nonatomic, strong) PlayEnlishView *m_playEnlishView;

@property(nonatomic,copy) SXBasicBlock myBaseBlock;
@property(nonatomic,assign) NSInteger m_selectIndex;//当前的行
@property(nonatomic,assign) NSInteger lastCellIndex;

- (void)getDataSource;
- (void)createTableView;
- (void)endOfResultList;

//刷新数据
- (void)refrehTableViewWithData:(NSArray *)array;

- (void)needLoadMoreData;

- (void)handlerNetWrokDataWithArray:(NSMutableArray *)resutArray;

- (void)adjustContentViewWithIsAdjust:(float)adjust;

//处理cell变色
- (void)handleCellColorWithIndex:(int)index;

//处理选择某一句读  //主动选择某一行
- (void)handleCellSelectWithIndex:(NSIndexPath *)indexPath;

//处理循环
- (void)handleLoopPlayWithIndex:(int)index;

- (void)resetSelectIndex;

//通知的对象
- (void)notificationSelectIndex:(NSNumber *)index;

@end
