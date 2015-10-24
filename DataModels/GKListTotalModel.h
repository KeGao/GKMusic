//
//  GKListTotalModel.h
//  GKMusic
//
//  Created by qianfeng on 14-9-27.
//  Copyright (c) 2014年 gao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GKListTotalModel : NSObject

//分类ID
@property (retain, nonatomic) NSString *categoryID;
//分类名称
@property (retain, nonatomic) NSString *categoryName;
//图片url
@property (retain, nonatomic) NSString *imgUrl;
//图片
@property (retain, nonatomic) UIImage *img;
//横幅url
@property (retain, nonatomic) NSString *bannerUrl;
//横幅
@property (retain, nonatomic) UIImage *banner;


@end
