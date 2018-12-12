//
//  GCDTestTests.m
//  GCDTestTests
//
//  Created by ZED on 2018/12/10.
//  Copyright © 2018年 ZED. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface GCDTestTests : XCTestCase

@end

@implementation GCDTestTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

#pragma mark - GCDTest
#pragma mark - 同步函数 + 主队列 ： 队列引起的循环等待中，形成死锁
- (void)testGCD_syncMain {
    NSLog(@"testGCD_syncMain --- Start --- %@",[NSThread currentThread]);
    dispatch_sync(dispatch_get_main_queue(), ^{
        NSLog(@"1 --- %@",[NSThread currentThread]);
    });
    dispatch_sync(dispatch_get_main_queue(), ^{
        NSLog(@"2 --- %@",[NSThread currentThread]);
    });
    dispatch_sync(dispatch_get_main_queue(), ^{
        NSLog(@"3 --- %@",[NSThread currentThread]);
    });
    NSLog(@"testGCD_syncMain --- End --- %@",[NSThread currentThread]);
}

#pragma mark - 异步函数 + 主队列 ：只在主线程中串行执行任务
- (void)testGCD_asyncMain {
    NSLog(@"testGCD_asyncMain --- Start --- %@",[NSThread currentThread]);
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"1 --- %@",[NSThread currentThread]);
    });
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"2 --- %@",[NSThread currentThread]);
    });
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"3 --- %@",[NSThread currentThread]);
    });
    NSLog(@"testGCD_asyncMain --- End --- %@",[NSThread currentThread]);
}

#pragma mark - 同步函数 + 串行队列 ：在当前线程中串行执行任务，不开辟新线程
- (void)testGCD_syncSerial {
    
    NSLog(@"testGCD_syncSerial --- Start --- %@",[NSThread currentThread]);
    dispatch_queue_t serialQueue = dispatch_queue_create("com.zed.queue", DISPATCH_QUEUE_SERIAL);
    dispatch_sync(serialQueue, ^{
        NSLog(@"1 --- %@",[NSThread currentThread]);
    });
    dispatch_sync(serialQueue, ^{
        NSLog(@"2 --- %@",[NSThread currentThread]);
    });
    dispatch_sync(serialQueue, ^{
        NSLog(@"3 --- %@",[NSThread currentThread]);
    });
    NSLog(@"testGCD_syncSerial --- End --- %@",[NSThread currentThread]);
}

#pragma mark - 异步函数 + 串行队列 ：串行执行任务，会开辟新线程,不会阻塞任务的执行
- (void)testGCD_asyncSerial {
    
    NSLog(@"testGCD_asyncSerial --- Start --- %@",[NSThread currentThread]);
    dispatch_queue_t serialQueue = dispatch_queue_create("com.zed.queue", DISPATCH_QUEUE_SERIAL);
    dispatch_async(serialQueue, ^{
        NSLog(@"1 --- %@",[NSThread currentThread]);
    });
    dispatch_async(serialQueue, ^{
        NSLog(@"2 --- %@",[NSThread currentThread]);
    });
    dispatch_async(serialQueue, ^{
        NSLog(@"3 --- %@",[NSThread currentThread]);
    });
    NSLog(@"testGCD_asyncSerial --- End --- %@",[NSThread currentThread]);
}

#pragma mark - 同步函数 + 并行队列 ：串行执行任务，不会开辟新线程,会阻塞任务的执行
- (void)testGCD_syncConcurrent {
    
    NSLog(@"testGCD_syncConcurrent --- Start --- %@",[NSThread currentThread]);
//    dispatch_queue_t concurrentQueue = dispatch_queue_create("com.zed.queue", DISPATCH_QUEUE_CONCURRENT);
    dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_sync(concurrentQueue, ^{
        NSLog(@"1 --- %@",[NSThread currentThread]);
    });
    dispatch_sync(concurrentQueue, ^{
        NSLog(@"2 --- %@",[NSThread currentThread]);
    });
    dispatch_sync(concurrentQueue, ^{
        NSLog(@"3 --- %@",[NSThread currentThread]);
    });
    NSLog(@"testGCD_syncConcurrent --- End --- %@",[NSThread currentThread]);
}

#pragma mark - 同步函数 + 并行队列 ：并行执行任务，开启多条线程,不会阻塞任务的执行
- (void)testGCD_asyncConcurrent {
    
    NSLog(@"testGCD_asyncConcurrent --- Start --- %@",[NSThread currentThread]);
    //    dispatch_queue_t concurrentQueue = dispatch_queue_create("com.zed.queue", DISPATCH_QUEUE_CONCURRENT);
    dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(concurrentQueue, ^{
        NSLog(@"1 --- %@",[NSThread currentThread]);
    });
    dispatch_async(concurrentQueue, ^{
        NSLog(@"2 --- %@",[NSThread currentThread]);
    });
    dispatch_async(concurrentQueue, ^{
        NSLog(@"3 --- %@",[NSThread currentThread]);
    });
    NSLog(@"testGCD_asyncConcurrent --- End --- %@",[NSThread currentThread]);
}

@end
