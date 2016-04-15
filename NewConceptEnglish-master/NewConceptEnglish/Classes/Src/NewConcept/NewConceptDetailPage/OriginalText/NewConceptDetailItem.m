//
//  NewConceptDetailItem.m
//  newIdea1.0
//
//  Created by yangshuo on 15/9/26.
//  Copyright (c) 2015年 xuGuohong. All rights reserved.
//

#import "NewConceptDetailItem.h"
#import "NewConceptDetailItemCell.h"
#import "FileManagerModel.h"

@interface NewConceptDetailItem()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation NewConceptDetailItem


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
    NSArray *newArray = [FileManagerModel handleDataWithDetailText:resutArray];
    [self.dataArray addObjectsFromArray:newArray];
}

#pragma mark - PrivateMethod

#pragma mark - UITableViewDataSource And UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"NewConceptDetailItemCell";
    NewConceptDetailItemCell *cell =
    [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell)
    {
        cell = [[NewConceptDetailItemCell alloc] initWithStyle:UITableViewCellStyleDefault
                                           reuseIdentifier:identifier];
    }
    NSDictionary *detailDict =  self.dataArray[indexPath.row];
    cell.m_dict = detailDict;
    return cell;
}

- (void)handleLoopPlayWithIndex:(int)index
{
    NSLog(@"---%d---%d",index,index);
    if (self.myBaseBlock)
    {
        self.myBaseBlock(@(kPlayEventNameLoop));
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self handleCellSelectWithIndex:indexPath];
    if (self.myBaseBlock)
    {
        self.myBaseBlock(kPlayEventNamePlaySelectSync);
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary *medicineDic = nil;
    medicineDic = self.dataArray[indexPath.row];
    float height = [NewConceptDetailItemCell getHightFromDict:medicineDic];
    return  height;
}
@end
