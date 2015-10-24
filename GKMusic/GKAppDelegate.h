//
//  GKAppDelegate.h
//  GKMusic
//
//  Created by qianfeng on 14-9-23.
//  Copyright (c) 2014年 gao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GKAppDelegate : UIResponder <UIApplicationDelegate>
{
    UIBackgroundTaskIdentifier taskID;
    UIImageView *_launchView;
}

@property (strong, nonatomic) UIWindow *window;

@end
