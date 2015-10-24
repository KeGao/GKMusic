//
//  GKHotSingerCell.h
//  GKMusic
//
//  Created by qianfeng on 14-10-10.
//  Copyright (c) 2014年 gao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GKSingerDetailModel.h"

@interface GKHotSingerCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *IV1;
@property (weak, nonatomic) IBOutlet UIImageView *IV2;
@property (weak, nonatomic) IBOutlet UIImageView *IV3;
@property (weak, nonatomic) IBOutlet UIImageView *IV4;
@property (weak, nonatomic) IBOutlet UIImageView *IV5;
@property (weak, nonatomic) IBOutlet UIImageView *IV6;
@property (weak, nonatomic) IBOutlet UIImageView *IV7;
@property (weak, nonatomic) IBOutlet UIImageView *IV8;

@property (weak, nonatomic) IBOutlet UILabel *LB1;
@property (weak, nonatomic) IBOutlet UILabel *LB2;
@property (weak, nonatomic) IBOutlet UILabel *LB3;
@property (weak, nonatomic) IBOutlet UILabel *LB4;
@property (weak, nonatomic) IBOutlet UILabel *LB5;
@property (weak, nonatomic) IBOutlet UILabel *LB6;
@property (weak, nonatomic) IBOutlet UILabel *LB7;
@property (weak, nonatomic) IBOutlet UILabel *LB8;

@property (retain, nonatomic) GKSingerDetailModel *modelD;

@end
