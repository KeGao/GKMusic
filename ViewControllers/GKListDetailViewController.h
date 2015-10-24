//
//  GKListDetailViewController.h
//  GKMusic
//
//  Created by Gao on 14-9-30.
//  Copyright (c) 2014年 gao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GKSpecialTotalModel.h"
#import "GKListTotalModel.h"

@interface GKListDetailViewController : UIViewController
<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
    NSMutableArray *_arrayData;
    
    GKSpecialTotalModel *_model;
    
    NSInteger _page;
    NSInteger _pagesize;
}

//歌单总分类数据源
@property (retain, nonatomic) GKListTotalModel *tModel;


@end
