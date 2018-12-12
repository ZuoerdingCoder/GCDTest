//
//  GCDExampleTest.m
//  GCDTestTests
//
//  Created by ZED on 2018/12/12.
//  Copyright © 2018年 ZED. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface GCDExampleTest : XCTestCase

@end

@implementation GCDExampleTest

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

#pragma mark - GCD
- (void)testGCDExample_1 {
    NSLog(@"1");
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        NSLog(@"2");
        dispatch_sync(queue, ^{
            NSLog(@"3");
        });
        NSLog(@"4");
    });
    NSLog(@"5");
    /*
     执行结果：1、5、2、3、4
     
     */
}

- (void)testGCDExample_2 {
    NSLog(@"1");
    dispatch_queue_t queue = dispatch_queue_create("com.zed.queue", DISPATCH_QUEUE_SERIAL);
    dispatch_async(queue, ^{
        NSLog(@"2");
        dispatch_sync(queue, ^{
            NSLog(@"3");
        });
        NSLog(@"4");
    });
    NSLog(@"5");
    /*
     sync/sync
     执行结果：1、2、或 1、5、2 然后死锁
     */
}

- (void)testGCDExample_3 {
    NSLog(@"1");
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_sync(queue, ^{
        NSLog(@"2");
        [self performSelector:@selector(p_print) withObject:nil afterDelay:0];
        NSLog(@"4");
    });
    NSLog(@"5");
    /*
     执行结果：1、2、4、5,3不会打印出来
     
     */
}

- (void)testGCDExample_4 {
    NSLog(@"1");
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        NSLog(@"2");
        [self performSelector:@selector(p_print) withObject:nil afterDelay:0];
        NSLog(@"4");
    });
    NSLog(@"5");
    /*
     执行结果：1、5、2、4,3不会打印出来
     
     */
}

- (void)testGCDExample_5 {
    NSLog(@"1");
    dispatch_queue_t queue = dispatch_queue_create("com.zed.queue", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue, ^{
        NSLog(@"2");
        dispatch_async(queue, ^{
            NSLog(@"3");
        });
        NSLog(@"4");
    });
    NSLog(@"5");
    /*
     执行结果：1、5、2、4、3
     */
}

- (void)testGCDExample_6 {
    NSLog(@"1");
    dispatch_queue_t queue = dispatch_queue_create("com.zed.queue", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue, ^{
        NSLog(@"2");
        dispatch_sync(queue, ^{
            NSLog(@"3");
        });
        NSLog(@"4");
    });
    NSLog(@"5");
    /*
     执行结果：1、5、2、3、4
     */
}

#pragma mark - Private
- (void)p_print {
    NSLog(@"3");
}

@end
