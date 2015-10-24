//
//  GKLaunchViewController.m
//  GKMusic
//
//  Created by Gao on 15/1/13.
//  Copyright (c) 2015年 gao. All rights reserved.
//

#import "GKLaunchViewController.h"
#import "GKMainViewController.h"
#import "GKMusicLibraryViewController.h"

/* 此类没有用到(不需要自己写launchView) */
@interface GKLaunchViewController ()

@end

@implementation GKLaunchViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _launchView  = [[UIImageView alloc] initWithFrame:self.view.bounds];
    _launchView.image = [UIImage imageNamed:@"LaunchImage-700-568h"];
    _launchView.alpha = 1;
    [self.view addSubview:_launchView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [UIView animateWithDuration:0.8 animations:^{
        _launchView.frame = CGRectMake(-50, -50, self.view.bounds.size.width+100, self.view.bounds.size.height+100); //最终位置
        _launchView.alpha = 0;
        
        //进入正式内容的主视图
        [self updateRootViewController];
    }];
}

- (void)updateRootViewController
{
    //初始化UI框架
    GKMainScrollViewController *mainScrollVC = [[GKMainScrollViewController alloc] init];
    self.view.window.rootViewController = mainScrollVC;
    
    
    //创建默认出现的前两个view
    GKMainViewController *mainVC = [[GKMainViewController alloc] init];
    GKMusicLibraryViewController *secVC = [[GKMusicLibraryViewController alloc] init];
    secVC.title = @"乐库";
    [mainScrollVC initViewControllerWithMain:mainVC andSecondary:secVC];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
