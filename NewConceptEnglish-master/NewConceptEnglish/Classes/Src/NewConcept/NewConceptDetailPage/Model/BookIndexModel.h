//
//  BookIndexModel.h
//  newIdea1.0
//
//  Created by jiuhao-yangshuo on 16/1/5.
//  Copyright © 2016年 xuGuohong. All rights reserved.
//

#import <Foundation/Foundation.h>

//@"仅播一次",@"单曲循环",@"顺序播放",@"随机播放",@"列表循环"
typedef enum : NSUInteger {
    PlayerModelPlayOnce = 0,
    PlayerModelSingleLoop,
    PlayerModelPlayOrder,
    PlayerModelPlayRandom,
    PlayerModelListLoop
} PlayerModelType;

@interface BookIndexModel : NSObject

@property (nonatomic,strong) NSArray *bookIndexModelArray;

@property (nonatomic,assign) NSInteger bookModelIndex;

@property (nonatomic,assign) PlayerModelType m_playerModelType;

//数组
+(NSArray *)fetchPlayerModelTitleArray;

//获取
+(NSString *)fetchPlayerModelTitleWithPlayerModelType:(PlayerModelType )type;

+(NSString *)fetchPlayerModelPlayViewTitleWithPlayerModelType:(PlayerModelType)type;

@end
