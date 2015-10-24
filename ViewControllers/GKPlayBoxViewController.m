//
//  GKPlayBoxViewController.m
//  GKMusic
//
//  Created by qianfeng on 14-9-26.
//  Copyright (c) 2014年 gao. All rights reserved.
//

#import "GKPlayBoxViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "MMProgressHUD.h"
#import "LyricsManage.h"
#import "LyricsAndTime.h"
#import "CONST.h"

@interface GKPlayBoxViewController ()

@end

@implementation GKPlayBoxViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        _index = 0;
        _modelIndex = 0;
    }
    return self;
}

+(id)shared
{
    static GKPlayBoxViewController* _sington=nil;
    if (_sington==nil) {
        _sington=[[GKPlayBoxViewController alloc] init];
        [[UIApplication sharedApplication].keyWindow addSubview:_sington.view];
        _sington.view.Frame = CGRectMake(0, 0, 320, 568);
        _sington.view.transform = CGAffineTransformMakeRotation(M_PI/5.5);
    }
    return _sington;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.view setBackgroundColor:[UIColor clearColor]];
    UIImageView *imageBgV = [[UIImageView alloc] initWithFrame:self.view.bounds];
    [imageBgV setImage:[UIImage imageNamed:@"skinBackImage_1.jpg"]];
    [self.view addSubview:imageBgV];
    
    /*创建自定义导航栏*/
    UIView *navView = [[GKMainScrollViewController getMain] createCustomNavigationBarWithTitle:nil];
    navView.backgroundColor = [UIColor clearColor];
    
    /*创建导航栏按钮*/
    UIButton *lbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [lbtn setFrame:CGRectMake(10, 27, 30, 30)];
    [lbtn setImage:[UIImage imageNamed:@"top_back.png"] forState:UIControlStateNormal];
    [lbtn addTarget:self action:@selector(pressBack) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:lbtn];
    
    UIButton *rbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rbtn setFrame:CGRectMake(280, 27, 30, 30)];
    [rbtn setImage:[UIImage imageNamed:@"top_search.png"] forState:UIControlStateNormal];
    [rbtn addTarget:self action:@selector(pressList) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:rbtn];
    
    [self.view addSubview:navView];

    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognizer:)];
    panGestureRecognizer.delegate = self;
    
    [self.view addGestureRecognizer:panGestureRecognizer];
    
    //设置旋转中心锚点
    self.view.layer.anchorPoint = CGPointMake(0.5, 2);

    _backLeft = NO;
    
    _labelSong = [[UILabel alloc] initWithFrame:CGRectMake(55, 75, 210, 40)];
    _labelSong.textAlignment = NSTextAlignmentCenter;
    _labelSong.text = @"歌名";
    _labelSong.font = [UIFont systemFontOfSize:17];
    [self.view addSubview:_labelSong];
    
    _labelSinger = [[UILabel alloc] initWithFrame:CGRectMake(60, 110, 200, 40)];
    _labelSinger.textAlignment = NSTextAlignmentCenter;
    _labelSinger.text = @"歌手";
    _labelSinger.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:_labelSinger];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 200, 60, 40)];
    label.text = @"进度条:";
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:label];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 300, 60, 40)];
    label1.text = @"音量:";
    label1.textAlignment = NSTextAlignmentCenter;
    label1.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:label1];
    
    _label2 = [[UILabel alloc] initWithFrame:CGRectMake(40, 170, 80, 30)];
    _label2.textAlignment = NSTextAlignmentCenter;
    _label2.font = [UIFont systemFontOfSize:14];
    _label2.text = @"00:00";
    [self.view addSubview:_label2];
    
    _label3 = [[UILabel alloc] initWithFrame:CGRectMake(120, 270, 80, 30)];
    _label3.textAlignment = NSTextAlignmentCenter;
    _label3.font = [UIFont systemFontOfSize:14];
    _label3.text = @"10";
    [self.view addSubview:_label3];
    
    _label4 = [[UILabel alloc] initWithFrame:CGRectMake(260, 170, 60, 30)];
    _label4.textAlignment = NSTextAlignmentCenter;
    _label4.font = [UIFont systemFontOfSize:14];
    _label4.text = @"00:00";
    [self.view addSubview:_label4];
    
    _lyricsLB = [[UILabel alloc] initWithFrame:CGRectMake(20, 360, 280, 100)];
    _lyricsLB.textAlignment = NSTextAlignmentCenter;
    _lyricsLB.font = [UIFont systemFontOfSize:26];
    _lyricsLB.numberOfLines = 0;
    [self.view addSubview:_lyricsLB];
    
    _sliderProgress = [[UISlider alloc] initWithFrame:CGRectMake(60, 200, 250, 40)];
    // 回调与事件
    [_sliderProgress addTarget:self action:@selector(startDrag:) forControlEvents:UIControlEventTouchDown];
    [_sliderProgress addTarget:self action:@selector(endDrag:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
    [_sliderProgress addTarget:self action:@selector(progressChange:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_sliderProgress];
    
    _sliderVolume = [[UISlider alloc] initWithFrame:CGRectMake(60, 300, 250, 40)];
    [_sliderVolume addTarget:self action:@selector(volumeChange:) forControlEvents:UIControlEventValueChanged];
    _sliderVolume.value = 1;
    [self.view addSubview:_sliderVolume];
    
    _toolBar = [[UIToolbar alloc] init];
    _toolBar.frame = CGRectMake(0, 524, 320, 44);
    [self.view addSubview:_toolBar];
    
    _btnPlay = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPlay target:self action:@selector(play)];
    
    _btnPause = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPause target:self action:@selector(play)];
    
    _btnStop = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(stop)];
    
    _btnRewind = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRewind target:self action:@selector(rewind)];
    
    _btnFastForward = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFastForward target:self action:@selector(fastForward)];
    
    _arrayModels = [NSArray arrayWithObjects:@"列表循环",@"顺序播放",@"单曲循环",@"单曲播放",@"随机播放", nil];
    _btnModel = [[UIBarButtonItem alloc] initWithTitle:_arrayModels[_modelIndex] style:UIBarButtonItemStyleBordered target:self action:@selector(modelChange)];
    
    _btnSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    NSArray *arrayItems = [NSArray arrayWithObjects:_btnModel,_btnSpace,_btnRewind,_btnSpace,_btnPlay,_btnSpace,_btnFastForward,_btnSpace,_btnStop,_btnSpace, nil];
    _toolBar.items = arrayItems;
    
    _isPlay = NO;
    _isRandom = NO;
    _isNext = YES;
    _haveMusic = NO;
    _haveLyrics = NO;
    
