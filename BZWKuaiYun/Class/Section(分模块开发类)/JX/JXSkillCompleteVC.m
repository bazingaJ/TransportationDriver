//
//  JXSkillCompleteVC.m
//  BZWKuaiYun
//
//  Created by Jessey Young on 2017/5/26.
//  Copyright © 2017年 ISU. All rights reserved.
//

#import "JXSkillCompleteVC.h"
#import "JXSkillCell.h"



@interface JXSkillCompleteVC ()<UITableViewDelegate,UITableViewDataSource,JXSkillCellDelegate,UITextFieldDelegate>
//模型数组
@property (nonatomic, strong) NSMutableArray *dataArr;
//装载技能按钮选择状态的数组
@property (nonatomic, strong) NSMutableArray *btnArr;
//上传用到的字符串
@property (nonatomic, strong) NSMutableString *wholeStr;

@property (nonatomic, strong) UITextField *skillTF;

@end

@implementation JXSkillCompleteVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initialized];
    [self setupUI];
    [self requestMySkillInfo];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
- (void)initialized
{
    self.dataArr = [NSMutableArray array];
    self.btnArr = [NSMutableArray array];
    self.wholeStr = [NSMutableString string];
}
- (void)setupUI
{
    self.tableVi.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapTableView)];
    tap.cancelsTouchesInView = NO;
    [self.tableVi addGestureRecognizer:tap];
    
}
//请求查询技能信息
- (void)requestMySkillInfo
{
    SVSHOW
    [JXRequestTool postMySkillInfoComplete:^(BOOL isSuccess, NSDictionary *respose) {
        if (isSuccess)
        {
            SVMISS
            self.dataArr = [JXMainModel mj_objectArrayWithKeyValuesArray:respose[@"res"]];
            [self.tableVi reloadData];
            
            dispatch_queue_t queue = dispatch_queue_create("createArrQueue", DISPATCH_QUEUE_CONCURRENT);
            dispatch_async(queue, ^{
                
                for (int i = 0; i <_dataArr.count; i++)
                {
                    JXMainModel *model = _dataArr[i];
                    NSString *isCheck = [NSString stringWithFormat:@"%@",model.isCheck];
                    if ([isCheck isEqualToString:@"0"])
                    {
                        [self.btnArr addObject:@"0"];
                    }
                    else
                    {
                        [self.btnArr addObject:@"1"];
                        
                    }
                    
                }
            });
            
        }
    }];
}
//上传我的技能信息
- (void)requestUploadMySkillInfo
{
    SVSHOW
    [JXRequestTool postMySkillImproveNeedSkillSet:_wholeStr complete:^(BOOL isSuccess, NSDictionary *respose) {
        if (isSuccess)
        {
            SVMISS
            [self showAlert];
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
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) return [self getCellHeightWithArrayCount:_dataArr.count];
    return 70;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID1 = @"cell1";
    static NSString *cellID2 = @"cell2";
    
    JXSkillCell *cell = nil;
    if (indexPath.row == 0)
    {
        cell =[tableView dequeueReusableCellWithIdentifier:cellID1];
        if (!cell)
        {
            cell = LoadBbundleCell(@"JXSkillCell", 0);
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.title.text = @"技能一";
        cell.delegate =self;
        cell.wholeArr = _dataArr;
    }
    else
    {
        cell =[tableView dequeueReusableCellWithIdentifier:cellID2];
        if (!cell)
        {
            cell = LoadBbundleCell(@"JXSkillCell", 1);
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        self.skillTF = cell.skillTF;
        self.skillTF.delegate = self;
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *vi = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 30)];
    vi.backgroundColor = white_color;
    UILabel *headerTitle = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, Main_Screen_Width, 30)];
    headerTitle.text = @"提示：根据您选择的技能我们将优先为您推送";
    headerTitle.textColor = RGBCOLOR(100, 100, 100);
    headerTitle.font = F13;
    [vi addSubview:headerTitle];
    
    return vi;
    
}

- (IBAction)saveBtnClick:(UIButton *)sender
{
    __block BOOL isOk = NO;
    [self.btnArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([obj isEqualToString:@"1"])
        {
            JXMainModel *model = _dataArr[idx];
            [self.wholeStr appendString:[NSString stringWithFormat:@"%@,",model.skillDesc]];
            isOk = YES;
        }
    }];
    if (isOk == NO && [_skillTF.text isEqualToString:@""])
    {
        SVINFO(@"请选择一项技能或填写一项技能", 1.5)
    }
    else
    {
        if (![JXTool verifyIsNullString:_skillTF.text])
        {
            [_wholeStr appendString:_skillTF.text];
        }
        [self requestUploadMySkillInfo];
        
    }
    
}

- (void)showAlert
{
    JCAlertStyle *style = [JCAlertStyle styleWithType:JCAlertTypeNormal];
    style.alertView.cornerRadius = 5;
    style.background.canDismiss = NO;
    
    style.title.textColor = RGBCOLOR(100, 100, 100);
    style.title.font = F15;
    style.title.insets = UIEdgeInsetsMake(15, 20, 5, 20);
    
    style.content.textColor = RGBCOLOR(144, 144, 144);
    style.content.font = F14;
    style.content.insets = UIEdgeInsetsMake(5, 20, 0, 20);
    style.content.minHeight = 100;
    
    style.buttonNormal.textColor = Main_Color;
    style.buttonCancel.textColor = RGBCOLOR(144, 144, 144);;
    
    
    JCAlertController *alert = [JCAlertController alertWithTitle:@"提示" message:@"技能保存成功，您选择的技能将作为推送的标准。\n" type:JCAlertTypeNormal];
    
    [alert addButtonWithTitle:@"好的" type:JCButtonTypeNormal clicked:^{
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    [self jc_presentViewController:alert presentType:JCPresentTypeFIFO presentCompletion:nil dismissCompletion:nil];
}


- (CGFloat)getCellHeightWithArrayCount:(NSInteger)count
{
    //96=36+30+30 一行高是30
    NSInteger rows = count / 3;
    NSInteger over = count % 3;
    if (over == 0)
    {
        return 30+rows*30;
    }
    else
    {
        return 36+(rows+1)*30;
    }
    
}
#pragma mark - JXSkillCellDelegate 方法
- (void)selectedButtonClick:(UIButton *)btn
{
    btn.selected = !btn.selected;
    NSInteger tag = btn.tag/10;
    if ([self.btnArr[tag] isEqualToString:@"0"])
    {
        [self.btnArr replaceObjectAtIndex:tag withObject:@"1"];
    }
    else
    {
        [self.btnArr replaceObjectAtIndex:tag withObject:@"0"];
    }
    
}




- (void)tapTableView
{
    [self.tableVi endEditing:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}



@end
