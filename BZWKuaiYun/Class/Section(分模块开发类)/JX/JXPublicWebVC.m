//
//  JXPublicWebVC.m
//  BZWKuaiYun
//
//  Created by Jessey Young on 2017/7/3.
//  Copyright © 2017年 ISU. All rights reserved.
//

#import "JXPublicWebVC.h"

@interface JXPublicWebVC ()

@end

@implementation JXPublicWebVC


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self requestDriverRules];
}
- (void)requestDriverRules
{
    [self.webVi loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlTxt]]];
    
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
