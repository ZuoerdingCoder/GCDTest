//
//  ZEDDispatchSemaphoreViewController.m
//  GCD(四) dispatch_semaphore
//
//  Created by 李超 on 2019/4/25.
//  Copyright © 2019年 李超. All rights reserved.
//

#ifndef ZED_LOCK
#define ZED_LOCK(lock) dispatch_semaphore_wait(lock, DISPATCH_TIME_FOREVER);
#endif

#ifndef ZED_UNLOCK
#define ZED_UNLOCK(lock) dispatch_semaphore_signal(lock);
#endif

#import "ZEDDispatchSemaphoreViewController.h"

@interface ZEDDispatchSemaphoreViewController ()

/* 需要加锁的资源 **/
@property (nonatomic, strong) NSMutableDictionary *dict;

/* 信号锁 **/
@property (nonatomic, strong) dispatch_semaphore_t lock;

@end

@implementation ZEDDispatchSemaphoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //创建共享资源
    self.dict = [NSMutableDictionary dictionary];
    //初始化信号量,设置初始值为1
    self.lock = dispatch_semaphore_create(1);
    
}


- (IBAction)threadSyncTask:(UIButton *)sender {
    
    NSLog(@"threadSyncTask start --- thread:%@",[NSThread currentThread]);
    
    //1.创建一个初始值为0的信号量
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    //2.定制一个异步任务
    //开启一个异步网络请求
    NSLog(@"开启一个异步网络请求");
    NSURLSession *session = [NSURLSession sharedSession];
    NSURL *url =
    [NSURL URLWithString:[@"https://www.baidu.com/" stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"GET";
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"%@", [error localizedDescription]);
        }
        if (data) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"%@", dict);
        }
        NSLog(@"异步网络任务完成---%@",[NSThread currentThread]);
        //4.调用signal方法，让信号量+1,然后唤醒先前被阻塞的线程
        NSLog(@"调用dispatch_semaphore_signal方法");
        dispatch_semaphore_signal(semaphore);
    }];
    [dataTask resume];
    
    //3.调用wait方法让信号量-1，这时信号量小于0，这个方法会阻塞当前线程，直到信号量等于0时，唤醒当前线程
    NSLog(@"调用dispatch_semaphore_wait方法");
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
    NSLog(@"threadSyncTask end --- thread:%@",[NSThread currentThread]);
}

- (IBAction)resourceLockTask:(UIButton *)sender {
    
    NSLog(@"resourceLockTask start --- thread:%@",[NSThread currentThread]);
    
    //使用异步执行并发任务会开辟新的线程的特性，来模拟开辟多个线程访问贡献资源的场景
    
    for (int i = 0; i < 3; i++) {
        
        NSLog(@"异步添加任务:%d",i);
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            ZED_LOCK(self.lock);
            
            //模拟对共享资源处理的耗时
            [NSThread sleepForTimeInterval:1];
            NSLog(@"i:%d --- thread:%@ --- 将要处理共享资源",i,[NSThread currentThread]);
            [self.dict setObject:@"semaphore" forKey:@"key"];
            NSLog(@"i:%d --- thread:%@ --- 共享资源处理完成",i,[NSThread currentThread]);
            ZED_UNLOCK(self.lock);
            
        });
    }
    
    NSLog(@"resourceLockTask end --- thread:%@",[NSThread currentThread]);
}



- (IBAction)crashScene1:(UIButton *)sender {
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(1);
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
    //在使用过程中将semaphore置为nil
    semaphore = nil;
}

- (IBAction)crashScene2:(UIButton *)sender {
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(1);
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
    //在使用过程中对semaphore进行重新赋值
    semaphore = dispatch_semaphore_create(3);
}


@end
