//
//  GKMainScrollViewController.h
//  GKMusic
//
//  Created by qianfeng on 14-9-26.
//  Copyright (c) 2014年 gao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GKMainViewController.h"

/**
 *  类似的UI框架及UI功能
 */
@interface GKMainScrollViewController : UIViewController <UIGestureRecognizerDelegate>

//获得主滚动视图控制器
+ (GKMainScrollViewController *)getMain;
+ (GKMainViewController *)getHomePage;

//初始化添加两个界面(主界面和乐库界面)
- (void)initViewControllerWithMain:(UIViewController *)mainVC andSecondary:(UIViewController *)secVC;

//在主控制器后面添加view (私有方法)
//- (void)addViewControllerToMain:(UIViewController *)viewController;

//删除superView后面所有的视图,添加上view
- (void)addVCBehindSuper:(UIViewController *)superVC withSub:(UIViewController *)subVC;

//返回到上一个view
- (void)backView:(UIViewController *)viewController;

//创建自定义导航栏
- (UIView *)createCustomNavigationBarWithTitle:(NSString *)title;

//隐藏底部音乐播放栏
- (void)hiddenMusicBottomBar:(BOOL)bHidden;

//显示音乐播放视图
- (void)showPlayBox;

//修改播放或暂停
- (void)changeBarButton;

//主视图控制器上的滚动视图
@property (retain, nonatomic) UIScrollView *scrollView;

@property (nonatomic,retain) UILabel *labelSong;
@property (nonatomic,retain) UILabel *labelSinger;
@property (nonatomic,retain) UIProgressView *progressView;
//底部音乐播放bar
@property (nonatomic,retain) UIToolbar *musicBottomBar;

@end
