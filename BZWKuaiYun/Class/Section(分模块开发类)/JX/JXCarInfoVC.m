//
//  JXCarInfoVC.m
//  BZWKuaiYun
//
//  Created by Jessey Young on 2017/7/10.
//  Copyright © 2017年 ISU. All rights reserved.
//

#import "JXCarInfoVC.h"
#import "JXPickView.h"
#import "JXSelectCarVC.h"
#import "JXRegCarInfoCell.h"

static NSInteger kPickerViewWidth = 250;

@interface JXCarInfoVC ()<UITableViewDelegate,
                          UITableViewDataSource,
                          JXPlateBtnDelegate,
                          JXPickerViewDelegate,
                          UITextFieldDelegate>
@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) NSArray *details;
@property (nonatomic, strong) JXPickView *picker;
@property (nonatomic, strong) NSString *wholePlateStr;
@property (nonatomic, strong) NSString *wholeCarType;
@property (nonatomic, strong) NSString *carTypeID;
@property (nonatomic, strong) NSString *specialStr;
@end

@implementation JXCarInfoVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initialized];
    [self setupUI];
    [self requestCarConfirmStatus];
}

- (void)initialized
{
    self.titles = @[@"车牌号码",@"车辆类型",@"特殊型号"];
    [kNotificationCenter addObserver:self selector:@selector(setupPlate:) name:@"changePlate" object:nil];
}

