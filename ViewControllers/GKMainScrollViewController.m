//
//  GKMainScrollViewController.m
//  GKMusic
//
//  Created by qianfeng on 14-9-26.
//  Copyright (c) 2014年 gao. All rights reserved.
//

#import "GKMainScrollViewController.h"
#import "GKPlayBoxViewController.h"
#import "GKMainViewController.h"

@interface GKMainScrollViewController ()<UIScrollViewDelegate>
{
    //用于存放视图控制器的数组
    NSMutableArray *_arrViewControllers;
    
//    //homepage视图
//     GKMainViewController *_mainVC;
    //乐库视图
    UIViewController *_secVC;
    
    //音乐播放界面视图控制器
    GKPlayBoxViewController *_playBoxVC;
    
    UIBarButtonItem *_btnPlay;
    
    UIBarButtonItem *_btnPause;
    
    UIBarButtonItem *_btnFastForward;
    
    UIBarButtonItem *_btnRewind;
    
    UIBarButtonItem *_btnSpace;
}

@end

@implementation GKMainScrollViewController

//创建一个静态的主视图控制器
static GKMainScrollViewController *MVC;
static GKMainViewController *_mainVC;
- (void)loadView
{
    [super loadView];
    
    //创建滚动视图
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.backgroundColor = [UIColor blackColor];
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.scrollsToTop = NO;//点击状态栏滑到顶部
    _scrollView.bounces = NO;
    _scrollView.delegate = self;
    _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    _scrollView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self.view addSubview:_scrollView];
    
    //创建音乐播放工具栏
    _musicBottomBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 58, self.view.frame.size.width, 58)];
    _musicBottomBar.backgroundColor = [UIColor whiteColor];
    _musicBottomBar.alpha = 0.9;
    [self.view addSubview:_musicBottomBar];
    //头像视图
    UIImageView *iconV = [[UIImageView alloc] initWithFrame:CGRectMake(3, 3, 52, 52)];
    iconV.image = [UIImage imageNamed:@"play_bar_singerbg.png"];
    [_musicBottomBar addSubview:iconV];
    //歌名
    _labelSong = [[UILabel alloc] initWithFrame:CGRectMake(65, 8, 160, 20)];
    _labelSong.textAlignment = NSTextAlignmentLeft;
    _labelSong.font = [UIFont systemFontOfSize:14];
    _labelSong.text = @"歌名";
    [_musicBottomBar addSubview:_labelSong];
    //歌手
    _labelSinger = [[UILabel alloc] initWithFrame:CGRectMake(65, 25, 160, 20)];
    _labelSinger.textAlignment = NSTextAlignmentLeft;
    _labelSinger.font = [UIFont systemFontOfSize:12];
    _labelSinger.textColor = [UIColor lightGrayColor];
    _labelSinger.text = @"歌手";
    [_musicBottomBar addSubview:_labelSinger];
    //进度条
    _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(65, 50, 250, 5)];
    _progressView.progressTintColor = [UIColor blueColor];
    _progressView.progress = 0;
    [_musicBottomBar addSubview:_progressView];
    
    _btnPlay = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPlay target:self action:@selector(play)];
    
    _btnPause = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPause target:self action:@selector(play)];
    
    _btnRewind = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRewind target:self action:@selector(rewind)];
    
    _btnFastForward = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFastForward target:self action:@selector(forward)];
    
    _btnSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    _btnSpace.width = 200;
    
    NSArray *arrayItems = [NSArray arrayWithObjects:_btnSpace,_btnRewind,_btnPlay,_btnFastForward, nil];
    _musicBottomBar.items = arrayItems;

    //点击事件
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] init];
    singleTap.numberOfTapsRequired = 1;
    singleTap.delegate = self;
    [singleTap addTarget:self action:@selector(showPlayBox)];
    [_musicBottomBar addGestureRecognizer:singleTap];
}

#pragma mark--UIGestureRecognizerDelegate
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    CGPoint location = [touch locationInView:_musicBottomBar];
    
    if(CGRectContainsPoint(CGRectMake(200, 5, 120, 48), location))
    {
        return NO;
    }
    return YES;
}

- (void)changeBarButton
{
    if (!_playBoxVC.isPlay) {
        NSArray *arrayItems = [NSArray arrayWithObjects:_btnSpace,_btnRewind,_btnPause,_btnFastForward, nil];
        _musicBottomBar.items = arrayItems;
    }
    else {
        NSArray *arrayItems = [NSArray arrayWithObjects:_btnSpace,_btnRewind,_btnPlay,_btnFastForward, nil];
        _musicBottomBar.items = arrayItems;
    }
}

//播放/暂停 按钮
- (void)play
{
    _playBoxVC = [GKPlayBoxViewController shared];
    [_playBoxVC play];
}

//上一曲
- (void)rewind
{
    [_playBoxVC rewind];
}
//下一曲
- (void)forward
{
    [_playBoxVC fastForward];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //初始化视图控制器数组
    if (!_arrViewControllers) {
        _arrViewControllers = [[NSMutableArray alloc] init];
    }
    MVC = self;
}

