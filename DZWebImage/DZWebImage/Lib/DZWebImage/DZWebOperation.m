//
//  DZWebOperation.m
//  DZWebImage
//
//  Created by 宋得中 on 15/9/21.
//  Copyright © 2015年 宋得中. All rights reserved.
//

#import "DZWebOperation.h"
#import "NSString+Extension.h"

@implementation DZWebOperation
/**
 *  自定义初始化方法
 *
 *  @param urlStr 图片地址字符串
 *  @param block  回调block
 *
 *  @return
 */
- (instancetype)initWithUrlStr:(NSString*)urlStr andBlock:(finishBlock)block
{
    if (self = [super init]) {
        self.url = urlStr;
        self.block = block;
    }
    return self;
}
/**
 *  重写main方法来实现操作内容
 */
- (void)main
{
    @autoreleasepool
    {
        //判断是否被取消
        if ([self isCancelled]) {
            NSLog(@"被取消");
            return;
        }
        NSURL* url = [NSURL URLWithString:self.url];
        NSData* data = [NSData dataWithContentsOfURL:url];
        //        [NSThread sleepForTimeInterval:2];
        UIImage* image = [UIImage imageWithData:data];
        //判断是否被取消
        if ([self isCancelled]) {
            NSLog(@"被取消");
            return;
        }
        //将数据写入到沙盒
        [data writeToFile:[self.url getAppendingPath] atomically:YES];
        
        //判断是否被取消
        if ([self isCancelled]) {
            NSLog(@"被取消");
            return;
        }
        
        //在主线程执行回调方法
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            if (self.block) {
                self.block(image);
            }
        }];
    }
}

@end
