//
//  LyricsManage.h
//  歌词解析项目
//
//  Created by qianfeng on 14-7-29.
//  Copyright (c) 2014年 gao. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Title;
@class LyricsAndTime;

@interface LyricsManage : NSObject

@property  Title *title;
@property NSMutableArray *arr;
@property NSString *str;
@property NSString *path;

- (id)init;

- (void)readFile;

- (void)sort;

- (void)play;

@end
