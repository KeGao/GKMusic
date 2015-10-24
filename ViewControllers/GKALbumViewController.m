//
//  GKALbumViewController.m
//  GKMusic
//
//  Created by qianfeng on 14-10-15.
//  Copyright (c) 2014年 gao. All rights reserved.
//

#import "GKALbumViewController.h"
#import "GKPlayBoxViewController.h"
#import "GKVCMusicList.h"
#import "GKMusicListCell.h"
#import "GKNetDownloadTS.h"
#import "Reachability.h"
#import "CONST.h"

@interface GKALbumViewController ()

@end

@implementation GKALbumViewController

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
    navView.backgroundColor = [UIColor clearColor];
    navView.tag = 55;
    
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
    
    /*创建头视图*/
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 245)];
    _header = [[UIImageView alloc] initWithFrame:CGRectMake(0, -45, 320, 290)];
    _header.contentMode = UIViewContentModeScaleAspectFill;
    _header.clipsToBounds = YES;
    _header.image = [UIImage imageNamed:@"yueku_banner_defaultBG.png"];
    [headerView addSubview:_header];
    
    _icon = [[UIImageView alloc] initWithFrame:CGRectMake(18, 164, 42, 42)];
    _icon.image = [UIImage imageNamed:@"CollectDetailPage_DefaulPortrait.png"];
    _icon.layer.cornerRadius = 21;
    _icon.clipsToBounds = YES;
    [_header addSubview:_icon];
    
    _name = [[UILabel alloc] initWithFrame:CGRectMake(62, 174, 74, 21)];
    _name.font = [UIFont boldSystemFontOfSize:14];
    _name.tintColor = [UIColor whiteColor];
    _name.textColor = [UIColor whiteColor];
    [_header addSubview:_name];
    
    _intro = [[UILabel alloc] initWithFrame:CGRectMake(20, 208, 241, 30)];
    _intro.tintColor = [UIColor whiteColor];
    _intro.textColor = [UIColor whiteColor];
    _intro.font = [UIFont systemFontOfSize:12];
    _intro.numberOfLines = 2;
    [_header addSubview:_intro];
    
    UIImageView *share = [[UIImageView alloc] initWithFrame:CGRectMake(282, 213, 18, 18)];
    share.image = [UIImage imageNamed:@"CollectDetailPage_Share.png"];
    [_header addSubview:share];
    
    _viewbg = [[UIView alloc] initWithFrame:CGRectMake(0, 200, 320, 45)];
    _viewbg.backgroundColor = [UIColor whiteColor];
    
    UIImageView *iv1 = [[UIImageView alloc] initWithFrame:CGRectMake(20, 16, 20, 20)];
    iv1.image = [UIImage imageNamed:@"skin_image_ic_list_common_bar_header_allplay.png"];
    [_viewbg addSubview:iv1];
    
    UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(42, 16, 62, 21)];
    lb.font = [UIFont systemFontOfSize:14];
    lb.text = @"全部播放";
    [_viewbg addSubview:lb];
    
    UIImageView *iv2 = [[UIImageView alloc] initWithFrame:CGRectMake(241, 16, 20, 20)];
    iv2.image = [UIImage imageNamed:@"CollectDetailPage_Collect.png"];
    [_viewbg addSubview:iv2];
    
    UIImageView *iv3 = [[UIImageView alloc] initWithFrame:CGRectMake(279, 16, 21, 20)];
    iv3.image = [UIImage imageNamed:@"skin_image_ic_list_common_bar_header_editmode.png"];
    [_viewbg addSubview:iv3];
    
    //尾视图
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 58)];
    footerView.backgroundColor = [UIColor whiteColor];
    
    //创建tableView
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 568) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableHeaderView = headerView;
    _tableView.tableFooterView = footerView;
    [self.view addSubview:_tableView];
    //添加自定义导航 不要让tableView的头视图挡住
    [self.view addSubview:navView];
    [self.view addSubview:_viewbg];
    
    //初始化数据源
    _arrayData = [[NSMutableArray alloc] init];
    
    //加载数据
    [self loadData];
}

- (void)loadData
{
    [self downloadDataWithUrl:ALBUMSONG(_tModel.albumid) andID:@"ALBUMSONG"];
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
        if ([ID isEqualToString:@"ALBUMSONG"]) {
            NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"下载专辑歌曲成功!");
            [self parseDicData:dict];
            _header.image = _tModel.img;
            _icon.image = _singericon;
            _name.text = _tModel.singername;
            _intro.text = _tModel.intro;
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
}

#pragma mark - TableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _arrayData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GKMusicListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MUSIC"];
    if (!cell) {
        cell =  [[[NSBundle mainBundle] loadNibNamed:@"GKMusicListCell" owner:self options:nil] lastObject];
    }
    _model = _arrayData[indexPath.row];
    cell.modelsong = _model;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 58;
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

#pragma mark - scrollview delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint p = scrollView.contentOffset;
    float y = 200 - p.y;
    UIView *navView = [self.view viewWithTag:55];
    if (y < 160) {
        navView.backgroundColor = RGBA(33,140,250,1);
    }
    else {
        navView.backgroundColor = [UIColor clearColor];
    }
    if (y <= 64) {
        y = 64;
    }
    _viewbg.frame = CGRectMake(0, y, 320, 45);
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
