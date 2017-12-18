//
//  JXConfirmVC.h
//  BZWKuaiYun
//
//  Created by Jessey Young on 2017/5/23.
//  Copyright © 2017年 ISU. All rights reserved.
//

#import "JXBaseVC.h"

@interface JXConfirmVC : JXBaseVC
@property (weak, nonatomic) IBOutlet UITextField *passTF;
@property (weak, nonatomic) IBOutlet UITextField *againPassTF;
@property (nonatomic, strong) NSString *codeStr;
@end
