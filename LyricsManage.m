//
//  LyricsManage.m
//  歌词解析项目
//
//  Created by qianfeng on 14-7-29.
//  Copyright (c) 2014年 gao. All rights reserved.
//

#import "LyricsManage.h"
#import "Title.h"
#import "LyricsAndTime.h"

@implementation LyricsManage

- (id)init
{
    self = [super init];
    if (self) {
        _arr = [[NSMutableArray alloc] init];
        _title = [[Title alloc] init];
        _path = [[NSString alloc] init];
    }
    return self;
}

- (void)readFile
{
    
    NSError *error;
    NSString *str = [NSString stringWithContentsOfFile:_path encoding:NSUTF8StringEncoding error:&error];
    if (error) {
        NSLog(@"%@",error);
    }
    NSArray *arr = [[NSArray alloc] init];

    arr = [str componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"[]"]];
//    for (id obj in arr) {
//        NSLog(@"%@",obj);
//    }
//    NSLog(@"%@",arr);
    
    NSString *song = [arr[1] substringFromIndex:[arr[1]rangeOfString:@":"].location+1];
    NSString *singer = [arr[3] substringFromIndex:[arr[3]rangeOfString:@":"].location+1];
    
    _title.song = song;
    _title.singer = singer;
    _str = _title.description;
    
    for (NSUInteger i = 9; i < [arr count]; i+=2) {
        NSUInteger x = 1;
        while ([arr[i+x] isEqualToString:@""]) {
            x += 2;
        }
        LyricsAndTime *obj = [[LyricsAndTime alloc] initWithLyrics:arr[i+x] andTime:arr[i]];
        [_arr addObject:obj];
    }
    
//    for (id obj in _arr) {
//        NSLog(@"%@",obj);
//    }
    
}


- (void)sort
{
    [_arr sortUsingSelector:@selector(islater:)];
    
//    for (id obj in _arr) {
//        NSLog(@"%@",obj);
//    }
}

- (void)play
{
    NSLog(@"%@",_title);
    float temp = 0;
    for (id obj in _arr) {
        NSLog(@"%@",obj);
        float x = [[obj myTime] intValue]*60 + [[[obj myTime] substringFromIndex:3] floatValue];
        sleep(x-temp);
        temp = x;
    }
}

@end
