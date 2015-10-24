//
//  GKSingerMusicViewController.m
//  GKMusic
//
//  Created by qianfeng on 14-10-12.
//  Copyright (c) 2014年 gao. All rights reserved.
//

#import "GKSingerMusicViewController.h"
#import "GKPlayBoxViewController.h"
#import "MMProgressHUD.h"
#import "GKVCMusicList.h"
#import <MediaPlayer/MediaPlayer.h>
#import <CoreMedia/CoreMedia.h>
#import "GKALbumViewController.h"
#import "GKMusicListCell.h"
#import "GKAlbumCell.h"
#import "GKMVCell.h"
#import "GKNetDownloadTS.h"
#import "Reachability.h"
#import "CONST.h"
#import "UIImageView+WebCache.h"

@interface GKSingerMusicViewController ()

@end

@implementation GKSingerMusicViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        _type = 1;
        _page = 1;
        _pagesize = 20;
        _arrD1 = NO;
        _arrD2 = NO;
        _arrD3 = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    /*创建自定义导航栏*/
    UIView *navView = [[GKMainScrollViewController getMain] createCustomNavigationBarWithTitle:self.title];
    navView.tag = 55;
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
    [rbtn addTarget:self action:@selector(pressSearch) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:rbtn];
    
    //创建头视图
    [self createHeaderView];
    
    //尾视图
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 58)];
    footerView.backgroundColor = [UIColor whiteColor];
    
    /*创建tableView*/
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 568) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableHeaderView = _headerView1;
    _tableView.tableFooterView = footerView;
    [self.view addSubview:_tableView];
    //添加自定义导航 不要让tableView的头视图挡住
    [self.view addSubview:navView];
    
    UIView *bgView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 35)];
    bgView1.backgroundColor = [UIColor whiteColor];
    bgView1.alpha = 0.85;
    
    _segCtrl = [[UISegmentedControl alloc] initWithFrame:CGRectMake(10, 5, 300, 25)];
    NSString *title1 = [NSString stringWithFormat:@"单曲(%@)",_tModel.songcount];
    NSString *title2 = [NSString stringWithFormat:@"专辑(%@)",_tModel.albumcount];
    NSString *title3 = [NSString stringWithFormat:@"MV(%@)",_tModel.mvcount];
    [_segCtrl insertSegmentWithTitle:title1 atIndex:0 animated:NO];
    [_segCtrl insertSegmentWithTitle:title2 atIndex:1 animated:NO];
    [_segCtrl insertSegmentWithTitle:title3 atIndex:2 animated:NO];
    [_segCtrl addTarget:self action:@selector(segmentChange:) forControlEvents:UIControlEventValueChanged];
    _segCtrl.selectedSegmentIndex = 0;
    [bgView1 addSubview:_segCtrl];
    
    UIView *bgView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 35, 320, 45)];
    bgView2.backgroundColor = [UIColor whiteColor];
    bgView2.tag = 60;
    
    UIImageView *iV1 = [[UIImageView alloc] initWithFrame:CGRectMake(15, 13, 20, 20)];
    iV1.image = [UIImage imageNamed:@"skin_image_ic_list_common_bar_header_allplay.png"];
    [bgView2 addSubview:iV1];
    
    UIImageView *iV2 = [[UIImageView alloc] initWithFrame:CGRectMake(279, 13, 21, 20)];
    iV2.image = [UIImage imageNamed:@"skin_image_ic_list_common_bar_header_editmode.png"];
    [bgView2 addSubview:iV2];
    
    UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(40, 13, 56, 20)];
    lb.textColor = [UIColor blackColor];
    lb.font = [UIFont systemFontOfSize:14];
    lb.text = @"全部播放";
    [bgView2 addSubview:lb];
    
    _viewbg = [[UIView alloc] initWithFrame:CGRectMake(0, 180, 320, 80)];
    _viewbg.backgroundColor = [UIColor clearColor];
    [_viewbg addSubview:bgView1];
    [_viewbg addSubview:bgView2];
    [self.view addSubview:_viewbg];
    
    //初始化数据源
    _arrayData = [[NSMutableArray alloc] init];
    _arrayData2 = [[NSMutableArray alloc] init];
    _arrayData3 = [[NSMutableArray alloc] init];

    [self downloadDataWithUrl:SINGERINFO(_tModel.singerid) andID:@"SINGERINFO"];
    //加载数据
    [self loadData];
}

