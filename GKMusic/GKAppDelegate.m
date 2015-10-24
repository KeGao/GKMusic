//
//  GKAppDelegate.m
//  GKMusic
//
//  Created by qianfeng on 14-9-23.
//  Copyright (c) 2014年 gao. All rights reserved.
//

#import "GKAppDelegate.h"
//#import "GKLaunchViewController.h"
#import "GKMainViewController.h"
#import "GKMusicLibraryViewController.h"
#import "GKPlayBoxViewController.h"
#import <AVFoundation/AVFoundation.h>

@implementation GKAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //设置顶部状态栏风格
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
//    GKLaunchViewController *vcLaunch = [[GKLaunchViewController alloc] init];
//    self.window.rootViewController = vcLaunch;
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];

    //初始化UI框架
    GKMainScrollViewController *mainScrollVC = [[GKMainScrollViewController alloc] init];
    self.window.rootViewController = mainScrollVC;
    
    
    //创建默认出现的前两个view
    GKMainViewController *mainVC = [[GKMainViewController alloc] init];
    GKMusicLibraryViewController *secVC = [[GKMusicLibraryViewController alloc] init];
    secVC.title = @"乐库";
    [mainScrollVC initViewControllerWithMain:mainVC andSecondary:secVC];
    
    _launchView  = [[UIImageView alloc] initWithFrame:self.window.bounds];
    _launchView.image = [UIImage imageNamed:@"LaunchImage-700-568h"];
    _launchView.alpha = 1;
    [self.window addSubview:_launchView];
    [self.window bringSubviewToFront:_launchView];
    
    [UIView animateWithDuration:1 delay:1 options:UIViewAnimationOptionTransitionNone animations:^{
        _launchView.frame = CGRectMake(-80, -140, self.window.bounds.size.width+160, self.window.bounds.size.height+320); //最终位置
        _launchView.alpha = 0;
    } completion:^(BOOL finished) {
        [_launchView removeFromSuperview];
    }];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    
    // 设置音频会话类型
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setActive:YES error:nil];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [self becomeFirstResponder];
    taskID = [application beginBackgroundTaskWithExpirationHandler:nil];//模拟机可以后台 (在真机上不行)
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
    [self resignFirstResponder];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    [application endBackgroundTask:taskID];
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (BOOL)canResignFirstResponder
{
    return YES;
}

- (void)remoteControlReceivedWithEvent:(UIEvent *)event
{
    NSLog(@"remoteControlReceivedWithEvent");
    GKPlayBoxViewController *pbVC = [GKPlayBoxViewController shared];
    if (event.type == UIEventTypeRemoteControl) {
        switch (event.subtype) {
            case UIEventSubtypeRemoteControlPlay:
                [pbVC play];
                break;
            case UIEventSubtypeRemoteControlPause:
                [pbVC play];
                break;
            case UIEventSubtypeRemoteControlStop:
                [pbVC stop];
                break;
            case UIEventSubtypeRemoteControlPreviousTrack:
                [pbVC rewind];
                break;
            case UIEventSubtypeRemoteControlNextTrack:
                [pbVC fastForward];
                break;
            default:
                break;
        }
    }
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
