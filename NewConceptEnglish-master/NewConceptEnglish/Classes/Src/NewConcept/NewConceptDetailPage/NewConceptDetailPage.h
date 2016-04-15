//
//  NewConceptDetailPage.h
//  newIdea1.0
//
//  Created by yangshuo on 15/9/26.
//  Copyright (c) 2015年 xuGuohong. All rights reserved.
//

#import "CommonViewController.h"
#import "FileManagerModel.h"
#import "BookIndexModel.h"

@interface NewConceptDetailPage : CommonViewController

@property(nonatomic,strong) NSDictionary *bookIndexDict;

@property (nonatomic,assign) ItemBookNum itemBook; //第一册

@property(nonatomic,copy) NSString *bookIndex; //1-24

@property(nonatomic,assign) BOOL isShowLove;

@property (nonatomic,strong) BookIndexModel *m_bookIndexModel;

@end
