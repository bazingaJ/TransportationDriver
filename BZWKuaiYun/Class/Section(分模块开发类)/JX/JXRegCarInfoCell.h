//
//  JXRegCarInfoCell.h
//  BZWKuaiYun
//
//  Created by Jessey Young on 2017/5/23.
//  Copyright © 2017年 ISU. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JXPlateBtnDelegate <NSObject>

- (void)plateBtnClick;

@end


@interface JXRegCarInfoCell : UITableViewCell
@property (nonatomic, assign) id<JXPlateBtnDelegate>delegate;
/**
 cell1
 */
@property (nonatomic, weak) IBOutlet UIButton *palteBtn;
@property (nonatomic, weak) IBOutlet UITextField *plateTF;


/**
 cell2
 */
@property (nonatomic, strong) IBOutlet UITextField *carTypeTF;

/**
 cell3
 */
@property (nonatomic, weak) IBOutlet UIButton *oneSingleBtn1;
@property (nonatomic, weak) IBOutlet UIButton *oneSingleBtn2;
@property (nonatomic, weak) IBOutlet UIButton *oneSingleBtn3;
@property (nonatomic, strong) NSString *specialString;
@end
