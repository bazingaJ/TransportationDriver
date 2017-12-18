//
//  JXAboutUsVC.m
//  BZWKuaiYun
//
//  Created by Jessey Young on 2017/5/27.
//  Copyright © 2017年 ISU. All rights reserved.
//

#import "JXAboutUsVC.h"

NSString *const AboutUsServiceNoDataTips = @"服务器没有配置数据";

@interface JXAboutUsVC ()

@end

@implementation JXAboutUsVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self requestDriverRules];
}

- (void)requestDriverRules
{
    [JXRequestTool postQuerySysDictNeedType:@"aboutmeUrl" complete:^(BOOL isSuccess, NSDictionary *respose) {
        if (isSuccess)
        {
            NSArray *arr = respose[@"res"];
            if (arr.count == 0)
            {
                SVERROR(AboutUsServiceNoDataTips, 1.5)
            }
            else
            {
                NSDictionary *dictionary = arr[0];
                [self.webVi loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:dictionary[@"value"]]]];
            }
            
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
