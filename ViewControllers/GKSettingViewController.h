//
//  GKSettingViewController.h
//  GKMusic
//
//  Created by qianfeng on 14-10-15.
//  Copyright (c) 2014年 gao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GKSettingViewController : UIViewController
<UITableViewDataSource, UITableViewDelegate>
{
    UIView *_navView;
    UITableView *_tableView;
    
    NSDictionary *_dicData;
    NSArray *_arKey;
}

@end
