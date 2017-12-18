//
//  JXBalanceDetailVC.m
//  BZWKuaiYun
//
//  Created by Jessey Young on 2017/5/26.
//  Copyright © 2017年 ISU. All rights reserved.
//

#import "JXBalanceDetailVC.h"
#import "JXBalanceDetailCell.h"

@interface JXBalanceDetailVC ()

@property (nonatomic, strong) NSMutableArray *dataArr;

@end

@implementation JXBalanceDetailVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initialized];
    [self setupUI];
    [self requestMyBalanceInfo];
}

- (void)initialized
{
    self.dataArr = [NSMutableArray array];
}

- (void)setupUI
{
    self.tableVi.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)requestMyBalanceInfo
{
    SVSHOW
    [JXRequestTool postMyBalanceInfoNeedPageSize:@"10" pageNum:@"1" complete:^(BOOL isSuccess, NSDictionary *respose) {
        if (isSuccess)
        {
            SVMISS
            NSArray *arr = [respose[@"res"] copy];
            if (arr.count == 0)
            {
                self.tableVi.hidden = YES;
            }
            else
            {
                self.tableVi.hidden = NO;
                self.dataArr = [JXMainModel mj_objectArrayWithKeyValuesArray:arr];
            }
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
    return 74;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cellIdentifier";
    JXBalanceDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell)
    {
        cell = LoadBbundleCell(@"JXBalanceDetailCell", 0);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    JXMainModel *model = _dataArr[indexPath.row];
    cell.model = model;
    return cell;
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
