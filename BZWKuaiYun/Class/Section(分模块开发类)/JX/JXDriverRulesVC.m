//
//  JXDriverRulesVC.m
//  BZWKuaiYun
//
//  Created by Jessey Young on 2017/5/27.
//  Copyright © 2017年 ISU. All rights reserved.
//

#import "JXDriverRulesVC.h"

@interface JXDriverRulesVC ()

@end

@implementation JXDriverRulesVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self requestDriverRules];
}

- (void)requestDriverRules
{
    [JXRequestTool postQuerySysDictNeedType:@"rulesUrl" complete:^(BOOL isSuccess, NSDictionary *respose) {
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
                [self.webV loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:dictionary[@"value"]]]];
            }
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}



@end
