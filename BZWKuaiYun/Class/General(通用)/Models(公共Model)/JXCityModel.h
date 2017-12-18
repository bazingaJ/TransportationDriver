//
//  JXCityModel.h
//  BZWKuaiYun
//
//  Created by Jessey Young on 2017/5/24.
//  Copyright © 2017年 ISU. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JXCityModel : NSObject

@property (nonatomic, strong) NSString *city;


@property (nonatomic, strong) NSString *shou;
@property (nonatomic, strong) NSString *wholeStr;

@end



@interface JXCountryModel : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *ID;


@end


@interface JXCarTypeModel : NSObject

@property (nonatomic, strong) NSString *autoImg;
@property (nonatomic, strong) NSString *autoSize;
@property (nonatomic, strong) NSString *autoType;
@property (nonatomic, strong) NSString *autoTypeName;
@property (nonatomic, strong) NSString *load;

@end
