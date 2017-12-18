//
//  JXMyPointVC.m
//  BZWKuaiYun
//
//  Created by Jessey Young on 2017/5/26.
//  Copyright © 2017年 ISU. All rights reserved.
//

#import "JXMyPointVC.h"
#import "JXMyPointHeaderView.h"
#import "JXPointCell.h"
#import "JXMainModel.h"

static NSString *const kPageSize = @"10";
static NSInteger count = 0;

@interface JXMyPointVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) JXMyPointHeaderView *headerView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@end

@implementation JXMyPointVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupUI];
    [self initialized];
    [self requestMyPointWithPageNum:1];
}
- (void)initialized
{
    self.dataArr = [NSMutableArray array];
}
- (void)setupUI
{
    
    self.tableVi.tableHeaderView = self.headerView;
    self.tableVi.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableVi.mj_footer = [MJRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(refeshNewData)];
}
- (JXMyPointHeaderView *)headerView
{
    if (!_headerView)
    {
        _headerView = [[[NSBundle mainBundle] loadNibNamed:@"JXMyPointHeaderView" owner:self options:nil]objectAtIndex:0];
        _headerView.frame = CGRectMake(0, 0, Main_Screen_Width, 160);
        _headerView.pointLab.text = self.myPoint;
    }
    return _headerView;
}

- (void)refeshNewData
{
    count ++;
    [self requestMyPointWithPageNum:count];
}

- (void)requestMyPointWithPageNum:(NSInteger)count
{
    SVSHOW
    [JXRequestTool postMyPointNeedPageSize:kPageSize pageNum:[NSString stringWithFormat:@"%ld",(long)count] complete:^(BOOL isSuccess, NSDictionary *respose) {
        if (isSuccess)
        {
            SVMISS
            NSDictionary *dic = respose[@"res"];
            self.dataArr = [JXMainModel mj_objectArrayWithKeyValuesArray:[NSMutableArray arrayWithArray:dic[@"costList"]]];
            [self.tableVi reloadData];
        }
    }];
}

#pragma mark - UITable view Data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cellIdentifier";
    JXPointCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell)
    {
        cell = LoadBbundleCell(@"JXPointCell", 0);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    JXMainModel *model = _dataArr[indexPath.row];
    cell.model =model;
    
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *vi = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 40)];
    vi.backgroundColor = white_color;
    
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 80, 40)];
    titleLab.text = @"积分明细";
    titleLab.textColor = RGBCOLOR(50, 50, 50);
    titleLab.font = F14;
    [vi addSubview:titleLab];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, MaxY(vi)-1, Main_Screen_Width, 1)];
    line.backgroundColor = RGBCOLOR(240, 240, 240);
    [vi addSubview:line];
    
    return vi;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}
#pragma mark - UITable view Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}



@end
