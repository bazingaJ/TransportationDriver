//
//  JXActivityVC.m
//  BZWKuaiYun
//
//  Created by Jessey Young on 2017/6/26.
//  Copyright © 2017年 ISU. All rights reserved.
//

#import "JXActivityVC.h"

@interface JXActivityVC ()
@property (weak, nonatomic) IBOutlet UIWebView *webVi;
@end

@implementation JXActivityVC



- (void)viewDidLoad
{
    [super viewDidLoad];
    [self overrideBackButton];
    
    [self setupUI];
}

- (void)setupUI
{
    self.title = self.titleLab;
    
    [self.webVi loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_url]]];
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
