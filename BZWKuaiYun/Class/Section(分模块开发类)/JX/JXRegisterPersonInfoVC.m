//
//  JXRegisterPersonInfoVC.m
//  BZWKuaiYun
//
//  Created by Jessey Young on 2017/5/23.
//  Copyright © 2017年 ISU. All rights reserved.
//

#import "JXRegisterPersonInfoVC.h"
#import "JXResInfoCell.h"
#import "JXRegCarInfoVC.h"


#import "JXExamVC.h"

@interface JXRegisterPersonInfoVC ()< UITableViewDelegate,
                                      UITableViewDataSource,
                                      UITextFieldDelegate >

@property (nonatomic, strong) NSMutableArray *datas;
@property (nonatomic, strong) NSString *cityName;
@property (nonatomic, strong) NSString *areaName;
@property (nonatomic, strong) NSString *cityID;
@property (nonatomic, strong) NSString *countryID;
@property (nonatomic, strong) NSMutableDictionary *sendDict;

@property (nonatomic, strong) NSString *logi;
@property (nonatomic, strong) NSString *lati;

@end

@implementation JXRegisterPersonInfoVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"注册";
    [self overrideBackButton];
    [self initialized];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
    self.tableVi.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardShouldDown)];
    tap.cancelsTouchesInView = NO;
    [self.tableVi addGestureRecognizer:tap];
}

- (void)initialized
{
    NSMutableDictionary *dic1 = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"真实姓名",@"title",@"请输入身份证真实姓名",@"placeholder",@"",@"content", nil];
    NSMutableDictionary *dic2 = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"身份证号",@"title",@"请输入真实身份证号",@"placeholder",@"",@"content", nil];
    NSMutableDictionary *dic3 = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"所属城市",@"title",@"北京市朝阳区",@"placeholder",@"",@"content", nil];
    NSMutableDictionary *dic4 = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"紧急联系人",@"title",@"请输入紧急联系人",@"placeholder",@"",@"content", nil];
    NSMutableDictionary *dic5 = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"紧急联系人电话",@"title",@"请输入紧急联系人号码",@"placeholder",@"",@"content", nil];
    self.datas = [[NSMutableArray alloc] initWithObjects:dic1,dic2,dic3,dic4,dic5, nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    self.sendDict = [NSMutableDictionary dictionary];
}

