//
//  JXOrderDetailVC.m
//  BZWKuaiYun
//
//  Created by Jessey Young on 2017/6/1.
//  Copyright © 2017年 ISU. All rights reserved.
//

#import "JXOrderDetailVC.h"

@interface JXOrderDetailVC ()
@property (nonatomic, strong) NSDictionary *dataDic;
// extInfo 额外留言字符串
@property (nonatomic, strong) NSString *extraStr;

@property (nonatomic, strong) NSMutableArray *labelListArr;
@end

@implementation JXOrderDetailVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupUI];
    [self initilized];
    [self changeBtnStyle];
}

- (void)initilized
{
    self.labelListArr = [NSMutableArray array];
    [kNotificationCenter addObserver:self selector:@selector(getOrderMoney) name:@"getmoney" object:nil];
}

- (void)getOrderMoney
{
    NSString *orderID = [UserInfo defaultUserInfo].orderID;
    [self requestOrderInfoNeedOrderId:orderID];
}

- (void)setupUI
{
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self requestOrderInfoNeedOrderId:self.orderId];
}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    NSUserDefaults *us = kUserDefaults;
    [us setObject:@"0" forKey:@"orderStyle"];
    [us synchronize];
}

- (void)changeBtnStyle
{
    
    NSString *identifier = [kUserDefaults objectForKey:@"orderStyle"];
    
    if ([identifier isEqualToString:@"1"])
    {
        [self.bottomBtn setTitle:@"订单进行中..." forState:UIControlStateNormal];
        self.bottomBtn.userInteractionEnabled = NO;
        self.agreeBtn.userInteractionEnabled = NO;
        self.refueseBtn.userInteractionEnabled = NO;
    }
    else if ([identifier isEqualToString:@"2"])
    {
        [self.bottomBtn setTitle:@"订单已完成" forState:UIControlStateNormal];
        self.bottomBtn.userInteractionEnabled = NO;
        self.agreeBtn.userInteractionEnabled = NO;
        self.refueseBtn.userInteractionEnabled = NO;
    }
    else if ([identifier isEqualToString:@"3"])
    {
        [self.bottomBtn setTitle:@"订单已取消" forState:UIControlStateNormal];
        self.bottomBtn.userInteractionEnabled = NO;
        self.agreeBtn.userInteractionEnabled = NO;
        self.refueseBtn.userInteractionEnabled = NO;
    }
    else if ([identifier isEqualToString:@"4"])
    {
        self.bottomBtn.userInteractionEnabled = YES;
        [self.bottomBtn setTitle:@"立即抢单" forState:UIControlStateNormal];
        [self.bottomBtn setTitleColor:white_color forState:UIControlStateNormal];
        [self.bottomBtn setBackgroundColor:Main_Color];
        self.agreeBtn.userInteractionEnabled = NO;
        self.refueseBtn.userInteractionEnabled = NO;
    }
    else if ([identifier isEqualToString:@"5"])
    {
        self.bottomBtn.hidden = YES;
    }
    else if ([identifier isEqualToString:@"6"])
    {
        self.bottomBtn.hidden = YES;
        self.agreeBtn.hidden = YES;
        self.refueseBtn.hidden = YES;
    }
}

#pragma mark - 获取订单详情数据

- (void)requestOrderInfoNeedOrderId:(NSString *)order
{
    SVSHOW
    [JXOrderRequestTool postOrderInfoDetailNeedOrderId:order complete:^(BOOL isSuccess, NSDictionary *respose) {
        if (isSuccess)
        {
            SVMISS
            self.dataDic = respose[@"res"];
            [self setupUIData:self.dataDic];
        }
    }];
}

