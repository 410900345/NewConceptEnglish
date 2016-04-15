//
//  NewConceptItemVC.h
//  newIdea1.0
//
//  Created by yangshuo on 15/9/26.
//  Copyright (c) 2015年 xuGuohong. All rights reserved.
//

#import "CommonViewController.h"
#import "FileManagerModel.h"

@interface NewConceptItemVC : CommonViewController

@property (nonatomic,assign) ItemBookNum itemBook;

-(void)setUpNewConceptItemVCBlock:(SXBasicBlock)mBlock;

@end