//    [self readData];
}

//从本地读取全部歌曲
- (void)readData
{
    _arraySongs = [[NSMutableArray alloc] init];
    _arraySingers = [[NSMutableArray alloc] init];
    
    //单例方法,创建管理文件的单例方法
    NSFileManager *fm = [NSFileManager defaultManager];
    
    //    NSString *path = [NSHomeDirectory() stringByAppendingString:@"/GKMusic.app"];
    //深度遍历(会去遍历当前目录下的子目录里的文件)
    NSArray *array = [fm subpathsOfDirectoryAtPath:PATH error:nil];
    //    NSLog(@"%@",array);
    for (NSString *str in array) {
        if ([str hasSuffix:@"mp3"]) {
            NSString *str2 = [str substringToIndex:[str rangeOfString:@".mp3"].location];
            //            NSString *string = [str2 substringFromIndex:[str2 rangeOfString:@"/"].location+1];
            NSString *string = str2;
            NSString *singer = nil;
            NSString *song = nil;
            if ([string rangeOfString:@"-"].length>0) {
                singer = [string substringToIndex:[string rangeOfString:@"-"].location-1];
                song = [string substringFromIndex:[string rangeOfString:@"-"].location+2];
            }
            else {
                singer = @"unknown";
                song = string;
            }
            [_arraySingers addObject:singer];
            [_arraySongs addObject:song];
        }
    }
    _songsCount = [NSString stringWithFormat:@"(%d首)",_arraySongs.count];
    if (_arraySongs.count > 0) {
        _haveMusic = YES;
        _index = 0;
        [self readMusic];
    }
}

