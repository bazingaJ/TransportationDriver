//
//  JXRegPhotoVC.h
//  BZWKuaiYun
//
//  Created by Jessey Young on 2017/5/23.
//  Copyright © 2017年 ISU. All rights reserved.
//

#import "JXBaseVC.h"

@interface JXRegPhotoVC : JXBaseVC

@property (strong, nonatomic) UICollectionView *collectionView;
@property (nonatomic, strong) UIImage *image1;

@property (nonatomic, strong) UIImage *image2;

@property (nonatomic, strong) UIImage *image3;

@property (nonatomic, strong) UIImage *image4;

- (instancetype)initWithDict:(NSMutableDictionary *)dict;

@end
