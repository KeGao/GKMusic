//
//  GKListDetailViewController.m
//  GKMusic
//
//  Created by Gao on 14-9-30.
//  Copyright (c) 2014年 gao. All rights reserved.
//

#import "GKListDetailViewController.h"
#import "GKSpecialDetailViewController.h"
#import "GKVCMusicList.h"
#import "GKSpecialCell.h"
#import "GKNetDownloadTS.h"
#import "Reachability.h"
#import "CONST.h"
#import "UIImageView+WebCache.h"

@interface GKListDetailViewController ()

@end

@implementation GKListDetailViewController

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
    UIImageView *header = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 120)];
    //下载横幅
    NSString *bannerUrl = [_tModel.bannerUrl stringByReplacingOccurrencesOfString:@"/{size}/" withString:@"/"];
    [header setImageWithURL:[NSURL URLWithString:bannerUrl] placeholderImage:[UIImage imageNamed:@"yueku_banner_defaultBG.png"]];
    //尾视图
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 58)];
    footerView.backgroundColor = [UIColor whiteColor];
    
    /*创建tableView*/
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
    
    //加载数据
    [self loadData];
}

- (void)loadData
{
    _page++;
    _pagesize = 20;
    [self downloadDataWithUrl:SPECIALLIST(_tModel.categoryID, _page, _pagesize) andID:[NSString stringWithFormat:@"%@",_tModel.categoryID]];
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
        if ([ID isEqualToString:[NSString stringWithFormat:@"%@",_tModel.categoryID]]) {
            NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"下载专题分类成功!");
            [self parseDicData:dict];
        }
//        else {
//            for (GKSpecialTotalModel *model in _arrayData) {
//                if ([[NSString stringWithFormat:@"imgs%@",model.specialid] isEqualToString:ID]) {
//                    UIImage *image = [UIImage imageWithData:data];
//                    model.img = image;
//                    NSLog(@"专题分类图片%@下载完成 image = %@",ID,image);
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
        _model = [[GKSpecialTotalModel alloc] init];
        _model.specialid = [dicInfo objectForKey:@"specialid"];
        _model.specialname = [dicInfo objectForKey:@"specialname"];
        _model.singername = [dicInfo objectForKey:@"singername"];
        _model.intro = [dicInfo objectForKey:@"intro"];
        _model.publishtime = [dicInfo objectForKey:@"publishtime"];
        _model.imgurl = [dicInfo objectForKey:@"imgurl"];
        _model.suid = [dicInfo objectForKey:@"suid"];
        _model.slid = [dicInfo objectForKey:@"slid"];
        _model.playcount = [dicInfo objectForKey:@"playcount"];
        //添加数据源
        [_arrayData addObject:_model];
//        //下载图片
//        NSString *imageUrl = [_model.imgurl stringByReplacingOccurrencesOfString:@"/{size}/" withString:@"/"];
//        [self downloadDataWithUrl:imageUrl andID:[NSString stringWithFormat:@"imgs%@",_model.specialid]];
    }
}

#pragma mark - TableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (_arrayData.count+1)/2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GKSpecialCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SPECIAL"];
    if (!cell) {
        cell =  [[[NSBundle mainBundle] loadNibNamed:@"GKSpecialCell" owner:self options:nil] lastObject];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOne:)];
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOne:)];
        [cell.img1IV addGestureRecognizer:tap];
        if (_arrayData.count>(2*indexPath.row+1)) {
            [cell.img2IV addGestureRecognizer:tap1];
        }
    }
    GKSpecialTotalModel *model = _arrayData[2*indexPath.row];
    cell.model1 = model;
    //下载图片
    NSString *imageUrl = [model.imgurl stringByReplacingOccurrencesOfString:@"/{size}/" withString:@"/"];
    [cell.img1IV setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"rankinglist_defaultCover.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        model.img = image;
    }];

    if (_arrayData.count>(2*indexPath.row+1)) {
        GKSpecialTotalModel *model = _arrayData[2*indexPath.row+1];
        cell.model2 = model;
        //下载图片
        NSString *imageUrl = [model.imgurl stringByReplacingOccurrencesOfString:@"/{size}/" withString:@"/"];
        [cell.img2IV setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"rankinglist_defaultCover.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
            model.img = image;
        }];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 200;
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
    for (GKSpecialTotalModel *model in _arrayData) {
        if (model.img == iv.image) {
            GKSpecialDetailViewController *sdVC = [[GKSpecialDetailViewController alloc] init];
            sdVC.title = model.specialname;
            sdVC.image = model.img;
            sdVC.intro = model.intro;
            [[GKMainScrollViewController getMain] addVCBehindSuper:self withSub:sdVC];
            break;
        }
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
