//
//  WordContentVC.h
//  newIdea1.0
//
//  Created by jiuhao-yangshuo on 16/3/9.
//  Copyright © 2016年 xuGuohong. All rights reserved.
//

#import "CommonViewController.h"

@interface WordContentVC : CommonViewController

@property (nonatomic,retain) NSMutableArray *m_dataArray;
@property (nonatomic ,assign) BOOL isShowContent;//是测试还是内容
@property (nonatomic,assign)    NSInteger wordIndex;
@end
