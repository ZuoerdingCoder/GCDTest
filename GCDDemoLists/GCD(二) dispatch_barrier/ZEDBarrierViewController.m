//
//  ZEDBarrierViewController.m
//  GCD(二) dispatch_barrier
//
//  Created by 李超 on 2019/4/23.
//  Copyright © 2019年 李超. All rights reserved.
//

#import "ZEDBarrierViewController.h"

@interface ZEDBarrierViewController ()

@property (nonatomic, strong) dispatch_queue_t serialQueue;
@property (nonatomic, strong) dispatch_queue_t concurrentQueue;

@end

@implementation ZEDBarrierViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //获取自定义串行队列
    self.serialQueue = dispatch_queue_create("com.zed.customSerialQueue", DISPATCH_QUEUE_SERIAL);
    //获取自定义并发队列
    self.concurrentQueue = dispatch_queue_create("com.zed.customConcurrentQueue", DISPATCH_QUEUE_CONCURRENT);
    
}

#pragma mark - dispatch_barrier_async + 自定义并发队列
/*
 * 特点：
 * 1.barrier之前的任务并发执行，barrier之后的任务在barrierw任务完成之后并发执行
 * 2.会开启新线程执行任务
 * 3.不会阻塞当前线程（主线程）
 */
- (IBAction)executeBarrierAsyncCustomConcurrentQueueTask:(UIButton *)sender {
    
    NSLog(@"CurrentThread---%@",[NSThread currentThread]);  // 打印当前线程
    NSLog(@"---begin---");
    
    NSLog(@"追加任务1");
    dispatch_async(self.concurrentQueue, ^{
        // 追加任务1
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"1---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    
    NSLog(@"追加任务2");
    dispatch_async(self.concurrentQueue, ^{
        // 追加任务2
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"2---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    
    NSLog(@"追加barrier_async任务");
    dispatch_barrier_async(self.concurrentQueue, ^{
        // 追加barrier任务
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"barrier---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    
    NSLog(@"追加任务3");
    dispatch_async(self.concurrentQueue, ^{
        // 追加任务3
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"3---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    
    NSLog(@"追加任务4");
    dispatch_async(self.concurrentQueue, ^{
        // 追加任务4
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"4---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    
    NSLog(@"---end---");
    NSLog(@"*********************************************************");
}

#pragma mark - dispatch_barrier_sync + 自定义并发队列
/*
 * 特点：
 * 1.barrier之前的任务并发执行，barrier之后的任务在barrierw任务完成之后并发执行
 * 2.会开启新线程执行任务
 * 3.会阻塞barrier_sync任务之后的任务的入队，必须等到barrier_sync任务执行完毕，才会继续把后面的异步任务添加到并发队列中
 */
- (IBAction)executeBarrierSyncCustomConcurrentQueueTask:(UIButton *)sender {
    
    NSLog(@"CurrentThread---%@",[NSThread currentThread]);  // 打印当前线程
    NSLog(@"---begin---");
    
    NSLog(@"追加任务1");
    dispatch_async(self.concurrentQueue, ^{
        // 追加任务1
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"1---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    
    NSLog(@"追加任务2");
    dispatch_async(self.concurrentQueue, ^{
        // 追加任务2
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"2---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    
    NSLog(@"追加barrier_sync任务");
    dispatch_barrier_sync(self.concurrentQueue, ^{
        // 追加barrier任务
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"barrier---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    
    NSLog(@"追加任务3");
    dispatch_async(self.concurrentQueue, ^{
        // 追加任务3
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"3---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    
    NSLog(@"追加任务4");
    dispatch_async(self.concurrentQueue, ^{
        // 追加任务4
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"4---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    
    NSLog(@"---end---");
    NSLog(@"*********************************************************");
}


- (IBAction)simulateMultiReadSingleWriteTask:(UIButton *)sender {
    
    for (int i = 0; i < 10; i++) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSLog(@"1 -- i:%d -- thread:%@",i,[NSThread currentThread]);
            dispatch_sync(self.concurrentQueue, ^{
                NSLog(@"2 -- i:%d -- thread:%@",i,[NSThread currentThread]);
            });
        });
    }
}


@end
