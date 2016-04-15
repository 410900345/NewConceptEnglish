//
//  BackContentView.h
//  newIdea1.0
//
//  Created by yangshuo on 16/3/22.
//  Copyright © 2016年 YangShuo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WordModel.h"

static NSString *const kBackColor = @"f2f2e8";
@interface BackContentView : UIView

-(void)createContentViewWithWordModel:(WordModel *)wordModel;
@end
