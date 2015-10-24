//
//  GKSingerMusicViewController.h
//  GKMusic
//
//  Created by qianfeng on 14-10-12.
//  Copyright (c) 2014年 gao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GKSingerModel.h"
#import "GKSingerMusicModel.h"
#import "GKSingerAlbumModel.h"
#import "GKSingerMVModel.h"
#import "GKWaitingAnimationView.h"

@interface GKSingerMusicViewController : UIViewController
<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
    NSMutableArray *_arrayData;
    NSMutableArray *_arrayData2;
    NSMutableArray *_arrayData3;
    
    GKSingerMusicModel *_model;
    GKSingerAlbumModel *_model2;
    GKSingerMVModel *_model3;
    
    UISegmentedControl *_segCtrl;
    
    NSInteger _page;
    NSInteger _pagesize;
    
    UIView *_viewbg;
    // tableView类型 1:单曲 2:专辑 3:MV
    int _type;
    BOOL _arrD1;
    BOOL _arrD2;
    BOOL _arrD3;
    
    UIView *_headerView1;
    UIView *_headerView2;
    
    UIImage *_icon;
    
    NSString *_filename;
    NSString *_fileSize;
    
    GKWaitingAnimationView *_waitView;
}

@property (retain, nonatomic) GKSingerModel *tModel;

@end
