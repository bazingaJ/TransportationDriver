//
//  JXReadVC.m
//  BZWKuaiYun
//
//  Created by Jessey Young on 2017/5/25.
//  Copyright © 2017年 ISU. All rights reserved.
//

#import "JXReadVC.h"
#import "JXExamVC.h"

@interface JXReadVC ()

@property (nonatomic, strong) UIScrollView *scr;
@property (nonatomic, strong) NSString *url;

@end

@implementation JXReadVC

- (instancetype)initWithRequestUrl:(NSString *)url
{
    if (self = [super init])
    {
        self.url = url;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"阅读材料";
    [self overrideBackButton];
    
    [self setupUI];
    
}

- (void)setupUI
{
    [self.webVi loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
}

- (IBAction)readBtn:(UIButton *)sender
{
    JXExamVC *vc =[[JXExamVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

//- (void)backButtonClick
//{
//    int index = (int)[self.navigationController.viewControllers indexOfObject:self];
//    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:(index-4)] animated:YES];
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}



@end