//初始化前两个界面
- (void)initViewControllerWithMain:(GKMainViewController *)mainVC andSecondary:(UIViewController *)secVC
{
    _mainVC = mainVC;
    _secVC = secVC;
    
    _mainVC.view.frame = CGRectMake(0, _mainVC.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
    [_scrollView addSubview:_mainVC.view];
    [_arrViewControllers addObject:_mainVC];
    
    _secVC.view.frame = CGRectMake(self.view.frame.size.width, _secVC.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
    [_scrollView addSubview:_secVC.view];
    [_arrViewControllers addObject:_secVC];
    
    _mainVC.view.tag = 1;
    _secVC.view.tag = 2;
    
    _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width*2, _scrollView.frame.size.height);
    [_scrollView scrollRectToVisible:_mainVC.view.frame animated:YES];
}

//先清空后面的视图控制器再添加新视图控制器
- (void)addVCBehindSuper:(UIViewController *)superVC withSub:(UIViewController *)subVC
{
    /*如果当前视图控制器后面已经没有视图了就直接加上要点击的新视图 
      否则就新把当前视图后面的视图全部清空然后让新视图加在当前视图后面*/
    if (_arrViewControllers.count > superVC.view.tag) {
        for (int i = superVC.view.tag; i < _arrViewControllers.count; i++) {
            /*注意数组下标是从0开始的tag是从1开始*/
            UIViewController *vc = [_arrViewControllers objectAtIndex:i];
            [vc.view removeFromSuperview];
        }
        [_arrViewControllers removeObjectsInRange:NSMakeRange(superVC.view.tag, _arrViewControllers.count - superVC.view.tag)];
    }
    [self addViewControllerToMain:subVC];
}

//直接添加视图控制器
- (void)addViewControllerToMain:(UIViewController *)viewController
{
    viewController.view.frame = CGRectMake(_scrollView.frame.size.width*_arrViewControllers.count, viewController.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
    [_scrollView addSubview:viewController.view];
    [_arrViewControllers addObject:viewController];
    viewController.view.tag = _arrViewControllers.count;
    //更新滚动视图的宽度
    _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width*_arrViewControllers.count, _scrollView.frame.size.height);
    //滑到当前视图
    [_scrollView scrollRectToVisible:viewController.view.frame animated:YES];
}

//获得主视图控制器
+ (GKMainScrollViewController *)getMain
{
    return MVC;
}

//获得主界面
+ (GKMainViewController *)getHomePage
{
    return _mainVC;
}

//返回上一个界面
- (void)backView:(UIViewController *)viewController
{
    [_scrollView scrollRectToVisible:CGRectMake(viewController.view.frame.origin.x-320, 0, 320, 568) animated:YES];
}

//隐藏底部音乐播放栏
- (void)hiddenMusicBottomBar:(BOOL)bHidden
{
    float yy = 0;
    if (bHidden)
        yy = [UIScreen mainScreen].bounds.size.height;
    else
        yy = [UIScreen mainScreen].bounds.size.height - 58;
    
    [UIView animateWithDuration:0.2 animations:^
     {
         _musicBottomBar.Frame = CGRectMake(0, yy, self.view.frame.size.width, 58);
     } completion:^(BOOL finished)
     {
         
     }];
}

//显示音乐播放视图
- (void)showPlayBox
{
    _playBoxVC = [GKPlayBoxViewController shared];
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionBeginFromCurrentState animations:^
     {
         _playBoxVC.view.transform = CGAffineTransformIdentity;
     } completion:^(BOOL finished) {}];
}

#pragma mark - scroll view delegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [_mainVC.SearchTF resignFirstResponder];
    if (scrollView.contentOffset.x == 0)
    {
        [self hiddenMusicBottomBar:NO];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //获得滚动视图偏移量 移动时一直在变
    CGFloat offset = scrollView.contentOffset.x;
    if (offset < 0) {
        return;
    }
    
    for (UIViewController *viewController in _arrViewControllers) {
        //获得视图下标
        NSInteger index = [_arrViewControllers indexOfObject:viewController];
        //获得视图宽度
        CGFloat width = _scrollView.frame.size.width;
        //计算出偏移量
        CGFloat y = index * width;
        //当前页0~1递增 即将出来页-1~0递增(取绝对值后1~0递减)
        CGFloat value = fabs((offset-y)/width);
        //获得缩放比例 cos(M_PI/7)大约是0.9 取比例0.9~1.0
        /*
         不均匀缩放
         当前页左移,value从0到1递增 *25.7°(即M_PI/7)后从0°到25.7°递增
         cos 0° = 1 , cos 25.7° = 0.9 ,所以缩放比例从1到0.9递减
         即将出现页 value从1到0递减 和当前页正好相反 缩放比例从0.9到1递增
         CGFloat scale = fabs(cos(value*M_PI/7));
         */
        //均匀缩放
        CGFloat scale = 1-0.1*fabs(value);
        //矩阵缩放变换
        viewController.view.transform = CGAffineTransformMakeScale(scale, scale);
    }
    
    for (UIViewController *viewController in self.childViewControllers) {
        
        CALayer *layer = viewController.view.layer;
        layer.shadowPath = [UIBezierPath bezierPathWithRect:viewController.view.bounds].CGPath;
    }
}

- (UIView *)createCustomNavigationBarWithTitle:(NSString *)title
{
   
    
    /*创建自定义导航栏视图*/
    UIView *navView = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, self.view.frame.size.width, 64.f)];
    navView.backgroundColor = RGBA(33,140,250,1);
    navView.userInteractionEnabled = YES; 
    
//    /*创建自定义状态栏视图*/
//    UIView *statusBarView = [[UIImageView alloc] initWithFrame:CGRectMake(0.f, 0.f, self.view.frame.size.width, 0.f)];
//    if (isIos7 >= 7 && __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_6_1)
//    {
//        statusBarView.frame = CGRectMake(statusBarView.frame.origin.x, statusBarView.frame.origin.y, statusBarView.frame.size.width, 20.f);
//        statusBarView.backgroundColor = [UIColor clearColor];
//        ((UIImageView *)statusBarView).backgroundColor = RGBA(33,140,250,1);
//        [_navView addSubview:statusBarView];
//    }
    
    /*创建导航栏标题*/
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((navView.frame.size.width - 200)/2, 22, 200, 40)];
    [titleLabel setText:title];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [navView addSubview:titleLabel];
    
    return navView;
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
