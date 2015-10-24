//
//  GKTestVC.h
//  GKMusic
//
//  Created by qianfeng on 14-9-28.
//  Copyright (c) 2014年 gao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface GKTestVC : UIViewController
<AVAudioPlayerDelegate>
{
    //创建对象
    AVAudioPlayer *_audioPlayer;
    
    BOOL _isPlay;
    
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
    
    UILabel *_labelSong;
    UILabel *_labelSinger;
    
    NSMutableArray *_arraySongs;
    NSMutableArray *_arraySingers;
    
    NSArray *_arrayModels;
    
    NSInteger _index;
    
    NSInteger _modelIndex;
    
    BOOL _isRandom;
    
    BOOL _isNext;
    
    UIToolbar *_toolBar;
}

@end
