//
//  JXChargeStandardVC.m
//  BZWKuaiYun
//
//  Created by Jessey Young on 2017/5/27.
//  Copyright © 2017年 ISU. All rights reserved.
//

#import "JXChargeStandardVC.h"
#import "JXSelectCity.h"
#import "JXCityModel.h"

@interface JXChargeStandardVC ()<AMapLocationManagerDelegate,UIScrollViewDelegate>

@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) AMapLocationManager *locationManager;
@property (nonatomic, assign) CLLocationCoordinate2D location;
@property (nonatomic, strong) NSString *cityCo;
@property (nonatomic, strong) NSArray *carTypeArr;
@property (nonatomic, strong) NSDictionary *dataDic;

@end

@implementation JXChargeStandardVC

- (AMapLocationManager *)locationManager
{
    if (!_locationManager)
    {
        self.locationManager = [[AMapLocationManager alloc] init];
        self.locationManager.delegate=self;
        self.locationManager.distanceFilter = 2;
        self.locationManager.locatingWithReGeocode = YES;
        // 带逆地理信息的一次定位（返回坐标和地址信息）
        self.locationManager.desiredAccuracy=kCLLocationAccuracyHundredMeters;
        //   定位超时时间，最低2s，此处设置为2s
        self.locationManager.locationTimeout =5;
        //   逆地理请求超时时间，最低2s，此处设置为2s
        self.locationManager.reGeocodeTimeout = 5;
    }
    return _locationManager;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupUI];
    [self startLocation];
    
    self.button=[UIButton buttonWithType:UIButtonTypeCustom];
    self.button.frame = CGRectMake(0,0, 200, 40);
    [self.button setTitle:@"收费标准- ▼" forState:UIControlStateNormal];
    [self.button setTitleColor:black_color forState:UIControlStateNormal];
    self.button.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size: 17.0];
    [self.button addTarget:self action:@selector(titleClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView=self.button;
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}
//请求所有的车型
- (void)requestqueryAutoType
{
    SVSHOW
    [JXRequestTool postQueryAutoTypeNeedAutoType:@"" complete:^(BOOL isSuccess, NSDictionary *respose) {
        if (isSuccess)
        {
            NSArray *arr = respose[@"res"];
            
            self.carTypeArr = [JXCarTypeModel mj_objectArrayWithKeyValuesArray:arr];
            
            [self setupUI];
            
            JXCarTypeModel *model = _carTypeArr[0];
            
            [self requestQueryChargeStandardNeedCityCode:self.cityCo type:model.autoType];
            
            SVMISS
        }
    }];
}
//收费标注查询接口
- (void)requestQueryChargeStandardNeedCityCode:(NSString *)code type:(NSString *)type
{
    SVSHOW
    [JXRequestTool postQueryChargeStandardNeedCityCode:code autoType:type complete:^(BOOL isSuccess, NSDictionary *respose) {
        if (isSuccess)
        {
            self.dataDic = respose[@"res"];
            
            //赋值第一个圆形标签
            NSString *before = [NSString stringWithFormat:@"%@",_dataDic[@"startPrice"]];
            NSMutableString *starMoney = [NSMutableString stringWithString:before];
            if (before.length>= 3)
            {
                [starMoney insertString:@"." atIndex:before.length-2];
                self.firstRoundLab.text = [NSString stringWithFormat:@"%@元\n%@公里\n起步价",starMoney,_dataDic[@"startDis"]];
            }
            else
            {
                self.firstRoundLab.text = [NSString stringWithFormat:@"%@元\n%@公里\n起步价",starMoney,_dataDic[@"startDis"]];
            }
            
            
            //赋值第二个圆形标签
            NSString *before2 = [NSString stringWithFormat:@"%@",_dataDic[@"perPrice"]];
            NSMutableString *starMoney2 = [NSMutableString stringWithString:before2];
            if (before2.length>= 3)
            {
                [starMoney2 insertString:@"." atIndex:before2.length-2];
                self.secondRoundLab.text = [NSString stringWithFormat:@"%@元\n%@公里\n超公里",starMoney2,_dataDic[@"perDis"]];
            }
            else
            {
                self.secondRoundLab.text = [NSString stringWithFormat:@"%@元\n%@公里\n超公里",starMoney2,_dataDic[@"perDis"]];
            }
            
            //赋值费用说明
            //动态适配 label高度
            if (![JXTool verifyIsNullString:_dataDic[@"feeNote"]])
            {
                NSString * originStr = _dataDic[@"feeNote"];
                NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:originStr];
                NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
                paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
                paraStyle.lineSpacing = 10;
                [AttributedStr addAttribute:NSParagraphStyleAttributeName value:paraStyle range:NSMakeRange(0, originStr.length)];
                [self.detailLab setAttributedText:AttributedStr];
                
                CGFloat height = [JXTool getLabelHeightWithString:_dataDic[@"feeNote"] needWidth:self.bigLabel.frame.size.width-30];
                self.bigLabelHeight.constant = height+33+35;
            }
            else
            {
                self.detailLab.text = @"暂无说明";
            }
            
            //赋值附加费用
            if (![JXTool verifyIsNullString:_dataDic[@"additionalFee"]])
            {
                NSString *beforeStr = _dataDic[@"additionalFee"];
                NSArray * arr= [beforeStr componentsSeparatedByString:@"|"];
                
                NSMutableString *leftStr = [NSMutableString string];
                NSMutableString *rightStr = [NSMutableString string];
                if (arr.count > 1)
                {
                    for (int i = 0 ; i < arr.count; i++)
                    {
                        
                        NSString *str = arr[i];
                        NSArray *smallArr = [str componentsSeparatedByString:@","];
                        [leftStr appendString:[NSString stringWithFormat:@"%@\n",[smallArr firstObject]]];
                        [rightStr appendString:[NSString stringWithFormat:@"%@\n",[smallArr lastObject]]];
                    }
                    
                    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:leftStr];
                    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
                    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
                    paraStyle.lineSpacing = 10;
                    [AttributedStr addAttribute:NSParagraphStyleAttributeName value:paraStyle range:NSMakeRange(0, leftStr.length)];
                    [self.leftLab setAttributedText:AttributedStr];
                    
                    
                    NSMutableAttributedString *AttributedStr2 = [[NSMutableAttributedString alloc]initWithString:rightStr];
                    NSMutableParagraphStyle *paraStyle2 = [[NSMutableParagraphStyle alloc] init];
                    paraStyle2.lineBreakMode = NSLineBreakByCharWrapping;
                    paraStyle2.alignment = NSTextAlignmentRight;
                    paraStyle2.lineSpacing = 10;
                    [AttributedStr2 addAttribute:NSParagraphStyleAttributeName value:paraStyle2 range:NSMakeRange(0, rightStr.length)];
                    [self.rightLab setAttributedText:AttributedStr2];
                    
                    self.bottomHeight.constant = 15 * arr.count + 33 + 30;
                }
                else
                {
                    self.leftLab.text = leftStr;
                    self.rightLab.text = @"";
                    self.bottomHeight.constant = 15 + 33 + 15;
                }
                
            }
            else
            {
                self.leftLab.text = @"暂无说明";
                self.rightLab.text = @"";
                self.bottomHeight.constant = 15 + 33 + 15;
            }
            
            
        }
        SVMISS
    }];
}
- (void)setupUI
{
    self.scr.contentSize = CGSizeMake(160*_carTypeArr.count, 0);
    for (int i = 0; i < _carTypeArr.count; i++)
    {
        JXCarTypeModel *model = _carTypeArr[i];
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(160*i, 0, 160, 100)];
        if (![JXTool verifyIsNullString:model.autoImg])
        {
            [img sd_setImageWithURL:[NSURL URLWithString:model.autoImg] placeholderImage:nil];
        }
        else
        {
            img.image = nil;
        }
        
        [self.scr addSubview:img];
    }
    JXCarTypeModel *mode = _carTypeArr[0];
    self.carTypeLab.text = mode.autoTypeName;
    self.carLoadLab.text = mode.load;
    self.carOutsideLab.text = mode.autoSize;
    
    self.bigLabel.layer.borderColor = RGBCOLOR(224, 224, 224).CGColor;
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.wordLab.bounds byRoundingCorners:UIRectCornerTopLeft |  UIRectCornerTopRight cornerRadii:CGSizeMake(5,5)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
    //设置大小
    maskLayer.frame = self.wordLab.bounds;
    //设置图形样子
    maskLayer.path = maskPath.CGPath;
    self.wordLab.layer.mask = maskLayer;
    
    self.bottomView.layer.borderColor = RGBCOLOR(224, 224, 224).CGColor;
    
    UIBezierPath *maskPath1 = [UIBezierPath bezierPathWithRoundedRect:self.underLab.bounds byRoundingCorners:UIRectCornerTopLeft |  UIRectCornerTopRight cornerRadii:CGSizeMake(5,5)];
    CAShapeLayer *maskLayer1 = [[CAShapeLayer alloc]init];
    //设置大小
    maskLayer1.frame = self.wordLab.bounds;
    //设置图形样子
    maskLayer1.path = maskPath1.CGPath;
    self.underLab.layer.mask = maskLayer1;
    
    
}

