//
//  GKHotSingerCell.m
//  GKMusic
//
//  Created by qianfeng on 14-10-10.
//  Copyright (c) 2014年 gao. All rights reserved.
//

#import "GKHotSingerCell.h"
#import "GKSingerModel.h"

@implementation GKHotSingerCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setModelD:(GKSingerDetailModel *)modelD
{
    int i = 0;
    for (GKSingerModel *model in modelD.arrData) {
        UILabel *lb = (UILabel *)[self.contentView viewWithTag:30+i];
        lb.text = model.singername;
        i++;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
