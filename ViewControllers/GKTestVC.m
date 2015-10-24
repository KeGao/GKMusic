//
//  GKTestVC.m
//  GKMusic
//
//  Created by qianfeng on 14-9-28.
//  Copyright (c) 2014年 gao. All rights reserved.
//

#import "GKTestVC.h"
#import "GKVCMusicList.h"
#import "CONST.h"

@interface GKTestVC ()

@end

@implementation GKTestVC

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

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[GKMainScrollViewController getMain] hiddenMusicBottomBar:YES];
    
    [self.view setBackgroundColor:[UIColor clearColor]];
    UIImageView *imageBgV = [[UIImageView alloc] initWithFrame:self.view.bounds];
    [imageBgV setImage:[UIImage imageNamed:@"skinBackImage_1.jpg"]];
    [self.view addSubview:imageBgV];
    
    /*创建自定义导航栏*/
    UIView *navView = [[GKMainScrollViewController getMain] createCustomNavigationBarWithTitle:self.title];
    
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
    
    //通知中心
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    //向通知中心添加事件函数
    [center addObserver:self selector:@selector(changeMusic:) name:@"message" object:nil];
    
//    _arraySongs = [[NSMutableArray alloc] init];
//    _arraySingers = [[NSMutableArray alloc] init];
//    
//    //单例方法,创建管理文件的单例方法
//    NSFileManager *fm = [NSFileManager defaultManager];
//    
////    NSString *path = [NSHomeDirectory() stringByAppendingString:@"/GKMusic.app"];
//    //深度遍历(会去遍历当前目录下的子目录里的文件)
//    NSArray *array = [fm subpathsOfDirectoryAtPath:PATH error:nil];
//    //    NSLog(@"%@",array);
//    for (NSString *str in array) {
//        if ([str hasSuffix:@"mp3"]) {
//            NSString *str2 = [str substringToIndex:[str rangeOfString:@".mp3"].location];
////            NSString *string = [str2 substringFromIndex:[str2 rangeOfString:@"/"].location+1];
//            NSString *string = str2;
//            NSString *singer = nil;
//            NSString *song = nil;
//            if ([string rangeOfString:@"-"].length>0) {
//                singer = [string substringToIndex:[string rangeOfString:@"-"].location-1];
//                song = [string substringFromIndex:[string rangeOfString:@"-"].location+2];
//            }
//            else {
//                singer = @"unknown";
//                song = string;
//            }
//            [_arraySingers addObject:singer];
//            [_arraySongs addObject:song];
//        }
//    }
//    for (NSString *str in _arraySongs) {
//        NSLog(@"%@",str);
//    }
    _labelSong = [[UILabel alloc] initWithFrame:CGRectMake(55, 75, 210, 40)];
    _labelSong.textAlignment = NSTextAlignmentCenter;
    _labelSong.font = [UIFont systemFontOfSize:17];
    _labelSong.text = _arraySongs[_index];
    [self.view addSubview:_labelSong];
    
    _labelSinger = [[UILabel alloc] initWithFrame:CGRectMake(60, 110, 200, 40)];
    _labelSinger.textAlignment = NSTextAlignmentCenter;
    _labelSinger.font = [UIFont systemFontOfSize:16];
    _labelSinger.text = _arraySingers[_index];
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
    
    _sliderProgress = [[UISlider alloc] initWithFrame:CGRectMake(60, 200, 250, 40)];
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
    
    [self readMusic];
}
//本地读取歌曲
- (void)readMusic
{
    _labelSong.text = _arraySongs[_index];
    _labelSinger.text = _arraySingers[_index];
    
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
}
//播放/暂停 按钮
- (void)play
{
    if (!_isPlay) {
        [_audioPlayer play];
        _isPlay = YES;
        
        NSArray *arrayItems = [NSArray arrayWithObjects:_btnModel,_btnSpace,_btnRewind,_btnSpace,_btnPause,_btnSpace,_btnFastForward,_btnSpace,_btnStop,_btnSpace, nil];
        _toolBar.items = arrayItems;
        
        [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(updateTimer:) userInfo:nil repeats:YES];
    }
    else {
        [_audioPlayer pause];
        _isPlay = NO;
        
        NSArray *arrayItems = [NSArray arrayWithObjects:_btnModel,_btnSpace,_btnRewind,_btnSpace,_btnPlay,_btnSpace,_btnFastForward,_btnSpace,_btnStop,_btnSpace, nil];
        _toolBar.items = arrayItems;
    }
}
//停止按钮
- (void)stop
{
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
    
    int min = progress/60;
    int sec = progress - min*60;
    
    _label2.text = [NSString stringWithFormat:@"%02d:%02d",min,sec];
}
//滑动进度条
- (void)progressChange:(UISlider *)slider
{
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

- (void)pressBack
{
    [[GKMainScrollViewController getMain] backView:self];
    NSLog(@"back!");
}

- (void)pressList
{
    GKVCMusicList *vcList = [[GKVCMusicList alloc] init];
    vcList.title = @"我的歌单";
    vcList.arrData = _arraySongs;
    [[GKMainScrollViewController getMain] addVCBehindSuper:self withSub:vcList];
}

- (void)changeMusic:(NSNotification *)noti
{
    _index = [noti.object integerValue]-1;
    [self stop];
    [self readMusic];
    [self play];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
