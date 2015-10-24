//
//  LyricsAndTime.h
//  歌词解析项目
//
//  Created by qianfeng on 14-7-29.
//  Copyright (c) 2014年 gao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LyricsAndTime : NSObject

@property NSString *lyric;

@property NSString *myTime;

- (id)initWithLyrics:(NSString *)lyric andTime:(NSString *)time;

- (NSString *)description;

- (BOOL)islater:(LyricsAndTime *)obj;

@end
