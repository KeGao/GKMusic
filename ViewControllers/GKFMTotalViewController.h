//
//  GKFMTotalViewController.h
//  GKMusic
//
//  Created by qianfeng on 14-10-9.
//  Copyright (c) 2014年 gao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GKRadioTotalModel.h"

@interface GKFMTotalViewController : UIViewController
<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
    NSMutableArray *_arrayData;
    NSMutableArray *_arrayData1;
    
    GKRadioTotalModel *_model;
    
    int _lastBtn;
}

@end
