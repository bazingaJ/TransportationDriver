//
//  JXDriveNaviVC.h
//  BZWKuaiYun
//
//  Created by Jessey Young on 2017/7/4.
//  Copyright © 2017年 ISU. All rights reserved.
//

#import "JXBaseVC.h"
#import <AMapNaviKit/AMapNaviKit.h>

typedef void(^SendBlock)(BOOL isSend);

@protocol JXDriveNaviViewControllerDelegate;

@interface JXDriveNaviVC : JXBaseVC

@property (nonatomic, weak) id <JXDriveNaviViewControllerDelegate> delegate;

@property (nonatomic, strong) AMapNaviDriveView *driveView;

@property (nonatomic, strong) NSString *orderIdd;

@property (nonatomic, assign) BOOL isSend;

@property (nonatomic, copy) SendBlock sendBlock;

@end

@protocol JXDriveNaviViewControllerDelegate <NSObject>

- (void)driveNaviViewCloseButtonClicked;

@end
