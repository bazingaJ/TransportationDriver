//
//  JXDatePickerView.h
//  BZWKuaiYun
//
//  Created by Jessey Young on 2017/6/27.
//  Copyright © 2017年 ISU. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JXDatePickerDelegate <NSObject>

- (void)cancelButtonClickAfter:(NSString *)str;
- (void)containButtonClickAfter:(NSString *)str;

@end

@interface JXDatePickerView : UIView

@property (nonatomic, assign) id<JXDatePickerDelegate>delegate;
@end




