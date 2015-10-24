//
//  GKMVCell.h
//  GKMusic
//
//  Created by qianfeng on 14-10-12.
//  Copyright (c) 2014年 gao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GKSingerMVModel.h"

@interface GKMVCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgIV1;
@property (weak, nonatomic) IBOutlet UIImageView *imgIV2;
@property (weak, nonatomic) IBOutlet UILabel *titleLB1;
@property (weak, nonatomic) IBOutlet UILabel *titleLB2;
@property (weak, nonatomic) IBOutlet UILabel *infoLB1;
@property (weak, nonatomic) IBOutlet UILabel *infoLB2;

@property (retain, nonatomic) GKSingerMVModel *model1;
@property (retain, nonatomic) GKSingerMVModel *model2;

@end
