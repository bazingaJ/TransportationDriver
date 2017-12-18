//
//  JXSelectCity.m
//  BZWKuaiYun
//
//  Created by Jessey Young on 2017/5/24.
//  Copyright © 2017年 ISU. All rights reserved.
//

#import "JXSelectCity.h"
#import "JXCityModel.h"

@interface JXSelectCity ()<UITableViewDelegate,UITableViewDataSource,AMapLocationManagerDelegate>
{
    UIImageView   *_bgImageView;
    UIView        *_tipsView;
    UILabel       *_tipsLab;
    NSTimer       *_timer;
}

@property (nonatomic, strong) NSDictionary *dataDic;
@property (nonatomic, strong) NSArray *indexArr;
@property (nonatomic, strong) UITableView *rightTableVi;

@property (nonatomic, strong) NSArray *contryArr;

@property (nonatomic, strong) NSString *selectCity;
@property (nonatomic, strong) NSString *cityID;
@property (nonatomic, strong) NSString *selectCountry;
@property (nonatomic, strong) NSString *countryID;

@property (nonatomic, strong) UILabel *locationLab;
@property (nonatomic, strong) NSString *wholeStr;

@property (nonatomic, strong) AMapLocationManager *locationManager;
@property (nonatomic, assign) CLLocationCoordinate2D location;

@property (nonatomic, strong) NSIndexPath *indexPa;

@end

@implementation JXSelectCity

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

- (UITableView *)rightTableVi
{
    if (!_rightTableVi)
    {
        if (_isMinePart)
        {
            _rightTableVi = [[UITableView alloc] initWithFrame:CGRectMake(Main_Screen_Width, 64, Main_Screen_Width/2, Main_Screen_Height-kNavBarHeight) style:UITableViewStylePlain];
        }
        else
        {
            _rightTableVi = [[UITableView alloc] initWithFrame:CGRectMake(Main_Screen_Width, 0, Main_Screen_Width/2, Main_Screen_Height-kNavBarHeight) style:UITableViewStylePlain];
        }
        
        _rightTableVi.backgroundColor = BackGround_Color;
        _rightTableVi.delegate = self;
        _rightTableVi.dataSource = self;
        _rightTableVi.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        [self.view addSubview:_rightTableVi];
    }
    return _rightTableVi;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"城市选择";
    [self overrideBackButton];
    [self initialized];
    [self setupUI];
    [self startLocation];
    [self requestCity];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
- (void)initialized
{
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 50)];
    headerView.backgroundColor = white_color;
    
    self.locationLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, Main_Screen_Width-30, 50)];
    self.locationLab.text = @"定位当前城市：定位中...";
    self.locationLab.font = F15;
    self.locationLab.textColor = Text_Color;
    
    [headerView addSubview:self.locationLab];
    
    self.tableVi.tableHeaderView = headerView;
}
- (void)setupUI
{
    self.tableVi.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

//开始第一次单词定位
- (void)startLocation
{
    
    [self.locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        if (error)
        {
            JXLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
            if (error.code == AMapLocationErrorLocateFailed)
            {
                return;
            }
        }
        
        if (regeocode)
        {
            
            self.wholeStr = regeocode.city;
            self.locationLab.text = [NSString stringWithFormat:@"定位当前城市：%@",self.wholeStr];
            self.location = location.coordinate;
            [self.tableVi reloadData];
        }
    }];
}
//请求城市
- (void)requestCity
{
    SVSHOW
    [JXRequestTool postQueryCitycomplete:^(BOOL isSuccess, NSDictionary *respose) {
        if (isSuccess)
        {
            SVMISS
            self.dataDic = respose[@"res"];
            NSArray *originArr = [_dataDic allKeys];
            self.indexArr = [originArr sortedArrayUsingSelector:@selector(compare:)];
            
            [self.tableVi reloadData];
        }
    }];
}

- (void)requestCountyNeed:(NSString *)cityId
{
    SVSHOW
    [JXRequestTool postQueryRegionNeedCityId:cityId complete:^(BOOL isSuccess, NSDictionary *respose) {
        if (isSuccess)
        {
            SVMISS
            self.contryArr = respose[@"res"];
            [self.rightTableVi reloadData];
        }
    }];
}

#pragma mark - UITable view Data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_tableVi == tableView)
    {
        return _indexArr.count;
    }
    else
    {
        return 1;
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_tableVi == tableView)
    {
        NSString *english = _indexArr[section];
        NSArray *citys = _dataDic[english];
        return citys.count;
    }
    else
    {
        return _contryArr.count;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_tableVi == tableView)
    {
        static NSString *cellID = @"cellIdentifier";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            
            UIView *lineVi = [[UIView alloc] init];
            lineVi.frame = CGRectMake(0, 0, 5, 50);
            lineVi.backgroundColor = clear_color;
            
            [cell addSubview:lineVi];
            
            
            [cell.textLabel setTextColor:Text_Color];
            cell.textLabel.font = F15;
        }
        UITableViewCell *cell0 = [tableView cellForRowAtIndexPath:_indexPa];
        UIView *lineVi0 = cell0.subviews[2];
        if (_indexPa.row == indexPath.row && _indexPa.section == indexPath.section)
        {
            lineVi0.backgroundColor = Main_Color;
        }
        else
        {
            lineVi0.backgroundColor = clear_color;
        }
        
        if (_indexPa.row == indexPath.row && _indexPa.section == indexPath.section)
        {
            [cell0.textLabel setTextColor:Main_Color];
        }
        else
        {
            [cell0.textLabel setTextColor:Text_Color];
        }
        NSString *english = _indexArr[indexPath.section];
        NSArray *citys = _dataDic[english];
        NSDictionary *smallDic = citys[indexPath.row];
        cell.textLabel.text =smallDic[@"name"];
        return cell;
    }
    else
    {
        static NSString *cellID = @"cellIdentifier";
        UITableViewCell *cell  =[tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            [cell.textLabel setTextColor:Text_Color];
            cell.textLabel.font = F15;
        }
        
        NSDictionary *smallDic = _contryArr[indexPath.row];
        cell.textLabel.text =smallDic[@"name"];
        
        return cell;
    }
    
}


