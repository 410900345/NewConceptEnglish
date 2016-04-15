//
//  SupportGiveViewController.m
//  newIdea1.0
//
//  Created by yangshuo on 15/11/12.
//  Copyright © 2015年 xuGuohong. All rights reserved.
//

#import "SupportGiveViewController.h"
#import "SupportTableViewCell.h"
#import "SupportDetailVC.h"


typedef enum : NSUInteger
{
    SupportSortHigh,
    SupportSortNew
} SupportSort;

static float const kDisplayNum = 20;
static float const kDisplayLimitNum = 88;

@interface SupportGiveViewController ()
{
    UIButton *m_right2;
    SupportSort m_sort;
    UIView *headView;
}
@end

@implementation SupportGiveViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
     self.title = @"  友情赞助(前88位)";
//     self.title = @"友情赞助";
    [self changeButtonContent];
    // Do any additional setup after loading the view.
    [self createHeadView];
    self.m_tableView.frame = CGRectMake(0, headView.bottom, kDeviceWidth, kDeviceHeight - headView.height);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self hiddenNavigationBarLine];
}

-(void)createHeadView
{
    headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 0.1)];
    headView.backgroundColor = [CommonImage colorWithHexString:@"444444"];
    [self.view addSubview:headView];
    
    NSString *str = @"有您的赞助我们才有动力持续优化软件,您的捐赠将于我们采购服务器,持续优化产品,并设计更优质的学习软件!真心希望每个用户都赞助一下!";
    UILabel *titleLab = [Common createLabel:CGRectMake(UI_spaceToLeft, UI_spaceToLeft, kDeviceWidth - 2*UI_spaceToLeft, 0.1) TextColor:@"888888" Font:[UIFont systemFontOfSize:16] textAlignment:NSTextAlignmentLeft labTitle:str];
    [headView addSubview:titleLab];
    titleLab.numberOfLines = 0;
    
    CGSize commentSize = [titleLab.text sizeWithFont:titleLab.font constrainedToSize:CGSizeMake(titleLab.width, 10000)];
    titleLab.height = ceil(commentSize.height);
    
    UIButton* withBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    withBtn.frame = CGRectMake(UI_spaceToLeft, titleLab.bottom +10, titleLab.width, 44);
    UIImage* image =  [CommonImage createImageWithColor:[CommonImage colorWithHexString:Color_Nav]];
    [withBtn setBackgroundImage:image forState:UIControlStateNormal];
    [withBtn setTitle:NSLocalizedString(@"我要赞助", nil) forState:UIControlStateNormal];
    [withBtn addTarget:self action:@selector(suportBtn) forControlEvents:UIControlEventTouchUpInside];
    [withBtn setImage:[UIImage imageNamed:@"common.bundle/tools/donate_coffe.png"] forState:UIControlStateNormal];
    [withBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -5, 0, 5)];
    [headView addSubview:withBtn];
    
    headView.height = withBtn.bottom +10;
}

-(void)changeButtonContent
{
    NSString *title = @"最新";
    m_sort = SupportSortHigh;
    m_right2 = [UIButton buttonWithType:UIButtonTypeCustom];
    m_right2.frame = CGRectMake(0, 0, 50, 44);
    m_right2.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [m_right2 addTarget:self action:@selector(butEventRight) forControlEvents:UIControlEventTouchUpInside];
    [m_right2 setTitle:title forState:UIControlStateNormal];
    [m_right2 setTitle:title forState:UIControlStateNormal];
    UIBarButtonItem* leftBar = [[UIBarButtonItem alloc] initWithCustomView:m_right2];
    self.navigationItem.rightBarButtonItem = leftBar;
}

-(void)butEventRight
{
    NSString *strTitle = @"最高";
    switch (m_sort)
    {
        case SupportSortHigh:
        {
            m_sort = SupportSortNew;
            strTitle = @"最新";
        }
            break;
        case SupportSortNew:
        {
            m_sort = SupportSortHigh;
            strTitle = @"最高";
        }
            break;
        default:
            break;
    }
    [m_right2 setTitle:strTitle forState:UIControlStateNormal];
    
    m_nowPage = 1;
    [self getDataSource];
}


-(void)suportBtn
{
    SupportDetailVC * modify = [[SupportDetailVC alloc]init];
    [self.navigationController pushViewController:modify animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)getDataSourceFromLocal
{
    [self getDataSource];
}

- (void)getDataSource
{
    WS(weakSelf);
    //创建BmobQuery实例，指定对应要操作的数据表名称
    BmobQuery *query = [BombModel getBombModelWothName:@"donate"];
    
    NSString * orderKey = @"money";
    switch (m_sort) {
        case SupportSortHigh:
            orderKey = @"money";
            break;
        case SupportSortNew:
            orderKey = @"createdAt";
            break;
        default:
            break;
    }
    if (!IsStrEmpty(orderKey) && orderKey.length >= 3)
    {
        [query orderByDescending:orderKey];
    }
    [self showLoadingActiview];
    [query whereKey:@"money" greaterThan:@(kDisplayNum)];
    //返回最多20个结果
    // 忽略前20
//    query.skip = (m_nowPage-1)* g_everyPageNum;
    query.limit = kDisplayLimitNum;
    //执行查询
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        //处理查询结果
        [weakSelf fengzhuangArray:array withError:error];
    }];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{

}

- (void)fengzhuangArray:(NSArray*)array withError:(NSError *)error
{
     [self stopLoadingActiView];
    //错误处理
    if (error)
    {
        [self endOfResultList];
        [self finishRefresh];
        return;
    }
    __block NSMutableArray *firstArray = [NSMutableArray array];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (BmobObject *obj in array)
        {
            NSArray *array1= @[@"objectId",@"money",@"bgColor",@"username",@"city",@"tag"];
            NSDictionary *dict = [BombModel getDataFrom:obj withParam:array1 withDict:nil];
            [firstArray addObject:dict];
        }
        if (m_nowPage == 1)
        {
            [self.m_dataArray removeAllObjects];
        }
        [self.m_dataArray addObjectsFromArray:firstArray];
        dispatch_async(dispatch_get_main_queue(), ^{
//            if(firstArray.count < g_everyPageNum)
//            {
                [self endOfResultList];
//            }
//            else
//            {
//                m_loadingMore = NO;
//            }
            [self.m_tableView reloadData];
            if (self.m_tableView)
            {
                  [self.m_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
            }          
//            m_nowPage++;
            [self finishRefresh];
        });
    });
}
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"sosCell";
    SupportTableViewCell *cell =
    [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell)
    {
        cell = [[SupportTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                  reuseIdentifier:identifier];
    }
    NSMutableDictionary *dict = self.m_dataArray[indexPath.row];
    [cell setUpDict:dict];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *medicineDic = nil;
    medicineDic = self.m_dataArray[indexPath.row];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    float height = kSupportTableViewCellH;
    return height;
}
@end
