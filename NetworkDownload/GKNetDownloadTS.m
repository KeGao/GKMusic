//
//  GKNetDownloadTS.m
//  iCartoom爱动漫
//
//  Created by qianfeng on 14-9-15.
//  Copyright (c) 2014年 gao. All rights reserved.
//

#import "GKNetDownloadTS.h"

@implementation GKNetDownloadTS

//下载函数
- (void)downloadURL:(NSString *)url withID:(NSString *)ID complete:(finishedBlock)finishedBlock
{
    _ID = ID;
    //block对象赋值,成员变量
    _finishedBlock = finishedBlock;
    
    //定义一个请求对象
    //不使用缓存 超时时间设定为60秒
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:600];
    
    //设置http的连接方式
    //GET:参数显示在连接地址上,只能获取数据
    //POST:参数不显示在连接的地址上,可以获取数据也可以上传数据
    //PUSH:与POST类似
    //DELETE:删除数据时使用,不常用
    [request setHTTPMethod:@"GET"];
    
    //开始数据下载
    _connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}
//获取应答
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    _data = [[NSMutableData alloc] init];
}
//获取数据
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_data appendData:data];
    if ([_ID isEqualToString:@"music"]) {
        if (_data) {
            //使用block函数块将数据回传给使用者
            _finishedBlock(_data, _ID);
        }
    }
}
//数据下载成功
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (_data) {
        //使用block函数块将数据回传给使用者
        _finishedBlock(_data, _ID);
    }
}



@end
