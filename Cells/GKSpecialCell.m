//
//  GKSpecialCell.m
//  GKMusic
//
//  Created by Gao on 14-9-30.
//  Copyright (c) 2014年 gao. All rights reserved.
//

#import "GKSpecialCell.h"

@implementation GKSpecialCell

- (void)awakeFromNib
{
    // Initialization code
}

/*设置专题分类数据模型*/
- (void)setModel1:(GKSpecialTotalModel *)model1
{
    _title1LB.text = model1.specialname;
    NSString *strDate = [model1.publishtime substringToIndex:10];
    _info1LB.text = [NSString stringWithFormat:@"%@/%@",model1.singername,strDate];
}

- (void)setModel2:(GKSpecialTotalModel *)model2
{
    _title2LB.text = model2.specialname;
    NSString *strDate = [model2.publishtime substringToIndex:10];
    _info2LB.text = [NSString stringWithFormat:@"%@/%@",model2.singername,strDate];
    _pushIV.image = [UIImage imageNamed:@"localSinger_cell_accessoryimage.png"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
