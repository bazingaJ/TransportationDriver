//
//  JXCommonQuestionVC.m
//  BZWKuaiYun
//
//  Created by Jessey Young on 2017/5/27.
//  Copyright © 2017年 ISU. All rights reserved.
//

#import "JXCommonQuestionVC.h"
#import "JXCommonQuestionDetailVC.h"

@interface JXCommonQuestionVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) NSIndexPath *indexP;
@end

@implementation JXCommonQuestionVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initialized];
    [self setupUI];
    [self requestNormalQuestion];
}
- (void)initialized
{
    
}
- (void)setupUI
{
    self.tableVi.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)requestNormalQuestion
{
    SVSHOW
    [JXRequestTool postQueryQuestionListComplete:^(BOOL isSuccess, NSDictionary *respose) {
        if (isSuccess)
        {
            self.titles = respose[@"res"];
            [self.tableVi reloadData];
            SVMISS
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
    return _titles.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    NSDictionary *dic= _titles[indexPath.row];
    cell.textLabel.text = dic[@"title"];
    cell.textLabel.textColor = RGBCOLOR(50, 50, 50);
    cell.textLabel.font = F14;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
#pragma mark - UITable view Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.indexP = indexPath;
    [self performSegueWithIdentifier:@"JXCommonQuestionDetailVC" sender:nil];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"JXCommonQuestionDetailVC"])
    {
        JXCommonQuestionDetailVC *vc = segue.destinationViewController;
        NSDictionary *dic= _titles[_indexP.row];
        vc.questionID = [NSString stringWithFormat:@"%@",dic[@"id"]];
        
    }
}

@end
