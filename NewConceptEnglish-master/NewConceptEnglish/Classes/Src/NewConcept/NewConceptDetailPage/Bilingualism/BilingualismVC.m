//
//  BilingualismVC.m
//  newIdea1.0
//
//  Created by yangshuo on 15/9/26.
//  Copyright (c) 2015年 xuGuohong. All rights reserved.
//

#import "BilingualismVC.h"
#import "BilingualismVCCell.h"
#import "FileManagerModel.h"

@interface BilingualismVC()<UITableViewDataSource,UITableViewDelegate>

@end


@implementation BilingualismVC

#pragma mark - life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createTableView];
    self.allTableView.frameHeight = kDeviceHeight -35;
    // Do any additional setup after loading the view.
}

-(void)getDataSource
{
//    [super getDataSource];
}

-(void)handlerNetWrokDataWithArray:(NSMutableArray *)resutArray
{
//    NSArray *newArray = [FileManagerModel handleDataWithDetailText:resutArray];
    NSArray* trueDeepCopyArray = [NSKeyedUnarchiver unarchiveObjectWithData:
                                  [NSKeyedArchiver archivedDataWithRootObject: resutArray]];
    for (NSDictionary *dict in trueDeepCopyArray)
    {
        NSMutableDictionary *newDict = [dict mutableCopy];
        [newDict removeObjectForKey:kTxtCellHight];
        [self.dataArray  addObject:newDict];
    }
//    [self.dataArray addObjectsFromArray:resutArray];
}
#pragma mark - PrivateMethod
- (void)handleLoopPlayWithIndex:(int)index
{
    if (self.m_playEnlishView.isLooping && self.m_playEnlishView.loopCount)
    {
        NSInteger currentPlayIndex = MAX(self.m_selectIndex-1,0);
        self.m_selectIndex = currentPlayIndex;
    }
}
#pragma mark - UITableViewDataSource And UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"NewConceptDetailItemCell";
    BilingualismVCCell *cell =
    [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell)
    {
        cell = [[BilingualismVCCell alloc] initWithStyle:UITableViewCellStyleDefault
                                               reuseIdentifier:identifier];
    }
    if (self.dataArray.count > indexPath.row)
    {
        NSDictionary *detailDict =  self.dataArray[indexPath.row];
        cell.m_dict = detailDict;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.myBaseBlock)
    {
        self.myBaseBlock(kPlayEventNamePlaySelectSync);
    }
    self.m_selectIndex = indexPath.row;
    [self handleCellColorWithIndex:indexPath.row];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary *medicineDic = nil;
    medicineDic = self.dataArray[indexPath.row];
    float height = [BilingualismVCCell getHightFromDict:medicineDic];
    return  height;
}
@end
