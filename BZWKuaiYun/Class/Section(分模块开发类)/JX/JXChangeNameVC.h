//
//  JXChangeNameVC.h
//  BZWKuaiYun
//
//  Created by Jessey Young on 2017/5/26.
//  Copyright © 2017年 ISU. All rights reserved.
//

#import "JXBaseVC.h"

typedef void(^NameChange)(NSString *name);
@interface JXChangeNameVC : JXBaseVC

@property (nonatomic, weak) IBOutlet UITextField *nameTF;
@property (nonatomic, strong) NSString *textName;
@property (nonatomic, copy) NameChange name;
@end