#pragma mark - UITable view Data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 54;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    static NSString *cellID = @"cellIdentifier";
    JXResInfoCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell)
    {
        cell = LoadBbundleCell(@"JXResInfoCell", 0);
    }
    cell.dataDic = _datas[indexPath.row];
    cell.detail.delegate = self;
    cell.detail.tag = indexPath.row + 10086;
    
    if (indexPath.row == 1)
    {
        cell.detail.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    }
    else if (indexPath.row == 2)
    {
        cell.detail.userInteractionEnabled = NO;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textFieldTrailing.constant = 0;
    }
    else if (indexPath.row == 4)
    {
        cell.detail.keyboardType = UIKeyboardTypeNumberPad;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( indexPath.row == 4)
    {
        cell.separatorInset = UIEdgeInsetsMake(0, Main_Screen_Width, 0, 0);
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 34;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *vi = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 34)];
    vi.backgroundColor = RGBCOLOR(240, 240, 240);
    
    UILabel *infoLab = [[UILabel alloc] init];
    infoLab.bounds = CGRectMake(0, 0, 150, 20);
    infoLab.center = CGPointMake(95, vi.center.y);
    infoLab.text = @"个人信息";
    infoLab.textColor = RGBCOLOR(100, 100, 100);
    infoLab.font = F13;
    [vi addSubview:infoLab];
    
    return vi;
}
#pragma mark - UITable view Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    JXResInfoCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (indexPath.row == 2)
    {
        JXSelectCity *vc = [[JXSelectCity alloc] init];
        vc.choice = ^(NSString *city, NSString *cityID, NSString *country, NSString *countryID, NSString *logi, NSString *lati) {
            
            cell.detail.text = [NSString stringWithFormat:@"%@ %@",city,country];
            NSMutableDictionary *dic1 = _datas[2];
            dic1[@"content"] = cell.detail.text;
            self.cityName = city;
            self.cityID = cityID;
            self.areaName = country;
            self.countryID = countryID;
            self.logi = logi;
            self.lati = lati;
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}
- (IBAction)nextButtonClick:(id)sender
{
    if ([self judgeIsNull])
    {
        JXRegCarInfoVC *vc = [[JXRegCarInfoVC alloc] initWithDict:_sendDict];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}
//判断条款项目是否输入为空
- (BOOL)judgeIsNull
{
    NSString *realName          = _datas[0][@"content"];
    NSString *idNumber          = _datas[1][@"content"];
    NSString *cityName          = _datas[2][@"content"];
    NSString *emergencyName     = _datas[3][@"content"];
    NSString *emergencyPhone    = _datas[4][@"content"];
    if ([JXTool verifyIsNullString:realName])
    {
        SVINFO(@"请输入姓名", 2)
        return NO;
    }
    else if ([JXTool verifyIsNullString:idNumber])
    {
        SVINFO(@"请输身份证号", 2)
        return NO;
    }
    else if (![JXTool verifyIdentityCard:idNumber])
    {
        SVINFO(@"请输入正确的身份证号", 2)
        return NO;
    }
    else if ([JXTool verifyIsNullString:cityName])
    {
        SVINFO(@"请选择所属城市", 2)
        return NO;
    }
    else if ([JXTool verifyIsNullString:emergencyName])
    {
        SVINFO(@"请输入与紧急联系人姓名", 2)
        return NO;
    }
    else if ([realName isEqualToString:emergencyName])
    {
        SVINFO(@"紧急联系人不可与真实姓名重复", 2)
        return NO;
    }
    else if ([JXTool verifyIsNullString:emergencyPhone])
    {
        SVINFO(@"请输入紧急联系人电话", 2)
        return NO;
    }
    else if ([emergencyPhone isEqualToString:USERPHONE])
    {
        SVINFO(@"紧急联系联系电话不可与注册手机号重复", 2)
        return NO;
    }
    else if (![JXTool verifyMobilePhone:emergencyPhone])
    {
        SVINFO(@"请输入正确的紧急联系人电话", 2)
        return NO;
    }
    else
    {
        self.sendDict[@"realName"] = realName;
        self.sendDict[@"idNumber"] = idNumber;
        self.sendDict[@"cityName"] = _cityName;
        self.sendDict[@"cityId"] = _cityID;
        self.sendDict[@"areaName"] = _areaName;
        self.sendDict[@"areaId"] = _countryID;
        self.sendDict[@"emergencyName"] = emergencyName;
        self.sendDict[@"emergencyPhone"] = emergencyPhone;
        self.sendDict[@"longi"] = _logi;
        self.sendDict[@"lati"] = _lati;
        return YES;
    }
    
}

#pragma mark - UITextField delegate 

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSUInteger identifier = textField.tag - 10086;
    switch (identifier) {
        case 0:
        {
            NSMutableDictionary *dic1 = _datas[0];
            dic1[@"content"] = textField.text;
        }
            break;
        case 1:
        {
            NSMutableDictionary *dic1 = _datas[1];
            dic1[@"content"] = textField.text;
        }
            break;
        case 2:
        {
            //textfield 作为按钮选择城市了
        }
            break;
        case 3:
        {
            NSMutableDictionary *dic1 = _datas[3];
            dic1[@"content"] = textField.text;
        }
            break;
        case 4:
        {
            NSMutableDictionary *dic1 = _datas[4];
            dic1[@"content"] = textField.text;
        }
            break;
            
        default:
            break;
    }
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSUInteger identifier = textField.tag - 10086;
    if (identifier == 1)
    {
        NSInteger loc =range.location;
        if (loc < 18)
        {
            return YES;
        }
        else
        {
            return NO;
        }
    }
    else if (identifier == 4)
    {
        NSInteger loc =range.location;
        if (loc < 11)
        {
            return YES;
        }
        else
        {
            return NO;
        }
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.tableVi endEditing:YES];
    return YES;
}

- (void)keyboardWillShow:(NSNotification *)noti
{
    CGRect keyBoardRect=[noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.tableVi.contentInset = UIEdgeInsetsMake(0, 0, keyBoardRect.size.height, 0);
}
- (void)keyboardWillHide:(NSNotification *)noti
{
      self.tableVi.contentInset = UIEdgeInsetsZero;
}
- (void)keyboardShouldDown
{
    [self.tableVi endEditing:YES];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.tableVi endEditing:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}



@end
