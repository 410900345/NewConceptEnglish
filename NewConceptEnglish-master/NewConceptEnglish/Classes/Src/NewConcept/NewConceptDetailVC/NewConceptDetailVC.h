//
//  NewConceptDetailVC.h
//  newIdea1.0
//
//  Created by yangshuo on 15/9/26.
//  Copyright (c) 2015年 xuGuohong. All rights reserved.
//

#import "CommonViewController.h"
#import "NewConceptBaseVC.h"
#import "FileManagerModel.h"

@interface NewConceptDetailVC : NewConceptBaseVC

@property(nonatomic,copy) NSString *bookIndex; //1-24

@property (nonatomic,assign) ItemBookNum itemBook; //第一册

@end
