//
//  GKSingerCategoryViewController.m
//  GKMusic
//
//  Created by qianfeng on 14-10-10.
//  Copyright (c) 2014年 gao. All rights reserved.
//

#import "GKSingerCategoryViewController.h"
#import "GKSingerMusicViewController.h"
#import "GKVCMusicList.h"
#import "GKHotSingerCell.h"
#import "GKNetDownloadTS.h"
#import "Reachability.h"
#import "CONST.h"
#import "UIImageView+WebCache.h"

@interface GKSingerCategoryViewController ()

@end

@implementation GKSingerCategoryViewController

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
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = footerView;
    [self.view addSubview:_tableView];
    
    //初始化数据源
    _arrayData = [[NSMutableArray alloc] init];
    
    //加载数据
    [self loadData];
}

- (void)loadData
{
    [self downloadDataWithUrl:SINGERCAT(_type, _sextype) andID:@"SINGERCAT"];
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
        if ([ID isEqualToString:@"SINGERCAT"]) {
            NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"下载分类歌手成功!");
            [self parseDicData:dict];
        }
//        else {
//            _modelD = _arrayData[0];
//            for (GKSingerModel *model in _modelD.arrData) {
//                if ([[NSString stringWithFormat:@"iconhot%@",model.singerid] isEqualToString:ID]) {
//                    UIImage *image = [UIImage imageWithData:data];
//                    model.img = image;
//                    NSLog(@"热门歌手图片%@下载完成 image = %@",ID,image);
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
    NSDictionary *dicFir = arrInfo[0];
    _modelD = [[GKSingerDetailModel alloc] init];
    _modelD.title = [dicFir objectForKey:@"title"];//热门
    _modelD.singer = [dicFir objectForKey:@"singer"];//8个热门歌手
    _modelD.arrData = [[NSMutableArray alloc] init];
    for (NSDictionary *dicInfo in _modelD.singer) {
        _model = [[GKSingerModel alloc] init];
        _model.singerid = [dicInfo objectForKey:@"singerid"];
        _model.singername = [dicInfo objectForKey:@"singername"];
        _model.intro = [dicInfo objectForKey:@"intro"];
        _model.songcount = [dicInfo objectForKey:@"songcount"];
        _model.albumcount = [dicInfo objectForKey:@"albumcount"];
        _model.mvcount = [dicInfo objectForKey:@"mvcount"];
        _model.imgurl = [dicInfo objectForKey:@"imgurl"];
        //添加数据
        [_modelD.arrData addObject:_model];
//        //下载图片
//        NSString *imageUrl = [_model.imgurl stringByReplacingOccurrencesOfString:@"{size}" withString:@"240"];
//        [self downloadDataWithUrl:imageUrl andID:[NSString stringWithFormat:@"iconhot%@",_model.singerid]];
    }
    //添加数据源
    [_arrayData addObject:_modelD];
    for (int i = 1;i < arrInfo.count;i++) {
        NSDictionary *dicInfo = arrInfo[i];
        _modelD = [[GKSingerDetailModel alloc] init];
        _modelD.title = [dicInfo objectForKey:@"title"];
        _modelD.singer = [dicInfo objectForKey:@"singer"];
        _modelD.arrData = [[NSMutableArray alloc] init];
        for (NSDictionary *dicDetail in _modelD.singer) {
            _model = [[GKSingerModel alloc] init];
            _model.singerid = [dicDetail objectForKey:@"singerid"];
            _model.singername = [dicDetail objectForKey:@"singername"];
            _model.songcount = [dicDetail objectForKey:@"songcount"];
            _model.albumcount = [dicDetail objectForKey:@"albumcount"];
            _model.mvcount = [dicDetail objectForKey:@"mvcount"];
            //添加数据源
            [_modelD.arrData addObject:_model];
        }
        //添加数据源
        [_arrayData addObject:_modelD];
    }
}

#pragma mark - TableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _arrayData.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    _modelD = _arrayData[section];
    return _modelD.arrData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        GKHotSingerCell *cell = [tableView dequeueReusableCellWithIdentifier:nil];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"GKHotSingerCell" owner:self options:nil] lastObject];
            NSArray *array = [NSArray arrayWithObjects:cell.IV1,cell.IV2,cell.IV3,cell.IV4,cell.IV5,cell.IV6,cell.IV7,cell.IV8, nil];
            for (int i = 0; i < 8; i++) {
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOne:)];
                [array[i] addGestureRecognizer:tap];
            }
        }
        _modelD = _arrayData[0];
        cell.modelD = _modelD;
        int i = 0;
        for (GKSingerModel *model in _modelD.arrData) {
            UIImageView *iv = (UIImageView *)[cell.contentView viewWithTag:20+i];
            //下载图片
            NSString *imageUrl = [model.imgurl stringByReplacingOccurrencesOfString:@"{size}" withString:@"240"];
            [iv setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"rankinglist_defaultCover.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                model.img = image;
            }];
            i++;
        }
        
        return cell;
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CELL"];
    }
    _modelD = _arrayData[indexPath.section];
    _model = _modelD.arrData[indexPath.row];
    cell.textLabel.text = _model.singername;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 200;
    }
    return 50;
}

#pragma mark - TableViewDelegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"select!");
    if (indexPath.section == 0) {
        return;
    }
    GKSingerMusicViewController *smVC = [[GKSingerMusicViewController alloc] init];
    _modelD = _arrayData[indexPath.section];
    _model = _modelD.arrData[indexPath.row];
    smVC.tModel = _model;
    smVC.title = _model.singername;
    [[GKMainScrollViewController getMain] addVCBehindSuper:self withSub:smVC];
}

- (void)tapOne:(UIGestureRecognizer *)tap
{
    UIImageView *iv = (UIImageView *)tap.view;
    _modelD = _arrayData[0];
    for (GKSingerModel *model in _modelD.arrData) {
        if (model.img == iv.image) {
            GKSingerMusicViewController *smVC = [[GKSingerMusicViewController alloc] init];
            smVC.title = model.singername;
            smVC.tModel = model;
            [[GKMainScrollViewController getMain] addVCBehindSuper:self withSub:smVC];
            break;
        }
    }
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

//索引数组
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    NSMutableArray *arrayIndex = [[NSMutableArray alloc] init];
    for (GKSingerDetailModel *modelD in _arrayData) {
        [arrayIndex addObject:modelD.title];
    }
    return arrayIndex;
}

//索引值
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    return index;
}

//头视图标题
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    GKSingerDetailModel *modelD = _arrayData[section];
    return modelD.title;
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
