//
//  JXPlatePickerV.m
//  BZWKuaiYun
//
//  Created by Jessey Young on 2017/5/24.
//  Copyright © 2017年 ISU. All rights reserved.
//

#import "JXPlatePickerV.h"

@interface JXPlatePickerV ()<UIPickerViewDelegate,UIPickerViewDataSource>
@property (nonatomic, strong) NSArray *shortCalls;
@property (nonatomic, strong) NSMutableArray *wholeArr;
@property (nonatomic, strong) NSMutableArray *indexArray;
@property (nonatomic, strong) NSArray *letterArr;
@property (nonatomic, strong) NSString *choiceStr;
@end

@implementation JXPlatePickerV

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self initialized];
        self.delegate = self;
        self.dataSource = self;
        self.backgroundColor = white_color;
    }
    return self;
}

- (void)initialized
{
    self.shortCalls = [NSArray arrayWithObjects:@"云",@"京",@"冀",@"吉",@"宁",@"川",@"新",@"晋",@"桂",@"沪",@"津",@"浙",@"渝",@"湘",@"琼",@"甘",@"皖",@"粤",@"苏",@"蒙",@"藏",@"豫",@"贵",@"赣",@"辽",@"鄂",@"闽",@"陕",@"青",@"鲁",@"黑", nil];
    self.letterArr = [NSArray arrayWithObjects:@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z", nil];
//    self.wholeArr  = [NSMutableArray array];
//    self.indexArray = [NSMutableArray array];
//    for (int i = 0; i <_shortCalls.count; i++)
//    {
//        NSMutableString *ms = [[NSMutableString alloc]initWithString:_shortCalls[i]];
//        //带声仄 //不能注释掉
//        if (CFStringTransform((__bridge CFMutableStringRef)ms, 0,kCFStringTransformMandarinLatin, NO))
//        {
//            //                        NSLog(@"pinyin: ---- %@", ms);
//        }
//        if (CFStringTransform((__bridge CFMutableStringRef)ms, 0,kCFStringTransformStripDiacritics, NO))
//        {
//            
//            NSString *bigStr = [ms uppercaseString]; // bigStr 是转换成功后的拼音
//            NSString *cha = [bigStr substringToIndex:1];
//            [self.wholeArr addObject:cha];  // cha 是汉字的首字母
//            //                        NSLog(@"pinyin: %@ ======== %@ ====== %@",model.nickname,ms, cha);
//            
//        }
//    }
//    
//    NSMutableArray *a = [self userSorting:_wholeArr];
//    JXLog(@"====%@-%@",self.wholeArr,a);
}
-(NSMutableArray *)userSorting:(NSMutableArray *)modelArr{
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    for(int i='A';i<='Z';i++)
    {
        NSMutableArray *rulesArray = [[NSMutableArray alloc] init];
        
        NSString *str1=[NSString stringWithFormat:@"%c",i];
        for(int j=0;j<modelArr.count;j++)
        {
            NSString *zimu = modelArr[j];  //这个model 是我自己创建的 里面包含用户的姓名 手机号 和 转化成功后的首字母
            if([zimu isEqualToString:str1])
            {
                [rulesArray addObject:zimu];    //把首字母相同的人物model 放到同一个数组里面
                [modelArr removeObject:zimu];   //model 放到 rulesArray 里面说明这个model 已经拍好序了 所以从总的modelArr里面删除
                j--;
                
            }
        }
        if (rulesArray.count !=0)
        {
            [array addObject:rulesArray];
            [self.indexArray addObject:[NSString stringWithFormat:@"%c",i]]; //把大写字母也放到一个数组里面
        }
    }
    
    if (modelArr.count !=0)
    {
        [array addObject:modelArr];
        [self.indexArray addObject:@"#"];  //把首字母不是A~Z里的字符全部放到 array里面 然后返回
    }
    
    return array;
    
}

#pragma mark- UIPicker View DataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component==0)
    {
        return _shortCalls.count;
    }
    else
    {
        return _letterArr.count;
    }
}
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    if (component==0) return 125;
    if (component==1) return 100;
    return 0;
}
- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component==0)
    {
        NSString * myDateString = _shortCalls[row];
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:myDateString];
        [attrString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, myDateString.length)];
        return attrString;
        
    }
    else
    {
        NSString *strDateWeek =_letterArr[row];
        
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:strDateWeek];
        [attrString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, strDateWeek.length)];
        return attrString;
    }
}
#pragma mark- UIPicker View Delegate
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component==0)
    {
        NSString *call = _shortCalls[row];
        
        NSInteger row1=[pickerView selectedRowInComponent:1];
        NSString *alpha =_letterArr[row1];
        
        self.choiceStr=[NSString stringWithFormat:@"%@--%@",call,alpha];
        
    }
    else
    {
        NSInteger row0=[pickerView selectedRowInComponent:0];
        NSString *call =_shortCalls[row0];
        
        NSString *alpha = _letterArr[row];
        self.choiceStr=[NSString stringWithFormat:@"%@--%@",call,alpha];
        
    }
    [SVProgressHUD showInfoWithStatus:_choiceStr];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleLight];
    [SVProgressHUD dismissWithDelay:2];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
