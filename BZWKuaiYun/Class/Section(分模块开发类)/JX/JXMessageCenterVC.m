//
//  JXMessageCenterVC.m
//  BZWKuaiYun
//
//  Created by Jessey Young on 2017/5/27.
//  Copyright © 2017年 ISU. All rights reserved.
//

#import "JXMessageCenterVC.h"
#import "JXMessageCell.h"

@interface JXMessageCenterVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSArray *dataArr;
@end

@implementation JXMessageCenterVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupUI];
    
    [self requestMyMessage];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = NO;
}
- (void)setupUI
{
    self.tableVi.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}


- (void)requestMyMessage
{
    SVSHOW
    [JXRequestTool postDriverInfoNeedPageSize:@"10" pageNum:@"1" complete:^(BOOL isSuccess, NSDictionary *respose) {
        if (isSuccess)
        {
            NSArray *arr = [respose[@"res"] copy];
            if (arr.count == 0)
            {
                SVMISS
                [self.tableVi reloadData];
                self.tableVi.hidden = YES;
                
            }
            else
            {
                SVMISS
                self.tableVi.hidden = NO;
                self.dataArr = [JXMainModel mj_objectArrayWithKeyValuesArray:arr];
                [self.tableVi reloadData];
            }
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
    //其他内容高度 68 下方详情内容高度每行16
    JXMainModel *model = _dataArr[indexPath.row];
    return 68+[JXTool getLabelHeightWithString:model.contents needWidth:Main_Screen_Width-30];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cellIdentifier";
    JXMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell)
    {
        cell = LoadBbundleCell(@"JXMessageCell", 0);
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
