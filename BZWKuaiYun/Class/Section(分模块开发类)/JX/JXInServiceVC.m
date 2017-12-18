//
//  JXInService.m
//  BZWKuaiYun
//
//  Created by Jessey Young on 2017/5/22.
//  Copyright © 2017年 ISU. All rights reserved.
//

#import "JXInServiceVC.h"
#import "JXMyOrderCell.h"
#import "JXOrderDetailVC.h"
#import "OrderModel.h"

NSString *const JXInServiceVCNoOrderData = @"暂时没有订单数据";

@interface JXInServiceVC ()<UITableViewDelegate,UITableViewDataSource,JXMyOrderDelegate>

@property (nonatomic, strong) NSMutableArray *dataArr;

@end

@implementation JXInServiceVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupUI];
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self requestOrderDataWithOrderStatus:@"1"];
}
- (void)setupUI
{
    
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(recognizer:)];
    
    swipe.direction = UISwipeGestureRecognizerDirectionDown;
    [self.view addGestureRecognizer:swipe];
    
    self.tableVi.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableVi.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(reloadNewData)];
}
- (void)reloadNewData
{
    [self requestOrderDataWithOrderStatus:@"1"];
}

- (void)recognizer:(UIGestureRecognizer *)recognizer
{
    SVSTATUS(@"正在查询")
    [self reloadNewData];
}

#pragma mark - 请求区
//获取订单数据
- (void)requestOrderDataWithOrderStatus:(NSString *)status
{
    
    [JXOrderRequestTool postMyOrderInfoNeedOrderStatus:status pageSize:@"10" pageNum:@"1" complete:^(BOOL isSuccess, NSDictionary *respose) {
        if (isSuccess)
        {
            SVMISS
            self.dataArr = [NSMutableArray arrayWithArray:[OrderModel mj_objectArrayWithKeyValuesArray:respose[@"res"]]];
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

- (void)requestCancelOrderWithOrderId:(NSString *)orderID completeWithBlock:(void(^)(BOOL isSuccess))block
{
    SVSHOW
    [JXOrderRequestTool postCancelOrderNeedOrderId:orderID complete:^(BOOL isSuccess, NSDictionary *respose) {
        if (isSuccess)
        {
            SVSUCCESS(@"取消成功", 1.5)
            
            block(YES);
            
        }
        else
        {
            SVMISS
            block(NO);
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
    
    cell.delegate = self;
    OrderModel *model = _dataArr[indexPath.row];
    cell.model = model;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
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
    
    [kUserDefaults setObject:@"1" forKey:@"orderStyle"];
    [kUserDefaults synchronize];
    [self.navigationController pushViewController:firstVC animated:YES];
}

- (void)cancelOrderBtnClick:(UIButton *)btn
{
    JXMyOrderCell *cell = (JXMyOrderCell *)btn.superview.superview.superview;
    NSIndexPath *index = [_tableVi indexPathForCell:cell];
    OrderModel *model = _dataArr[index.row];
    NSString *orderID = [NSString stringWithFormat:@"%@",model.orderId];
    
    JCAlertStyle *style = [JCAlertStyle styleWithType:JCAlertTypeNormal];
    style.alertView.cornerRadius = 5;
    style.background.canDismiss = YES;
    
    style.title.textColor = RGBCOLOR(100, 100, 100);
    style.title.font = F15;
    style.title.insets = UIEdgeInsetsMake(15, 20, 5, 20);
    
    style.content.textColor = RGBCOLOR(144, 144, 144);
    style.content.font = F14;
    style.content.insets = UIEdgeInsetsMake(10, 20, 20, 20);
    style.content.minHeight = 100;
    
    style.buttonNormal.textColor = Main_Color;
    style.buttonCancel.textColor = RGBCOLOR(144, 144, 144);;
    
    
    JCAlertController *alert = [JCAlertController alertWithTitle:@"提示" message:@"取消订单将接受惩罚！" type:JCAlertTypeNormal];
    [alert addButtonWithTitle:@"取消" type:JCButtonTypeCancel clicked:^{
        
    }];
    [alert addButtonWithTitle:@"确定" type:JCButtonTypeNormal clicked:^{
        [self requestCancelOrderWithOrderId:orderID completeWithBlock:^(BOOL isSuccess) {
            if (isSuccess)
            {
                SVSUCCESS(@"取消成功", 1.5)
                [kNotificationCenter postNotificationName:@"gotoTable" object:nil];
                [self.dataArr removeObjectAtIndex:index.row];
                [self.tableVi reloadData];
            }
        }];
    }];
    
    [self jc_presentViewController:alert presentType:JCPresentTypeFIFO presentCompletion:nil dismissCompletion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}


#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"JXOrderDetailVC"])
    {
//        JXOrderDetailVC *vc = [segue destinationViewController];
        
    }
    
    
}


@end
