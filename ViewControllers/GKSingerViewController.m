//
//  GKSingerViewController.m
//  GKMusic
//
//  Created by qianfeng on 14-10-10.
//  Copyright (c) 2014年 gao. All rights reserved.
//

#import "GKSingerViewController.h"
#import "GKSingerCategoryViewController.h"
#import "GKSingerMusicViewController.h"
#import "GKVCMusicList.h"
#import "UIImage+UIImageExtras.h"
#import "GKNetDownloadTS.h"
#import "GKSingerCell.h"
#import "Reachability.h"
#import "CONST.h"
#import "UIImageView+WebCache.h"

@interface GKSingerViewController ()

@end

@implementation GKSingerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        _type = 1;
        D1 = NO;
        D2 = NO;
        D3 = NO;
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
    
    /*头视图*/
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, 320, 170)];
    
    _segCtrl = [[UISegmentedControl alloc] initWithFrame:CGRectMake(10, 10, 300, 30)];
    [_segCtrl insertSegmentWithTitle:@"华语" atIndex:0 animated:NO];
    [_segCtrl insertSegmentWithTitle:@"欧美" atIndex:1 animated:NO];
    [_segCtrl insertSegmentWithTitle:@"日韩" atIndex:2 animated:NO];
    [_segCtrl addTarget:self action:@selector(segmentChange:) forControlEvents:UIControlEventValueChanged];
    _segCtrl.selectedSegmentIndex = 0;
    [headerView addSubview:_segCtrl];
    
    //男
    _btnMale = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _btnMale.frame = CGRectMake(35, 55, 50, 50);
    _btnMale.titleLabel.font = [UIFont systemFontOfSize:12];
    _btnMale.tintColor = [UIColor whiteColor];
    _btnMale.layer.cornerRadius = 25;
    _btnMale.backgroundColor = [UIColor colorWithRed:0.299 green:0.769 blue:1.000 alpha:1.000];
    UIImage *imageMale = [UIImage imageNamed:@"singer_male"];
    imageMale = [imageMale imageByScalingToSize:CGSizeMake(100, 120)];
    [_btnMale setImage:imageMale forState:UIControlStateNormal];
    [_btnMale setTitle:@"男" forState:UIControlStateNormal];
    _btnMale.imageEdgeInsets = UIEdgeInsetsMake(-5, 5, 0, 0);
    _btnMale.titleEdgeInsets = UIEdgeInsetsMake(25, -100, 0, 0);
    [_btnMale addTarget:self action:@selector(pressMale) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:_btnMale];
    
    //女
    _btnFemale = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _btnFemale.frame = CGRectMake(135, 55, 50, 50);
    _btnFemale.titleLabel.font = [UIFont systemFontOfSize:12];
    _btnFemale.tintColor = [UIColor whiteColor];
    _btnFemale.layer.cornerRadius = 25;
    _btnFemale.backgroundColor = [UIColor colorWithRed:1.000 green:0.000 blue:0.165 alpha:1.000];
    UIImage *imageFemale = [UIImage imageNamed:@"singer_female"];
    imageFemale = [imageFemale imageByScalingToSize:CGSizeMake(100, 120)];
    [_btnFemale setImage:imageFemale forState:UIControlStateNormal];
    [_btnFemale setTitle:@"女" forState:UIControlStateNormal];
    _btnFemale.imageEdgeInsets = UIEdgeInsetsMake(-5, 0, 0, 0);
    _btnFemale.titleEdgeInsets = UIEdgeInsetsMake(25, -100, 0, 0);
    [_btnFemale addTarget:self action:@selector(pressFemale) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:_btnFemale];
    
    //组合
    _btnGroup = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _btnGroup.frame = CGRectMake(235, 55, 50, 50);
    _btnGroup.titleLabel.font = [UIFont systemFontOfSize:12];
    _btnGroup.tintColor = [UIColor whiteColor];
    _btnGroup.layer.cornerRadius = 25;
    _btnGroup.backgroundColor = [UIColor colorWithRed:0.000 green:0.731 blue:0.012 alpha:1.000];
    UIImage *imageGroup = [UIImage imageNamed:@"singer_group.png"];
    imageGroup = [imageGroup imageByScalingToSize:CGSizeMake(100, 120)];
    [_btnGroup setImage:imageGroup forState:UIControlStateNormal];
    [_btnGroup setTitle:@"组合" forState:UIControlStateNormal];
    _btnGroup.imageEdgeInsets = UIEdgeInsetsMake(-5, 3, 0, 0);
    _btnGroup.titleEdgeInsets = UIEdgeInsetsMake(25, -100, 0, 0);
    [_btnGroup addTarget:self action:@selector(pressGroup) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:_btnGroup];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn.frame = CGRectMake(15, 135, 60, 20);
    [btn setTitle:@"人气歌手" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    btn.userInteractionEnabled = NO;
    [headerView addSubview:btn];
    
    //尾视图
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 58)];
    footerView.backgroundColor = [UIColor whiteColor];
    
    //创建tableView
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
    if (_type == 1) {
        if (D1) {
            _arrayData = [NSMutableArray arrayWithArray:_arrayCH];
            //刷新数据视图
            [_tableView reloadData];
            return;
        }
    }
    else if (_type == 2) {
        if (D2) {
            _arrayData = [NSMutableArray arrayWithArray:_arrayAM];
            //刷新数据视图
            [_tableView reloadData];
            return;
        }
    }
    else {
        if (D3) {
            _arrayData = [NSMutableArray arrayWithArray:_arrayJK];
            //刷新数据视图
            [_tableView reloadData];
            return;
        }
    }
    [self downloadDataWithUrl:SINGER(_type) andID:[NSString stringWithFormat:@"SINGER%d",_type]];
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
        if ([[ID substringToIndex:6] isEqualToString:@"SINGER"]) {
            NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"下载歌手成功!");
            _arrayData = [[NSMutableArray alloc] init];
            [self parseDicData:dict];
            switch ([[ID substringFromIndex:6] intValue]) {
                case 1: D1 = YES; _arrayCH = [NSArray arrayWithArray:_arrayData]; break;
                case 2: D2 = YES; _arrayAM = [NSArray arrayWithArray:_arrayData]; break;
                case 3: D3 = YES; _arrayJK = [NSArray arrayWithArray:_arrayData]; break;
            }
        }
