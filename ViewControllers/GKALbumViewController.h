//
//  GKALbumViewController.h
//  GKMusic
//
//  Created by qianfeng on 14-10-15.
//  Copyright (c) 2014年 gao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GKSingerMusicModel.h"
#import "GKSingerAlbumModel.h"

@interface GKALbumViewController : UIViewController
<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
    NSMutableArray *_arrayData;
    
    GKSingerMusicModel *_model;
    UIImageView *_header;
    UIImageView *_icon;
    UILabel *_name;
    UILabel *_intro;
    UIView *_viewbg;
    
    NSString *_filename;
    NSString *_fileSize;
}

@property (retain, nonatomic) GKSingerAlbumModel *tModel;
@property (retain, nonatomic) UIImage *singericon;

@end
