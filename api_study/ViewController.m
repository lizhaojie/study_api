//
//  ViewController.m
//  api_study
//
//  Created by lizhaojie on 2017/11/20.
//  Copyright © 2017年 lizhaojie. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSTimer *timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(timerFun) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop]addTimer:timer forMode:NSRunLoopCommonModes];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)timerFun{
    NSLog(@"timer");
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
