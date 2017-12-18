//
//  JXConfirmVC.m
//  BZWKuaiYun
//
//  Created by Jessey Young on 2017/5/23.
//  Copyright © 2017年 ISU. All rights reserved.
//

#import "JXConfirmVC.h"

@interface JXConfirmVC ()<UITextFieldDelegate>

@end

@implementation JXConfirmVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"忘记密码";
    [self overrideBackButton];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void)request
{
    [JXRequestTool postResetPwdNeedPassword:self.passTF.text checkCode:self.codeStr complete:^(BOOL isSuccess, NSDictionary *respose) {
        if (isSuccess)
        {
            SVSUCCESS(@"密码修改成功", 1.5)
            int index = (int)[self.navigationController.viewControllers indexOfObject:self];
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:(index-2)] animated:YES];
        }
    }];
}

- (IBAction)commitBtnClick:(UIButton *)sender
{
    if ([self textFieldJudge])
    {
        [self request];
    }
}

- (BOOL)textFieldJudge
{
    if ([JXTool verifyIsNullString:_passTF.text])
    {
        SVINFO(@"请输入新密码", 1.5)
        return NO;
    }
    else if (![[JXTool verifyIslegelFromIndex:6 ToIndex:12 string:_passTF.text] isEqualToString:@""])
    {
        SVINFO([JXTool verifyIslegelFromIndex:6 ToIndex:12 string:_passTF.text], 1.5)
        return NO;
    }
    else if ([JXTool verifyIsNullString:_againPassTF.text])
    {
        SVINFO(@"请再次输入密码", 1.5)
        return NO;
    }
    else if (![_passTF.text isEqualToString:_againPassTF.text])
    {
        SVINFO(@"请重新输入", 1.5)
        return NO;
    }
    else
    {
        return YES;
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSInteger loc =range.location;
    if (loc < 12)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}



@end
