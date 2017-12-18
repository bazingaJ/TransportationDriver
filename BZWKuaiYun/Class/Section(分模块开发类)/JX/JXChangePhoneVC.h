//
//  JXChangePhoneVC.h
//  BZWKuaiYun
//
//  Created by Jessey Young on 2017/5/26.
//  Copyright © 2017年 ISU. All rights reserved.
//

#import "JXBaseVC.h"
#import "JKCountDownButton.h"

@interface JXChangePhoneVC : JXBaseVC
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextField *codeTF;
@property (weak, nonatomic) IBOutlet JKCountDownButton *codeBtn;

@end