- (void)createHeaderView
{
    /*创建头视图1*/
    _headerView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 260)];
    UIImageView *header = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 215)];
    header.contentMode = UIViewContentModeScaleAspectFill;
    header.tag = 50;
    header.clipsToBounds = YES;
    if (_icon) {
        header.image = _icon;
    }
    else {
        header.image = [UIImage imageNamed:@"singer_default_bg.png"];
    }
    [_headerView1 addSubview:header];
    
    /*创建头视图2*/
    _headerView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 215)];
    UIImageView *header2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 215)];
    header2.contentMode = UIViewContentModeScaleAspectFill;
    header2.clipsToBounds = YES;
    header2.image = header.image;
    [_headerView2 addSubview:header2];
}

- (void)loadData
{
    if (_arrD1) {
        UIView *view = [self.view viewWithTag:60];
        view.hidden = NO;
        [self createHeaderView];
        _tableView.tableHeaderView = _headerView1;
        [_tableView reloadData];
        return;
    }
//    [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleFade];
//    [MMProgressHUD showWithStatus:@"正在加载"];
    _waitView = [[GKWaitingAnimationView alloc] initWithFrame:CGRectMake(150, 120, 19, 19)];
    _waitView.imagesPath = @"/Users/gao/Desktop/images";
    _waitView.velocity = 0.5;
    [self.view addSubview:_waitView];
    [_waitView show];
    [self downloadDataWithUrl:SINGERSONG(_tModel.singerid, _page, _pagesize) andID:@"SINGERSONG"];
}

- (void)loadData2
{
    if (_arrD2) {
        UIView *view = [self.view viewWithTag:60];
        view.hidden = YES;
        [self createHeaderView];
        _tableView.tableHeaderView = _headerView2;
        [_tableView reloadData];
        return;
    }
    [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleFade];
    [MMProgressHUD showWithStatus:@"正在加载"];
    [self downloadDataWithUrl:SINGERALBUM(_tModel.singerid, _page, _pagesize) andID:@"SINGERALBUM"];
}

- (void)loadData3
{
    if (_arrD3) {
        UIView *view = [self.view viewWithTag:60];
        view.hidden = YES;
        [self createHeaderView];
        _tableView.tableHeaderView = _headerView2;
        [_tableView reloadData];
        return;
    }
    [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleFade];
    [MMProgressHUD showWithStatus:@"正在加载"];
    NSString *url = SINGERMV(_tModel.singerid, _tModel.singername, _page, _pagesize);
    url = [url stringByAddingPercentEscapesUsingEncoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8)];
    [self downloadDataWithUrl:url andID:@"SINGERMV"];
}

#pragma mark - DownloadData

- (void)downloadDataWithUrl:(NSString *)url andID:(NSString *)ID
{
    Reachability *abi = [Reachability reachabilityForInternetConnection];
    BOOL isReachable = [abi isReachable];
    if (!isReachable) {
        NSLog(@"无网络连接!");
        [MMProgressHUD dismissWithError:@"无网络连接"];
        return;
    }
    NSLog(@"开始下载 ID = %@",ID);
    UIView *view = [self.view viewWithTag:60];
    GKNetDownloadTS *dw = [[GKNetDownloadTS alloc] init];
    [dw downloadURL:url withID:ID complete:^(NSData *data, NSString *ID) {
        if ([ID isEqualToString:@"SINGERSONG"]) {
            NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"下载歌手单曲成功!");
            [self parseDicData:dict];
            _arrD1 = YES;
        }
        else if ([ID isEqualToString:@"SINGERINFO"]) {
            NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"下载歌手信息成功!");
            //获得列表字典
            NSDictionary *dictData = [dict objectForKey:@"data"];
            NSString *imgurl = [dictData objectForKey:@"imgurl"];
            NSString *imageUrl = [imgurl stringByReplacingOccurrencesOfString:@"{size}" withString:@"400"];
//            [self downloadDataWithUrl:imageUrl andID:@"SINGERICON"];
            UIImageView *iv = (UIImageView *)[self.view viewWithTag:50];
            [iv setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"singer_default_bg.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                _icon = image;
            }];
        }
