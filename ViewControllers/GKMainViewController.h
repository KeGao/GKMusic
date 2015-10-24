//
//  GKMainViewController.h
//  GKMusic
//
//  Created by qianfeng on 14-9-24.
//  Copyright (c) 2014年 gao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GKMainViewController : UIViewController
<UITextFieldDelegate,UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *hpScrollV;
@property (weak, nonatomic) IBOutlet UITextField *SearchTF;
@property (weak, nonatomic) IBOutlet UIView *viewTopR;
@property (weak, nonatomic) IBOutlet UIView *viewMidR;
@property (weak, nonatomic) IBOutlet UIView *viewBottomR;
@property (weak, nonatomic) IBOutlet UIView *viewTopL;
@property (weak, nonatomic) IBOutlet UIView *viewBottomL;
@property (weak, nonatomic) IBOutlet UIButton *btnLocalMusic;
@property (weak, nonatomic) IBOutlet UILabel *musicCountLB;
@property (weak, nonatomic) IBOutlet UIButton *btnMyLike;
@property (weak, nonatomic) IBOutlet UIButton *btnMyMusicList;
@property (weak, nonatomic) IBOutlet UIButton *btnDownloadMngmt;
@property (weak, nonatomic) IBOutlet UIButton *btnRecentPlay;
@property (weak, nonatomic) IBOutlet UIButton *btnMusicLibrary;
@property (weak, nonatomic) IBOutlet UIButton *btnSinger;
@property (weak, nonatomic) IBOutlet UIButton *btnMV;
@property (weak, nonatomic) IBOutlet UIButton *btnNearby;
@property (weak, nonatomic) IBOutlet UIButton *btnMore;

- (IBAction)pressLocalMusic:(UIButton *)sender;
- (IBAction)pressMyLike:(UIButton *)sender;
- (IBAction)pressMyMusicList:(UIButton *)sender;
- (IBAction)pressDownloadMngmt:(UIButton *)sender;
- (IBAction)pressRecentPlay:(UIButton *)sender;
- (IBAction)pressMusicLibrary:(UIButton *)sender;
- (IBAction)pressSinger:(UIButton *)sender;
- (IBAction)pressMV:(UIButton *)sender;
- (IBAction)pressNearby:(UIButton *)sender;
- (IBAction)pressMore:(UIButton *)sender;

- (IBAction)pressSetting:(UIButton *)sender;
- (IBAction)pressBack:(UIButton *)sender;

@end
