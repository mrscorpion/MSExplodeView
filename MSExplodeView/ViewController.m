//
//  ViewController.m
//  MSExplodeView
//
//  Created by mr.scorpion on 16/5/1.
//  Copyright © 2016年 mr.scorpion. All rights reserved.
//

#import "ViewController.h"
#import "MSExplodeView.h"

@interface ViewController ()
{
    MSExplodeView *_explodeView;
}
@end

@implementation ViewController
/**
 *  Explode
 */
- (void)explode
{
    static int flag = 0;
    [_explodeView explodeWithPrepareImage:[UIImage imageNamed:[NSString stringWithFormat:@"img%d.jpg", flag++%2]]];
}

#pragma mark - Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *leftItems = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(explode)];
    self.navigationItem.leftBarButtonItem = leftItems;
    
    _explodeView = [[MSExplodeView alloc] initWithFrame:self.view.bounds];
    _explodeView.image = [UIImage imageNamed:@"img1.jpg"];
    [self.view addSubview:_explodeView];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
@end
