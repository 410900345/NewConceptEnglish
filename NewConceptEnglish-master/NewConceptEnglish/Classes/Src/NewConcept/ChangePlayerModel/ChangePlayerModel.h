//
//  ChangePlayerModel.h
//  newIdea1.0
//
//  Created by jiuhao-yangshuo on 16/1/6.
//  Copyright © 2016年 xuGuohong. All rights reserved.
//

#import "ContentViewController.h"
#import "BookIndexModel.h"

static NSString *const KChangePlayerModel = @"KChangePlayerModel";

@interface ChangePlayerModel : ContentViewController

//出现选择声音的页面
+ (void)showChangePlayerModelWithBlock:(ContentViewControllerBlock)block;

@end
