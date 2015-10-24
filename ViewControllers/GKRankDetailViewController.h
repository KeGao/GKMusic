//
//  GKRankDetailViewController.h
//  GKMusic
//
//  Created by qianfeng on 14-9-25.
//  Copyright (c) 2014年 gao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GKRankDetailModel.h"
#import "GKRankTotalModel.h"

@interface GKRankDetailViewController : UIViewController
<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
    NSMutableArray *_arrayData;
    
    GKRankDetailModel *_model;
    
    NSInteger _page;
    NSInteger _pagesize;
    
    NSString *_filename;
    NSString *_fileSize;
}

//排行总榜数据源
@property (retain, nonatomic) GKRankTotalModel *tModel;

@end
