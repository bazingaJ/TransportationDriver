//
//  JXChangeNameVC.m
//  BZWKuaiYun
//
//  Created by Jessey Young on 2017/5/26.
//  Copyright © 2017年 ISU. All rights reserved.
//

#import "JXChangeNameVC.h"

@interface JXChangeNameVC ()<UITextFieldDelegate>

@property (nonatomic, strong) UIButton *rightBtn;

@end

@implementation JXChangeNameVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupUI];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.nameTF becomeFirstResponder];
}
- (void)setupUI
{
    UIView *rightView = [[UIView alloc] init];
    rightView.frame = CGRectMake(0, 0, 60, 40);
    
    
    self.rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.rightBtn.frame = CGRectMake(15, 0, 60, 40);
    [self.rightBtn setTitle:@"保存" forState:UIControlStateNormal];
    self.rightBtn.titleLabel.font = F16;
    [self.rightBtn setTitleColor:RGBACOLOR(254, 98, 70, .5) forState:UIControlStateNormal];
    [self.rightBtn addTarget:self action:@selector(saveBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    [rightView addSubview:self.rightBtn];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightView];
    
    UIView *leftView = [[UIView alloc] init];
    leftView.frame = CGRectMake(0, 0, 60, 40);
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(-20, 0, 60, 40);
    [leftBtn setTitle:@"取消" forState:UIControlStateNormal];
    leftBtn.titleLabel.font = F16;
    [leftBtn setTitleColor:RGBCOLOR(100, 100, 100) forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    [leftView addSubview:leftBtn];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftView];
    
    self.nameTF.text = self.textName;
}

- (void)saveBtnClick
{
    if ([JXTool verifyIsNullString:_nameTF.text])
    {
        SVINFO(@"姓名不能为空", 1.5)
    }
    else
    {
        SVSTATUS(@"上传中")
        [JXRequestTool postUpdateMyInfoNeedPhoto:@"" mobile:@"" checkCode:@"" trueName:self.nameTF.text uploadType:UploadTypeName complete:^(BOOL isSuccess, NSDictionary *respose) {
            if (isSuccess)
            {
                SVMISS
                if (self.name)
                {
                    self.name(_nameTF.text);
                }
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
    }
    
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    [self.rightBtn setTitleColor:Main_Color forState:UIControlStateNormal];
    return YES;
}
- (void)cancelBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

@end