//        else if ([ID isEqualToString:@"SINGERICON"]) {
//            UIImage *image = [UIImage imageWithData:data];
//            UIImageView *iv = (UIImageView *)[self.view viewWithTag:50];
//            iv.image = image;
//            _icon = image;
//            NSLog(@"歌手图片下载完成 image = %@",image);
//        }
        else if ([ID isEqualToString:@"SINGERALBUM"]) {
            NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"下载歌手专辑成功!");
            [self parseDicData2:dict];
            _arrD2 = YES;
            view.hidden = YES;
            [self createHeaderView];
            _tableView.tableHeaderView = _headerView2;
        }
//        else if ([[ID substringToIndex:5] isEqualToString:@"album"]) {
//            for (GKSingerAlbumModel *model in _arrayData2) {
//                if ([[NSString stringWithFormat:@"album%@",model.albumid] isEqualToString:ID]) {
//                    UIImage *image = [UIImage imageWithData:data];
//                    model.img = image;
//                    NSLog(@"歌手专辑图片%@下载完成 image = %@",ID,image);
//                    break;
//                }
//            }
//        }
        else if ([ID isEqualToString:@"SINGERMV"]) {
            NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"下载歌手MV成功!");
            [self parseDicData3:dict];
            _arrD3 = YES;
            view.hidden = YES;
            [self createHeaderView];
            _tableView.tableHeaderView = _headerView2;
        }
        else if ([ID isEqualToString:@"musicinfo"]) {
            NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"下载歌曲信息成功!");
            NSString *strUrl = [dict objectForKey:@"url"];
            _fileSize = [dict objectForKey:@"fileSize"];
            [self downloadDataWithUrl:strUrl andID:@"music"];
        }
        else if ([ID isEqualToString:@"music"]){
            if (data.length < [_fileSize floatValue]) {
                GKPlayBoxViewController *pbVC = [GKPlayBoxViewController shared];
                float rate = (float)data.length/[_fileSize floatValue]*100;
                pbVC.labelSong.text = [NSString stringWithFormat:@"下载了%.2f%%",rate];
            }
            else {
                NSLog(@"下载歌曲成功!");
                GKPlayBoxViewController *pbVC = [GKPlayBoxViewController shared];
                BOOL isOK = [data writeToFile:FULLPATH(_filename) atomically:YES];
                NSLog(@"isok = %d",isOK);
                [pbVC readData];
                [GKMainScrollViewController getHomePage].musicCountLB.text = pbVC.songsCount;
                for (int i = 0; i < pbVC.arraySongs.count; i++) {
                    if ([[NSString stringWithFormat:@"%@ - %@",pbVC.arraySingers[i],pbVC.arraySongs[i]] isEqualToString:_filename]) {
                        pbVC.index = i;
                        break;
                    }
                }
                [pbVC stop];
                [pbVC readMusic];
                [pbVC play];
            }
        }
//        else {
//            for (GKSingerMVModel *model in _arrayData3) {
//                if ([[NSString stringWithFormat:@"mv%@",model.hash] isEqualToString:ID]) {
//                    UIImage *image = [UIImage imageWithData:data];
//                    model.img = image;
//                    NSLog(@"歌手MV图片%@下载完成 image = %@",ID,image);
//                    break;
//                }
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
    NSDictionary *dictData = [dic objectForKey:@"data"];
    //获得列表数组
    NSArray *arrInfo = [dictData objectForKey:@"info"];
    for (NSDictionary *dicInfo in arrInfo) {
        _model = [[GKSingerMusicModel alloc] init];
        _model.filename = [dicInfo objectForKey:@"filename"];
        _model.hash = [dicInfo objectForKey:@"hash"];
        _model.duration = [dicInfo objectForKey:@"duration"];
        _model.hash320 = [dicInfo objectForKey:@"320hash"];
        _model.sqhash = [dicInfo objectForKey:@"sqhash"];
        _model.mvhash = [dicInfo objectForKey:@"mvhash"];
        _model.feetype = [dicInfo objectForKey:@"feetype"];
        //添加数据源
        [_arrayData addObject:_model];
    }
//    [MMProgressHUD dismissWithSuccess:@"完成"];
    [_waitView hide];
}

