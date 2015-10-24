//
//  GKFMTotalViewController.m
//  GKMusic
//
//  Created by qianfeng on 14-10-9.
//  Copyright (c) 2014年 gao. All rights reserved.
//

#import "GKFMTotalViewController.h"
#import "GKFMDetailViewController.h"
#import "GKVCMusicList.h"
#import "GKNetDownloadTS.h"
#import "GKYuekuCommonCell.h"
#import "Reachability.h"
#import "CONST.h"
#import "UIImageView+WebCache.h"

@interface GKFMTotalViewController ()

@end

@implementation GKFMTotalViewController

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
    
    //创建顶部按钮
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, 320, 41)];
    scrollView.contentSize = CGSizeMake(640, 41);
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.backgroundColor = [UIColor whiteColor];
    scrollView.scrollsToTop = NO;
    [self.view addSubview:scrollView];
    
    NSArray *arrayBtns = @[@"全部",@"主题",@"名人",@"场景",@"年代",@"心情",@"特色",@"语言",@"风格",@"有声",@"最近"];
    
    for (int i = 0; i < 11; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        btn.frame = CGRectMake(7+57*i, 11, 57, 22);
        btn.layer.cornerRadius = 3;
        [btn setTitle:arrayBtns[i] forState:UIControlStateNormal];
        [btn setTintColor:[UIColor blackColor]];
        btn.tag = 100+i;
        [btn addTarget:self action:@selector(pressBtn:) forControlEvents:UIControlEventTouchUpInside];
        if (i == 0) {
            btn.backgroundColor = [UIColor colorWithRed:0.236 green:0.443 blue:0.841 alpha:1.000];
            btn.titleLabel.textColor = [UIColor whiteColor];
            _lastBtn = 100;
        }
        [scrollView addSubview:btn];
    }

    //尾视图
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 58)];
    footerView.backgroundColor = [UIColor whiteColor];

    //创建tableView
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 105, 320, 568-105) style:UITableViewStylePlain];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.allowsSelection = NO;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = footerView;
    [self.view addSubview:_tableView];
    
    //初始化数据源
    _arrayData = [[NSMutableArray alloc] init];

    //加载数据
    [self downloadDataWithUrl:FMALL andID:@"FMALL"];
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
    static int c = 0;
    c++;
    NSLog(@"c = %d",c);
    GKNetDownloadTS *dw = [[GKNetDownloadTS alloc] init];
    [dw downloadURL:url withID:ID complete:^(NSData *data, NSString *ID) {
        if ([ID isEqualToString:@"FMALL"]) {
            NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"下载电台成功!");
            [self parseDicData:dict];
        }
//        else {
//            for (GKRadioTotalModel *model in _arrayData1) {
//                if ([[NSString stringWithFormat:@"imgfm%@",model.fmid] isEqualToString:ID]) {
//                    UIImage *image = [UIImage imageWithData:data];
//                    model.img = image;
//                    NSLog(@"电台图片%@下载完成 image = %@",ID,image);
//                    static int d = 0;
//                    d++;
//                    NSLog(@"d = %d",d);
//                    break;
//                }
//                if ([[NSString stringWithFormat:@"bnrfm%@",model.fmid] isEqualToString:ID]) {
//                    UIImage *banner = [UIImage imageWithData:data];
//                    model.banner = banner;
//                    NSLog(@"电台横幅%@下载完成 banner = %@",ID,banner);
//                    static int e = 0;
//                    e++;
//                    NSLog(@"e = %d",e);
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
    //获得列表数组
    NSArray *arrData = [dic objectForKey:@"data"];
    for (NSDictionary *dicInfo in arrData) {
        _model = [[GKRadioTotalModel alloc] init];
        _model.fmid = [dicInfo objectForKey:@"fmid"];
        _model.fmname = [dicInfo objectForKey:@"fmname"];
        _model.classid = [dicInfo objectForKey:@"classid"];
        _model.classname = [dicInfo objectForKey:@"classname"];
        _model.fmtype = [dicInfo objectForKey:@"fmtype"];
        _model.heat = [dicInfo objectForKey:@"heat"];
        _model.imgurl = [dicInfo objectForKey:@"imgurl"];
        _model.bannerurl = [dicInfo objectForKey:@"banner"];
        _model.description = [dicInfo objectForKey:@"description"];
        _model.isnew = [dicInfo objectForKey:@"isnew"];
        _model.addtime = [dicInfo objectForKey:@"addtime"];
        //添加数据源
        [_arrayData addObject:_model];
//        if (_arrayData.count < 600) {
//            //下载图片
//            NSString *imageUrl = [_model.imgurl stringByReplacingOccurrencesOfString:@"/{size}/" withString:@"/"];
//            [self downloadDataWithUrl:imageUrl andID:[NSString stringWithFormat:@"imgfm%@",_model.fmid]];
//            //下载横幅
//            NSString *bannerUrl = [_model.bannerurl stringByReplacingOccurrencesOfString:@"/{size}/" withString:@"/"];
//            [self downloadDataWithUrl:bannerUrl andID:[NSString stringWithFormat:@"bnrfm%@",_model.fmid]];
//        }
    }
    _arrayData1 = [NSMutableArray arrayWithArray:_arrayData];
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
    GKRadioTotalModel *model = _arrayData[2*indexPath.row];
    cell.modelfm1 = model;
    cell.playIV1.image = nil;
    //下载图片
    NSString *imageUrl = [model.imgurl stringByReplacingOccurrencesOfString:@"/{size}/" withString:@"/"];
    [cell.img1IV setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"rankinglist_defaultCover.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        model.img = image;
        cell.playIV1.image = [UIImage imageNamed:@"radarPlay.png"];
    }];
    if (_arrayData.count>(2*indexPath.row+1)) {
        GKRadioTotalModel *model = _arrayData[2*indexPath.row+1];
        cell.modelfm2 = model;
        cell.playIV.image = nil;
        //下载图片
        NSString *imageUrl = [model.imgurl stringByReplacingOccurrencesOfString:@"/{size}/" withString:@"/"];
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
    for (GKRadioTotalModel *model in _arrayData) {
        if (model.img == iv.image) {
            GKFMDetailViewController *fmVC = [[GKFMDetailViewController alloc] init];
            fmVC.title = model.fmname;
            fmVC.tModel = model;
            [[GKMainScrollViewController getMain] addVCBehindSuper:self withSub:fmVC];
            break;
        }
    }
    NSLog(@"tap image!");
}

