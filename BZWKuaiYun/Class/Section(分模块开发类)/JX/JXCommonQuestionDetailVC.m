//
//  JXCommonQuestionDetailVC.m
//  BZWKuaiYun
//
//  Created by Jessey Young on 2017/5/27.
//  Copyright © 2017年 ISU. All rights reserved.
//

#import "JXCommonQuestionDetailVC.h"

@interface JXCommonQuestionDetailVC ()
@property (nonatomic, strong) NSDictionary *dataDic;
@end

@implementation JXCommonQuestionDetailVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupUI];
    [self requestQuestionDetail];
    
}

- (void)setupUI
{
    self.scrView.contentSize = CGSizeMake(0, Main_Screen_Height);
    
}

- (void)requestQuestionDetail
{
    SVSHOW
    [JXRequestTool postQueryQuestionDetailNeedQuestionId:self.questionID complete:^(BOOL isSuccess, NSDictionary *respose) {
        if (isSuccess)
        {
            self.dataDic = respose[@"res"];
            NSString *wholeStr = nil;
            NSString *op1 = _dataDic[@"options1"];
            NSString *op2 = _dataDic[@"options2"];
            NSString *op3 = _dataDic[@"options3"];
            NSString *op4 = _dataDic[@"options4"];
            
            if ([JXTool verifyIsNullString:op4] && ![JXTool verifyIsNullString:op3])
            {
                wholeStr = [NSString stringWithFormat:@"%@\n%@\n1.%@\n2.%@\n3.%@",_dataDic[@"title"],_dataDic[@"profile"],op1,op2,op3];
            }
            else if ([JXTool verifyIsNullString:op3] && ![JXTool verifyIsNullString:op2])
            {
                wholeStr = [NSString stringWithFormat:@"%@\n%@\n1.%@\n2.%@",_dataDic[@"title"],_dataDic[@"profile"],op1,op2];
            }
            else if ([JXTool verifyIsNullString:op2] && ![JXTool verifyIsNullString:op1])
            {
                wholeStr = [NSString stringWithFormat:@"%@\n%@\n1.%@",_dataDic[@"title"],_dataDic[@"profile"],op1];
            }
            else if ([JXTool verifyIsNullString:op1])
            {
                wholeStr = [NSString stringWithFormat:@"%@\n%@",_dataDic[@"title"],_dataDic[@"profile"]];
            }
            else
            {
                wholeStr = [NSString stringWithFormat:@"%@\n%@\n1.%@\n2.%@\n3.%@\n4.%@",_dataDic[@"title"],_dataDic[@"profile"],op1,op2,op3,op4];
            }
            
            NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:wholeStr];
            NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
            paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
            paraStyle.lineSpacing = 10;
            [AttributedStr addAttribute:NSParagraphStyleAttributeName value:paraStyle range:NSMakeRange(0, wholeStr.length)];
            [self.contentLab setAttributedText:AttributedStr];
            
            CGFloat height =[JXTool getLabelHeightWithString:wholeStr needWidth:Main_Screen_Width-16];
            if (height > Main_Screen_Height)
            {
                self.scrView.contentSize = CGSizeMake(0, height);
            }
            SVMISS
            
        }
    }];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}


@end
