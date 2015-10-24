//
//  GKSingerViewController.h
//  GKMusic
//
//  Created by qianfeng on 14-10-10.
//  Copyright (c) 2014年 gao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GKSingerModel.h"

@interface GKSingerViewController : UIViewController
<UITableViewDelegate,UITableViewDataSource>
{
    UISegmentedControl *_segCtrl;
    
    UIButton *_btnMale;
    UIButton *_btnFemale;
    UIButton *_btnGroup;
    
    UITableView *_tableView;
    NSMutableArray *_arrayData;
    
    NSArray *_arrayCH;
    NSArray *_arrayAM;
    NSArray *_arrayJK;
    
    GKSingerModel *_model;
    
    int _type;
    BOOL D1;
    BOOL D2;
    BOOL D3;
}

@end