#pragma mark - UITable view Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_tableVi == tableView)
    {
        UITableViewCell *cell0 = [tableView cellForRowAtIndexPath:_indexPa];
        cell0.textLabel.textColor = Text_Color;
        UIView *lineVi0 = cell0.subviews[2];
        lineVi0.backgroundColor = clear_color;
        
        
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.textLabel.textColor = Main_Color;
        UIView *lineVi = cell.subviews[2];
        lineVi.backgroundColor = Main_Color;
        
        NSString *english = _indexArr[indexPath.section];
        NSArray *citys = _dataDic[english];
        NSDictionary *smallDic = citys[indexPath.row];
        self.selectCity = smallDic[@"name"];
        NSString *str = smallDic[@"citycode"];
        if (_isMinePart)
        {
            if (self.cityInfo)
            {
                self.cityInfo(self.selectCity, str);
            }
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            
            [self requestCountyNeed:smallDic[@"id"]];
            
            id city = smallDic[@"id"];
            self.cityID = [NSString stringWithFormat:@"%@",city];
            [UIView animateWithDuration:0.2 animations:^{
                self.rightTableVi.transform = CGAffineTransformMakeTranslation(-Main_Screen_Width/2, 0);
            } completion:^(BOOL finished) {
                
            }];
        }
        self.indexPa = indexPath;
    }
    else
    {
        NSDictionary *smallDic = _contryArr[indexPath.row];
        self.selectCountry =smallDic[@"name"];
        id country = smallDic[@"id"];
        self.countryID = [NSString stringWithFormat:@"%@",country];
        NSString *logi = [NSString stringWithFormat:@"%f",self.location.longitude];
        NSString *lati = [NSString stringWithFormat:@"%f",self.location.latitude];
        if (self.choice)
        {
            self.choice(_selectCity,_cityID,_selectCountry,_countryID,logi,lati);
        }
        [self.navigationController popViewControllerAnimated:YES];
        
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50.0;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (_tableVi == tableView)
    {
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 50)];
        bgView.backgroundColor = RGBCOLOR(240, 240, 240);
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 250, 50)];
        titleLabel.font = F18;
        titleLabel.text = _indexArr[section];
        [bgView addSubview:titleLabel];
        return bgView;
    }
    else
    {
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 50)];
        bgView.backgroundColor = RGBCOLOR(240, 240, 240);
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 250, 50)];
        titleLabel.font = F18;
        titleLabel.text = _selectCity;
        [bgView addSubview:titleLabel];
        return bgView;
    }
    
    
    
}
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if (_tableVi == tableView)
    {
        NSMutableArray *indexNumber = [NSMutableArray arrayWithArray:_indexArr];
        return indexNumber;
    }
    return nil;
    
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    if (_tableVi == tableView)
    {
        [self showTipsWithTitle:title];
        
        return index;
    }
    return index;
    
}

- (void)showTipsWithTitle:(NSString*)title
{
    if (!_tipsView)
    {
        //添加字母提示框
        _tipsView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 80, 80)];
        _tipsView.center = kWindow.center;
        _tipsView.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:0.8];
        //设置提示框圆角
        _tipsView.layer.masksToBounds = YES;
        _tipsView.layer.cornerRadius  = _tipsView.frame.size.width/20;
        _tipsView.layer.borderColor   = [UIColor whiteColor].CGColor;
        _tipsView.layer.borderWidth   = 2;
        [kWindow addSubview:_tipsView];
    }
    if (!_tipsLab)
    {
        //添加提示字母lable
        _tipsLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, _tipsView.frame.size.width, _tipsView.frame.size.height)];
        //设置背景为透明
        _tipsLab.backgroundColor = [UIColor clearColor];
        _tipsLab.font = [UIFont boldSystemFontOfSize:50];
        _tipsLab.textAlignment = NSTextAlignmentCenter;
        
        [_tipsView addSubview:_tipsLab];
    }
    _tipsLab.text = title;//设置当前显示字母
    
    //    [self performSelector:@selector(hiddenTipsView:) withObject:nil afterDelay:0.3];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self hiddenTipsView];
        });
    
    
//    _timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(hiddenTipsView) userInfo:nil repeats:NO];
//    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    
}


- (void)hiddenTipsView
{
    [UIView animateWithDuration:0.2 animations:^{
        _tipsView.alpha = 0;
    } completion:^(BOOL finished) {
        [_tipsView removeFromSuperview];
        _bgImageView = nil;
        _tipsLab     = nil;
        _tipsView    = nil;
    }];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}



@end
