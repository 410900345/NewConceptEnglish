//
//  NceOneDoubleVC.m
//  newIdea1.0
//
//  Created by jiuhao-yangshuo on 16/3/30.
//  Copyright © 2016年 YangShuo. All rights reserved.
//

#import "NceOneDoubleVC.h"
#import "NceOneDoubleDao.h"
#import "NewConceptDetailCell.h"
#import "FileManagerModel.h"
#import "NceOneDoubleDetail.h"
#import "NetAccess.h"
#import "DoubleBookHeader.h"
#import "CommonSet.h"
#import "AppUtil.h"

@interface NceOneDoubleVC ()<NetAccessDelegate>
{
    NceOneDoubleDao *m_nceOneDoubleDao;
    NetAccess *mynet;
     BOOL isloadingData;
    NSIndexPath *m_selectIndexPath;
}
@end

@implementation NceOneDoubleVC

#pragma mark -life cycle
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
       
    }
    return self;
}

- (void)dealloc{
    [self closeNowView];
}

-(BOOL)closeNowView
{
    [mynet setUpNilDelegate];
    mynet = nil;
    return [super closeNowView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        m_nceOneDoubleDao = [[NceOneDoubleDao alloc] init];
        NSArray *array = [m_nceOneDoubleDao findAllNceOneDoubleBookFromDB];
        for (int i = 0;i< array.count;i++) {
            
            NSMutableDictionary *dict = array[i];
            if (i%2==1)
            {
//                m_infodict[kBookIndexTxt] ,m_infodict[kBookTxt]];
                [dict replaceOldKeyy:@"pnum" withNewKey:kBookIndexTxt];
                [dict replaceOldKeyy:@"en" withNewKey:kBookTxt];
                [self.m_dataArray addObject:dict];
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
             [self createTableView];
        });
    });
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"NewConceptDetailCell";
    NewConceptDetailCell *cell =
    [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell)
    {
        cell = [[NewConceptDetailCell alloc] initWithStyle:UITableViewCellStyleDefault
                                           reuseIdentifier:identifier];
    }
    NSDictionary *detailText = self.m_dataArray[indexPath.row];
    if ([detailText isKindOfClass:[NSDictionary class]])
    {
        cell.m_dict = detailText;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    m_selectIndexPath = indexPath;
    [self setJumpEvents:indexPath.row];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)setJumpEvents:(NSInteger)index
{
    if (isloadingData)
    {
        return;
    }
    
    NSString *indexBookStr = kDoubleBookName;
    NSString *bookPath = [[AppUtil  getDocPath] stringByAppendingPathComponent:kDoubleBookName];
    NSFileManager *fileManage = [NSFileManager defaultManager];
    BOOL isDir;
    NSString *indexBook = [NSString stringWithFormat:@"%@%@",bookPath,indexBookStr];//doc/book/zipName
//    文件存在
    if(![fileManage fileExistsAtPath:bookPath isDirectory:&isDir])
    {
        [self downloadbookWthName:indexBookStr];
    }
    else
    {
        [self gotoDetailVC];
    }
    return;

}

-(void)downloadbookWthName:(NSString *)bookName
{
     NSString *urlStr = [CommonSet sharedInstance].double_url;
    if (!urlStr.length)
    {
        return;
    }
    if (!mynet)
    {
        mynet = [[NetAccess alloc]init];
        mynet.delegate = self;
    }
    [self showLoadProgressView];
    //   NSString *bookName = @"1_1_24";
//  m_bookName = bookName;
    mynet.m_fileSavedocPath = [AppUtil  getCachesPath];
    [mynet downLoadUrl:urlStr andProgressView:m_loadingView withBookName:kDoubleBookName];
}

-(void)downLoadFinishWithFilePath:(NSString *)filePath withFileName:(NSString *)fileName
{
    WS(weakSelf);
//    m_bookName = nil;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [AppUtil extZipResWithZipName:fileName withOldPath:filePath withNewPath:[AppUtil getDoubleBookHtmlPath]];
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf handleViewDataDownloadFinish];
        });
    });
}

-(void)handleViewDataDownloadFinish
{
    [self removeProgressView];
    [self gotoDetailVC];
}

- (void)gotoDetailVC
{
    NSDictionary *detailText = self.m_dataArray[m_selectIndexPath.row];
    NceOneDoubleDetail *model = [[NceOneDoubleDetail alloc] init];
    model.m_superDic = detailText;
    [self.navigationController pushViewController:model animated:YES];
}

@end
