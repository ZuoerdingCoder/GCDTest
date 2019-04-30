//
//  ZEDMultiReadSingleWriteHandler.h
//  GCD(二) dispatch_barrier
//
//  Created by 李超 on 2019/4/23.
//  Copyright © 2019年 李超. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZEDMultiReadSingleWriteHandler : NSObject

- (id)dataForKey:(NSString *)key;
- (void)setData:(id)data forKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
