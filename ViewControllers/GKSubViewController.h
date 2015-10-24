//
//  GKSubViewController.h
//  GKMusic
//
//  Created by qianfeng on 14-10-15.
//  Copyright (c) 2014年 gao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GKSubViewController : UIViewController
{
    UILabel *signalLabel;
    UISegmentedControl *selectTypeSegment;
}

@property (nonatomic, strong) NSString *szSignal;

- (id)initWithFrame:(CGRect)frame andSignal:(NSString *)szSignal;

@end
