//
//  JXRegCarInfoVC.h
//  BZWKuaiYun
//
//  Created by Jessey Young on 2017/5/23.
//  Copyright © 2017年 ISU. All rights reserved.
//

#import "JXBaseVC.h"

@interface JXRegCarInfoVC : JXBaseVC

@property (nonatomic, weak) IBOutlet UITableView *tableVi;
@property (nonatomic, strong) UIControl *layerControl;
@property (nonatomic, strong) UIButton *plateBtn;
@property (nonatomic, strong) UIButton *btn1;
@property (nonatomic, strong) UIButton *btn2;
@property (nonatomic, strong) UIButton *btn3;

- (instancetype)initWithDict:(NSMutableDictionary *)dict;

@end
