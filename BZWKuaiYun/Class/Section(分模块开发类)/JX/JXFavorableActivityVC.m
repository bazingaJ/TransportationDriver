//
//  JXFavorableActivityVC.m
//  BZWKuaiYun
//
//  Created by Jessey Young on 2017/5/27.
//  Copyright © 2017年 ISU. All rights reserved.
//

#import "JXFavorableActivityVC.h"
#import "JXActivityCell.h"
#import "JXActivityVC.h"

@interface JXFavorableActivityVC ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) NSArray *dataArr;

//记录所点击的索引
@property (nonatomic, strong) NSIndexPath *indexPa;

@end

@implementation JXFavorableActivityVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupUI];
    [self requestEventInfo];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
- (void)setupUI
{
    self.tableVi.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)requestEventInfo
{
    SVSHOW
    [JXRequestTool postEventInfoNeedPageSize:@"10" pageNum:@"1" complete:^(BOOL isSuccess, NSDictionary *respose) {
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
                self.dataArr = [JXMainModel mj_objectArrayWithKeyValuesArray:respose[@"res"]];
            }
            [self.tableVi reloadData];
        }
        else
        {
            self.tableVi.hidden = YES;
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
    //副标题是动态高度 其中单单一行的高度是15
    JXMainModel *model = _dataArr[indexPath.row];
    return 175+[JXTool getLabelHeightWithString:model.eventDesc needWidth:Main_Screen_Width-40];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cellIdentifier";
    JXActivityCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell)
    {
        cell = LoadBbundleCell(@"JXActivityCell", 0);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    JXMainModel *model = _dataArr[indexPath.row];
    cell.model = model;
    return cell;
}
#pragma mark - UITable view Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.indexPa = indexPath;
    [self performSegueWithIdentifier:@"JXActivityVC" sender:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

#pragma mark - Navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"JXActivityVC"])
    {
        JXMainModel *model = _dataArr[_indexPa.row];
        JXActivityVC *vc =segue.destinationViewController;
        vc.url = model.eventUrl;
        vc.titleLab = model.title;
    }
}



@end
