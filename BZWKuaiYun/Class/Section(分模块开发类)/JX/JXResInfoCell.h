//
//  JXResInfoCell.h
//  BZWKuaiYun
//
//  Created by Jessey Young on 2017/5/23.
//  Copyright © 2017年 ISU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JXResInfoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UITextField *detail;
@property (nonatomic, strong) NSMutableDictionary *dataDic;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textFieldTrailing;

@end