- (void)setupUI
{
    self.tableVi.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableVi.hidden = YES;
    self.layerControl.hidden = YES;
    self.layerControl.userInteractionEnabled = NO;
    self.picker.hidden = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)];
    tap.cancelsTouchesInView = NO;
    [self.tableVi addGestureRecognizer:tap];
    
}
// 点击tableview 收起键盘
- (void)tapClick
{
    [self.tableVi endEditing:YES];
}
- (void)requestCarConfirmStatus
{
    SVSHOW
    [JXRequestTool postcarCheckOutComplete:^(BOOL isSuccess, NSDictionary *respose) {
        if (isSuccess)
        {
            SVMISS
            self.tableVi.hidden = NO;
            NSDictionary *dic= respose[@"res"];
            self.details = @[dic[@"autoNum"],dic[@"autoTypeDesc"],dic[@"special"]];
            // 设置特殊规格
            self.specialStr = [NSString stringWithFormat:@"%@",dic[@"special"]];
            [self.tableVi reloadData];
            // 设置车牌号码
            NSMutableString *plateStr=[[NSMutableString alloc]initWithString:[[NSString stringWithFormat:@"%@",dic[@"autoNum"]] substringToIndex:2]];
            [plateStr insertString:@" " atIndex:1];
            [self.plateBtn setTitle:plateStr forState:UIControlStateNormal];
            
            // 设置车牌号码
            self.plateTF.text = [[NSString stringWithFormat:@"%@",dic[@"autoNum"]] substringFromIndex:2];
            _wholePlateStr = string(plateStr, self.plateTF.text);
            _carTypeID = s_str(dic[@"autoType"]);
            _wholeCarType = s_str(dic[@"autoTypeDesc"]);
            
//            NSArray *arr = [specialStr componentsSeparatedByString:@","];
//            [self.btn1 setImage:JX_IMAGE(@"guigeweixuan") forState:UIControlStateNormal];
//            [self.btn2 setImage:JX_IMAGE(@"guigeweixuan") forState:UIControlStateNormal];
//            [self.btn3 setImage:JX_IMAGE(@"guigeweixuan") forState:UIControlStateNormal];
//            for (NSString *str in arr)
//            {
//                if ([str isEqualToString:@"开顶"])
//                {
//                    self.btn1.selected = YES;
//                    [self.btn1 setImage:JX_IMAGE(@"guigexuanzhoang") forState:UIControlStateNormal];
//                }
//                if ([str isEqualToString:@"双排座"])
//                {
//                    self.btn2.selected = YES;
//                    [self.btn2 setImage:JX_IMAGE(@"guigexuanzhoang") forState:UIControlStateNormal];
//                }
//                if ([str isEqualToString:@"带尾板"])
//                {
//                    self.btn3.selected = YES;
//                    [self.btn3 setImage:JX_IMAGE(@"guigexuanzhoang") forState:UIControlStateNormal];
//                }
//            }
            
            
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
    return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row != 2) return 54;
    return 60;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID1 = @"cell1";
    static NSString *cellID2 = @"cell2";
    static NSString *cellID3 = @"cell3";
    JXRegCarInfoCell *cell1 = [tableView dequeueReusableCellWithIdentifier:cellID1];
    JXRegCarInfoCell *cell2 = [tableView dequeueReusableCellWithIdentifier:cellID2];
    JXRegCarInfoCell *cell3 = [tableView dequeueReusableCellWithIdentifier:cellID3];
    if (indexPath.row == 0)
    {
        if (!cell1)
        {
            cell1 = LoadBbundleCell(@"JXRegCarInfoCell", 0);
            cell1.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell1.delegate = self;
        cell1.plateTF.delegate = self;
        cell1.plateTF.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        self.plateTF = cell1.plateTF;
        self.plateBtn = cell1.palteBtn;
        
        
        return cell1;
    }
    else if (indexPath.row == 1)
    {
        if (!cell2)
        {
            cell2 = LoadBbundleCell(@"JXRegCarInfoCell", 1);
            cell2.selectionStyle = UITableViewCellSelectionStyleNone;
            cell2.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        cell2.carTypeTF.text = self.details[indexPath.row];
        return cell2;
    }
    else
    {
        if (!cell3)
        {
            cell3 = LoadBbundleCell(@"JXRegCarInfoCell", 2);
            cell3.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell3.specialString = self.specialStr;
        self.btn1 = cell3.oneSingleBtn1;
        self.btn2 = cell3.oneSingleBtn2;
        self.btn3 = cell3.oneSingleBtn3;
        return cell3;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *vi = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 30)];
    vi.backgroundColor = RGBCOLOR(240, 240, 240);
    
    //header 的标题
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 150, 30)];
    titleLab.text = @"车辆信息";
    titleLab.textColor = RGBCOLOR(100, 100, 100);
    titleLab.font = F14;
    [vi addSubview:titleLab];
    
    
    return vi;
    
}
#pragma mark - UITable view Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableVi endEditing:YES];
    JXRegCarInfoCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (indexPath.row == 1)
    {
        JXSelectCarVC *vc= [[JXSelectCarVC alloc] init];
        vc.car = ^(NSString *first, NSString *second, NSString *autoType) {
            cell.carTypeTF.text = [NSString stringWithFormat:@"%@ %@",first,second];
            self.wholeCarType = [NSString stringWithFormat:@"%@ %@",first,second];
            self.carTypeID = autoType;
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - UITextField delegate
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSString *originStr = [NSString stringWithFormat:@"%@%@",self.plateBtn.currentTitle,textField.text];
    self.wholePlateStr = [originStr stringByReplacingOccurrencesOfString:@" " withString:@""];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSInteger loc =range.location;
    if (loc < 5)
    {
        return YES;
    }
    else
    {
        return NO;
    }
    
}

- (IBAction)commitBtnClick:(UIButton *)sender
{
    if ([self judgeIsNull])
    {
        SVSHOW
        [JXRequestTool postUpdateAutoInfoNeedAutoNum:_wholePlateStr autoType:_carTypeID special:[self specialStrMake] complete:^(BOOL isSuccess, NSDictionary *respose) {
            if (isSuccess)
            {
                SVSUCCESS(@"修改成功", 2)
                int index = (int)[self.navigationController.viewControllers indexOfObject:self];
                [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:(index-2)] animated:YES];
                [kUserDefaults setObject:@"可以刷新" forKey:@"是否刷新"];
                [kUserDefaults synchronize];
            }
        }];
    }
}

- (BOOL)judgeIsNull
{
    [self.tableVi endEditing:YES];
    _wholePlateStr = [_wholePlateStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ([JXTool verifyIsNullString:_wholePlateStr])
    {
        SVINFO(@"请输入车牌号", 2)
        return NO;
    }
    else if (![JXTool verifyPlateNum:_wholePlateStr])
    {
        SVINFO(@"请输入正确的车牌号", 2)
        return NO;
    }
    else if ([JXTool verifyIsNullString:_wholeCarType])
    {
        SVINFO(@"请选择车辆型号", 2)
        return NO;
    }
    else if (self.btn1.selected == NO && self.btn2.selected == NO && self.btn3.selected == NO)
    {
        SVINFO(@"请选择特殊规格", 2)
        return NO;
    }
    else
    {
        return YES;
    }
}

- (NSString *)specialStrMake
{
    if (self.btn1.selected)
    {
        if (self.btn2.selected)
        {
            if (self.btn3.selected)
            {
                return @"开顶,双排座,带尾板";
            }
            else
            {
                return @"开顶,双排座";
            }
        }
        else
        {
            if (self.btn3.selected)
            {
                return @"开顶,带尾板";
            }
            else
            {
                return @"开顶";
            }
        }
    }
    else
    {
        if (self.btn2.selected)
        {
            if (self.btn3.selected)
            {
                return @"双排座,带尾板";
            }
            else
            {
                return @"双排座";
            }
        }
        else
        {
            if (self.btn3.selected)
            {
                return @"带尾板";
            }
            else
            {
                return @"";
            }
        }
    }
}

- (void)setupPlate:(NSNotification *)noti
{
    NSString *plateNum = noti.object;
    [self.plateBtn setTitle:plateNum forState:UIControlStateNormal];
}

#pragma mark - protocol Click
- (void)plateBtnClick
{
    self.layerControl.userInteractionEnabled = YES;
    [UIView animateWithDuration:.03f animations:^{
        self.layerControl.hidden = NO;
    } completion:^(BOOL finished) {
        self.picker.transform = CGAffineTransformMakeTranslation(0, -kPickerViewWidth);
    }];
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
- (void)cancelButtonClickAfter
{
    [self goHide];
}
- (void)containButtonClickAfter
{
    [self goHide];
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
- (JXPickView *)picker
{
    if (!_picker)
    {
        _picker = [[JXPickView alloc] initWithFrame:CGRectMake(0, Main_Screen_Height, Main_Screen_Width, kPickerViewWidth)];
        _picker.something = self;
        [self.view addSubview:_picker];
    }
    return _picker;
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
