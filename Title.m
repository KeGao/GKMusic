//
//  Title.m
//  歌词解析项目
//
//  Created by qianfeng on 14-7-29.
//  Copyright (c) 2014年 gao. All rights reserved.
//

#import "Title.h"

@implementation Title

- (NSString *)description
{
    NSString *str = [NSString stringWithFormat:@"%@ %@",_song,_singer];
    return str;
}

@end
