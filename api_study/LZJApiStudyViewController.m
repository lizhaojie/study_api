//
//  LZJSDWebImageAPIViewController.m
//  api_study
//
//  Created by lizhaojie on 2017/11/20.
//  Copyright © 2017年 lizhaojie. All rights reserved.
//

#import "LZJSDWebImageAPIViewController.h"
#import "LZJStudyApiDefine.h"

@interface LZJSDWebImageAPIViewController ()

@end

@implementation LZJSDWebImageAPIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self test_gcd];
    self.view.backgroundColor = [UIColor whiteColor];
//    [self block_test_one];
//    [self block_test_two];
//    [self study_sdweb_image];
    // Do any additional setup after loading the view.
}
- (void)test_gcd{
//    [self test_global];//全局队列
    [self test_serial];//串行队列
    
}
- (void)test_serial{
    dispatch_queue_t serialQueue = dispatch_queue_create("serialQueue", 0);
//    [self asyn_gcd_queue:serialQueue];//串行队列，异步执行 创建了新线程
    [self syn_gcd_queue:serialQueue];//串行队列，同步执行 未开新线程，在主线程（当前线程）中执行
}
- (void)test_global{
    NSLog(@"----queueWillCreate: thread:%@",[NSThread currentThread]);
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    [self asyn_gcd_queue:queue];//全局队列，异步执行 创建了新线程
    [self syn_gcd_queue:queue];//全局队列，同步执行 未开新线程，在主线程（当前线程）中执行
}
- (void)asyn_gcd_queue:(dispatch_queue_t)queue{
    dispatch_async(queue, ^{
        NSLog(@"----logIn: thread:%@",[NSThread currentThread]);
    });
    NSLog(@"----blockOutside: thread:%@",[NSThread currentThread]);
}
- (void)syn_gcd_queue:(dispatch_queue_t)queue{
    dispatch_sync(queue, ^{
        NSLog(@"----logIn: thread:%@",[NSThread currentThread]);
    });
    NSLog(@"----blockOutside: thread:%@",[NSThread currentThread]);
}
- (void)block_test_one{
     __block int a = 0;
    void(^testBlock)(void) = ^{
        a = 2;
        NSLog(@"p == %p, value = %d",&a,a);
    };
    NSLog(@"before int p == %p, value == %d",&a,a);
    testBlock();
    NSLog(@"after int p == %p, value == %d",&a,a);

}
- (void)block_test_two{
    int a = 0;
    void(^testBlock)(void) = ^{
        NSLog(@"p == %p, value = %d",&a,a);
    };
    NSLog(@"before int p == %p, value == %d",&a,a);
    testBlock();
    NSLog(@"after int p == %p, value == %d",&a,a);
    
}
- (void)study_sdweb_image{
    UIImageView *imageView = [[UIImageView alloc] init];
    [self.view addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.width.height.mas_equalTo(80);
    }];
    imageView.backgroundColor = [UIColor greenColor];
    [imageView sd_setImageWithURL:[NSURL URLWithString:@"http://www.zcool.com.cn/work/ZMjMyODM0MzY=.html"] placeholderImage:nil];
}
//memery,disk cache with imageUrl reload cacheImage with options
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
