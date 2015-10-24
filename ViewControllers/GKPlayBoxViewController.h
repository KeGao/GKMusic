//
//  GKPlayBoxViewController.h
//  GKMusic
//
//  Created by qianfeng on 14-9-26.
//  Copyright (c) 2014年 gao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
@class LyricsManage;

/**
 *  播放页面
 *  支持手势的旋转动画
 */
@interface GKPlayBoxViewController : UIViewController<
UIGestureRecognizerDelegate,AVAudioPlayerDelegate>
{
    CGPoint _startTouch;
    
    BOOL _backLeft;
    
    //创建对象
    AVAudioPlayer *_audioPlayer;
    
    //调节音量
    UISlider *_sliderVolume;
    //调节进度
    UISlider *_sliderProgress;
    
    UIBarButtonItem *_btnPlay;
    
    UIBarButtonItem *_btnPause;
    
    UIBarButtonItem *_btnStop;
    
    UIBarButtonItem *_btnFastForward;
    
    UIBarButtonItem *_btnRewind;
    
    UIBarButtonItem *_btnSpace;
    
    UIBarButtonItem *_btnModel;
    
    UILabel *_label2;
    
    UILabel *_label3;
    
    UILabel *_label4;
    
    UILabel *_lyricsLB;
    
    NSArray *_arrayModels;

    NSInteger _modelIndex;
    
    BOOL _isRandom;
    
    BOOL _isNext;
    
    BOOL _haveMusic;
    
    BOOL _haveLyrics;
    
    UIToolbar *_toolBar;
    
    LyricsManage *_lrc;
    
    NSTimer *_timer;
    
    int index;
}

@property (nonatomic,assign) BOOL isMoving;
@property (nonatomic,retain) UILabel *labelSong;
@property (nonatomic,retain) UILabel *labelSinger;
@property (nonatomic,retain) NSMutableArray *arraySongs;
@property (nonatomic,retain) NSMutableArray *arraySingers;
@property (nonatomic,assign) NSInteger index;
@property (nonatomic,retain) NSString *songsCount;
@property (nonatomic,assign) BOOL isPlay;

+(id)shared;
- (void)readMusic;
- (void)readData;
- (void)stop;
- (void)play;
- (void)rewind;
- (void)fastForward;

@end
