//
//  JXCanceledVC.m
//  BZWKuaiYun
//
//  Created by Jessey Young on 2017/5/22.
//  Copyright © 2017年 ISU. All rights reserved.
//

#import "JXCanceledVC.h"
#import "JXMyOrderCell.h"
#import "JXOrderDetailVC.h"

@interface JXCanceledVC ()<UITableViewDelegate,UITableViewDataSource,JXMyOrderDelegate>

@property (nonatomic, strong) NSArray *dataArr;

@end

@implementation JXCanceledVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupUI];
    [self requestOrderDataWithOrderStatus:@"3"];
}
- (void)setupUI
{
    //添加手势
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(recognizer3:)];
    
    swipe.direction = UISwipeGestureRecognizerDirectionDown;
    [self.view addGestureRecognizer:swipe];
    
    self.tableVi.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableVi.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(reloadNewData3)];
}
- (void)reloadNewData3
{
    [self requestOrderDataWithOrderStatus:@"3"];
}
- (void)recognizer3:(UIGestureRecognizer *)recognizer
{
    SVSTATUS(@"正在查询")
    [self reloadNewData3];
}
//获取订单数据
- (void)requestOrderDataWithOrderStatus:(NSString *)status
{
    [JXOrderRequestTool postMyOrderInfoNeedOrderStatus:status pageSize:@"10" pageNum:@"1" complete:^(BOOL isSuccess, NSDictionary *respose) {
        if (isSuccess)
        {
            SVMISS
            self.dataArr = [OrderModel mj_objectArrayWithKeyValuesArray:respose[@"res"]];
            if (_dataArr.count == 0)
            {
                self.tableVi.hidden = YES;
                [self.tableVi reloadData];
                [self.tableVi.mj_header endRefreshing];
            }
            else
            {
                self.tableVi.hidden = NO;
                [self.tableVi reloadData];
                [self.tableVi.mj_header endRefreshing];
                
            }
        }
        else
        {
            SVMISS
            self.tableVi.hidden = YES;
            [self.tableVi reloadData];
            [self.tableVi.mj_header endRefreshing];
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
    return 168;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cellIdentifier";
    JXMyOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell)
    {
        cell = LoadBbundleCell(@"JXMyOrderCell", 0);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    OrderModel *model = _dataArr[indexPath.row];
    cell.delegate = self;
    cell.model = model;
    cell.cancelOrder.hidden = YES;
    cell.lookBtnTrailing.constant = 10;
    return cell;
}
- (void)checkOrderBtnClick:(UIButton *)btn
{
    //通过父视图寻找 来确定indexPath 最后确定OrderID
    JXMyOrderCell *cell = (JXMyOrderCell *)btn.superview.superview.superview;
    NSIndexPath *index = [_tableVi indexPathForCell:cell];
    OrderModel *model = _dataArr[index.row];
    NSString *orderID = [NSString stringWithFormat:@"%@",model.orderId];
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    JXOrderDetailVC *firstVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"JXOrderDetailVC"];
    firstVC.orderId = orderID;
    NSUserDefaults *us = kUserDefaults;
    [us setObject:@"3" forKey:@"orderStyle"];
    [us synchronize];
    
    [self.navigationController pushViewController:firstVC animated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
