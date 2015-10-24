//
//  GKMusicListCell.h
//  GKMusic
//
//  Created by qianfeng on 14-9-25.
//  Copyright (c) 2014年 gao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GKRankDetailModel.h"
#import "GKFMDetailModel.h"
#import "GKSingerMusicModel.h"

@interface GKMusicListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *musicLB;
@property (weak, nonatomic) IBOutlet UIImageView *sqIV;
@property (weak, nonatomic) IBOutlet UIImageView *mvIV;

@property (retain, nonatomic) GKRankDetailModel *model;
@property (retain, nonatomic) GKFMDetailModel *modelfm;
@property (retain, nonatomic) GKSingerMusicModel *modelsong;

@end
