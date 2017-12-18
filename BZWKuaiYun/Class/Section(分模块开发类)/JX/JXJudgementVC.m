//
//  JXJudgementVC.m
//  BZWKuaiYun
//
//  Created by Jessey Young on 2017/6/1.
//  Copyright © 2017年 ISU. All rights reserved.
//

#import "JXJudgementVC.h"
#import "JXJudgeView.h"
#import "JXJudgeCell.h"

@interface JXJudgementVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) JXJudgeView *headerView;
@property (nonatomic, strong) NSDictionary *dataDic;
@property (nonatomic, strong) NSArray *dataArr;
@end

@implementation JXJudgementVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupUI];
    [kNotificationCenter addObserver:self selector:@selector(handleData:) name:@"evaluate" object:nil];
}
- (JXJudgeView *)headerView
{
    if (!_headerView)
    {
        _headerView = [[[NSBundle mainBundle] loadNibNamed:@"JXJudgeView" owner:self options:nil]objectAtIndex:0];
        _headerView.frame = CGRectMake(0, 0, Main_Screen_Width, 170);
    }
    return _headerView;
}
- (void)setupUI
{
    self.tableVi.tableHeaderView = self.headerView;
    self.tableVi.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
}

- (void)handleData:(NSNotification *)noti
{
    self.dataDic = noti.userInfo;
    self.headerView.scoreLab.text = [NSString stringWithFormat:@"%@",_dataDic[@"average"]];
    self.headerView.pointDetail.text = _dataDic[@"desc"];
    NSArray *arr = _dataDic[@"commentList"];
    self.dataArr = [JXMainModel mj_objectArrayWithKeyValuesArray:arr];
    if (_dataArr.count == 0)
    {
        SVINFO(@"暂无评价数据", 1.5)
    }
    else
    {
        SVMISS
    }
    [self.tableVi reloadData];
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
    JXMainModel *model = _dataArr[indexPath.row];
    if (![JXTool verifyIsNullString:model.comment])
    {
        //评价内容需要动态高度加载  92+16
        return 112+[JXTool getLabelHeightWithString:model.comment needWidth:Main_Screen_Width-36];
    }
    return 108;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cellIdentifier";
    JXJudgeCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell)
    {
        cell = LoadBbundleCell(@"JXJudgeCell", 0);
    }
    JXMainModel *model = _dataArr[indexPath.row];
    cell.model = model;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 33;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *vi = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 33)];
    
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 150, 33)];
    titleLab.text = @"用户评价";
    titleLab.textColor = RGBCOLOR(50, 50, 50);
    titleLab.font = F13;
    [vi addSubview:titleLab];
    
    return vi;
}
#pragma mark - UITable view Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)dealloc
{
    [kNotificationCenter removeObserver:self name:@"evaluate" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
