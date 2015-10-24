//
//  GKListViewController.h
//  GKMusic
//
//  Created by qianfeng on 14-9-26.
//  Copyright (c) 2014年 gao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GKListBannersModel.h"
#import "GKListTotalModel.h"

@interface GKListViewController : UIViewController
<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
    NSMutableArray *_arrayData;
    NSMutableArray *_arrayBanner;
    
    GKListBannersModel *_banModel;
    GKListTotalModel *_listModel;
    
    NSMutableArray *_arrBanners;
    
    UIPageControl *_pageCtrl;
    
    NSTimer *_timer;
    
    UIScrollView *_sv;
    
    NSDate *_fireDate;
}

@end