//读取指定歌曲
- (void)readMusic
{
    _labelSong.text = _arraySongs[_index];
    _labelSinger.text = _arraySingers[_index];
    
    [self loadLyrics];//读取歌词
    
    [GKMainScrollViewController getMain].labelSong.text = _labelSong.text;
    [GKMainScrollViewController getMain].labelSinger.text = _labelSinger.text;
    
    NSString *str = [NSString stringWithFormat:@"%@ - %@",_arraySingers[_index],_arraySongs[_index]];
    NSString *strPath = [NSString stringWithFormat:@"%@/%@.mp3",PATH,str];
    NSData *data = [NSData dataWithContentsOfFile:strPath];
    _audioPlayer = [[AVAudioPlayer alloc] initWithData:data error:nil];
    _audioPlayer.delegate = self;
    
    float duration = _audioPlayer.duration;
    int min = duration/60;
    int sec = duration - min*60;
    _label4.text = [NSString stringWithFormat:@"%02d:%02d",min,sec];
    
    BOOL isReady = [_audioPlayer prepareToPlay];
    NSLog(@"isReady = %d",isReady);
    if (!isReady) {
        if (_isNext) {
            [self fastForward];
        }
        else {
            [self rewind];
        }
    }
    
    // 在锁屏界面显示歌曲信息
    [self showInfoInLockedScreen];
}

/**
 *  在锁屏界面显示歌曲信息
 */
- (void)showInfoInLockedScreen
{
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    // 标题(音乐名称)
    info[MPMediaItemPropertyTitle] = _labelSong.text;
    
    // 作者
    info[MPMediaItemPropertyArtist] = _labelSinger.text;
    
    // 专辑
    info[MPMediaItemPropertyAlbumTitle] = _labelSinger.text;
    
    // 图片
    info[MPMediaItemPropertyArtwork] = [[MPMediaItemArtwork alloc] initWithImage:[UIImage imageNamed:@"CollectDetailPage_NoBackground.jpg"]];
    
    [MPNowPlayingInfoCenter defaultCenter].nowPlayingInfo = info;
}

- (void)loadLyrics
{
    NSString *path = [[NSBundle mainBundle] pathForResource:_labelSong.text ofType:@"lrc"];
    
    if (path) {
        _lrc = [[LyricsManage alloc] init];
        _lrc.path = path;
        [_lrc readFile];
        [_lrc sort];
        
        _lyricsLB.text = _lrc.str;
        _lyricsLB.textColor = [UIColor greenColor];

        _haveLyrics = YES;
    } else {
        _lyricsLB.text = @"暂未找到歌词";
        _lyricsLB.textColor = [UIColor blackColor];
        
        _haveLyrics = NO;
    }
}

- (void)updateLyrics:(NSTimer *)timer
{
    if (index < _lrc.arr.count) {
        float x = [[_lrc.arr[index] myTime] intValue]*60 + [[[_lrc.arr[index] myTime] substringFromIndex:3] floatValue];
        if (_audioPlayer.currentTime >= x) {
            _lyricsLB.text = [_lrc.arr[index] lyric];
            _lyricsLB.textColor = [UIColor greenColor];
            index++;
        }
    }
    if (index == _lrc.arr.count) {
        _lyricsLB.textColor = [UIColor redColor];
    }
}

- (void)lyricsPlay
{
    if (_timer == nil) {
        index = 0;
        _timer = [NSTimer timerWithTimeInterval:0.1 target:self selector:@selector(updateLyrics:) userInfo:nil repeats:YES];
        NSRunLoop *runloop=[NSRunLoop currentRunLoop];
        [runloop addTimer:_timer forMode:NSRunLoopCommonModes];
    }
    else {
        //开启定时器
        [_timer setFireDate:[NSDate distantPast]];
    }
}

 -(void)lyricsPause
{
    //关闭定时器
    [_timer setFireDate:[NSDate distantFuture]];
}

- (void)lyricsStop
{
    [_timer invalidate];
    _timer = nil;
    _lyricsLB.text = _lrc.str;
    _lyricsLB.textColor = [UIColor greenColor];
}