- (void)setupUIData:(NSDictionary *)dict
{
    [self.bottomBtn setTitle:dict[@"processDesc"] forState:UIControlStateNormal];;
    //计算距离目的地的公里数
    dispatch_queue_t queue = dispatch_queue_create("com.yjx.www", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue, ^{
      
        id longitude = [kUserDefaults objectForKey:HomePageLongiString];
        double longi = [longitude doubleValue];
        id latitude = [kUserDefaults objectForKey:HomePageLatitString];
        double latit = [latitude doubleValue];
        
        id meLongitude = dict[@"lon"];
        double meLongi = [meLongitude doubleValue];
        id meLatitude = dict[@"lat"];
        double melatit = [meLatitude doubleValue];
        
        MAMapPoint point1 = MAMapPointForCoordinate(CLLocationCoordinate2DMake(latit,longi));
        MAMapPoint point2 = MAMapPointForCoordinate(CLLocationCoordinate2DMake(melatit,meLongi));
        
        
        CLLocationDistance distance = MAMetersBetweenMapPoints(point1,point2);
        
        double kiloM = distance/1000;
        dispatch_async(dispatch_get_main_queue(), ^{
            // 通知主线程刷新
            self.kilometreLab.text = [NSString stringWithFormat:@"%.1f公里",kiloM];
        });
        
    });
    
    //设置状态图片
    [self setupHeadImgNeedDic:dict];
    //订单编号
    self.orderNoLab.text = [NSString stringWithFormat:@"订单编号：%@",dict[@"orderNo"]];
    //下单时间
    self.timeLab.text = dict[@"createTime"];
    //预约时间
    self.orderTime.text = dict[@"bookingTime"];
    //设置很多途径地址的布局
    [self setupAddressViewNeedDict:dict];
    //设置留言款项的布局
    [self setupLeaveItem:dict];
    //用户留言备注
    if ([JXTool verifyIsNullString:dict[@"remarks"]])
    {
        self.leaveWordLab.text = @"暂无留言";
    }
    else
    {
        self.leaveWordLab.text = dict[@"remarks"];
    }
    
    //应收取的金额
    NSString *before = [NSString stringWithFormat:@"%@",dict[@"actualAmt"]];
    NSMutableString *starMoney = [NSMutableString stringWithString:before];
    if (before.length >= 3)
    {
        [starMoney insertString:@"." atIndex:before.length-2];
        self.moneyLab.text = [NSString stringWithFormat:@"%@",starMoney];
    }
    else if (before.length == 2)
    {
        self.moneyLab.text = [NSString stringWithFormat:@"0.%@",starMoney];
    }
    else if (before.length == 1)
    {
        self.moneyLab.text = [NSString stringWithFormat:@"0.0%@",starMoney];
    }
        
    
    SVMISS
}
//设置状态图片
- (void)setupHeadImgNeedDic:(NSDictionary *)dict
{
    NSString *orderType = [NSString stringWithFormat:@"%@",dict[@"orderType"]];
    if ([orderType isEqualToString:@"1"])
    {
        self.locViewTop.constant = -20;
        self.orderStatusPic.image = JX_IMAGE(@"jishi");
    }
    else if ([orderType isEqualToString:@"2"])
    {
        
        self.orderStatusPic.image = JX_IMAGE(@"yuyue");
    }
    else if ([orderType isEqualToString:@"3"])
    {
        self.locViewTop.constant = -20;
        self.orderStatusPic.image = JX_IMAGE(@"zhipai");
    }
    else
    {
        self.locViewTop.constant = -20;
        self.orderStatusPic.image = JX_IMAGE(@"jishi");
    }
}
//设置地址视图view
- (void)setupAddressViewNeedDict:(NSDictionary *)dict
{
    NSArray *arr = dict[@"orderTrip"];
    self.startTitleLab.text = [arr firstObject][@"title"];
    self.startDetailLab.text = [arr firstObject][@"address"];
    self.endTitleLab.text = [arr lastObject][@"title"];
    self.endDetailLab.text = [arr lastObject][@"address"];
    
//    Main_Screen_Width-58 label的宽度
    CGFloat startTitleLabHeight = [JXTool getLabelHeightWithString:self.startTitleLab.text needWidth:Main_Screen_Width-58];
    CGFloat startDetailHeight = [JXTool getLabelHeightWithString:self.startDetailLab.text needWidth:Main_Screen_Width-58];
    
    
    switch (arr.count)
    { 
        case 3:
        {
            UILabel *detailLab = [[UILabel alloc] init];
            detailLab.frame = CGRectMake(self.startDetailLab.frame.origin.x, startTitleLabHeight+startDetailHeight+20, Main_Screen_Width-58, 20);
            detailLab.text =arr[1][@"address"];
            detailLab.textColor = RGBCOLOR(128, 128, 128);
            detailLab.font = F14;
            [self.addressView addSubview:detailLab];
            
            UIView *round = [[UIView alloc] init];
            round.frame = CGRectMake(22.5, detailLab.center.y-2, 8, 8);
            round.backgroundColor = RGBCOLOR(180, 180, 180);
            ViewRadius(round, 4);
            [self.addressView addSubview:round];
            
            self.addressHeight.constant = 130;
        }
            break;
        case 4:
        {
            UILabel *detailLab = [[UILabel alloc] init];
            detailLab.frame = CGRectMake(self.startDetailLab.frame.origin.x, startTitleLabHeight+startDetailHeight+20, Main_Screen_Width-58, 20);
            detailLab.text =arr[1][@"address"];
            detailLab.textColor = RGBCOLOR(128, 128, 128);
            detailLab.font = F14;
            [self.addressView addSubview:detailLab];
            
            UIView *round = [[UIView alloc] init];
            round.frame = CGRectMake(22.5, detailLab.center.y-2, 8, 8);
            round.backgroundColor = RGBCOLOR(180, 180, 180);
            ViewRadius(round, 4);
            [self.addressView addSubview:round];
            
            UILabel *detailLab2 = [[UILabel alloc] init];
            detailLab2.frame = CGRectMake(self.startDetailLab.frame.origin.x, CGRectGetMaxY(detailLab.frame)+5, Main_Screen_Width-58, 20);
            detailLab2.text =arr[2][@"address"];
            detailLab2.textColor = RGBCOLOR(128, 128, 128);
            detailLab2.font = F14;
            [self.addressView addSubview:detailLab2];
            
            UIView *round2 = [[UIView alloc] init];
            round2.frame = CGRectMake(22.5, detailLab2.center.y-2, 8, 8);
            round2.backgroundColor = RGBCOLOR(180, 180, 180);
            ViewRadius(round2, 4);
            [self.addressView addSubview:round2];
            
            self.addressHeight.constant = 155;
        }
            break;
        case 5:
        {
            UILabel *detailLab = [[UILabel alloc] init];
            detailLab.frame = CGRectMake(self.startDetailLab.frame.origin.x, startTitleLabHeight+startDetailHeight+20, Main_Screen_Width-58, 20);
            detailLab.text =arr[1][@"address"];
            detailLab.textColor = RGBCOLOR(128, 128, 128);
            detailLab.font = F14;
            [self.addressView addSubview:detailLab];
            
            UIView *round = [[UIView alloc] init];
            round.frame = CGRectMake(22.5, detailLab.center.y-2, 8, 8);
            round.backgroundColor = RGBCOLOR(180, 180, 180);
            ViewRadius(round, 4);
            [self.addressView addSubview:round];
            
            UILabel *detailLab2 = [[UILabel alloc] init];
            detailLab2.frame = CGRectMake(self.startDetailLab.frame.origin.x, CGRectGetMaxY(detailLab.frame)+5, Main_Screen_Width-58, 20);
            detailLab2.text =arr[2][@"address"];
            detailLab2.textColor = RGBCOLOR(128, 128, 128);
            detailLab2.font = F14;
            [self.addressView addSubview:detailLab2];
            
            UIView *round2 = [[UIView alloc] init];
            round2.frame = CGRectMake(22.5, detailLab2.center.y-2, 8, 8);
            round2.backgroundColor = RGBCOLOR(180, 180, 180);
            ViewRadius(round2, 4);
            [self.addressView addSubview:round2];
            
            UILabel *detailLab3 = [[UILabel alloc] init];
            detailLab3.frame = CGRectMake(self.startDetailLab.frame.origin.x, CGRectGetMaxY(detailLab2.frame)+5, Main_Screen_Width-58, 20);
            detailLab3.text =arr[3][@"address"];
            detailLab3.textColor = RGBCOLOR(128, 128, 128);
            detailLab3.font = F14;
            [self.addressView addSubview:detailLab3];
            
            UIView *round3 = [[UIView alloc] init];
            round3.frame = CGRectMake(22.5, detailLab3.center.y-2, 8, 8);
            round3.backgroundColor = RGBCOLOR(180, 180, 180);
            ViewRadius(round3, 4);
            [self.addressView addSubview:round3];
            
            self.addressHeight.constant = 180;
        }
            break;
            
        default:
        {
            self.addressHeight.constant = 120;
        }
            break;
    }
}

