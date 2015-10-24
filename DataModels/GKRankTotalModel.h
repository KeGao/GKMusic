//
//  GKRankTotalModel.h
//  GKMusic
//
//  Created by qianfeng on 14-9-25.
//  Copyright (c) 2014年 gao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GKRankTotalModel : NSObject

//排行ID
@property (retain, nonatomic) NSString *rankID;
//排行名称
@property (retain, nonatomic) NSString *rankName;
//排行类型
@property (retain, nonatomic) NSString *rankType;
//排行介绍
@property (retain, nonatomic) UIImage *introduce;
//图片url
@property (retain, nonatomic) NSString *imgUrl;
//图片
@property (retain, nonatomic) UIImage *img;
//横幅url
@property (retain, nonatomic) NSString *bannerUrl;
//横幅
@property (retain, nonatomic) UIImage *banner;
//横幅7url
@property (retain, nonatomic) NSString *banner7Url;
//横幅7
@property (retain, nonatomic) UIImage *banner7;

@end
