//
//  JXResInfoCell.m
//  BZWKuaiYun
//
//  Created by Jessey Young on 2017/5/23.
//  Copyright © 2017年 ISU. All rights reserved.
//

#import "JXResInfoCell.h"

@implementation JXResInfoCell

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)setDataDic:(NSMutableDictionary *)dataDic
{
    self.title.text = dataDic[@"title"];
    self.detail.placeholder = dataDic[@"placeholder"];
    self.detail.text = dataDic[@"content"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

}

@end