//播放/暂停 按钮
- (void)play
{
    if (!_haveMusic) {
        return;
    }
    [[GKMainScrollViewController getMain] changeBarButton];
    if (!_isPlay) {
        if (_haveLyrics) {
            [self lyricsPlay];
        }

        [_audioPlayer play];
        _isPlay = YES;
        
        NSArray *arrayItems = [NSArray arrayWithObjects:_btnModel,_btnSpace,_btnRewind,_btnSpace,_btnPause,_btnSpace,_btnFastForward,_btnSpace,_btnStop,_btnSpace, nil];
        _toolBar.items = arrayItems;
        
        [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(updateTimer:) userInfo:nil repeats:YES];
    }
    else {
        if (_haveLyrics) {
            [self lyricsPause];
        }
 
        [_audioPlayer pause];
        _isPlay = NO;
        
        NSArray *arrayItems = [NSArray arrayWithObjects:_btnModel,_btnSpace,_btnRewind,_btnSpace,_btnPlay,_btnSpace,_btnFastForward,_btnSpace,_btnStop,_btnSpace, nil];
        _toolBar.items = arrayItems;
    }
}
//停止按钮
- (void)stop
{
    if (!_haveMusic) {
        return;
    }
    if (_haveLyrics) {
        [self lyricsStop];
    }
    _isPlay = YES;
    [[GKMainScrollViewController getMain] changeBarButton];
    NSArray *arrayItems = [NSArray arrayWithObjects:_btnModel,_btnSpace,_btnRewind,_btnSpace,_btnPlay,_btnSpace,_btnFastForward,_btnSpace,_btnStop,_btnSpace, nil];
    _toolBar.items = arrayItems;
    
    [_audioPlayer stop];
    _isPlay = NO;
    _label2.text = @"00:00";
    _audioPlayer.currentTime = 0;
    _sliderProgress.value = 0;
}
//上一曲
- (void)rewind
{
    if (!_haveMusic) {
        return;
    }
    _isNext = NO;
    _index--;
    if (_index < 0) {
        _index = _arraySongs.count-1;
    }
    BOOL c = _isPlay;
    [self stop];
    [self readMusic];
    if (c) {
        [self play];
    }
}
//下一曲
- (void)fastForward
{
    if (!_haveMusic) {
        return;
    }
    _isNext = YES;
    if (_isRandom) {
        _index = arc4random()%_arraySongs.count;
        BOOL c = _isPlay;
        [self stop];
        [self readMusic];
        if (c) {
            [self play];
        }
    }
    else {
        _index++;
        if (_index == _arraySongs.count) {
            _index = 0;
        }
        BOOL c = _isPlay;
        [self stop];
        [self readMusic];
        if (c) {
            [self play];
        }
    }
}
//刷新进度条
- (void)updateTimer:(NSTimer *)timer
{
    if (!_isPlay) {
        [timer invalidate];
        timer = nil;
    }
    float progress = _audioPlayer.currentTime;
    float duration = _audioPlayer.duration;
    
    float value = progress/duration;
    
    _sliderProgress.value = value;
    [GKMainScrollViewController getMain].progressView.progress = value;
    
    int min = progress/60;
    int sec = progress - min*60;
    
    _label2.text = [NSString stringWithFormat:@"%02d:%02d",min,sec];
}

// 开始
- (void) startDrag:(UISlider *)slider
{

}

//结束
- (void) endDrag:(UISlider *)slider
{
    if (_haveLyrics) {
        for (int i = 0; i < _lrc.arr.count-1; i++) {
            float x = [[_lrc.arr[i] myTime] intValue]*60 + [[[_lrc.arr[i] myTime] substringFromIndex:3] floatValue];
            float y = [[_lrc.arr[i+1] myTime] intValue]*60 + [[[_lrc.arr[i+1] myTime] substringFromIndex:3] floatValue];
            if (_audioPlayer.currentTime >= x && _audioPlayer.currentTime < y) {
                index = i;
            }
            else if (_audioPlayer.currentTime >= y) {
                index = i + 1;
            }
        }
    }
}

