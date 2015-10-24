//
//  GKListViewController.m
//  GKMusic
//
//  Created by qianfeng on 14-9-26.
//  Copyright (c) 2014年 gao. All rights reserved.
//

#import "GKListViewController.h"
#import "GKListDetailViewController.h"
#import "GKVCMusicList.h"
#import "GKNetDownloadTS.h"
#import "GKYuekuCommonCell.h"
#import "Reachability.h"
#import "CONST.h"
#import "UIImageView+WebCache.h"

@interface GKListViewController ()

@end

@implementation GKListViewController

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
    // Do any additional setup after loading the view.
    
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
    [rbtn addTarget:self action:@selector(pressSearch) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:rbtn];
    
    [self.view addSubview:navView];
    
 
    //初始化默认横幅数组
    _arrBanners = [[NSMutableArray alloc] init];
    for (int i = 0; i < 7; i++) {  //实际只有5页 前后各添加一页可以循环播放
        UIImage *image = [UIImage imageNamed:@"yueku_banner_defaultBG.png"];
        UIImageView *iView = [[UIImageView alloc] initWithImage:image];
        [_arrBanners addObject:iView];
    }
    
    /*创建头视图*/
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 170)];
    _sv = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 150)];
    _sv.contentSize = CGSizeMake(320*7, 150);
    [_sv scrollRectToVisible:CGRectMake(320, 0, 320, 150) animated:NO];  //显示实际第一页
    _sv.pagingEnabled = YES;
    _sv.bounces = NO;
    _sv.showsHorizontalScrollIndicator = NO;
    _sv.delegate = self;
    for (int i = 0; i < 7; i++) {
        UIImageView *iView = _arrBanners[i];
        iView.frame = CGRectMake(320*i, 0, 320, 150);
        [_sv addSubview:iView];
    }
    [header addSubview:_sv];
    
    _pageCtrl = [[UIPageControl alloc] initWithFrame:CGRectMake(120, 160, 80, 10)];
    _pageCtrl.numberOfPages = 5;
    _pageCtrl.backgroundColor = [UIColor greenColor];
    _pageCtrl.pageIndicatorTintColor = [UIColor colorWithWhite:0.8 alpha:1.000];
    _pageCtrl.currentPageIndicatorTintColor = [UIColor whiteColor];
    _pageCtrl.currentPage = 0;
    _pageCtrl.defersCurrentPageDisplay = YES;
    [header addSubview:_pageCtrl];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(updateMyTimer:) userInfo:nil repeats:YES];
    
    //尾视图
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 58)];
    footerView.backgroundColor = [UIColor whiteColor];
    
    //创建tableView
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, 320, 568-64) style:UITableViewStylePlain];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.allowsSelection = NO;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableHeaderView = header;
    _tableView.tableFooterView = footerView;
    [self.view addSubview:_tableView];
    
    //初始化数据源
    _arrayData = [[NSMutableArray alloc] init];
    _arrayBanner = [[NSMutableArray alloc] init];
    
    //加载数据
    [self downloadDataWithUrl:CATEGORY andID:@"CATEGORY"];
    //开始下载横幅图片
    [self downloadDataWithUrl:BANNER andID:@"BANNER"];
}

- (void)viewWillDidAppear:(BOOL)animated
{
    [_timer invalidate];
    _timer = nil;
}

#pragma mark - DownloadData

- (void)downloadDataWithUrl:(NSString *)url andID:(NSString *)ID
{
    Reachability *abi = [Reachability reachabilityForInternetConnection];
    BOOL isReachable = [abi isReachable];
    if (!isReachable) {
        NSLog(@"无网络连接!");
        return;
    }
    NSLog(@"开始下载 ID = %@",ID);
    GKNetDownloadTS *dw = [[GKNetDownloadTS alloc] init];
    [dw downloadURL:url withID:ID complete:^(NSData *data, NSString *ID) {
        if ([ID isEqualToString:@"CATEGORY"]) {
            NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"下载歌单成功!");
            [self parseDicData:dict];
        }
        else if ([ID isEqualToString:@"BANNER"]) {
            NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"下载横幅成功!");
            [self parseBannerData:dict];
        }
//        else {
//            for (GKListTotalModel *model in _arrayData) {
//                if ([[NSString stringWithFormat:@"imgl%@",model.categoryID] isEqualToString:ID]) {
//                    UIImage *image = [UIImage imageWithData:data];
//                    model.img = image;
//                    NSLog(@"歌单图片%@下载完成 image = %@",ID,image);
//                    break;
//                }
//                if ([[NSString stringWithFormat:@"bnrl%@",model.categoryID] isEqualToString:ID]) {
//                    UIImage *banner = [UIImage imageWithData:data];
//                    model.banner = banner;
//                    NSLog(@"歌单分类横幅%@下载完成 banner = %@",ID,banner);
//                    break;
//                }
//            }
//            int count = 0;
//            for (GKListBannersModel *model in _arrayBanner) {
//                if ([[NSString stringWithFormat:@"banner%@",model.ID] isEqualToString:ID]) {
//                    UIImage *image = [UIImage imageWithData:data];
//                    model.img = image;
//                    UIImageView *iView = _arrBanners[count];
//                    iView.image = image;
//                    NSLog(@"歌单顶部横幅%@下载完成 TopBanner = %@",ID,image);
//                    break;
//                }
//                count++;
//            }
//        }
        //刷新数据视图
        [_tableView reloadData];
    }];
}

