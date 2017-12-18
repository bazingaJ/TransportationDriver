//
//  JXFeedbackVC.m
//  BZWKuaiYun
//
//  Created by Jessey Young on 2017/5/27.
//  Copyright © 2017年 ISU. All rights reserved.
//

#import "JXFeedbackVC.h"

@interface JXFeedbackVC ()<UITextFieldDelegate,UITextViewDelegate>

@end

@implementation JXFeedbackVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets= NO;
    [kNotificationCenter addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [kNotificationCenter addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}
- (IBAction)commitBtn:(UIButton *)sender
{
    if ([self.adviceTV.text isEqualToString:@""])
    {
        SVINFO(@"请输入内容", 1.5)
    }
    else if ([self.phoneTF.text isEqualToString:@""])
    {
        SVINFO(@"请填写您的手机号码", 1.5)
    }
    else if (![JXTool verifyMobilePhone:self.phoneTF.text])
    {
        SVINFO(@"请输入正确的手机号码", 1.5)
    }
    else
    {
        SVSHOW
        [JXRequestTool postFeedBackNeedUserType:@"3" telephone:self.phoneTF.text contents:self.adviceTV.text complete:^(BOOL isSuccess, NSDictionary *respose) {
            if (isSuccess)
            {
                SVSUCCESS(@"反馈成功", 1.5)
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
    }
}


- (void)textViewDidChange:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""])
    {
        self.placeholderLab.hidden = NO;
    }
    else
    {
        self.placeholderLab.hidden = YES;
    }
}
- (void)keyboardWillShow:(NSNotification *)noti
{
    CGRect keyBoardRect=[noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    if ([self.adviceTV isFirstResponder])
    {
        //目标视图UITextField
        CGRect frame = self.adviceTV.frame;
        CGFloat y = frame.origin.y + frame.size.height - (self.view.frame.size.height - keyBoardRect.size.height);
        if(y > 0)
        {
            self.view.transform = CGAffineTransformMakeTranslation(0, -y);
        }
    }
    else
    {
        //目标视图UITextField
        CGRect frame = self.phoneTF.frame;
        CGFloat y = frame.origin.y + frame.size.height - (self.view.frame.size.height - keyBoardRect.size.height);
        if(y > 0)
        {
            self.view.transform = CGAffineTransformMakeTranslation(0, -y);
        }
        
    }
}
- (void)keyboardWillHide:(NSNotification *)noti
{
    self.view.transform = CGAffineTransformIdentity;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
- (void)dealloc
{
    [kNotificationCenter removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [kNotificationCenter removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}



@end