//        else {
//            for (GKSingerModel *model in _arrayData) {
//                if ([[NSString stringWithFormat:@"icon%@",model.singerid] isEqualToString:ID]) {
//                    UIImage *image = [UIImage imageWithData:data];
//                    model.img = image;
//                    NSLog(@"歌手图片%@下载完成 image = %@",ID,image);
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
        _model = [[GKSingerModel alloc] init];
        _model.singerid = [dicInfo objectForKey:@"singerid"];
        _model.singername = [dicInfo objectForKey:@"singername"];
        _model.intro = [dicInfo objectForKey:@"intro"];
        _model.songcount = [dicInfo objectForKey:@"songcount"];
        _model.albumcount = [dicInfo objectForKey:@"albumcount"];
        _model.mvcount = [dicInfo objectForKey:@"mvcount"];
        _model.imgurl = [dicInfo objectForKey:@"imgurl"];
        //添加数据源
        [_arrayData addObject:_model];
//        //下载图片
//        NSString *imageUrl = [_model.imgurl stringByReplacingOccurrencesOfString:@"{size}" withString:@"400"];
//        [self downloadDataWithUrl:imageUrl andID:[NSString stringWithFormat:@"icon%@",_model.singerid]];
    }
}

#pragma mark - TableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _arrayData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GKSingerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SINGER"];
    if (!cell) {
        cell =  [[[NSBundle mainBundle] loadNibNamed:@"GKSingerCell" owner:self options:nil] lastObject];
    }
    GKSingerModel *model = _arrayData[indexPath.row];
    cell.model = model;
    //下载图片
    NSString *imageUrl = [model.imgurl stringByReplacingOccurrencesOfString:@"{size}" withString:@"400"];
    [cell.iconIV setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"rankinglist_defaultCover.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        model.img = image;
    }];

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
    GKSingerMusicViewController *smVC = [[GKSingerMusicViewController alloc] init];
    _model = _arrayData[indexPath.row];
    smVC.tModel = _model;
    smVC.title = _model.singername;
    [[GKMainScrollViewController getMain] addVCBehindSuper:self withSub:smVC];
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

#pragma mark - UISegmentedControl Change Methods

- (void)segmentChange:(UISegmentedControl *)segCtrl
{
    _type = segCtrl.selectedSegmentIndex+1;
    [self loadData];
}

#pragma mark - TopButton Press Methods

- (void)pressMale
{
    GKSingerCategoryViewController *scVC = [[GKSingerCategoryViewController alloc] init];
    scVC.type = _type;
    scVC.sextype = 1;
    NSArray *array = @[@"华语",@"欧美",@"日韩"];
    scVC.title = [NSString stringWithFormat:@"%@男歌手",array[_type-1]];
    [[GKMainScrollViewController getMain] addVCBehindSuper:self withSub:scVC];
}

- (void)pressFemale
{
    GKSingerCategoryViewController *scVC = [[GKSingerCategoryViewController alloc] init];
    scVC.type = _type;
    scVC.sextype = 2;
    NSArray *array = @[@"华语",@"欧美",@"日韩"];
    scVC.title = [NSString stringWithFormat:@"%@女歌手",array[_type-1]];
    [[GKMainScrollViewController getMain] addVCBehindSuper:self withSub:scVC];
}

- (void)pressGroup
{
    GKSingerCategoryViewController *scVC = [[GKSingerCategoryViewController alloc] init];
    scVC.type = _type;
    scVC.sextype = 3;
    NSArray *array = @[@"华语",@"欧美",@"日韩"];
    scVC.title = [NSString stringWithFormat:@"%@组合",array[_type-1]];
    [[GKMainScrollViewController getMain] addVCBehindSuper:self withSub:scVC];
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
