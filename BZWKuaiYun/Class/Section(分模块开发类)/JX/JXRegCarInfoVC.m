//
//  JXRegCarInfoVC.m
//  BZWKuaiYun
//
//  Created by Jessey Young on 2017/5/23.
//  Copyright © 2017年 ISU. All rights reserved.
//

#import "JXRegCarInfoVC.h"
#import "JXRegCarInfoCell.h"
#import "JXRegPhotoVC.h"
#import "JXSelectCarVC.h"
#import "JXPickView.h"

static NSInteger kPickerViewWidth = 250;

@interface JXRegCarInfoVC ()< JXPlateBtnDelegate,
                              JXPickerViewDelegate,
                              UITableViewDelegate,
                              UITextFieldDelegate,
                              UITableViewDataSource>

@property (nonatomic, strong) JXPickView *picker;
@property (nonatomic, strong) NSString *wholePlateStr;
@property (nonatomic, strong) NSString *wholeCarType;
@property (nonatomic, strong) NSString *carTypeID;
@property (nonatomic, strong) NSMutableDictionary *sendDict;
@end

@implementation JXRegCarInfoVC

- (instancetype)initWithDict:(NSMutableDictionary *)dict
{
    if (self = [super init])
    {
        self.sendDict = [NSMutableDictionary dictionary];
        self.sendDict = dict;
        JXLog(@"====%@",_sendDict);
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"注册";
    [self overrideBackButton];
    
    [kNotificationCenter addObserver:self selector:@selector(setupPlate:) name:@"changePlate" object:nil];
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tableVi.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.layerControl.hidden = YES;
    self.layerControl.userInteractionEnabled = NO;
    self.picker.hidden = NO;
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
        
        return cell2;
    }
    else
    {
        if (!cell3)
        {
            cell3 = LoadBbundleCell(@"JXRegCarInfoCell", 2);
            cell3.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        self.btn1 = cell3.oneSingleBtn1;
        self.btn2 = cell3.oneSingleBtn2;
        self.btn3 = cell3.oneSingleBtn3;
        return cell3;
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
    infoLab.text = @"车辆信息";
    infoLab.textColor = RGBCOLOR(100, 100, 100);
    infoLab.font = F13;
    [vi addSubview:infoLab];
    
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

- (IBAction)nextBtnClick:(UIButton *)sender
{
    if ([self judgeIsNull])
    {
        JXRegPhotoVC *vc = [[JXRegPhotoVC alloc] initWithDict:_sendDict];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

- (BOOL)judgeIsNull
{
    [self.tableVi endEditing:YES];
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
        self.sendDict[@"plateNo"] =_wholePlateStr;
        self.sendDict[@"carType"] =_carTypeID;
        self.sendDict[@"special"] = [self specialStrMake];
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
        _picker = [[JXPickView alloc] initWithFrame:CGRectMake(0, Main_Screen_Height-64, Main_Screen_Width, kPickerViewWidth)];
        _picker.something = self;
        [self.view addSubview:_picker];
    }
    return _picker;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}



@end
