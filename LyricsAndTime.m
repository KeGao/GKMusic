//
//  LyricsAndTime.m
//  歌词解析项目
//
//  Created by qianfeng on 14-7-29.
//  Copyright (c) 2014年 gao. All rights reserved.
//

#import "LyricsAndTime.h"

@implementation LyricsAndTime


- (id)initWithLyrics:(NSString *)lyric andTime:(NSString *)time
{
    self = [super init];
    if (self) {
        _lyric = lyric;
        _myTime = time;
    }
    return self;
}

- (NSString *)description
{
    NSString *str = [NSString stringWithFormat:@"%@  %@",_myTime,_lyric];
    return str;
}

- (BOOL)islater:(LyricsAndTime *)obj
{
    return [self.myTime compare: obj.myTime]>0;
}

@end
