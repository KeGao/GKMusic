//
//  GKYuekuCommonModel.h
//  GKMusic
//
//  Created by qianfeng on 14-9-25.
//  Copyright (c) 2014年 gao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GKYuekuCommonModel : NSObject

//标题
@property (retain, nonatomic) NSString *title;
//订购类型
@property (retain, nonatomic) NSString *subScribeType;
//图片url
@property (retain, nonatomic) NSString *imgUrl;
//图片
@property (retain, nonatomic) UIImage *img;
//横幅url
@property (retain, nonatomic) NSString *bannerUrl;
//横幅
@property (retain, nonatomic) UIImage *banner;

@end
