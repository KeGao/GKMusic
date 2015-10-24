//
//  GKMusicLibraryViewController.h
//  GKMusic
//
//  Created by qianfeng on 14-9-24.
//  Copyright (c) 2014年 gao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GKYuekuCommonModel.h"

@interface GKMusicLibraryViewController : UIViewController
<UITableViewDelegate,UITableViewDataSource>
{
    UIButton *_btnRank;
    UIButton *_btnList;
    UIButton *_btnRadio;
    
    UITableView *_tableView;
    NSMutableArray *_arrayData;
    
    GKYuekuCommonModel *_model;
}

@end
