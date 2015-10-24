//
//  GKMusicListCell.m
//  GKMusic
//
//  Created by qianfeng on 14-9-25.
//  Copyright (c) 2014年 gao. All rights reserved.
//

#import "GKMusicListCell.h"

@implementation GKMusicListCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setModel:(GKRankDetailModel *)model
{
    _musicLB.text = model.filename;
    if (model.sqhash.length>0) {
        _sqIV.image = [UIImage imageNamed:@"ic_audio_item_hq_mark.png"];
    }
    else {
        _sqIV.image = nil;
    }
    if (model.mvhash.length>0) {
        _mvIV.image = [UIImage imageNamed:@"ic_audio_item_mv_mark.png"];
    }
    else {
        _mvIV.image = nil;
    }
}

- (void)setModelfm:(GKFMDetailModel *)model
{
    _musicLB.text = model.name;
    if (model.hash320.length>0) {
        _sqIV.image = [UIImage imageNamed:@"ic_audio_item_hq_mark.png"];
    }
    else {
        _sqIV.image = nil;
    }
    if (model.mvhash.length>0) {
        _mvIV.image = [UIImage imageNamed:@"ic_audio_item_mv_mark.png"];
    }
    else {
        _mvIV.image = nil;
    }
}

- (void)setModelsong:(GKSingerMusicModel *)model
{
    _musicLB.text = model.filename;
    if (model.hash320.length>0) {
        _sqIV.image = [UIImage imageNamed:@"ic_audio_item_hq_mark.png"];
    }
    else {
        _sqIV.image = nil;
    }
    if (model.mvhash.length>0) {
        _mvIV.image = [UIImage imageNamed:@"ic_audio_item_mv_mark.png"];
    }
    else {
        _mvIV.image = nil;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
