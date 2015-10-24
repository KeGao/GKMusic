//
//  GKWaitingAnimationView.m
//  GKMusic
//
//  Created by Gao on 14-10-29.
//  Copyright (c) 2014年 gao. All rights reserved.
//

#import "GKWaitingAnimationView.h"

@implementation GKWaitingAnimationView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
    }
    return self;
}

- (void)show
{
    if (_imagesPath) {
        //单例方法,创建管理文件的单例方法
        NSFileManager *fm = [NSFileManager defaultManager];
        //深度遍历(会去遍历当前目录下的子目录里的文件)
        NSArray *array = [fm subpathsOfDirectoryAtPath:_imagesPath error:nil];
        NSMutableArray *images = [[NSMutableArray alloc] init];
        NSString *strFullPath = nil;
        for (NSString *str in array) {
            if ([str hasSuffix:@"png"]) {
                strFullPath = [NSString stringWithFormat:@"%@/%@",_imagesPath,str];
                NSData *data = [NSData dataWithContentsOfFile:strFullPath];
                UIImage *image = [[UIImage alloc] initWithData:data];
                [images addObject:image];
            }
        }
        NSLog(@"count = %d",images.count);
        if (images.count != 0) {
            self.animationImages = images;
            self.animationDuration = _velocity;
            [self startAnimating];
        }
    }
}

- (void)hide
{
    [self stopAnimating];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
