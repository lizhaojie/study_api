//
//  LZJSDWebImageAPIViewController.m
//  api_study
//
//  Created by lizhaojie on 2017/11/20.
//  Copyright © 2017年 lizhaojie. All rights reserved.
//

#import "LZJApiStudyViewController.h"
#import "LZJStudyApiDefine.h"
#import "LZJOperation.h"

@interface LZJApiStudyViewController ()

@end

@implementation LZJApiStudyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self test_operation];
//    [self test_gcd];
    self.view.backgroundColor = [UIColor whiteColor];
//    [self block_test_one];
//    [self block_test_two];
//    [self study_sdweb_image];
    // Do any additional setup after loading the view.
}
- (void)test_operation{
//    NSOperation *operation = [[NSOperation alloc] init];
//    [self test_subOperation];//子类
//    [self test_subOperations];
//    [self test_opQueue];
//    [self test_dependency];
    [self test_custom_suboperation];
}
- (void)test_custom_suboperation{
    LZJOperation *op = [[LZJOperation alloc] init];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperation:op];
    NSLog(@"current mainThread == %@",[NSThread currentThread]);
}
- (void)test_subOperation{
    NSInvocationOperation *invocationOperation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(logOne) object:nil];
    [invocationOperation start];
    NSBlockOperation *blockOp = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"blockOpThread: %@----log: NSBlockOperation running", [NSThread currentThread]);

    }];
    [blockOp start];
    
}
/*
 任务是并行执行的，但是阻塞了主线程，直到任务都执行完成
 
 */
- (void)test_subOperations{
    NSBlockOperation *blockOp = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"任务 0：blockOpThread: %@----log: NSBlockOperation running", [NSThread currentThread]);
        
    }];
    for (int i = 1; i < 5; i++) {
        [blockOp addExecutionBlock:^{
            NSLog(@"任务 %d：blockOpThread: %@----log: NSBlockOperation running", i, [NSThread currentThread]);

        }];
    }
    
    [blockOp start];
}
/*
 实现并行异步执行
 */
- (void)test_opQueue{
    NSLog(@"main thread start");
    
    NSOperationQueue *queue=  [[NSOperationQueue alloc] init];
    NSBlockOperation *blockOp = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"任务 0：blockOpThread: %@----log: NSBlockOperation running", [NSThread currentThread]);

    }];
    for (int i = 1; i < 5; i++) {
        [blockOp addExecutionBlock:^{
            NSLog(@"任务 %d：blockOpThread: %@----log: NSBlockOperation running", i, [NSThread currentThread]);
            
        }];
    }
    [queue addOperation:blockOp];
//    [queue waitUntilAllOperationsAreFinished];//阻塞当前线程知道执行完所有任务，再执行当前线程中的其他任务
//    [blockOp waitUntilFinished];//阻塞当前线程知道执行完所有任务，再执行当前线程中的其他任务
    NSLog(@"main thread end");

    
}
/*
 实现串行执行
 
 */
- (void)test_dependency{
    NSLog(@"main thread start");
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    NSBlockOperation *opOne = [NSBlockOperation blockOperationWithBlock:^{
//        [NSThread sleepForTimeInterval:1.0];
        NSLog(@"任务 1  blockOpThread: %@", [NSThread currentThread]);
    }];
    NSBlockOperation *opTwo = [NSBlockOperation blockOperationWithBlock:^{
//        [NSThread sleepForTimeInterval:1.0];
        NSLog(@"任务 2  blockOpThread: %@", [NSThread currentThread]);
    }];
    NSBlockOperation *opThree = [NSBlockOperation blockOperationWithBlock:^{
//        [NSThread sleepForTimeInterval:1.0];
        NSLog(@"任务 3 blockOpThread: %@", [NSThread currentThread]);
    }];
    NSBlockOperation *opFour = [NSBlockOperation blockOperationWithBlock:^{
//        [NSThread sleepForTimeInterval:1.0];
        NSLog(@"任务 4 blockOpThread: %@", [NSThread currentThread]);
    }];
    [opFour addDependency:opThree];
    [opThree addDependency:opTwo];
    [opTwo addDependency:opOne];
    [queue addOperations:[NSArray arrayWithObjects:opOne,opTwo,opThree,opFour, nil] waitUntilFinished:YES];//params:waitUntilFinished:是否阻塞主线程 YES:阻塞 NO:不阻塞
    
    NSLog(@"main thread end");
}
- (void)logOne{
    NSLog(@"invocationThread: %@----log: NSInvocationOperation running", [NSThread currentThread]);
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
