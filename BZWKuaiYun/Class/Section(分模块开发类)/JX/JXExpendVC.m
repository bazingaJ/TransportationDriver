//
//  JXExpendVC.m
//  BZWKuaiYun
//
//  Created by Jessey Young on 2017/6/1.
//  Copyright © 2017年 ISU. All rights reserved.
//

#import "JXExpendVC.h"
#import "JXInOutView.h"
#import "JXInOutCell.h"
#import "JXDatePickerView.h"

static const NSInteger kPickerViewH = 250;

@interface JXExpendVC ()<JXDateChoiceDelegate,JXDatePickerDelegate>
@property (nonatomic, strong) JXInOutView *headerView;
@property (nonatomic, strong) UIControl *layerControl;
@property (nonatomic, strong) NSDictionary *dataDic;
@property (nonatomic, strong) NSArray *dataArr;
@property (nonatomic, strong) JXDatePickerView *picker;
@end

@implementation JXExpendVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupUI];
    [self requestMyOutComeWithYearMonthString:[JXAppTool getNowYearAndMonth]];
}

- (JXInOutView *)headerView
{
    if (!_headerView)
    {
        _headerView = [[[NSBundle mainBundle] loadNibNamed:@"JXInOutView" owner:self options:nil]objectAtIndex:0];
        _headerView.delegate = self;
        _headerView.wholeMoneyLab.textColor = Main_Color;
        _headerView.moneyDetailLab.text = @"总支出";
        _headerView.frame = CGRectMake(0, 0, Main_Screen_Width, 180);
    }
    return _headerView;
}
- (void)setupUI
{
    self.tableVi.tableHeaderView = self.headerView;
    self.tableVi.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
}

- (void)requestMyOutComeWithYearMonthString:(NSString *)str
{
    SVSHOW
    [JXRequestTool postMyInOutComeNeedPageSize:@"10" pageNum:@"1" queryDate:str type:@"2" complete:^(BOOL isSuccess, NSDictionary *respose) {
        if (isSuccess)
        {
            self.dataDic = respose[@"res"];
            NSString *total = [NSString stringWithFormat:@"%@",[JXAppTool transforMoneyGetPenny:[NSString stringWithFormat:@"%@",_dataDic[@"total"]]]];
            NSString *outcomeStr = [NSString stringWithFormat:@"%@",total];
            
            self.headerView.wholeMoneyLab.text = [outcomeStr stringByReplacingOccurrencesOfString:@".00" withString:@""];
            self.dataArr = [JXMainModel mj_objectArrayWithKeyValuesArray:_dataDic[@"commentList"]];
            if (_dataArr.count == 0)
            {
                SVINFO(@"暂无支出数据", 1.5)
            }
            else
            {
                SVMISS
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
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cellIdentifier";
    JXInOutCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell)
    {
        cell = LoadBbundleCell(@"JXInOutCell", 0);
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    }
    
    JXMainModel *model = _dataArr[indexPath.row];
    cell.model = model;
    id money = model.amount;
    NSString *amount = [NSString stringWithFormat:@"%@",money];
    if (![JXTool verifyIsNullString:amount])
    {
        cell.moneyLab.text = [NSString stringWithFormat:@"-%@",[JXAppTool transforMoneyGetPenny:money]];
    }
    if (![JXTool verifyIsNullString:model.note])
    {
        cell.titleLab.text = model.operDesc;
    }
    cell.moneyLab.textColor = Main_Color;
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
    titleLab.text = @"支出明细";
    titleLab.textColor = RGBCOLOR(50, 50, 50);
    titleLab.font = F13;
    [vi addSubview:titleLab];
    
    return vi;
}
- (void)yearButtonClick
{
    self.layerControl.userInteractionEnabled = YES;
    [UIView animateWithDuration:.03f animations:^{
        self.layerControl.hidden = NO;
    } completion:^(BOOL finished) {
        self.picker.transform = CGAffineTransformMakeTranslation(0, -kPickerViewH);
    }];
}

- (void)monthButtonClick
{
    self.layerControl.userInteractionEnabled = YES;
    [UIView animateWithDuration:.03f animations:^{
        self.layerControl.hidden = NO;
    } completion:^(BOOL finished) {
        self.picker.transform = CGAffineTransformMakeTranslation(0, -kPickerViewH);
    }];
}


- (JXDatePickerView *)picker
{
    if (!_picker)
    {
        _picker = [[JXDatePickerView alloc] initWithFrame:CGRectMake(0, Main_Screen_Height-64, Main_Screen_Width, kPickerViewH)];
        _picker.delegate = self;
        [self.view addSubview:_picker];
    }
    return _picker;
}
- (UIControl *)layerControl
{
    if (!_layerControl)
    {
        //蒙层
        self.layerControl =[[UIControl alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height)];
        self.layerControl.backgroundColor=[UIColor blackColor];
        self.layerControl.alpha=0.6;
        [self.layerControl addTarget:self action:@selector(goHide) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.layerControl];
    }
    return _layerControl;
}
- (void)goHide
{
    self.layerControl.userInteractionEnabled = NO;
    [UIView animateWithDuration:.03f animations:^{
        self.layerControl.hidden = YES;;
    } completion:^(BOOL finished) {
        self.picker.transform = CGAffineTransformIdentity;
    }];
}
- (void)cancelButtonClickAfter:(NSString *)str
{
    [self goHide];
}
- (void)containButtonClickAfter:(NSString *)str
{
    [self goHide];
    NSArray *arr = [str componentsSeparatedByString:@" "];
    [self.headerView.yearBtn setTitle:[NSString stringWithFormat:@"%@年 ▼",[arr firstObject]] forState:UIControlStateNormal];
    [self.headerView.monthBtn setTitle:[NSString stringWithFormat:@"%@月 ▼",[arr lastObject]] forState:UIControlStateNormal];
    [self requestMyOutComeWithYearMonthString:[str stringByReplacingOccurrencesOfString:@" " withString:@"-"]];
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
