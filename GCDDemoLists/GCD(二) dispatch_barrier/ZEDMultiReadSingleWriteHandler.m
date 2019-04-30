//
//  ZEDMultiReadSingleWriteHandler.m
//  GCD(二) dispatch_barrier
//
//  Created by 李超 on 2019/4/23.
//  Copyright © 2019年 李超. All rights reserved.
//

#import "ZEDMultiReadSingleWriteHandler.h"

// 多读单写模型
@interface ZEDMultiReadSingleWriteHandler ()

/** 并发队列 */
@property (nonatomic, strong) dispatch_queue_t concurrentQueue;

/** 多读单写的数据容器，可能在不同的线程中访问 */
@property (nonatomic, strong) NSMutableDictionary *dict;

@end

@implementation ZEDMultiReadSingleWriteHandler

- (instancetype)init {
    self = [super init];
    if (self) {
        self.concurrentQueue = dispatch_queue_create("zed.concurrent.queue", DISPATCH_QUEUE_CONCURRENT);
        self.dict = [NSMutableDictionary dictionary];
    }
    return self;
}

- (id)dataForKey:(NSString *)key {
    __block id data;
    //同步读取指定数据
    dispatch_sync(self.concurrentQueue, ^{
        data = [self.dict objectForKey:key];
        
    });
    return data;
}

- (void)setData:(id)data forKey:(NSString *)key {
    // 异步栅栏调用设置数据
    dispatch_barrier_async(self.concurrentQueue, ^{
        [self.dict setObject:data forKey:key];
    });
}

@end