- (void)parseDicData2:(NSDictionary *)dic
{
    //获得列表字典
    NSDictionary *dictData = [dic objectForKey:@"data"];
    //获得列表数组
    NSArray *arrInfo = [dictData objectForKey:@"info"];
    for (NSDictionary *dicInfo in arrInfo) {
        _model2 = [[GKSingerAlbumModel alloc] init];
        _model2.albumid = [dicInfo objectForKey:@"albumid"];
        _model2.albumname = [dicInfo objectForKey:@"albumname"];
        _model2.singerid = [dicInfo objectForKey:@"singerid"];
        _model2.singername = [dicInfo objectForKey:@"singername"];
        _model2.intro = [dicInfo objectForKey:@"intro"];
        _model2.publishtime = [dicInfo objectForKey:@"publishtime"];
        _model2.imgurl = [dicInfo objectForKey:@"imgurl"];
        //添加数据源
        [_arrayData2 addObject:_model2];
//        //下载图片
//        NSString *imageUrl = [_model2.imgurl stringByReplacingOccurrencesOfString:@"/{size}/" withString:@"/"];
//        [self downloadDataWithUrl:imageUrl andID:[NSString stringWithFormat:@"album%@",_model2.albumid]];
    }
    [MMProgressHUD dismissWithSuccess:@"完成"];
}

- (void)parseDicData3:(NSDictionary *)dic
{
    //获得列表字典
    NSDictionary *dictData = [dic objectForKey:@"data"];
    //获得列表数组
    NSArray *arrInfo = [dictData objectForKey:@"info"];
    for (NSDictionary *dicInfo in arrInfo) {
        _model3 = [[GKSingerMVModel alloc] init];
        _model3.filename = [dicInfo objectForKey:@"filename"];
        _model3.singername = [dicInfo objectForKey:@"singername"];
        _model3.hash = [dicInfo objectForKey:@"hash"];
        _model3.imgurl = [dicInfo objectForKey:@"imgurl"];
        _model3.intro = [dicInfo objectForKey:@"intro"];
        //添加数据源
        [_arrayData3 addObject:_model3];
//        //下载图片
//        NSString *imageUrl = [_model3.imgurl stringByReplacingOccurrencesOfString:@"{size}" withString:@"240"];
//        [self downloadDataWithUrl:imageUrl andID:[NSString stringWithFormat:@"mv%@",_model3.hash]];
    }
    [MMProgressHUD dismissWithSuccess:@"完成"];
}

#pragma mark - TableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_type == 1) {
        return _arrayData.count;
    }
    else if (_type == 2) {
        return (_arrayData2.count+1)/2;
    }
    return (_arrayData3.count+1)/2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_type == 1) {
        _tableView.allowsSelection = YES;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        GKMusicListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MUSIC"];
        if (!cell) {
            cell =  [[[NSBundle mainBundle] loadNibNamed:@"GKMusicListCell" owner:self options:nil] lastObject];
        }
        _model = _arrayData[indexPath.row];
        cell.modelsong = _model;
        return cell;
    }
    else if (_type == 2) {
        _tableView.allowsSelection = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        GKAlbumCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ALBUM"];
        if (!cell) {
            cell =  [[[NSBundle mainBundle] loadNibNamed:@"GKAlbumCell" owner:self options:nil] lastObject];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAlbum:)];
            UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAlbum:)];
            [cell.imgIV1 addGestureRecognizer:tap];
            if (_arrayData2.count>(2*indexPath.row+1)) {
                [cell.imgIV2 addGestureRecognizer:tap1];
            }
            cell.backgroundColor = [UIColor colorWithWhite:0.865 alpha:1.000];
        }
        GKSingerAlbumModel *model2 = _arrayData2[2*indexPath.row];
        cell.model1 = model2;
        //下载图片
        NSString *imageUrl = [model2.imgurl stringByReplacingOccurrencesOfString:@"/{size}/" withString:@"/"];
        [cell.imgIV1 setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"rankinglist_defaultCover.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
            model2.img = image;
        }];
        if (_arrayData2.count>(2*indexPath.row+1)) {
            GKSingerAlbumModel *model2 = _arrayData2[2*indexPath.row+1];
            cell.model2 = model2;
            //下载图片
            NSString *imageUrl = [model2.imgurl stringByReplacingOccurrencesOfString:@"/{size}/" withString:@"/"];
            [cell.imgIV2 setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"rankinglist_defaultCover.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                model2.img = image;
            }];
        } else {
            cell.view2.hidden = YES;
        }
        return cell;
    }
    _tableView.allowsSelection = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    GKMVCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MV"];
    if (!cell) {
        cell =  [[[NSBundle mainBundle] loadNibNamed:@"GKMVCell" owner:self options:nil] lastObject];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapMV:)];
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapMV:)];
        [cell.imgIV1 addGestureRecognizer:tap];
        if (_arrayData3.count>(2*indexPath.row+1)) {
            [cell.imgIV2 addGestureRecognizer:tap1];
        }
    }
    GKSingerMVModel *model3 = _arrayData3[2*indexPath.row];
    cell.model1 = model3;
    //下载图片
    NSString *imageUrl = [model3.imgurl stringByReplacingOccurrencesOfString:@"{size}" withString:@"240"];
    [cell.imgIV1 setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"rankinglist_defaultCover.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        model3.img = image;
    }];
    if (_arrayData3.count>(2*indexPath.row+1)) {
        GKSingerMVModel *model3 = _arrayData3[2*indexPath.row+1];
        cell.model2 = model3;
        //下载图片
        NSString *imageUrl = [model3.imgurl stringByReplacingOccurrencesOfString:@"{size}" withString:@"240"];
        [cell.imgIV2 setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"rankinglist_defaultCover.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
            model3.img = image;
        }];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_type == 1) {
        return 58;
    }
    else if (_type == 2) {
        return 200;
    }
    return 140;
}

