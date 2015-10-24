//
//  GKRankViewController.h
//  GKMusic
//
//  Created by qianfeng on 14-9-25.
//  Copyright (c) 2014年 gao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GKRankTotalModel.h"

@interface GKRankViewController : UIViewController
<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
    NSMutableArray *_arrayData;
    
    GKRankTotalModel *_model;
}

@end
