//
//  GKMainViewController.m
//  GKMusic
//
//  Created by qianfeng on 14-9-24.
//  Copyright (c) 2014年 gao. All rights reserved.
//

#import "GKMainViewController.h"
#import "GKMusicLibraryViewController.h"
#import "GKPlayBoxViewController.h"
#import "GKSingerViewController.h"
#import "GKSettingViewController.h"
#import "GKVCMusicList.h"

#define kALPHA 0.7

@interface GKMainViewController ()
{
    UIButton *_btn;
}

@end

@implementation GKMainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    /*滚动视图*/
    _hpScrollV.backgroundColor = [UIColor clearColor];
    _hpScrollV.pagingEnabled = YES;
    _hpScrollV.showsHorizontalScrollIndicator = NO;
    _hpScrollV.contentSize = CGSizeMake(_hpScrollV.frame.size.width*2, _hpScrollV.frame.size.height);
    [_hpScrollV scrollRectToVisible:CGRectMake(_hpScrollV.frame.size.width, 0, self.view.frame.size.width, _hpScrollV.frame.size.height) animated:NO];
    _hpScrollV.delegate = self;
    
    /*搜索栏*/
    UIImage *image = [UIImage imageNamed:@"homePage_searchbg_normal.png"];
    image = [image stretchableImageWithLeftCapWidth:image.size.width * 0.5 topCapHeight:image.size.height * 0.5];
    _SearchTF.background = image;
    _SearchTF.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 50)];
    _SearchTF.leftViewMode = UITextFieldViewModeAlways;
    _SearchTF.rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 35, 50)];
    UIImageView *sIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"homePage_searchIcon.png"]];
    sIV.frame = CGRectMake(0, 15, 20, 20);
    [_SearchTF.rightView addSubview:sIV];
    _SearchTF.rightViewMode = UITextFieldViewModeAlways;
    _SearchTF.delegate = self;
    
    /*选项栏背景*/
    _viewTopR.layer.cornerRadius = 3;
    _viewMidR.layer.cornerRadius = 3;
    _viewBottomR.layer.cornerRadius = 3;
    _viewTopL.layer.cornerRadius = 3;
    _viewBottomL.layer.cornerRadius = 3;
    
    //取消第一响应事件按钮
    _btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _btn.frame = self.view.bounds;
    [_btn addTarget:self action:@selector(pressBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btn];
    _btn.hidden = YES;
    
    //获取歌曲数量
    GKPlayBoxViewController *pbVC = [GKPlayBoxViewController shared];
    [pbVC readData];
    _musicCountLB.text = pbVC.songsCount;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    _btn.hidden = NO;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    _btn.hidden = YES;
}

- (void)pressBtn
{
    [_SearchTF resignFirstResponder];
}


- (IBAction)pressLocalMusic:(UIButton *)sender {
    
    GKVCMusicList *vcList = [[GKVCMusicList alloc] init];
    vcList.title = @"我的歌单";
//    vcList.arrData = _arraySongs;
    [[GKMainScrollViewController getMain] addVCBehindSuper:self withSub:vcList];
    
//    GKTestVC *testVC = [[GKTestVC alloc] init];
//    testVC.title = @"本地音乐";
//    [[GKMainScrollViewController getMain] addVCBehindSuper:self withSub:testVC];
}

- (IBAction)pressMyLike:(UIButton *)sender {
    NSLog(@"my like!");
}

- (IBAction)pressMyMusicList:(UIButton *)sender {
    NSLog(@"my list!");
    
    GKVCMusicList *vcList = [[GKVCMusicList alloc] init];
    vcList.title = @"我的歌单";
    //    vcList.arrData = _arraySongs;
    [[GKMainScrollViewController getMain] addVCBehindSuper:self withSub:vcList];
}

- (IBAction)pressDownloadMngmt:(UIButton *)sender {
}

- (IBAction)pressRecentPlay:(UIButton *)sender {
}

- (IBAction)pressMusicLibrary:(UIButton *)sender {
    
    GKMusicLibraryViewController *listVC = [[GKMusicLibraryViewController alloc] init];
    listVC.title = @"乐库";
    [[GKMainScrollViewController getMain] addVCBehindSuper:self withSub:listVC];
}

- (IBAction)pressSinger:(UIButton *)sender {
    
    GKSingerViewController *singerVC = [[GKSingerViewController alloc] init];
    singerVC.title = @"歌手";
    [[GKMainScrollViewController getMain] addVCBehindSuper:self withSub:singerVC];
}

- (IBAction)pressMV:(UIButton *)sender {
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"此功能暂未开放,敬请期待!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alertView show];
}

- (IBAction)pressNearby:(UIButton *)sender {
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"此功能暂未开放,敬请期待!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alertView show];
}

- (IBAction)pressMore:(UIButton *)sender {
    [_hpScrollV scrollRectToVisible:CGRectMake(0, 0, self.view.frame.size.width, _hpScrollV.frame.size.height) animated:YES];
}

- (IBAction)pressSetting:(UIButton *)sender {
    
    [[GKMainScrollViewController getMain] hiddenMusicBottomBar:YES];
    GKSettingViewController *setVC = [[GKSettingViewController alloc] init];
    setVC.title = @"设置";
    [[GKMainScrollViewController getMain] addVCBehindSuper:self withSub:setVC];
}

- (IBAction)pressBack:(UIButton *)sender {
    [_hpScrollV scrollRectToVisible:CGRectMake(_hpScrollV.frame.size.width, 0, self.view.frame.size.width, _hpScrollV.frame.size.height) animated:YES];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
