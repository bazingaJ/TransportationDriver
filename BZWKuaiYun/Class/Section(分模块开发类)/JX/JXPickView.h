//
//  JXPickView.h
//  BZWKuaiYun
//
//  Created by Jessey Young on 2017/5/24.
//  Copyright © 2017年 ISU. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JXPickerViewDelegate <NSObject>

- (void)cancelButtonClickAfter;
- (void)containButtonClickAfter;

@end

@interface JXPickView : UIView
@property (nonatomic, assign) id<JXPickerViewDelegate>something;
@end