//滑动进度条
- (void)progressChange:(UISlider *)slider
{
    if (!_haveMusic) {
        return;
    }
    _audioPlayer.currentTime = slider.value*_audioPlayer.duration;
}
//滑动音量条
- (void)volumeChange:(UISlider *)slider
{
    _audioPlayer.volume = slider.value;
    int value = 0;
    if (_audioPlayer.volume != 0) {
        if (_audioPlayer.volume != 1) {
            value = _audioPlayer.volume*10+1;
        }
        else {
            value = 10;
        }
    }
    _label3.text = [NSString stringWithFormat:@"%d",value];
}
//切换播放模式
- (void)modelChange
{
    _modelIndex++;
    if (_modelIndex == _arrayModels.count) {
        _modelIndex = 0;
    }
    _isRandom = NO;
    if (_modelIndex == 4) {
        _isRandom = YES;
    }
    _btnModel.title = _arrayModels[_modelIndex];
    [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleShrink];
    [MMProgressHUD showWithStatus:_btnModel.title];
    [MMProgressHUD dismissWithSuccess:nil];
}

//列表循环
- (void)model01
{
    [self fastForward];
}
//顺序播放
- (void)model02
{
    if (_index == _arraySongs.count-1) {
        [self stop];
    }
    else {
        [self fastForward];
    }
}
//单曲循环
- (void)model03
{
    [self stop];
    [self play];
}
//单曲播放
- (void)model04
{
    [self stop];
}
//随机播放
- (void)model05
{
    [self fastForward];
}

#pragma mark - AVAudioPlayerDelegate

//一曲放完结束后
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    switch (_modelIndex) {
        case 0:[self model01];return;
        case 1:[self model02];return;
        case 2:[self model03];return;
        case 3:[self model04];return;
        case 4:[self model05];return;
    }
}

/**
 *  音乐播放器被打断(打\接电话)
 */
- (void)audioPlayerBeginInterruption:(AVAudioPlayer *)player
{
    NSLog(@"audioPlayerBeginInterruption---被打断");
}

/**
 *  音乐播放器停止打断(打\接电话)
 */
- (void)audioPlayerEndInterruption:(AVAudioPlayer *)player withOptions:(NSUInteger)flags
{
    NSLog(@"audioPlayerEndInterruption---停止打断");
    [player play];
}


//直接收回页面
- (void)pressBack
{
    [UIView animateWithDuration:0.3 animations:^
     {
         if (_backLeft) {
             self.view.transform = CGAffineTransformMakeRotation(-M_PI/5.5);
         }else {
             self.view.transform = CGAffineTransformMakeRotation(M_PI/5.5);
         }
     } completion:^(BOOL finished) {
     }];
}

- (void)pressList
{

}

- (void)panGestureRecognizer:(UIPanGestureRecognizer *)recoginzer
{
    CGPoint touchPoint = [recoginzer locationInView:[[UIApplication sharedApplication] keyWindow]];
    
    if (recoginzer.state == UIGestureRecognizerStateBegan)
    {
        _isMoving = YES;
        _startTouch = touchPoint;
        
    }else if (recoginzer.state == UIGestureRecognizerStateEnded)
    {
        //横向滑动速度
        CGFloat xVelocity = [recoginzer velocityInView: [[recoginzer view] superview]].x;
        if (touchPoint.x - _startTouch.x > 180||xVelocity > 1000)
        {
            [UIView animateWithDuration:0.2 animations:^{
                self.view.transform = CGAffineTransformMakeRotation(M_PI/5.5);
            } completion:^(BOOL finished) {
                _isMoving = NO;
                _backLeft = NO;
            }];
        }else if (touchPoint.x - _startTouch.x < -180||xVelocity < -1000)
        {
            [UIView animateWithDuration:0.2 animations:^{
                self.view.transform = CGAffineTransformMakeRotation(-M_PI/5.5);
            } completion:^(BOOL finished) {
                _isMoving = NO;
                _backLeft = YES;
            }];
        }else
        {
            [UIView animateWithDuration:0.2 animations:^
             {
                 self.view.transform = CGAffineTransformIdentity;
             } completion:^(BOOL finished) {
                 _isMoving = NO;
             }];
            
        }
        return;
    }else if (recoginzer.state == UIGestureRecognizerStateCancelled)
    {
        [UIView animateWithDuration:0.2 animations:^{
            self.view.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            _isMoving = NO;
        }];
        return;
    }
    if (_isMoving)
        [self moveViewWithX:touchPoint.x - _startTouch.x];
}

- (void)moveViewWithX:(float)x
{
    double r = M_PI/6 * (x/320);
    self.view.transform = CGAffineTransformMakeRotation(r);
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
