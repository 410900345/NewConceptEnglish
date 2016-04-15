//
//  KXPayManageView.m
//  jiuhaohealth4.2
//
//  Created by jiuhao-yangshuo on 15/12/21.
//  Copyright © 2015年 xuGuohong. All rights reserved.
//

#import "SXManageView.h"
#import "WordList.h"

static float const kHeaderViewH = 55;
static NSString *const KseparatorColor = @"ebebeb";
@interface SXManageView ()<UITableViewDataSource, UITableViewDelegate>
{
    UITableView *m_tableView;
    SXBasicBlock _inBlock;
    UIView* m_view;
}
@end

@implementation SXManageView

-(id)initWithKXPayManageViewBlock:(SXBasicBlock)block
{
    CGRect frame = [UIScreen mainScreen].bounds;
    self = [super initWithFrame:frame];
    if (self)
    {
        
        //        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
        _inBlock = [block copy];
        
        m_view = [[UIView alloc] initWithFrame:frame];
        m_view.backgroundColor = [UIColor clearColor];
        [self addSubview:m_view];
    }
    return self;
}

-(void)setM_dataArray:(NSArray *)dataArray
{
    if (_m_dataArray != dataArray)
    {
        _m_dataArray = nil;
        _m_dataArray = [NSMutableArray arrayWithArray:dataArray];
    }
    [self.tableView reloadData];
}

-(UITableView *)tableView
{
    if (m_tableView != nil) {
        return m_tableView;
    }
    
    CGRect rect = self.frame;
    rect.origin.x = 0;
    rect.origin.y = 0;
    rect.size.width = kDeviceWidth-25*2;
    float height = kHeaderViewH+_m_dataArray.count*kSXManageViewCellH;
    rect.size.height = MIN(kDeviceHeight-100, height);// 超出屏幕
    
    m_tableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
    m_tableView.delegate = self;
    m_tableView.rowHeight = kSXManageViewCellH;
    m_tableView.separatorColor = [CommonImage colorWithHexString:KseparatorColor];
    m_tableView.dataSource = self;
    m_tableView.alwaysBounceHorizontal = NO;
    m_tableView.alwaysBounceVertical = NO;
    m_tableView.showsHorizontalScrollIndicator = NO;
    m_tableView.showsVerticalScrollIndicator = NO;
    m_tableView.scrollEnabled = NO;
    m_tableView.backgroundColor = [UIColor whiteColor];
    m_tableView.layer.cornerRadius = 4.0;
    m_tableView.tableHeaderView = [self createHeaderView];
    m_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self adjustSeparatorInsetWithView:m_tableView];
    m_tableView.center = self.center;
    
    [self addSubview:self.tableView];
    [self bringSubviewToFront:m_tableView];
    return m_tableView;
}

-(UIView *)createHeaderView
{
    UIView * headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, m_tableView.width, kHeaderViewH)];
    headerView.backgroundColor = [UIColor whiteColor];
    
    UILabel *m_titleLabel = [Common createLabel:CGRectMake(0,0, headerView.width, headerView.height) TextColor:COLOR_666666 Font:[UIFont boldSystemFontOfSize:M_FRONT_SIXTEEN] textAlignment:NSTextAlignmentCenter labTitle:@""];
    m_titleLabel.text = @"请选择生词本";
    [headerView addSubview:m_titleLabel];
    
    UILabel* lineLable =[[UILabel alloc] initWithFrame:CGRectMake(15, headerView.height - 0.5, headerView.width-30, 0.5)] ;
    lineLable.backgroundColor = [CommonImage colorWithHexString:KseparatorColor];
    [headerView addSubview:lineLable];
    return headerView;
}

#pragma mark - UITableView DataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_m_dataArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    SXManageViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[SXManageViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    if (indexPath.row < _m_dataArray.count)
    {
        cell.m_dict = _m_dataArray[indexPath.row];
    }
    //    if (IS_OS_8_OR_LATER)//分割线到头
    //    {
    //        cell.preservesSuperviewLayoutMargins = NO;
    //    }
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self adjustSeparatorInsetWithView:cell];
}

