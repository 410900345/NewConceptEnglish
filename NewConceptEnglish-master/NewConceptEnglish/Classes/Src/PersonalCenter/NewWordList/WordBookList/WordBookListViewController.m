//
//  WordBookListViewController.m
//  newIdea1.0
//
//  Created by jiuhao-yangshuo on 16/3/29.
//  Copyright © 2016年 YangShuo. All rights reserved.
//

#import "WordBookListViewController.h"
#import "WordList.h"
#import "WordBookListCell.h"
#import "SXAlertView.h"
#import "AppUtil.h"
#import "NetAccess.h"
#import "LearnWordDao.h"

@interface WordBookListViewController ()<UIActionSheetDelegate,NetAccessDelegate>
{
    WordList *m_wordDao;
    NSIndexPath *m_indexPath;
    NetAccess *mynet;
}
@end

@implementation WordBookListViewController

#pragma mark -life cycle
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"省心生词本";
        self.navigationItem.rightBarButtonItem = [Common CreateNavBarButton3:self setEvent:@selector(butEventAdd) setTitle:@"添加"];
    }
    return self;
}

-(BOOL)closeNowView
{
    [mynet setUpNilDelegate];
    mynet = nil;
    return [super closeNowView];
}

-(void)butEventAdd
{
    [self newwordBookChangeOrAddName:YES];
}

-(void)newwordBookChangeOrAddName:(BOOL)add
{
    WS(weakSelf);
    [SXAlertView showAlertViewWithTitle:@"生词本名称" andConfirmBlock:^(NSString *content) {
        [weakSelf createNewWordBookWithName:content withChangeOrAddName:add];
    } andWithCancelBlock:^(id content) {
        
    }];
}

///  创建
///
///  @param name 名字
///  @param add  是修改 还是添加名称
-(void)createNewWordBookWithName:(NSString *)name withChangeOrAddName:(BOOL)add
{
    if (!IsStrEmpty(name))
    {
        if (![m_wordDao haveBookName:name])
        {
            if (add)
            {
                [m_wordDao crateWorBookWithName:name];
                NSMutableDictionary *dict = [m_wordDao fetchWorBookListsDataWithBookName:name];
                if (dict.count)
                {
                    [dict setObject:@0 forKey:kBookWordCount];
                    [self.m_dataArray insertObject:dict atIndex:0];
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
                    [self.m_tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                }
            }
            else
            {
                NSMutableDictionary *dict = self.m_dataArray[m_indexPath.row];
                [m_wordDao renameWordBookWithBookID:dict[@"bookid"] withNewName:name];
                [dict setObject:name forKey:@"book_name"];
                [self.m_tableView reloadRowsAtIndexPaths:@[m_indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            }
        }
        else
        {
            [Common MBProgressTishi:@"名称已经存在!" forHeight:kDeviceHeight];
        }
    }
}

- (void)dealloc
{
    TT_RELEASE_SAFELY(m_wordDao);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createTableView];
    self.m_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.m_tableView.rowHeight = kWordBookListCell;
    [self loadLocalDataWithName:kNcewordDb];
    //串行队列
    dispatch_queue_t queueS = dispatch_queue_create("com.kangxun", DISPATCH_QUEUE_SERIAL);
    dispatch_async(queueS, ^{
        m_wordDao = [[WordList alloc] init];
        [self fetchDataFromDB];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.m_tableView reloadData];
        });
    });
}

