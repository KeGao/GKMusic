//
//  GKSpecialDetailViewController.h
//  GKMusic
//
//  Created by Gao on 14-10-4.
//  Copyright (c) 2014年 gao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GKSpecialDetailViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *bannerIV;
@property (weak, nonatomic) IBOutlet UILabel *introduceLB;

@property (retain, nonatomic) UIImage *image;
@property (retain, nonatomic) NSString *intro;

@end
