//
//  VocabularyVC.m
//  newIdea1.0
//
//  Created by yangshuo on 15/9/26.
//  Copyright (c) 2015年 xuGuohong. All rights reserved.
//

#import "VocabularyVC.h"
#import "VocabularyVCCell.h"
#import "FileManagerModel.h"

@interface VocabularyVC()<UITableViewDataSource,UITableViewDelegate>

@end


@implementation VocabularyVC

#pragma mark - life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createTableView];
    self.allTableView.frameHeight = kDeviceHeight -35;
    // Do any additional setup after loading the view.
}

-(void)handlerNetWrokDataWithArray:(NSMutableArray *)resutArray
{
    NSLog(@"%@",resutArray);
    NSMutableArray *newArray = [[NSMutableArray alloc] init];
    for (int i = 0; i<resutArray.count/2; i++)
    {
        NSString *string = resutArray[i*2 +1];
        //去掉前后空格修饰
        NSString *trimmedString = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSDictionary *dict = @{kTxtDetail:resutArray[i*2],
                               kTxtChinese:trimmedString
                               };
        [newArray addObject:dict];
    }
    [self.dataArray addObjectsFromArray:newArray];
}

-(void)getDataSource
{
//    [super getDataSource];
}
#pragma mark - UITableViewDataSource And UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"NewConceptDetailItemCell";
    VocabularyVCCell *cell =
    [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell)
    {
        cell = [[VocabularyVCCell alloc] initWithStyle:UITableViewCellStyleDefault
                                               reuseIdentifier:identifier];
    }
    NSDictionary *detailDict =  self.dataArray[indexPath.row];
    cell.m_dict = detailDict;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *medicineDic = nil;
    medicineDic = self.dataArray[indexPath.row];
     NSString *txtDetail = medicineDic[kTxtDetail];
    NSArray *titleArray = [txtDetail componentsSeparatedByString:@"["];
    txtDetail = [titleArray firstObject];
    NSAssert(txtDetail != nil, @"Argument must be non-nil");
    [[FileManagerModel sharedFileManagerModel]readWordFromResoure:txtDetail withIsUk:NO withUrl:nil];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  kVocabularyVCCellHeight;
}
@end