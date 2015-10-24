//
//  GKSingerCell.m
//  GKMusic
//
//  Created by qianfeng on 14-10-10.
//  Copyright (c) 2014年 gao. All rights reserved.
//

#import "GKSingerCell.h"

@implementation GKSingerCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setModel:(GKSingerModel *)model
{
    _nameLB.text = model.singername;
    _introduceLB.text = model.intro;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
