//
//  JXSelectCarVC.m
//  BZWKuaiYun
//
//  Created by Jessey Young on 2017/5/24.
//  Copyright © 2017年 ISU. All rights reserved.
//

#import "JXSelectCarVC.h"
#import "JXCityModel.h"

@interface JXSelectCarVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) UITableView *rightTable;
@property (nonatomic, strong) NSMutableArray *rightArr;

@property (nonatomic, strong) NSString *selectCar;
@property (nonatomic, strong) NSString *selectCarType;

@property (nonatomic, strong) NSIndexPath *indexPa;

@end

@implementation JXSelectCarVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"车辆选择";
    [self overrideBackButton];
    [self initialized];
    [self setupUI];
    [self requestqueryAutoType];
}
- (void)initialized
{
    self.indexPa = [NSIndexPath indexPathForRow:0 inSection:0];
    self.dataArr = [NSMutableArray array];
    self.rightArr = [NSMutableArray array];
}
- (void)setupUI
{
    self.tableVi.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.rightTable.hidden = NO;
    self.automaticallyAdjustsScrollViewInsets = YES;
}

- (UITableView *)rightTable
{
    if (!_rightTable)
    {
        _rightTable = [[UITableView alloc] initWithFrame:CGRectMake(Main_Screen_Width, 64, Main_Screen_Width/2, Main_Screen_Height-kNavBarHeight) style:UITableViewStylePlain];
        _rightTable.backgroundColor = BackGround_Color;
        _rightTable.delegate = self;
        _rightTable.dataSource = self;
        _rightTable.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _rightTable.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        [self.view addSubview:_rightTable];
    }
    return _rightTable;
}
//获取全部车型
- (void)requestqueryAutoType
{
    SVSHOW
    [JXRequestTool postQueryAutoTypeNeedAutoType:@"" complete:^(BOOL isSuccess, NSDictionary *respose) {
        if (isSuccess)
        {
            [self.dataArr removeAllObjects];
            NSArray *arr = respose[@"res"];
            for (NSDictionary *smallDic in arr)
            {
                JXCarTypeModel *model = [JXCarTypeModel mj_objectWithKeyValues:smallDic];
                [self.dataArr addObject:model];
            }
            SVMISS
            [self.tableVi reloadData];
        }
    }];
}
//获取某一个车型子系列
- (void)requestQueryAutoType:(NSString *)type
{
    SVSHOW
    [JXRequestTool postQueryAutoTypeNeedAutoType:type complete:^(BOOL isSuccess, NSDictionary *respose) {
        if (isSuccess)
        {
            [self.rightArr removeAllObjects];
            NSArray *arr = respose[@"res"];
            for (NSDictionary *smallDic in arr)
            {
                JXCarTypeModel *model = [JXCarTypeModel mj_objectWithKeyValues:smallDic];
                [self.rightArr addObject:model];
            }
            SVMISS
            [self.rightTable reloadData];
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
    if (tableView == _tableVi)
    {
        return _dataArr.count;
    }
    else
    {
        return _rightArr.count;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _tableVi)
    {
        static NSString *cellID = @"cellIdentifier";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
            
            UIView *lineVi = [[UIView alloc] init];
            lineVi.frame = CGRectMake(0, 0, 5, 50);
            lineVi.backgroundColor = clear_color;
            [cell addSubview:lineVi];
        }
        JXCarTypeModel *model = _dataArr[indexPath.row];
        cell.textLabel.text = model.autoTypeName;
        return cell;
    }
    else
    {
        static NSString *cellID1 = @"cellIdentifier1";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID1];
        if (!cell)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID1];
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
            
        }
        JXCarTypeModel *model = _rightArr[indexPath.row];
        NSString *autoSizeStr = model.autoSize;
        if ([JXTool verifyIsNullString:autoSizeStr])
        {
            cell.textLabel.text = @"暂无数据";
        }
        else
        {
            cell.textLabel.text = [NSString stringWithFormat:@"车厢长%@",model.autoSize];
        }
        
        return cell;
    }
    
}

#pragma mark - UITable view Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (tableView == _tableVi)
    {
        UITableViewCell *cell0 = [tableView cellForRowAtIndexPath:_indexPa];
        cell0.textLabel.textColor = Text_Color;
        UIView *lineVi0 = cell0.subviews[2];
        lineVi0.backgroundColor = clear_color;
        
        
        cell.textLabel.textColor = Main_Color;
        UIView *lineVi = cell.subviews[2];
        lineVi.backgroundColor = Main_Color;
        
        JXCarTypeModel *model = _dataArr[indexPath.row];
        self.selectCar = model.autoTypeName;
        [self requestQueryAutoType:model.autoTypeName];
        
        [UIView animateWithDuration:0.2 animations:^{
            self.rightTable.transform = CGAffineTransformMakeTranslation(-Main_Screen_Width/2, 0);
        } completion:^(BOOL finished) {
            
        }];
        self.indexPa = indexPath;
    }
    else
    {
        JXCarTypeModel *model = _rightArr[indexPath.row];
        self.selectCarType = cell.textLabel.text;
        [UIView animateWithDuration:0.2 animations:^{
            self.rightTable.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            if (self.car)
            {
                self.car(_selectCar, _selectCarType, model.autoType);
            }
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }
    
}
- (void)createLineInView:(UITableViewCell *)cell
{
    UIView *lineVi = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 3, cell.frame.size.height)];
    lineVi.backgroundColor = Main_Color;
    [cell addSubview:lineVi];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}



@end
