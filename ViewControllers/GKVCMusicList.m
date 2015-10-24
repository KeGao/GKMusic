//
//  GKVCMusicList.m
//  AudioPlayer
//
//  Created by Gao on 14-9-14.
//  Copyright (c) 2014年 gao. All rights reserved.
//

#import "GKVCMusicList.h"
#import "GKPlayBoxViewController.h"
#import "CONST.h"

@interface GKVCMusicList ()

@end

@implementation GKVCMusicList

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        _arrData = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    /*创建自定义导航栏*/
    UIView *navView = [[GKMainScrollViewController getMain] createCustomNavigationBarWithTitle:self.title];

    GKPlayBoxViewController *pbVC = [GKPlayBoxViewController shared];
//    [pbVC readData];  //会readMusic 导致中断音乐播放 其实这个时候已经readData过了 数组中有值
    _arrData = pbVC.arraySongs;
    
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

    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 104, 320, 406) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    [self.view addSubview:_tableView];
    
    _arrayData = [[NSMutableArray alloc] init];
    for (int i = 0; i < _arrData.count; i++) {
        NSString *str = [NSString stringWithFormat:@"%d. %@",i+1,_arrData[i]];
        [_arrayData addObject:str];
    }
    
    //创建搜索栏对象
    _searchBar = [[UISearchBar alloc] init];
    //搜索栏位置
    _searchBar.frame = CGRectMake(0, 64, 320, 40);
    //设置搜索栏代理
    _searchBar.delegate = self;
    _searchBar.showsCancelButton = YES;
    [self.view addSubview:_searchBar];
    
    isSearch = NO;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (isSearch) {
        return 1;
    }
    return _arrayData.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //返回搜索结果的个数
    if (isSearch) {
        return _arrayResult.count;
    }
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"strID"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"strID"];
    }
    NSString *str = nil;
    if (isSearch) {
        str = [_arrayResult objectAtIndex:indexPath.row];
    }
    else {
        str = [_arrayData objectAtIndex:indexPath.section];
    }
    cell.textLabel.text = str;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *str = nil;
    if (isSearch) {
        str = _arrayResult[indexPath.row];
    }
    else {
        str = _arrayData[indexPath.section];
    }
    NSString *str1 = [str substringToIndex:[str rangeOfString:@"."].location];
    GKPlayBoxViewController *pbVC = [GKPlayBoxViewController shared];
    [[GKMainScrollViewController getMain] showPlayBox];
    pbVC.index = [str1 integerValue]-1;
    [pbVC stop];
    [pbVC readMusic];
    [pbVC play];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if (!isSearch) {
        NSMutableArray *arrayIndex = [[NSMutableArray alloc] init];
        for (int i = 1; i <= _arrayData.count ; i+=5) {
            NSString *str = [NSString stringWithFormat:@"%d",i];
            [arrayIndex addObject:str];
        }
        
        return arrayIndex;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    return [title integerValue]-1;
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    NSLog(@"已经开始搜索编辑!");
    //开启搜索状态
    isSearch = YES;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    NSLog(@"已经结束搜索!");
    //关闭搜索状态
//    isSearch = NO;   //这里不能关闭 页面加载单元格会在键盘收回后执行,如果变成NO加载单元格会出错
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    //收回键盘
    [_searchBar resignFirstResponder];
}

//当点击取消按钮时调用此函数
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    isSearch = NO;
    _searchBar.text = nil;
    [_searchBar resignFirstResponder];
    [_tableView reloadData];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    NSString *strFind = searchText;
    //初始化结果数组
    _arrayResult = [[NSMutableArray alloc] init];
    
    for (NSString *strContent in _arrayData) {
        //从一个字符串中查找是否包含另外一个子字符串
        //返回值的范围为range
        NSRange range = [strContent rangeOfString:strFind];
        //如果包含子串,范围有效
        //length != 0,子串的长度不为0;
        //length == 0,没有找到与子串相同的子串
        if (range.length == 0) {
            
        }
        else{
            [_arrayResult addObject:strContent];
        }
    }
    [_tableView reloadData];
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
