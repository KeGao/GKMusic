//
//  GKMVCell.m
//  GKMusic
//
//  Created by qianfeng on 14-10-12.
//  Copyright (c) 2014年 gao. All rights reserved.
//

#import "GKMVCell.h"

@implementation GKMVCell

- (void)awakeFromNib
{
    // Initialization code
}

/*设置歌手MV数据模型*/
- (void)setModel1:(GKSingerMVModel *)model1
{
    _titleLB1.text = model1.filename;
    _infoLB1.text = model1.singername;
}

- (void)setModel2:(GKSingerMVModel *)model2
{
    _titleLB2.text = model2.filename;
    _infoLB2.text = model2.singername;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