#pragma mark - ParseData

- (void)parseDicData:(NSDictionary *)dic
{
    //获得列表字典
    NSDictionary *dictData = [dic objectForKeyedSubscript:@"data"];
    //获得列表数组
    NSArray *arrInfo = [dictData objectForKeyedSubscript:@"info"];
    for (NSDictionary *dicInfo in arrInfo) {
        _listModel = [[GKListTotalModel alloc] init];
        _listModel.categoryID = [dicInfo objectForKey:@"categoryid"];
        _listModel.categoryName = [dicInfo objectForKey:@"categoryname"];
        _listModel.imgUrl = [dicInfo objectForKey:@"imgurl"];
        _listModel.bannerUrl = [dicInfo objectForKey:@"bannerurl"];
        //添加数据源
        [_arrayData addObject:_listModel];
//        //下载图片
//        NSString *imageUrl = [_listModel.imgUrl stringByReplacingOccurrencesOfString:@"/{size}/" withString:@"/"];
//        [self downloadDataWithUrl:imageUrl andID:[NSString stringWithFormat:@"imgl%@",_listModel.categoryID]];
//        //下载横幅
//        NSString *bannerUrl = [_listModel.bannerUrl stringByReplacingOccurrencesOfString:@"/{size}/" withString:@"/"];
//        [self downloadDataWithUrl:bannerUrl andID:[NSString stringWithFormat:@"bnrl%@",_listModel.categoryID]];
    }
}

- (void)parseBannerData:(NSDictionary *)dic
{
    //获得列表字典
    NSDictionary *dictData = [dic objectForKey:@"data"];
    //获得列表数组
    NSArray *arrInfo = [dictData objectForKey:@"info"];
    int i = 0;
    for (NSDictionary *dicInfo in arrInfo) {
        _banModel = [[GKListBannersModel alloc] init];
        _banModel.ID = [dicInfo objectForKey:@"id"];
        _banModel.type = [dicInfo objectForKey:@"type"];
        _banModel.title = [dicInfo objectForKey:@"title"];
        _banModel.url = [dicInfo objectForKey:@"url"];
        _banModel.imgurl = [dicInfo objectForKey:@"imgurl"];
        NSDictionary *extra = [dicInfo objectForKey:@"extra"];
        if ([extra isKindOfClass:[@"NSDictionary" class]]) {
            _banModel.name = [extra objectForKey:@"name"];
            _banModel.singerName = [extra objectForKey:@"singername"];
            _banModel.singerID = [extra objectForKey:@"singerid"];
            _banModel.intro = [extra objectForKey:@"intro"];
            _banModel.publishtime = [extra objectForKey:@"publishtime"];
            _banModel.suid = [extra objectForKey:@"suid"];
            _banModel.slid = [extra objectForKey:@"slid"];
        }
        //添加数据源
        [_arrayBanner addObject:_banModel];
        //下载顶部横幅
        NSString *bannerUrl = [_banModel.imgurl stringByReplacingOccurrencesOfString:@"/{size}/" withString:@"/"];
//        [self downloadDataWithUrl:bannerUrl andID:[NSString stringWithFormat:@"banner%@",_banModel.ID]];
        [_arrBanners[i+1] setImageWithURL:[NSURL URLWithString:bannerUrl]];
        if (i == 0) {
            [[_arrBanners lastObject] setImageWithURL:[NSURL URLWithString:bannerUrl]];
        } else if (i == 4) {
            [[_arrBanners firstObject] setImageWithURL:[NSURL URLWithString:bannerUrl]];
        }
        i++;
    }
    
}

