//
//  JXExamVC.m
//  BZWKuaiYun
//
//  Created by Jessey Young on 2017/5/25.
//  Copyright © 2017年 ISU. All rights reserved.
//

#import "JXExamVC.h"
#import "JXExamCell.h"
#import "JXGradeVC.h"
#import "JXExamModel.h"

@interface JXExamVC ()<UITableViewDelegate,UITableViewDataSource,JXExamOptionDelegate>
//装载数据的数组
@property (nonatomic, strong) NSMutableArray *dataArr;
//装载答案的数组
@property (nonatomic, strong) NSMutableArray *answerArr;
//装载答案的可变字符串
@property (nonatomic, strong) NSMutableString *answerStr;
@end

@implementation JXExamVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"考试考核";
    [self overrideBackButton];
    [self initialized];
    [self setupUI];
    [self requestExamInfo];
    
}
//加载UI设置
- (void)setupUI
{
    self.tableVi.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}
//数据容器初始化设置
- (void)initialized
{
    self.dataArr = [NSMutableArray array];
    
}
//创建一个装载答案的数组
- (void)createNewAnswerArrWithOriginArr:(NSMutableArray *)arr
{
    self.answerArr = [NSMutableArray array];
    for (int i = 0; i < arr.count; i++)
    {
        [self.answerArr addObject:@"0"];
    }
}
#pragma mark - 请求区
//请求查询考试题目
- (void)requestExamInfo
{
    SVSTATUS(@"正在加载考试题目")
    [JXRequestTool postExamInfoNeedComplete:^(BOOL isSuccess, NSDictionary *respose) {
        if (isSuccess)
        {
            NSArray *arr = respose[@"res"];
            self.dataArr = [JXExamModel mj_objectArrayWithKeyValuesArray:arr];
            [self createNewAnswerArrWithOriginArr:_dataArr];
            [self.tableVi reloadData];
            SVMISS
        }
    }];
}
//请求提交考试题目
- (void)requestWithContents:(NSMutableString *)contents
{
    SVSTATUS(@"正在提交")
    [JXRequestTool postExamCommitNeedContents:contents complete:^(BOOL isSuccess, NSDictionary *respose) {
        if (isSuccess)
        {
            SVMISS
            NSDictionary *dic = respose[@"res"];
            id yunStr = dic[@"yunId"];
            [kUserDefaults setObject:[NSString stringWithFormat:@"%@",yunStr] forKey:@"yunId"];
            [kUserDefaults synchronize];
            JXGradeVC *vc = [[JXGradeVC alloc] initWithDic:dic];
            if ([[NSString stringWithFormat:@"%@",dic[@"isPass"]] isEqualToString:@"1"])
            {
                vc.isPass = YES;
            }
            else
            {
                vc.isPass = NO;
            }
            [self.navigationController pushViewController:vc animated:YES];
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
    return 150;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cellIdentifier";
    JXExamCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell)
    {
        cell = LoadBbundleCell(@"JXExamCell", 0);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    JXExamModel *model = _dataArr[indexPath.row];
    NSString *title = [NSString stringWithFormat:@" %@. %@",model.sort,model.subject];
    cell.delegate = self;
    cell.titleLab.text = title;
    cell.model = model;
    cell.btnStatus = _answerArr[indexPath.row];
    return cell;
}

- (void)optionButtonClick:(UIButton *)btn
{
    NSInteger option = btn.tag;
    NSString *optionStr = nil;
    switch (option) {
        case 1:
        {
            optionStr = @"1";
        }
            break;
        case 2:
        {
            optionStr = @"2";
        }
            break;
        case 3:
        {
            optionStr = @"3";
        }
            break;
            
        default:
            break;
    }
    
    JXExamCell *cell = (JXExamCell *)btn.superview.superview;
    NSIndexPath *indexPath = [_tableVi indexPathForCell:cell];
    [_answerArr replaceObjectAtIndex:indexPath.row withObject:optionStr];
    self.answerStr = [NSMutableString string];
    for (int i = 0; i <_answerArr.count; i++)
    {
        JXExamModel *model = _dataArr[i];
        NSString *str = [NSString stringWithFormat:@"%@,%@|",model.subjectId,_answerArr[i]];
        [self.answerStr appendString:str];
    }
    
}

#pragma mark - 提交考试答案按钮点击事件
- (IBAction)commiBtnClick:(UIButton *)sender
{
    if ([self judgeCommitIsLegel])
    {
        [self requestWithContents:_answerStr];
    }
    
}
//判断是否合法
- (BOOL)judgeCommitIsLegel
{
    __block BOOL isLegel = NO;
    [_answerArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[NSString class]] && ![obj isEqualToString:@"0"])
        {
            isLegel = YES;
        }
        else if ([obj isKindOfClass:[NSString class]] && [obj isEqualToString:@"0"])
        {
            SVINFO(@"请答题完成后提交", 2)
            *stop = YES;
            isLegel = NO;
        }
        else
        {
            isLegel = NO;
        }
    }];
    return isLegel;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}



@end