-(void)adjustSeparatorInsetWithView:(UITableViewCell *)view
{
    UIEdgeInsets insetSep = UIEdgeInsetsMake(0, 15, 0, 15);
    if ([view respondsToSelector:@selector(setSeparatorInset:)]) {
        [view setSeparatorInset:insetSep];
    }
    if ([view respondsToSelector:@selector(setLayoutMargins:)]) {
        [view setLayoutMargins:insetSep];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = _m_dataArray[indexPath.row];
    if (_inBlock)
    {
        _inBlock(dict);
    }
    [self dismiss:YES];
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self dismiss:YES];
}

-(void)dismiss:(BOOL)animate
{
    [UIView animateWithDuration:0.3 animations:^{
        m_tableView.transform = CGAffineTransformMakeScale(0.1f, 0.1f);
        self.alpha = 0.f;
    } completion:^(BOOL finished) {
        m_view.backgroundColor = [UIColor clearColor];
        [self removeFromSuperview];
    }];
}

-(void)show
{
    self.alpha = 0.f;
    self.transform = CGAffineTransformMakeScale(0.1f, 0.1f);
    [UIView animateWithDuration:0.2f delay:0.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.transform = CGAffineTransformMakeScale(1.05f, 1.05f);
        self.alpha = 1.f;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.08f delay:0.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.transform = CGAffineTransformIdentity;
            m_view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
        } completion:nil];
    }];
}

+(void)showSXManageViewWithBlock:(SXBasicBlock)block
{
    dispatch_queue_t queueS = dispatch_queue_create("com.kangxun", DISPATCH_QUEUE_SERIAL);
    dispatch_async(queueS, ^{
        WordList *wordList = [[WordList alloc] init];
        NSArray *dataArray = [wordList fetchWorBookListsData];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (dataArray.count)
            {
                SXManageView *payView = [[SXManageView alloc] initWithKXPayManageViewBlock:block];
                payView.m_dataArray = dataArray;
                [APP_DELEGATE addSubview:payView];
                [payView show];
            }
        });
    });
}

#pragma mark - insert into
+ (void)inserIntoDBWithDict:(NSDictionary *)dict
{
    __block NSDictionary *weakDict = dict;
    WS(weakSelf);
    [[self class] showSXManageViewWithBlock:^(NSDictionary *content) {
        [weakSelf insertIntoDict:weakDict withBookContent:content];
    }];
}

+ (void)insertIntoDict:(NSDictionary *)dict withBookContent:(NSDictionary *)bookDict
{
    WordList *wordList = [[WordList alloc] init];
    WordListModel *model = [WordListModel yy_modelWithDictionary:dict];
    model.pid = bookDict[@"bookid"];
    [wordList insertBookWithWordListModel:model];
}

+(void)inserIntoDBWithModel:(WordListModel *)wordListModel
{
    __block WordListModel *weakDict = wordListModel;
    WS(weakSelf);
    [[self class] showSXManageViewWithBlock:^(NSDictionary *content) {
        [weakSelf insertIntoModel:weakDict withBookContent:content];
    }];
}

+(void )fillModelWithWord:(NSString *)word andSymbol:(NSString *)symbol andExplain:(NSString *)explain
{
    WordListModel *wordListModel = [WordListModel fillModelWithWord:word andSymbol:symbol andExplain:explain];
    [SXManageView inserIntoDBWithModel:wordListModel];
}

+ (void)insertIntoModel:(WordListModel *)model withBookContent:(NSDictionary *)bookDict
{
    WordList *wordList = [[WordList alloc] init];
    model.pid = bookDict[@"bookid"];
    [wordList insertBookWithWordListModel:model];
}

@end
