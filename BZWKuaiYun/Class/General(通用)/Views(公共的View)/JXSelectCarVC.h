//
//  JXSelectCarVC.h
//  BZWKuaiYun
//
//  Created by Jessey Young on 2017/5/24.
//  Copyright © 2017年 ISU. All rights reserved.
//

#import "JXBaseVC.h"

typedef void(^selectedCar)(NSString *first, NSString *second,NSString *autoType);

@interface JXSelectCarVC : JXBaseVC
@property (weak, nonatomic) IBOutlet UITableView *tableVi;
@property (nonatomic, strong) selectedCar car;
@end
