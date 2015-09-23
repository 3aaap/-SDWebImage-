//
//  HMOperationManager.m
//  01-仿SDWebImage（单张图片例子）
//
//  Created by 宋得中 on 15/9/21.
//  Copyright © 2015年 宋得中. All rights reserved.
//

#import "HMOperationManager.h"
#import "NSString+Extension.h"

@interface HMOperationManager ()

@property (nonatomic, strong) NSMutableDictionary<NSString*, UIImage*>* imageCache;
@property (nonatomic, strong) NSMutableDictionary<NSString*, HMWebOperation*> * oprationCache;
@property (nonatomic, copy) NSString *preUrl;
@property (nonatomic, strong) NSOperationQueue *queue;

@end

@implementation HMOperationManager

#pragma mark--------singleton--------

static id instance;

+ (instancetype)sharedOperationManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[HMOperationManager alloc]init];
    });
    return instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [super allocWithZone:zone];
    });
    return instance;
}

- (instancetype)copyWithZone:(struct _NSZone*)zone
{
    return instance;
}


#pragma mark--------download method--------

- (void)downloadImageWithUrl:(NSString *)urlStr andFinishBlock:(finishBlock)block
{
    
    /**
     *  判断图片缓存池中是否存在该图片
     */
    if ([self.imageCache objectForKey:urlStr]) {
        if (block) {
            NSLog(@"从图片缓存中读取");
            block([self.imageCache objectForKey:urlStr]);
        }
        return;
    }
    
    /**
     *  判断沙盒缓存中是否存在该图片
     */
    UIImage *image = [UIImage imageWithContentsOfFile:[urlStr getAppendingPath]];
    if (image) {
        NSLog(@"沙盒加载");
        [self.imageCache setObject:image forKey:urlStr];
        if (block) {
            block(image);
        }
        return;
    }
    
    /**
     *  判断操作缓存池中是否存在正在执行的该操作
     */
    if ([self.oprationCache objectForKey:urlStr]) {
        NSLog(@"正在加载");
        return;
    }
    
    
    //创建自定义操作对象
    HMWebOperation *operation = [[HMWebOperation alloc]initWithUrlStr:urlStr andBlock:^(UIImage *image) {
        NSLog(@"网络加载");
        if (image) {
            //将图片放入图片缓冲池
            [self.imageCache setObject:image forKey:urlStr];
            if (block) {
                block(image);
            }
        } else{
            NSLog(@"----------");
            block([UIImage imageNamed:@"user_default"]);
        }
        
        //任务执行完后，将操作缓冲池中的操作删除
        [self.oprationCache removeObjectForKey:urlStr];
    }];
    //将操作对象加入并发队列
    NSOperationQueue *concurrentQueue = [[NSOperationQueue alloc]init];
    [self.oprationCache setObject:operation forKey:urlStr];
    [concurrentQueue addOperation:operation];
    self.queue = concurrentQueue;
    
}

/**
 *  根据下载地址取消缓存池中正在执行还没结束的任务
 *
 *  @param urlStr 
 */
- (void)cancelOperationWithUrl:(NSString *)urlStr
{
    if (urlStr == nil) {
        return;
    }
    //如果是同一张图片，取消上次尚未执行完毕的操作
    [[self.oprationCache objectForKey:urlStr] cancel];
    
    //被取消的任务从缓存池中移除
    [self.oprationCache removeObjectForKey:urlStr];
}

#pragma mark--------lazy loading--------

- (NSMutableDictionary<NSString *,HMWebOperation *> *)oprationCache
{
    if (!_oprationCache) {
        _oprationCache = [NSMutableDictionary dictionary];
    }
    return _oprationCache;
}

- (NSMutableDictionary<NSString *,UIImage *> *)imageCache
{
    if (!_imageCache) {
        _imageCache = [NSMutableDictionary dictionary];
    }
    return _imageCache;
}

#pragma mark--------memory realease--------
/**
 *  重写init方法，向通知中心添加通知的接收者
 *
 *  @return
 */
- (instancetype)init
{
    if (self = [super init]) {
#if TARGET_OS_IPHONE
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(memoryRelease) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
#endif
    }
    return self;
}
/**
 *  清理内存
 */
- (void)memoryRelease
{
    [self.queue cancelAllOperations];
    [self.oprationCache removeAllObjects];
    [self.imageCache removeAllObjects];
}


@end
