//
//  GKFMDetailViewController.h
//  GKMusic
//
//  Created by qianfeng on 14-10-9.
//  Copyright (c) 2014年 gao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GKRadioTotalModel.h"
#import "GKFMDetailModel.h"

@interface GKFMDetailViewController : UIViewController
<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
    NSMutableArray *_arrayData;
    
    GKFMDetailModel *_model;
    
    NSString *_offset;
    
    NSString *_filename;
    NSString *_fileSize;
}

//电台总数据源
@property (retain, nonatomic) GKRadioTotalModel *tModel;

@end