#pragma mark - TableViewDelegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"select!");
    
    _model = _arrayData[indexPath.row];
    _filename = _model.filename;
    GKPlayBoxViewController *pbVC = [GKPlayBoxViewController shared];
    [pbVC stop];
    [[GKMainScrollViewController getMain] showPlayBox];
    for (int i = 0; i < pbVC.arraySongs.count; i++) {
        if ([[NSString stringWithFormat:@"%@ - %@",pbVC.arraySingers[i],pbVC.arraySongs[i]] isEqualToString:_filename]) {
            pbVC.index = i;
            [pbVC readMusic];
            [pbVC play];
            return;
        }
    }
    pbVC.labelSong.text = @"下载中...";
    pbVC.labelSinger.text = @"下载中...";
    [self downloadDataWithUrl:MUSICINFO(_model.hash) andID:@"musicinfo"];
    NSLog(@"歌曲链接:%@",MUSICURL(_model.hash));
}

- (void)tapAlbum:(UIGestureRecognizer *)tap
{
    NSLog(@"tapAlbum");
    UIImageView *iv = (UIImageView *)tap.view;
    for (GKSingerAlbumModel *model in _arrayData2) {
        if (model.img == iv.image) {
            GKALbumViewController *alVC = [[GKALbumViewController alloc] init];
            alVC.title = model.albumname;
            alVC.tModel = model;
            alVC.singericon = _icon;
            [[GKMainScrollViewController getMain] addVCBehindSuper:self withSub:alVC];
            break;
        }
    }
}

- (void)tapMV:(UIGestureRecognizer *)tap
{
    NSLog(@"tapMV");
    NSString *strUrl = @"http://storagemv2.mobile.kugou.com/201505041321/b2f4b83da348495cdaf5a58c3b119d22/M08/30/D2/CgEy51UVhVyhcqReAqr6gWsJ50M853.mp4";

    NSURL *url = [NSURL URLWithString:strUrl];
    //视频播放控制器
    MPMoviePlayerViewController *_MPVC;
    _MPVC = [[MPMoviePlayerViewController alloc] initWithContentURL:url];
    _MPVC.view.frame = self.view.bounds;
    [[GKMainScrollViewController getMain] presentViewController:_MPVC animated:YES completion:nil];
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

#pragma mark - scrollview delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint p = scrollView.contentOffset;
    float y = 180 - p.y;
    UIView *navView = [self.view viewWithTag:55];
    if (y <= 64) {
        y = 64;
        navView.backgroundColor = RGBA(33,140,250,1);
    }
    else {
        navView.backgroundColor = [UIColor clearColor];
    }
    _viewbg.frame = CGRectMake(0, y, 320, 80);
}

#pragma mark - UISegmentedControl Change Methods

- (void)segmentChange:(UISegmentedControl *)segCtrl
{
        switch (segCtrl.selectedSegmentIndex) {
        case 0: _type = 1;[self loadData];  break;
        case 1: _type = 2;[self loadData2]; break;
        case 2: _type = 3;[self loadData3]; break;
    }
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
