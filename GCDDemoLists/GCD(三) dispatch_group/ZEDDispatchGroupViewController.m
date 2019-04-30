//
//  ZEDDispatchGroupViewController.m
//  GCD(三) dispatch_group
//
//  Created by 李超 on 2019/4/23.
//  Copyright © 2019年 李超. All rights reserved.
//

#import "ZEDDispatchGroupViewController.h"

@interface ZEDDispatchGroupViewController ()

@property (nonatomic, strong) dispatch_group_t group;

@end

@implementation ZEDDispatchGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSLog(@"ZEDDispatchGroupViewController viewDidLoad");
    
    //第一步：创建group
    NSLog(@"初始化group");
    self.group = dispatch_group_create();
    
    //第二步：追加任务到group
    NSLog(@"使用dispatch_group_async方式追加任务1");
    dispatch_group_async(self.group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];                        // 模拟耗时操作
            NSLog(@"1---%@",[NSThread currentThread]);      // 打印当前线程
        }
        NSLog(@"任务1完成");
    });
    
    NSLog(@"使用dispatch_group_async方式追加任务2");
    dispatch_group_async(self.group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];                        // 模拟耗时操作
            NSLog(@"2---%@",[NSThread currentThread]);      // 打印当前线程
        }
        NSLog(@"任务2完成");
    });
    
    NSLog(@"使用dispatch_group_enter方式追加任务3");
    //dispatch_group_enter与dispatch_group_leave必须成对出现
    dispatch_group_enter(self.group);

    //开启一个网络请求
    NSURLSession *session = [NSURLSession sharedSession];
    NSURL *url =
    [NSURL URLWithString:[@"https://www.baidu.com/" stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"GET";
    
    NSLog(@"3---start---%@",[NSThread currentThread]);
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"%@", [error localizedDescription]);
        }
        if (data) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"%@", dict);
        }
        NSLog(@"3---end---%@",[NSThread currentThread]);
        NSLog(@"任务3完成");
        dispatch_group_leave(self.group);
    }];
    [dataTask resume];
    
    
    //第三步：添加group中任务全部完成的回调
    NSLog(@"使用dispatch_group_notify添加异步任务全部完成的监听");
    //dispatch_group_notify 的方式不会阻塞当前线程
    dispatch_group_notify(self.group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"---所有任务全部执行完毕---");
        
    });
    
    //dispatch_group_wai会阻塞当前线程，直到group中的任务全部完成，才能继续往主队列中追加任务
//    dispatch_group_wait(self.group, DISPATCH_TIME_FOREVER);
    
    NSLog(@"---测试结束了---");
}


@end
