//
//  GKMusicLibraryViewController.m
//  GKMusic
//
//  Created by qianfeng on 14-9-24.
//  Copyright (c) 2014年 gao. All rights reserved.
//

#import "GKMusicLibraryViewController.h"
#import "GKRankViewController.h"
#import "GKListViewController.h"
#import "GKFMTotalViewController.h"
#import "GKNetDownloadTS.h"
#import "GKVCMusicList.h"
#import "UIImage+UIImageExtras.h"
#import "GKYuekuCommonCell.h"
#import "Reachability.h"
#import "CONST.h"
#import "UIImageView+WebCache.h"

@interface GKMusicLibraryViewController ()

@end

@implementation GKMusicLibraryViewController

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
    
    /*乐库三个按钮作为tableView的头视图*/
    UIView *headerView = [[UIView alloc] init];
    headerView.frame = CGRectMake(0, 0, 320, 70);
    
    //排行
    _btnRank = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnRank.frame = CGRectMake(0, 1, 106, 65);
    _btnRank.backgroundColor = [UIColor colorWithRed:0.875 green:0.620 blue:0.175 alpha:1.000];
    UIImage *imageRank = [UIImage imageNamed:@"yueku_rank@2x.png"];
    imageRank = [imageRank imageByScalingToSize:CGSizeMake(30, 30)];
    [_btnRank setImage:imageRank forState:UIControlStateNormal];
    [_btnRank setTitle:@"排行" forState:UIControlStateNormal];
    [_btnRank setBackgroundImage:[UIImage imageNamed:@"selectArea.png"] forState:UIControlStateHighlighted];
    _btnRank.titleEdgeInsets = UIEdgeInsetsMake(4, 5, 0, 0);
    [_btnRank addTarget:self action:@selector(pressRank) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:_btnRank];
    
    //歌单
    _btnList = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnList.frame = CGRectMake(107, 1, 106, 65);
    _btnList.backgroundColor = [UIColor colorWithRed:1.000 green:0.161 blue:0.303 alpha:1.000];
    UIImage *imageList = [UIImage imageNamed:@"yueku_recommend@2x.png"];
    imageList = [imageList imageByScalingToSize:CGSizeMake(30, 30)];
    [_btnList setImage:imageList forState:UIControlStateNormal];
    [_btnList setTitle:@"歌单" forState:UIControlStateNormal];
    [_btnList setBackgroundImage:[UIImage imageNamed:@"selectArea.png"] forState:UIControlStateHighlighted];
    _btnList.titleEdgeInsets = UIEdgeInsetsMake(4, 5, 0, 0);
    [_btnList addTarget:self action:@selector(pressList) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:_btnList];
    
    //电台
    _btnRadio = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnRadio.frame = CGRectMake(214, 1, 106, 65);
    _btnRadio.backgroundColor = [UIColor magentaColor];
    UIImage *imageRadio = [UIImage imageNamed:@"yueku_radio@2x.png"];
    imageRadio = [imageRadio imageByScalingToSize:CGSizeMake(30, 30)];
    [_btnRadio setImage:imageRadio forState:UIControlStateNormal];
    [_btnRadio setTitle:@"电台" forState:UIControlStateNormal];
    [_btnRadio setBackgroundImage:[UIImage imageNamed:@"selectArea.png"] forState:UIControlStateHighlighted];
    _btnRadio.titleEdgeInsets = UIEdgeInsetsMake(4, 5, 0, 0);
    [_btnRadio addTarget:self action:@selector(pressRadio) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:_btnRadio];
    
    //尾视图
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 58)];
    footerView.backgroundColor = [UIColor whiteColor];
    
    //创建tableView
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, 320, 568-64) style:UITableViewStylePlain];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.allowsSelection = NO;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableHeaderView = headerView;
    _tableView.tableFooterView = footerView;
    [self.view addSubview:_tableView];
    
    //初始化数据源
    _arrayData = [[NSMutableArray alloc] init];
    
    //加载数据
    [self downloadDataWithUrl:RECOMMEND andID:@"RECOMMEND"];
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
        if ([ID isEqualToString:@"RECOMMEND"]) {
             NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"下载乐库成功!");
            [self parseDicData:dict];
        }
//        else {
//            for (GKYuekuCommonModel *model in _arrayData) {
//                if ([[NSString stringWithFormat:@"%@",model.subScribeType] isEqualToString:ID]) {
//                    UIImage *image = [UIImage imageWithData:data];
//                    model.img = image;
//                    NSLog(@"乐库图片%@下载完成 image = %@",ID,image);
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
        _model = [[GKYuekuCommonModel alloc] init];
        _model.title = [dicInfo objectForKey:@"title"];
        _model.subScribeType = [dicInfo objectForKey:@"subscribetype"];
        _model.imgUrl = [dicInfo objectForKey:@"imgurl"];
        _model.bannerUrl = [dicInfo objectForKey:@"bannerurl"];
        //添加数据源
        [_arrayData addObject:_model];
//        //下载图片
//        NSString *imageUrl = [_model.imgUrl stringByReplacingOccurrencesOfString:@"/{size}/" withString:@"/"];
//        [self downloadDataWithUrl:imageUrl andID:[NSString stringWithFormat:@"%@",_model.subScribeType]];
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
    }
    GKYuekuCommonModel *model = _arrayData[2*indexPath.row];
    cell.model1 = model;
    cell.playIV1.image = nil;
    //下载图片
    NSString *imageUrl = [model.imgUrl stringByReplacingOccurrencesOfString:@"/{size}/" withString:@"/"];
    [cell.img1IV setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"rankinglist_defaultCover.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        model.img = image;
        cell.playIV1.image = [UIImage imageNamed:@"radarPlay.png"];
    }];
    if (_arrayData.count>(2*indexPath.row+1)) {
        GKYuekuCommonModel *model = _arrayData[2*indexPath.row+1];
        cell.model2 = model;
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

#pragma mark - TopButton Press Methods
//排行
- (void)pressRank
{
    NSLog(@"pressRank!");
    GKRankViewController *rankVC = [[GKRankViewController alloc] init];
    rankVC.title = @"排行";
    [[GKMainScrollViewController getMain] addVCBehindSuper:self withSub:rankVC];
}
//歌单
- (void)pressList
{
    NSLog(@"pressList!");
    GKListViewController *listVC = [[GKListViewController alloc] init];
    listVC.title = @"歌单";
    [[GKMainScrollViewController getMain] addVCBehindSuper:self withSub:listVC];
}
//电台
- (void)pressRadio
{
    NSLog(@"pressRadio!");
    GKFMTotalViewController *fmVC = [[GKFMTotalViewController alloc] init];
    fmVC.title = @"电台";
    [[GKMainScrollViewController getMain] addVCBehindSuper:self withSub:fmVC];
}

#pragma mark - UIGestureRecognizer action method

- (void)tapOne:(UIGestureRecognizer *)tap
{
    UIImageView *iv = (UIImageView *)tap.view;
    int i = 0;
    for (GKYuekuCommonModel *model in _arrayData) {
        if (model.img == iv.image) {
            switch (i) {
                case 0:
                    [self pressRank];break;
                case 1:
                    [self pressList];break;
                case 2:
                    [self pressRadio];break;
                default:
                    break;
            }
            break;
        }
        i++;
    }
    NSLog(@"tap image!");
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
