//
//  BilingualismVCCell.h
//  newIdea1.0
//
//  Created by yangshuo on 15/9/26.
//  Copyright (c) 2015年 xuGuohong. All rights reserved.
//

#import <UIKit/UIKit.h>

static const CGFloat kBilingualismVCCell = 50.0;
@interface BilingualismVCCell : UITableViewCell

@property(nonatomic,strong) NSMutableDictionary *m_dict;

+ (float)getHightFromDict:(NSMutableDictionary *)dcit;

//变颜色
-(void)changeCellColorIsChange:(BOOL)isChange;

@end
