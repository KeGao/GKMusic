//
//  GKRankViewController.m
//  GKMusic
//
//  Created by qianfeng on 14-9-25.
//  Copyright (c) 2014年 gao. All rights reserved.
//

#import "GKRankViewController.h"
#import "GKRankDetailViewController.h"
#import "GKVCMusicList.h"
#import "GKNetDownloadTS.h"
#import "GKYuekuCommonCell.h"
#import "Reachability.h"
#import "CONST.h"
#import "UIImageView+WebCache.h"

@interface GKRankViewController ()

@end

@implementation GKRankViewController

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
    
    //尾视图
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 58)];
    footerView.backgroundColor = [UIColor whiteColor];
    
    //创建tableView
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, 320, 568-64) style:UITableViewStylePlain];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.allowsSelection = NO;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = footerView;
    [self.view addSubview:_tableView];
    
    //初始化数据源
    _arrayData = [[NSMutableArray alloc] init];
    
    //加载数据
    [self downloadDataWithUrl:RANKTOTAL andID:@"RANKTOTAL"];
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
        if ([ID isEqualToString:@"RANKTOTAL"]) {
            NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"下载排行成功!");
            [self parseDicData:dict];
        }
//        else {
//            for (GKRankTotalModel *model in _arrayData) {
//                if ([[NSString stringWithFormat:@"img%@",model.rankID] isEqualToString:ID]) {
//                    UIImage *image = [UIImage imageWithData:data];
//                    model.img = image;
//                    NSLog(@"排行图片%@下载完成 image = %@",ID,image);
//                    break;
//                }
//                if ([[NSString stringWithFormat:@"bnr%@",model.rankID] isEqualToString:ID]) {
//                    UIImage *banner = [UIImage imageWithData:data];
//                    model.banner = banner;
//                    NSLog(@"排行横幅%@下载完成 banner = %@",ID,banner);
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
        _model = [[GKRankTotalModel alloc] init];
        _model.rankID = [dicInfo objectForKey:@"rankid"];
        _model.rankName = [dicInfo objectForKey:@"rankname"];
        _model.rankType = [dicInfo objectForKey:@"ranktype"];
        _model.introduce = [dicInfo objectForKey:@"intro"];
        _model.imgUrl = [dicInfo objectForKey:@"imgurl"];
        _model.bannerUrl = [dicInfo objectForKey:@"bannerurl"];
        _model.banner7Url = [dicInfo objectForKey:@"banner7url"];
        //添加数据源
        [_arrayData addObject:_model];
//        //下载图片
//        NSString *imageUrl = [_model.imgUrl stringByReplacingOccurrencesOfString:@"/{size}/" withString:@"/"];
//        [self downloadDataWithUrl:imageUrl andID:[NSString stringWithFormat:@"img%@",_model.rankID]];
//        //下载横幅
//        NSString *bannerUrl = [_model.bannerUrl stringByReplacingOccurrencesOfString:@"/{size}/" withString:@"/"];
//        [self downloadDataWithUrl:bannerUrl andID:[NSString stringWithFormat:@"bnr%@",_model.rankID]];
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
    GKRankTotalModel *model = _arrayData[2*indexPath.row];
    cell.modelr1 = model;
    cell.playIV1.image = nil;
    //下载图片
    NSString *imageUrl = [model.imgUrl stringByReplacingOccurrencesOfString:@"/{size}/" withString:@"/"];
    [cell.img1IV setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"rankinglist_defaultCover.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        model.img = image;
        cell.playIV1.image = [UIImage imageNamed:@"radarPlay.png"];
    }];
    if (_arrayData.count>(2*indexPath.row+1)) {
        GKRankTotalModel *model = _arrayData[2*indexPath.row+1];
        cell.modelr2 = model;
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
    for (GKRankTotalModel *model in _arrayData) {
        if (model.img == iv.image) {
            GKRankDetailViewController *rdVC = [[GKRankDetailViewController alloc] init];
            rdVC.title = model.rankName;
            rdVC.tModel = model;
            [[GKMainScrollViewController getMain] addVCBehindSuper:self withSub:rdVC];
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
