//
//  JXReadVC.h
//  BZWKuaiYun
//
//  Created by Jessey Young on 2017/5/25.
//  Copyright © 2017年 ISU. All rights reserved.
//

#import "JXBaseVC.h"

@interface JXReadVC : JXBaseVC

@property (weak, nonatomic) IBOutlet UIWebView *webVi;

- (instancetype)initWithRequestUrl:(NSString *)url;

@end
