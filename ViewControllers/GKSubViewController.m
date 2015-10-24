//
//  GKSubViewController.m
//  GKMusic
//
//  Created by qianfeng on 14-10-15.
//  Copyright (c) 2014年 gao. All rights reserved.
//

#import "GKSubViewController.h"

@interface GKSubViewController ()

@end

@implementation GKSubViewController

- (id)initWithFrame:(CGRect)frame andSignal:(NSString *)szSignal
{
    self = [super init];
    if (self)
    {
        self.szSignal = szSignal;
        self.view.frame = frame;
        self.title = szSignal;
        [self.view setBackgroundColor:[UIColor whiteColor]];
        self.view.layer.borderWidth = 1;
        self.view.layer.borderColor = [UIColor blueColor].CGColor;
    }
    
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    signalLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 160, 90)];
    signalLabel.text = _szSignal;
    signalLabel.textAlignment = NSTextAlignmentCenter;
    signalLabel.contentMode = UIViewContentModeScaleAspectFill;
    [signalLabel setBackgroundColor:[UIColor clearColor]];
    [signalLabel setTextColor:[UIColor blackColor]];
    [signalLabel setFont:[UIFont systemFontOfSize:20]];
    signalLabel.center = self.view.center;
    [self.view addSubview:signalLabel];
    signalLabel.userInteractionEnabled = YES;
    signalLabel.layer.borderWidth = 1;
    signalLabel.layer.borderColor = [UIColor blueColor].CGColor;
    
    UITapGestureRecognizer *singleTapRecognizer = [[UITapGestureRecognizer alloc] init];
    singleTapRecognizer.numberOfTapsRequired = 1;
    [singleTapRecognizer addTarget:self action:@selector(pust2View:)];
    [signalLabel addGestureRecognizer:singleTapRecognizer];
}

- (void)setSzSignal:(NSString *)szSignal
{
    _szSignal = szSignal;
    signalLabel.text = szSignal;
}

- (void)pust2View:(id)sender
{
    GKSubViewController *subViewController = [[GKSubViewController alloc] initWithFrame:[UIScreen mainScreen].bounds andSignal:@""];
    [[GKMainScrollViewController getMain] addVCBehindSuper:self withSub:subViewController];
    subViewController.szSignal = [NSString stringWithFormat:@"%d", subViewController.view.tag];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