- (void)pressBtn:(UIButton *)btn
{
    UIButton *lastBtn = (UIButton *)[self.view viewWithTag:_lastBtn];
    lastBtn.backgroundColor = [UIColor clearColor];
    lastBtn.titleLabel.textColor = [UIColor blackColor];
    btn.backgroundColor = [UIColor colorWithRed:0.269 green:0.505 blue:0.958 alpha:1.000];
    btn.titleLabel.textColor = [UIColor whiteColor];
    btn.tintColor = [UIColor whiteColor];
    _lastBtn = btn.tag;
    
    NSArray *arrClassid = @[@"7",@"11",@"6",@"5",@"4",@"1",@"3",@"2",@"12"];
    
    _arrayData = [NSMutableArray arrayWithArray:_arrayData1];
    if (btn.tag != 100 && btn.tag != 110) {
        for (GKRadioTotalModel *model in _arrayData1) {
            if (![[NSString stringWithFormat:@"%@",model.classid] isEqualToString:arrClassid[btn.tag-101]]) {
                [_arrayData removeObject:model];
            }
        }
    }
    else if (btn.tag == 110) {
        [_arrayData removeAllObjects];
        for (GKRadioTotalModel *model in _arrayData1) {
            [_arrayData addObject:model];
            if (_arrayData.count == 2) {
                break;
            }
        }
    }
    
    [_tableView reloadData];
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