// 设置留言款项的布局
- (void)setupLeaveItem:(NSDictionary *)dict
{
    self.extraStr = dict[@"extInfo"];
    NSArray *arr = [_extraStr componentsSeparatedByString:@","];
    CGFloat sumWidth = 0.0f;
    int row = 0;
    CGFloat maxY = .0f;
    
    BOOL isChange = NO;
    if (![JXTool verifyIsNullString:[arr firstObject]])
    {
        for (int i = 0 ; i < arr.count; i++)
        {
            if (sumWidth < Main_Screen_Width)
            {
                UILabel *txtLab = [[UILabel alloc] init];
                CGSize size =  [arr[i] sizeWithAttributes:@{NSFontAttributeName:F13}];
                if (i == 0)//确定第一个位置
                {
                    txtLab.frame = CGRectMake(25, 10, size.width+10, 25);
                    maxY = CGRectGetMaxY(txtLab.frame)+10;
                }
                else
                {
                    if (i == arr.count - 1) //确定最后的maxY
                    {
                        if (sumWidth + size.width + 10 + 25 <= Main_Screen_Width)
                        {
                            txtLab.frame = CGRectMake(sumWidth, row * 25 + 10 * (row + 1), size.width+10, 25);
                            maxY = CGRectGetMaxY(txtLab.frame)+10;
                        }
                        else
                        {
                            row = row + 1;
                            txtLab.frame = CGRectMake(25, row * 25 + 10 * (row + 1), size.width+10, 25);
                            maxY = CGRectGetMaxY(txtLab.frame)+10;
                        }
                    }
                    else //非最后的
                    {
                        if (sumWidth + size.width + 10 + 25 <= Main_Screen_Width)
                        {
                            txtLab.frame = CGRectMake(sumWidth, row * 25 + 10 * (row + 1), size.width+10, 25);
                        }
                        else
                        {
                            row = row + 1;
                            isChange = YES;
                            txtLab.frame = CGRectMake(25, row * 25 + 10 * (row + 1), size.width+10, 25);
                        }
                    }
                    
                }
                
                txtLab.text = arr[i];
                txtLab.font = F13;
                txtLab.textColor = RGBCOLOR(90, 90, 90);
                txtLab.textAlignment = NSTextAlignmentCenter;
                ViewBorderRadius(txtLab,  3, 0.5, RGBCOLOR(140, 140, 140));
                [self.flowView addSubview:txtLab];
                sumWidth= CGRectGetMaxX(txtLab.frame) + 10;
            }
            self.flowHeight.constant = maxY;
        }
    }
    else
    {
        self.flowHeight.constant = 0;
    }
}

- (IBAction)callBtnClick:(UIButton *)sender
{
    NSString *orderStatus = _dataDic[@"status"];
    
    if ([orderStatus compare:@"2" options:NSNumericSearch] == NSOrderedDescending)
    {
        NSString *numberStr = _dataDic[@"consignorTel"];
        NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",numberStr];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }
    else
    {
        NSString *numberStr = _dataDic[@"consignorTel"];
        NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",numberStr];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }
    
}

- (IBAction)nowGrabBtnClick:(UIButton *)sender
{
    [kNotificationCenter postNotificationName:@"changePage" object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)refuseBtnClick:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)agreeBtnClick:(UIButton *)sender
{
    [kNotificationCenter postNotificationName:@"changePage" object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dealloc
{
    [kNotificationCenter removeObserver:self name:@"getmoney" object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}



@end
