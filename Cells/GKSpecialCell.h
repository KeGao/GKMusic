//
//  GKSpecialCell.h
//  GKMusic
//
//  Created by Gao on 14-9-30.
//  Copyright (c) 2014年 gao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GKSpecialTotalModel.h"

@interface GKSpecialCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *img1IV;
@property (weak, nonatomic) IBOutlet UIImageView *img2IV;
@property (weak, nonatomic) IBOutlet UILabel *title1LB;
@property (weak, nonatomic) IBOutlet UILabel *title2LB;
@property (weak, nonatomic) IBOutlet UILabel *info1LB;
@property (weak, nonatomic) IBOutlet UILabel *info2LB;
@property (weak, nonatomic) IBOutlet UIImageView *pushIV;

@property (retain, nonatomic) GKSpecialTotalModel *model1;
@property (retain, nonatomic) GKSpecialTotalModel *model2;

@end
