//
//  GKYuekuCommonCell.m
//  GKMusic
//
//  Created by qianfeng on 14-9-25.
//  Copyright (c) 2014年 gao. All rights reserved.
//

#import "GKYuekuCommonCell.h"

@implementation GKYuekuCommonCell

- (void)awakeFromNib
{
    // Initialization code
}

/*设置乐库数据模型*/
- (void)setModel1:(GKYuekuCommonModel *)model1
{    
    _title1LB.text = model1.title;
}

- (void)setModel2:(GKYuekuCommonModel *)model2
{
    _title2LB.text = model2.title;
}

/*设置排行总界面数据模型*/
- (void)setModelr1:(GKRankTotalModel *)model1
{    
    _title1LB.text = model1.rankName;
}

- (void)setModelr2:(GKRankTotalModel *)model2
{
    _title2LB.text = model2.rankName;
}

/*设置歌单总界面数据模型*/
- (void)setModelList1:(GKListTotalModel *)model1
{
    _title1LB.text = model1.categoryName;
}

- (void)setModelList2:(GKListTotalModel *)model2
{
    _title2LB.text = model2.categoryName;
}

/*设置电台总界面数据模型*/
- (void)setModelfm1:(GKRadioTotalModel *)model1
{
    _title1LB.text = model1.fmname;
    _descLB1.text = [model1.addtime substringToIndex:10];
}

- (void)setModelfm2:(GKRadioTotalModel *)model2
{
    _title2LB.text = model2.fmname;
    _descLB2.text = [model2.addtime substringToIndex:10];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
