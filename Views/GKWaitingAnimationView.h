//
//  GKWaitingAnimationView.h
//  GKMusic
//
//  Created by Gao on 14-10-29.
//  Copyright (c) 2014年 gao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GKWaitingAnimationView : UIImageView

@property (retain, nonatomic) NSString *imagesPath;
@property (assign, nonatomic) CGFloat velocity;

- (void)show;
- (void)hide;

@end
