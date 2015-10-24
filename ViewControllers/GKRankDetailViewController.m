//
//  GKRankDetailViewController.m
//  GKMusic
//
//  Created by qianfeng on 14-9-25.
//  Copyright (c) 2014年 gao. All rights reserved.
//

#import "GKRankDetailViewController.h"
#import "GKPlayBoxViewController.h"
#import "GKVCMusicList.h"
#import "GKMusicListCell.h"
#import "GKNetDownloadTS.h"
#import "Reachability.h"
#import "CONST.h"
#import "UIImageView+WebCache.h"

@interface GKRankDetailViewController ()

@end

@implementation GKRankDetailViewController

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
    
    
    /*创建头视图*/
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 152)];
    UIImageView *header = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 120)];
    //下载横幅
    NSString *bannerUrl = [_tModel.bannerUrl stringByReplacingOccurrencesOfString:@"/{size}/" withString:@"/"];
    [header setImageWithURL:[NSURL URLWithString:bannerUrl] placeholderImage:[UIImage imageNamed:@"yueku_banner_defaultBG.png"]];
    [headerView addSubview:header];
    
    UILabel *timeLB = [[UILabel alloc] initWithFrame:CGRectMake(150, 95, 160, 20)];
    timeLB.textColor = [UIColor whiteColor];
    timeLB.font = [UIFont systemFontOfSize:13];
    timeLB.tag = 10;
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
    _page++;
    _pagesize = 30;
    [self downloadDataWithUrl:RANKDETAIL(_tModel.rankID, _tModel.rankType, _page, _pagesize) andID:[NSString stringWithFormat:@"%@",_tModel.rankID]];
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
        if ([ID isEqualToString:[NSString stringWithFormat:@"%@",_tModel.rankID]]) {
            NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"下载具体排行成功!");
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
    //获得列表字典
    NSDictionary *dictData = [dic objectForKey:@"data"];
    //获得列表数组
    NSArray *arrInfo = [dictData objectForKey:@"info"];
    for (NSDictionary *dicInfo in arrInfo) {
        _model = [[GKRankDetailModel alloc] init];
        _model.filename = [dicInfo objectForKey:@"filename"];
        _model.hash = [dicInfo objectForKey:@"hash"];
        _model.hash320 = [dicInfo objectForKey:@"320hash"];
        _model.sqhash = [dicInfo objectForKey:@"sqhash"];
        _model.mvhash = [dicInfo objectForKey:@"mvhash"];
        _model.feetype = [dicInfo objectForKey:@"feetype"];
        _model.isfirst = [dicInfo objectForKey:@"isfirst"];
        _model.addtime = [dicInfo objectForKey:@"addtime"];
        //添加数据源
        [_arrayData addObject:_model];
    }
    _model = _arrayData[0];
    UILabel *timeLB = (UILabel *)[self.view viewWithTag:10];
    timeLB.text = [NSString stringWithFormat:@"最近更新时间:  %@",[_model.addtime substringToIndex:10]];
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
    cell.model = _model;
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
