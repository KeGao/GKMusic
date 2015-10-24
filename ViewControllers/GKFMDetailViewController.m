//
//  GKFMDetailViewController.m
//  GKMusic
//
//  Created by qianfeng on 14-10-9.
//  Copyright (c) 2014年 gao. All rights reserved.
//

#import "GKFMDetailViewController.h"
#import "GKPlayBoxViewController.h"
#import "GKVCMusicList.h"
#import "GKMusicListCell.h"
#import "GKNetDownloadTS.h"
#import "Reachability.h"
#import "CONST.h"
#import "UIImageView+WebCache.h"

@interface GKFMDetailViewController ()

@end

@implementation GKFMDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        _offset = @"";
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
    
    
    /*创建头视图*/
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 152)];
    UIImageView *header = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 120)];
    //下载横幅
    NSString *bannerUrl = [_tModel.bannerurl stringByReplacingOccurrencesOfString:@"/{size}/" withString:@"/"];
    [header setImageWithURL:[NSURL URLWithString:bannerUrl] placeholderImage:[UIImage imageNamed:@"yueku_banner_defaultBG.png"]];
    header.userInteractionEnabled = YES;
    [headerView addSubview:header];
    
    UIButton *refreshBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    refreshBtn.frame = CGRectMake(10, 85, 80, 25);
    refreshBtn.backgroundColor = [UIColor colorWithWhite:0.314 alpha:0.800];
    refreshBtn.layer.cornerRadius = 4;
    [refreshBtn setImage:[UIImage imageNamed:@"yueku_radio_refresh.png"] forState:UIControlStateNormal];
    [refreshBtn setTitle:@" 换一批" forState:UIControlStateNormal];
    refreshBtn.tintColor = [UIColor whiteColor];
    refreshBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [refreshBtn addTarget:self action:@selector(loadData) forControlEvents:UIControlEventTouchUpInside];
    [header addSubview:refreshBtn];
    
    UILabel *timeLB = [[UILabel alloc] initWithFrame:CGRectMake(150, 95, 160, 20)];
    timeLB.textColor = [UIColor whiteColor];
    timeLB.font = [UIFont systemFontOfSize:13];
    timeLB.text = [NSString stringWithFormat:@"最近更新时间:  %@",[_tModel.addtime substringToIndex:10]];
    [header addSubview:timeLB];
    
    UIImageView *iV1 = [[UIImageView alloc] initWithFrame:CGRectMake(10, 130, 20, 20)];
    iV1.image = [UIImage imageNamed:@"skin_image_ic_list_common_bar_header_allplay.png"];
    [headerView addSubview:iV1];
    
    UIImageView *iV2 = [[UIImageView alloc] initWithFrame:CGRectMake(279, 130, 21, 20)];
    iV2.image = [UIImage imageNamed:@"skin_image_ic_list_common_bar_header_editmode.png"];
    [headerView addSubview:iV2];
    
    UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(35, 130, 56, 20)];
    lb.textColor = [UIColor blackColor];
    lb.font = [UIFont systemFontOfSize:14];
    lb.text = @"全部播放";
    [headerView addSubview:lb];
    
    //尾视图
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 58)];
    footerView.backgroundColor = [UIColor whiteColor];
    
    /*创建tableView*/
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, 320, 568-64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableHeaderView = headerView;
    _tableView.tableFooterView = footerView;
    [self.view addSubview:_tableView];
    
    //初始化数据源
    _arrayData = [[NSMutableArray alloc] init];
    
    //加载数据
    [self loadData];
    
}

- (void)loadData
{
    [self downloadDataWithUrl:FMMUSIC(_offset,_tModel.fmtype,_offset,_tModel.fmid) andID:[NSString stringWithFormat:@"%@ %@",_tModel.fmname,_offset]];
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
        if ([ID isEqualToString:[NSString stringWithFormat:@"%@ %@",_tModel.fmname,_offset]]) {
            NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"下载电台歌单成功!");
            [_arrayData removeAllObjects];
            [self parseDicData:dict];
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
    //获得列表数组
    NSArray *arrData = [dic objectForKey:@"data"];
    //获得偏移(用于获取下一组数据)
    _offset = [arrData[0] objectForKey:@"offset"];
    //获得歌曲数组
    NSArray *arrSongs = [arrData[0] objectForKey:@"songs"];
    for (NSDictionary *dicInfo in arrSongs) {
        _model = [[GKFMDetailModel alloc] init];
        _model.sid = [dicInfo objectForKey:@"sid"];
        _model.name = [dicInfo objectForKey:@"name"];
        _model.hash = [dicInfo objectForKey:@"hash"];
        _model.hash320 = [dicInfo objectForKey:@"320hash"];
        _model.hash_ape = [dicInfo objectForKey:@"hash_ape"];
        _model.imgurl = [dicInfo objectForKey:@"imgurl"];
        _model.imgurl180 = [dicInfo objectForKey:@"imgurl180"];
        _model.mvhash = [dicInfo objectForKey:@"mvhash"];
        _model.hmvhash = [dicInfo objectForKey:@"hmvhash"];
        _model.trac = [dicInfo objectForKey:@"trac"];
        _model.isfilehead = [dicInfo objectForKey:@"isfilehead"];
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
    cell.modelfm = _model;
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
    _filename = _model.name;
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