-(void)fetchDataFromDB
{
    NSArray *array =  [m_wordDao fetchWorBookListsData];
    for (NSMutableDictionary *dict in array) {
        int count =  [m_wordDao fetchLocalNewBookWordCountWithBookID:dict[@"bookid"]];
        [dict setObject:@(count) forKey:kBookWordCount];
        [self.m_dataArray addObject:dict];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"WordBookListCell";
    WordBookListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[WordBookListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    if (self.m_dataArray.count)
    {
        NSDictionary *dict = self.m_dataArray[indexPath.row];
        cell.dicInfo = dict;
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
     NSDictionary *dict = self.m_dataArray[indexPath.row];
    [WordBookListCell goToListWordViewWithDict:dict];
}

#pragma mark - Event response
-(void)routerEventWithEventType:(SXEventType)eventName userInfo:(WordBookListCell *)userInfo
{
    NSIndexPath *indexPath = [self.m_tableView indexPathForCell:userInfo];
    m_indexPath = indexPath;
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:NSLocalizedString(@"取消", nil)
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:NSLocalizedString(@"修改生词本名字", nil),
                                  NSLocalizedString(@"删除生词本", nil),
                                  NSLocalizedString(@"置顶生词本",nil),
                                  nil];
    [actionSheet showInView:self.view];
}

//- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    NSDictionary *dict = self.m_dataArray[m_indexPath.row];
    NSString *bookTitle = dict[@"book_name"];
    if ([kDefautWordBook isEqualToString:bookTitle] && ( buttonIndex == 0 || buttonIndex == 1))
    {
        [Common MBProgressTishi:@"默认生词本不让修改" forHeight:kDeviceHeight];
        return;
    }
    switch (buttonIndex) {
        case 0:
            NSLog(@"xiugai ");
            [self newwordBookChangeOrAddName:NO];
            break;
        case 1:
        {
            [m_wordDao deleteWordBookBookID:dict[@"bookid"]];
            [self.m_dataArray removeObjectAtIndex:m_indexPath.row];
            [self.m_tableView deleteRowsAtIndexPaths:@[m_indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        }
        case 2:
        {
            [m_wordDao updateWordBookDateWithBookID:dict[@"bookid"]];
            [self.m_dataArray exchangeObjectAtIndex:m_indexPath.row withObjectAtIndex:0];
            [self.m_tableView moveRowAtIndexPath:m_indexPath toIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            break;
        }
        default:
            break;
    }
}

#pragma mark - Network response
-(BOOL)fileDBExistsAtWithName:(NSString *)name
{
    BOOL isExists = YES;
    NSString *pathString = [[AppUtil getDbPath] stringByAppendingFormat:@"/%@",name];
    NSFileManager *fileManage = [NSFileManager defaultManager];
    BOOL isDir;
    //文件存在
    isExists =[fileManage fileExistsAtPath:pathString isDirectory:&isDir];
    return isExists;
}
-(void)loadLocalDataWithName:(NSString *)bookId
{
    //    NSString *indexBook = [NSString stringWithFormat:@"%@road_map_%@.json",kLearnWordurl,bookId];
    NSString *aliUrl = @"http://iosnce.file.alimmdn.com/shengxinword.eng";
//    NSString *indexBook = kLearnWordDBurl;
    NSString *indexBook = aliUrl;
    //文件存在
    if(![self fileDBExistsAtWithName:bookId])
    {
        [self downloadbookWthName:indexBook withFileName:bookId withSpare:NO];
    }
}
-(void)downloadbookWthName:(NSString *)bookNameURL withFileName:(NSString *)fileName withSpare:(BOOL)spare
{
    if (!mynet)
    {
        mynet = [[NetAccess alloc]init];
        mynet.delegate = self;
        mynet.m_fileSavedocPath = [Common datePath];
    }
    [self showLoadProgressView];
    NSString *urlStr = bookNameURL;
    [mynet downLoadUrl:urlStr andProgressView:m_loadingView withBookName:fileName];
}

-(void)requestFailed
{
    [self removeProgressView];
}

-(void)downLoadFinishWithFilePath:(NSString *)filePath withFileName:(NSString *)fileName
{
    [self removeProgressView];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [AppUtil extZipResWithZipName:fileName withOldPath:filePath withNewPath:[AppUtil getDbPath]];
        dispatch_async(dispatch_get_main_queue(), ^{
            [Common MBProgressTishi:@"配置单词数据完成" forHeight:kDeviceHeight];
        });
    });
}
@end
