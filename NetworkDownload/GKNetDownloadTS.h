//
//  GKNetDownloadTS.h
//  iCartoom爱动漫
//
//  Created by qianfeng on 14-9-15.
//  Copyright (c) 2014年 gao. All rights reserved.
//

#import <Foundation/Foundation.h>

//定义一个block类型
//参数一:下载后的数据返回值
//参数二:区分用
typedef void(^finishedBlock) (NSData *data, NSString *ID);

//下载数据类
@interface GKNetDownloadTS : NSObject
<NSURLConnectionDelegate,NSURLConnectionDataDelegate>
{
    //定义一个块对象,用于下载后的数据返回
    finishedBlock _finishedBlock;
    //下载对象
    NSURLConnection *_connection;
    //数据
    NSMutableData *_data;
    
    NSString *_ID;
}

//下载函数
- (void)downloadURL:(NSString *)url withID:(NSString *)ID complete:(finishedBlock)finishedBlock;

@end
