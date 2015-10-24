//
//  GKRankDetailModel.h
//  GKMusic
//
//  Created by qianfeng on 14-9-25.
//  Copyright (c) 2014年 gao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GKRankDetailModel : NSObject

//歌曲信息
@property (retain, nonatomic) NSString *filename;
//hash(低品质)
@property (retain, nonatomic) NSString *hash;
//320hash(标准品质)
@property (retain, nonatomic) NSString *hash320;
//sqhash(高品质)
@property (retain, nonatomic) NSString *sqhash;
//mvhash
@property (retain, nonatomic) NSString *mvhash;
//feetype
@property (retain, nonatomic) NSString *feetype;
//isfirst
@property (retain, nonatomic) NSString *isfirst;
//addTime
@property (retain, nonatomic) NSString *addtime;

@end
