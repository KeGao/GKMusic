//
//  GKYuekuCommonCell.h
//  GKMusic
//
//  Created by qianfeng on 14-9-25.
//  Copyright (c) 2014年 gao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GKYuekuCommonModel.h"
#import "GKRankTotalModel.h"
#import "GKListTotalModel.h"
#import "GKRadioTotalModel.h"

typedef void(^completed) (UIImage *image, NSString *ID);

@interface GKYuekuCommonCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *img1IV;
@property (weak, nonatomic) IBOutlet UIImageView *img2IV;
@property (weak, nonatomic) IBOutlet UILabel *title1LB;
@property (weak, nonatomic) IBOutlet UILabel *title2LB;
@property (weak, nonatomic) IBOutlet UIImageView *playIV1;
@property (weak, nonatomic) IBOutlet UIImageView *playIV;
@property (weak, nonatomic) IBOutlet UILabel *descLB1;
@property (weak, nonatomic) IBOutlet UILabel *descLB2;


@property (retain, nonatomic) GKYuekuCommonModel *model1;
@property (retain, nonatomic) GKYuekuCommonModel *model2;
@property (retain, nonatomic) GKRankTotalModel *modelr1;
@property (retain, nonatomic) GKRankTotalModel *modelr2;
@property (retain, nonatomic) GKListTotalModel *modelList1;
@property (retain, nonatomic) GKListTotalModel *modelList2;
@property (retain, nonatomic) GKRadioTotalModel *modelfm1;
@property (retain, nonatomic) GKRadioTotalModel *modelfm2;

@end