#pragma mark - TableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (_arrayData.count+1)/2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GKYuekuCommonCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YUEKU"];
    if (!cell) {
        cell =  [[[NSBundle mainBundle] loadNibNamed:@"GKYuekuCommonCell" owner:self options:nil] lastObject];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOne:)];
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOne:)];
        [cell.img1IV addGestureRecognizer:tap];
        if (_arrayData.count>(2*indexPath.row+1)) {
            [cell.img2IV addGestureRecognizer:tap1];
        }
        cell.title1LB.font = [UIFont boldSystemFontOfSize:14];
        cell.title1LB.textColor = [UIColor whiteColor];
        cell.title2LB.font = [UIFont boldSystemFontOfSize:14];
        cell.title2LB.textColor = [UIColor whiteColor];
    }
    GKListTotalModel *model = _arrayData[2*indexPath.row];
    cell.modelList1 = model;
    cell.playIV1.image = nil;
    //下载图片
    NSString *imageUrl = [model.imgUrl stringByReplacingOccurrencesOfString:@"/{size}/" withString:@"/"];
    [cell.img1IV setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"rankinglist_defaultCover.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        model.img = image;
        cell.playIV1.image = [UIImage imageNamed:@"radarPlay.png"];
    }];

    if (_arrayData.count>(2*indexPath.row+1)) {
        GKListTotalModel *model = _arrayData[2*indexPath.row+1];
        cell.modelList2 = model;
        cell.playIV.image = nil;
        //下载图片
        NSString *imageUrl = [model.imgUrl stringByReplacingOccurrencesOfString:@"/{size}/" withString:@"/"];
        [cell.img2IV setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"rankinglist_defaultCover.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
            model.img = image;
            cell.playIV.image = [UIImage imageNamed:@"radarPlay.png"];
        }];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 135;
}

#pragma mark - navigationItem Press Methods
//返回
- (void)pressBack
{
    [[GKMainScrollViewController getMain] backView:self];
    NSLog(@"back!");
}
//搜索
- (void)pressSearch
{
    NSLog(@"search!");
    
    GKVCMusicList *vcList = [[GKVCMusicList alloc] init];
    vcList.title = @"我的歌单";
    //    vcList.arrData = _arraySongs;
    [[GKMainScrollViewController getMain] addVCBehindSuper:self withSub:vcList];
}

#pragma mark - UIGestureRecognizer action method

- (void)tapOne:(UIGestureRecognizer *)tap
{
    UIImageView *iv = (UIImageView *)tap.view;
    for (GKListTotalModel *model in _arrayData) {
        if (model.img == iv.image) {
            GKListDetailViewController *ldVC = [[GKListDetailViewController alloc] init];
            ldVC.title = model.categoryName;
            ldVC.tModel = model;
            [[GKMainScrollViewController getMain] addVCBehindSuper:self withSub:ldVC];
            break;
        }
    }
    NSLog(@"tap image!");
}

#pragma mark - scrollView delegate methods
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (_fireDate == nil) {
        //暂停定时器
        [_timer setFireDate:[NSDate distantFuture]];
    }
}

//滑动至数组最后1张图片时，将当前显示的图片调整成实际上的第1张图片
//滑动至数组第1张图片时，将当前显示的图片调整成实际上的最后1张图片
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    float xOffset = scrollView.contentOffset.x;
    
    if (xOffset == 6 * self.view.bounds.size.width) {
        
        [_sv scrollRectToVisible:CGRectMake(self.view.bounds.size.width, 0, self.view.bounds.size.width, 150) animated:NO];
    }
    else if (xOffset == 0) {
        
        [_sv scrollRectToVisible:CGRectMake(5 * self.view.bounds.size.width, 0, self.view.bounds.size.width, 150) animated:NO];
    }
    
    NSInteger a = scrollView.contentOffset.x/320-1;
    _pageCtrl.currentPage = a;
    
    if (_fireDate == nil) {
        _fireDate = [NSDate dateWithTimeIntervalSinceNow:3];
        //开启定时器
        [_timer setFireDate:_fireDate];
    }
}

- (void)updateMyTimer:(NSTimer *)timer
{
    if (_sv.contentOffset.x == 6 * self.view.bounds.size.width) {
        
        [_sv scrollRectToVisible:CGRectMake(self.view.bounds.size.width, 0, self.view.bounds.size.width, 150) animated:NO];
    }

    float xOffset = _sv.contentOffset.x+320;
    _pageCtrl.currentPage = (_pageCtrl.currentPage+1) % 5;
    
    [_sv scrollRectToVisible:CGRectMake(xOffset, 0, 320, 150) animated:YES];
    
    _fireDate = nil;
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
