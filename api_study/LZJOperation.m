//
//  LZJOperation.m
//  api_study
//
//  Created by lizhaojie on 2017/12/5.
//  Copyright © 2017年 lizhaojie. All rights reserved.
//

#import "LZJOperation.h"
#import <UIKit/UIKit.h>
/*
 自定义串行的：syn
 只要实现main方法即可
 自定义并行的：Asyn
 需要override
 start
 main
 isexecuting:需要手动实现kvo机制
 isfinished：需要手动实现kvo机制
 isconcurrent
 isAsynchoronous
 与非并发操作不同的是，需要另外自定义一个方法来执行操作而不是直接调用start方法
 */
typedef void (^dowloadFinishedBlock)(UIImage *image);

@interface LZJOperation(){
    
}
@property (nonatomic, copy) dowloadFinishedBlock downloadImageFinished;
@property (assign, nonatomic, getter = isFinished) BOOL finished;
@property (assign, nonatomic, getter = isExecuting) BOOL executing;

@end

@implementation LZJOperation
@synthesize finished = _finished;
@synthesize executing = _executing;
- (id)init{
    self = [super init];
    if (self) {
        self.executing = NO;
        self.finished = NO;
    }
    return self;
}
- (void)start{
    if ([self isCancelled]) {
        [self willChangeValueForKey:@"isFinished"];
        self.finished = YES;
        [self didChangeValueForKey:@"isFinished"];
        return;
    }
    [self willChangeValueForKey:@"isExecuting"];
    [NSThread detachNewThreadSelector:@selector(main) toTarget:self withObject:nil];
    self.executing = YES;
    [self didChangeValueForKey:@"isExecuting"];
}

- (void)main{
    NSLog(@"main begin");
    @try{
        //必须为自定义的operation提供autorelease pool ,因为operation完成后需要销毁
        @autoreleasepool{
            BOOL taskFinished = NO;
            while (taskFinished == NO&&[self isCancelled] == NO) {
                // 自定义的好事task
                [self downloadImage];
                NSLog(@"currentThread = %@", [NSThread currentThread]);
                NSLog(@"mainThread    = %@", [NSThread mainThread]);
                
                // 这里相应的操作都已经完成，后面就是要通知KVO我们的操作完成了。
                
                taskFinished = YES;
            }
        }
    }
    @catch(NSException *exception){
        NSLog(@"exception == %@", exception);
    }
    NSLog(@"main end");
}
- (void)downloadImage{
    //在这里定义自己的并发任务
    NSLog(@"自定义并发操作NSOperation");
    
    NSURL *url=[NSURL URLWithString:@"https://...."];
    NSData *data=[NSData dataWithContentsOfURL:url];
    UIImage *imgae=[UIImage imageWithData:data];
    
    if (self.downloadImageFinished) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.downloadImageFinished(imgae);

        });
    }
    
}
- (BOOL)isAsynchronous{
    return YES;
}
- (void)setFinished:(BOOL)finished{
    [self willChangeValueForKey:@"isFinished"];
    _finished = finished;
    [self didChangeValueForKey:@"isFinished"];
}
- (void)setExecuting:(BOOL)executing{
    [self willChangeValueForKey:@"isExecuting"];
    _executing = executing;
    [self didChangeValueForKey:@"isExecuting"];
}
- (BOOL)isExecuting{
    return _executing;
}
- (BOOL)isFinished{
    return _finished;
}

@end
