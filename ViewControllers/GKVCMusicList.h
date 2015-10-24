//
//  GKVCMusicList.h
//  AudioPlayer
//
//  Created by Gao on 14-9-14.
//  Copyright (c) 2014年 gao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GKVCMusicList : UIViewController
<UITableViewDelegate,UITableViewDataSource,
UISearchBarDelegate>
{
    UITableView *_tableView;
    
    //搜索栏对象
    UISearchBar *_searchBar;
    //搜索结果
    NSMutableArray *_arrayResult;
    //当前状态是否为搜索状态
    BOOL isSearch;
    
    NSMutableArray *_arrayData;
    
}

@property (retain, nonatomic)  NSMutableArray *arrData;


@end
