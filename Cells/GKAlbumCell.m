//
//  GKAlbumCell.m
//  GKMusic
//
//  Created by qianfeng on 14-10-12.
//  Copyright (c) 2014年 gao. All rights reserved.
//

#import "GKAlbumCell.h"

@implementation GKAlbumCell

- (void)awakeFromNib
{
    // Initialization code
}

/*设置歌手专辑数据模型*/
- (void)setModel1:(GKSingerAlbumModel *)model1
{
    _titleLB1.text = model1.albumname;
    NSString *strDate = [model1.publishtime substringToIndex:10];
    _infoLB1.text = [NSString stringWithFormat:@"%@ /%@",model1.singername,strDate];
}

- (void)setModel2:(GKSingerAlbumModel *)model2
{
    _titleLB2.text = model2.albumname;
    NSString *strDate = [model2.publishtime substringToIndex:10];
    _infoLB2.text = [NSString stringWithFormat:@"%@ /%@",model2.singername,strDate];
    _pushIV.image = [UIImage imageNamed:@"localSinger_cell_accessoryimage.png"];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
