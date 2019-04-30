//
//  ViewController.m
//  GCD(一) 队列、任务、串行、并发
//
//  Created by 李超 on 2019/4/20.
//  Copyright © 2019年 李超. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, strong) dispatch_queue_t serialQueue;
@property (nonatomic, strong) dispatch_queue_t concurrentQueue;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //GCD使用三步骤
    //一、创建或获取队列
    
    //获取自定义串行队列
    self.serialQueue = dispatch_queue_create("com.zed.customSerialQueue", DISPATCH_QUEUE_SERIAL);
    //获取自定义并发队列
    self.concurrentQueue = dispatch_queue_create("com.zed.customConcurrentQueue", DISPATCH_QUEUE_CONCURRENT);
    //获取主队列
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    //获取全局并发队列
    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    //二、定制任务
    void (^block)(void) = ^{
        NSLog(@"执行任务");
        for (int i = 0; i<10; i++) {
            NSLog(@"%d",i);
        }
        NSLog(@"Thread:%@",[NSThread currentThread]);
    };
    
    //三、将任务增加到队列中
    dispatch_async(globalQueue, block);
}

#pragma mark - 同步执行+并发队列
/*
 * 特点：
 * 1.在当前线程中执行任务，不会开启新线程
 * 2.按序执行任务，执行行完一个任务，再执行下一个任务
 * 3.会阻塞当前线程
 */
- (IBAction)executeSyncConcurrencyTask:(UIButton *)sender {
    
    NSLog(@"CurrentThread---%@",[NSThread currentThread]);  // 打印当前线程
    NSLog(@"SyncConcurrencyTask---begin");
    
    dispatch_sync(self.concurrentQueue, ^{
        // 追加任务1
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"1---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    
    dispatch_sync(self.concurrentQueue, ^{
        // 追加任务2
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"2---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    
    dispatch_sync(self.concurrentQueue, ^{
        // 追加任务3
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"3---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    
    NSLog(@"SyncConcurrencyTask---end");
    NSLog(@"*********************************************************");
}

#pragma mark - 异步执行+并发队列
/*
 * 特点：
 * 1.开启多个新线程执行任务
 * 2.任务交替（同时）执行
 * 3.不会阻塞当前线程
 */
- (IBAction)executeAsyncConcurrencyTask:(UIButton *)sender {
    
    NSLog(@"CurrentThread begin---%@",[NSThread currentThread]);  // 打印当前线程
    NSLog(@"AsyncConcurrencyTask---begin");
    
    dispatch_async(self.concurrentQueue, ^{
        // 追加任务1
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"1---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    
    dispatch_async(self.concurrentQueue, ^{
        // 追加任务2
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"2---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    
    dispatch_async(self.concurrentQueue, ^{
        // 追加任务3
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"3---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    
    NSLog(@"CurrentThread end---%@",[NSThread currentThread]);  // 打印当前线程
    NSLog(@"AsyncConcurrencyTask---end");
    NSLog(@"*********************************************************");
}

#pragma mark - 同步执行+串行队列
/*
 * 特点：
 * 1.在当前线程中执行任务，不会开启新线程
 * 2.按序执行任务，执行行完一个任务，再执行下一个任务
 * 3.会阻塞当前线程
 */
- (IBAction)executeSyncSerialTask:(UIButton *)sender {
    
    NSLog(@"CurrentThread begin---%@",[NSThread currentThread]);  // 打印当前线程
    NSLog(@"SyncSerialTask---begin");
    
    dispatch_sync(self.serialQueue, ^{
        // 追加任务1
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"1---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    
    dispatch_sync(self.serialQueue, ^{
        // 追加任务2
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"2---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    
    dispatch_sync(self.serialQueue, ^{
        // 追加任务3
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"3---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    
    NSLog(@"CurrentThread end---%@",[NSThread currentThread]);  // 打印当前线程
    NSLog(@"SyncSerialTask---end");
    NSLog(@"*********************************************************");
}

#pragma mark - 异步执行+串行队列
/*
 * 特点：
 * 1.会会开启一条新线程
 * 2.按序执行任务，执行行完一个任务，再执行下一个任务
 * 3.不会阻塞当前线程
 */
- (IBAction)executeAsyncSerialTask:(UIButton *)sender {
    
    NSLog(@"CurrentThread begin---%@",[NSThread currentThread]);  // 打印当前线程
    NSLog(@"AsyncSerialTask---begin");
    
    dispatch_async(self.serialQueue, ^{
        // 追加任务1
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"1---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    
    dispatch_async(self.serialQueue, ^{
        // 追加任务2
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"2---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    
    dispatch_async(self.serialQueue, ^{
        // 追加任务3
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"3---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    
    NSLog(@"CurrentThread end---%@",[NSThread currentThread]);  // 打印当前线程
    NSLog(@"AsyncSerialTask---end");
    NSLog(@"*********************************************************");
}

#pragma mark - 同步执行+主队列
/*
 * 特点：
 * 会直接产生死锁
 */
- (IBAction)executeSyncMainQueueTask:(UIButton *)sender {
    
    NSLog(@"CurrentThread begin---%@",[NSThread currentThread]);  // 打印当前线程
    NSLog(@"SyncMainQueueTask---begin");
    
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    
    dispatch_sync(mainQueue, ^{
        // 追加任务1
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"1---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    
    dispatch_sync(mainQueue, ^{
        // 追加任务2
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"2---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    
    dispatch_sync(mainQueue, ^{
        // 追加任务3
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"3---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    
    NSLog(@"CurrentThread end---%@",[NSThread currentThread]);  // 打印当前线程
    NSLog(@"SyncMainQueueTask---end");
    NSLog(@"*********************************************************");
}

#pragma mark - 异步执行+主队列
/*
 * 特点：
 * 1.在当前线程（主线程）中执行任务
 * 2.按序执行任务，执行行完一个任务，再执行下一个任务
 * 3.不会阻塞当前线程
 */
- (IBAction)executeAsyncMainQueueTask:(UIButton *)sender {
    
    NSLog(@"CurrentThread begin---%@",[NSThread currentThread]);  // 打印当前线程
    NSLog(@"AsyncMainQueueTask---begin");
    
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    
    dispatch_async(mainQueue, ^{
        // 追加任务1
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"1---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    
    dispatch_async(mainQueue, ^{
        // 追加任务2
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"2---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    
    dispatch_async(mainQueue, ^{
        // 追加任务3
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"3---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    
    NSLog(@"CurrentThread end---%@",[NSThread currentThread]);  // 打印当前线程
    NSLog(@"AsyncMainQueueTask---end");
    NSLog(@"*********************************************************");
}

#pragma mark - 子线程执行耗时代码，主线程更新UI
- (IBAction)threadInteraction:(UIButton *)sender {
    
    NSLog(@"CurrentThread begin---%@",[NSThread currentThread]);  // 打印当前线程
    NSLog(@"threadInteraction---begin");
    
    //异步添加任务到全局并发队列执行耗时操作
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        //执行耗时任务
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"1---%@",[NSThread currentThread]);      // 打印当前线程
        }
        
        //回到主线程更新UI
        dispatch_sync(dispatch_get_main_queue(), ^{
            
            //Do something here to update UI
            
        });
    });
    
    NSLog(@"CurrentThread end---%@",[NSThread currentThread]);  // 打印当前线程
    NSLog(@"threadInteraction---end");
    NSLog(@"*********************************************************");
}



@end