//开始第一次单词定位
- (void)startLocation
{
    SVSTATUS(@"定位中")
    [self.locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        if (error)
        {
            SVERROR(@"定位出现错误", 1.5)
            JXLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
            if (error.code == AMapLocationErrorLocateFailed)
            {
                return;
            }
        }
        
        if (regeocode)
        {
            SVMISS
            [self.button setTitle:[NSString stringWithFormat:@"收费标准-%@ ▼",regeocode.city] forState:UIControlStateNormal];
            self.cityCo = regeocode.adcode;
            //请求车型
            [self requestqueryAutoType];
            
        }
        else
        {
            SVERROR(@"定位出现错误", 1.5)
        }
    }];
}

- (void)titleClick
{
    JXSelectCity *vc =[[JXSelectCity alloc] init];
    vc.isMinePart = YES;
    vc.cityInfo = ^(NSString *city, NSString *cityCode) {
        [self.button setTitle:[NSString stringWithFormat:@"收费标准-%@ ▼",city] forState:UIControlStateNormal];
        self.cityCo = cityCode;
        //请求车型
        [self requestqueryAutoType];
    };
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger i = scrollView.contentOffset.x/160;
    JXCarTypeModel *model = _carTypeArr[i];
    self.carTypeLab.text = model.autoTypeName;
    self.carLoadLab.text = model.load;
    self.carOutsideLab.text = model.autoSize;
    [self requestQueryChargeStandardNeedCityCode:self.cityCo type:model.autoType];
}

- (IBAction)leftBtnClick:(UIButton *)sender
{
    NSInteger i = self.scr.contentOffset.x/160;
    
    if (i > 0)
    {
        JXCarTypeModel *model = _carTypeArr[i-1];
        self.carTypeLab.text = model.autoTypeName;
        self.carLoadLab.text = model.load;
        self.carOutsideLab.text = model.autoSize;
        [self.scr setContentOffset:CGPointMake(160*(i-1), 0) animated:YES];
        [self requestQueryChargeStandardNeedCityCode:self.cityCo type:model.autoType];
    }
    
}
- (IBAction)rightBtn:(UIButton *)sender
{
    NSInteger i = self.scr.contentOffset.x/160;
    if (i < _carTypeArr.count-1)
    {
        JXCarTypeModel *model = _carTypeArr[i+1];
        self.carTypeLab.text = model.autoTypeName;
        self.carLoadLab.text = model.load;
        self.carOutsideLab.text = model.autoSize;
        [self.scr setContentOffset:CGPointMake(160*(i+1), 0) animated:YES];
        [self requestQueryChargeStandardNeedCityCode:self.cityCo type:model.autoType];
    }
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}



@end
