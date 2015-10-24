//
//  GKSingerCategoryViewController.h
//  GKMusic
//
//  Created by qianfeng on 14-10-10.
//  Copyright (c) 2014年 gao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GKSingerModel.h"
#import "GKSingerDetailModel.h"

@interface GKSingerCategoryViewController : UIViewController
<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
    NSMutableArray *_arrayData;
    
    GKSingerModel *_model;
    GKSingerDetailModel *_modelD;
}

@property (assign, nonatomic) int type;
@property (assign, nonatomic) int sextype;

@end
