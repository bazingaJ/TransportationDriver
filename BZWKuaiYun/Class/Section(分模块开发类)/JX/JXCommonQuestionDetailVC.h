//
//  JXCommonQuestionDetailVC.h
//  BZWKuaiYun
//
//  Created by Jessey Young on 2017/5/27.
//  Copyright © 2017年 ISU. All rights reserved.
//

#import "JXBaseVC.h"

@interface JXCommonQuestionDetailVC : JXBaseVC

@property (weak, nonatomic) IBOutlet UILabel *contentLab;
@property (nonatomic, weak) IBOutlet UIScrollView *scrView;
@property (nonatomic, strong) NSString *questionID;
@end
