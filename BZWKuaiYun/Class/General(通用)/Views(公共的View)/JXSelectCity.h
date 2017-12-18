//
//  JXSelectCity.h
//  BZWKuaiYun
//
//  Created by Jessey Young on 2017/5/24.
//  Copyright © 2017年 ISU. All rights reserved.
//

#import "JXBaseVC.h"

typedef void(^selectdCity)(NSString *city,NSString *cityID,NSString *country,NSString *countryID,NSString *logi,NSString *lati);

typedef void(^returnCityInfo)(NSString *city,NSString *cityCode);

@interface JXSelectCity : JXBaseVC
@property (nonatomic, weak) IBOutlet UITableView *tableVi;
@property (nonatomic, assign) BOOL isMinePart;
@property (nonatomic, strong) selectdCity choice;
@property (nonatomic, strong) returnCityInfo cityInfo;


@end
