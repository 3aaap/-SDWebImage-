//
//  ViewController.m
//  06-仿SDWebImage（Git）
//
//  Created by 宋得中 on 15/9/19.
//  Copyright © 2015年 宋得中. All rights reserved.
//

#import "ViewController.h"
#import "HMAppModel.h"
#import "HMTableViewCell.h"
#import "NSString+CachePath.h"

@interface ViewController ()

@property (nonatomic, strong) NSArray* modelArr;

@property (nonatomic, strong) NSMutableDictionary* operationCache;

@property (nonatomic, strong) NSMutableDictionary* imageCache;

@property (nonatomic, strong) NSOperationQueue* queue;

@end

@implementation ViewController
/**
 *  lazy loading
 *
 *  @return image cache dict
 */
- (NSMutableDictionary*)imageCache
{
    if (!_imageCache) {
        _imageCache = [NSMutableDictionary dictionary];
    }
    return _imageCache;
}
/**
 *  lazy loading
 *
 *  @return operation cache dict
 */
- (NSMutableDictionary*)operationCache
{
    if (!_operationCache) {
        _operationCache = [NSMutableDictionary dictionary];
    }
    return _operationCache;
}
/**
 *  lazy Loading
 *
 *  @return modelArr
 */
- (NSArray*)modelArr
{
    if (!_modelArr) {
        _modelArr = [HMAppModel models];
    }
    return _modelArr;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.tableView.rowHeight = 80;
}

#pragma mark------Datasource Methods------
/**
 *  返回行数
 *
 *  @param tableView
 *  @param section
 *
 *  @return tableView的行数
 */
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.modelArr.count;
}

/**
 *  返回cell
 *
 *  @param tableView
 *  @param indexPath
 *
 *  @return cell
 */
- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    //重用ID
    static NSString* ID = @"AppInfo";

    //从缓存池中取出cell
    HMTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:ID];

    //得到数据模型
    HMAppModel* model = self.modelArr[indexPath.row];

    //给cell的属性赋值
    cell.nameLabel.text = model.name;
    cell.downloadLabel.text = model.download;

    //判断图片缓存池中是否存在对应的图片对象
    if ([self.imageCache objectForKey:model.icon]) {
        cell.headView.image = [self.imageCache objectForKey:model.icon];
        return cell;
    }

    //判断沙盒缓存中是否存在对应的图片
    NSData* imageData = [NSData dataWithContentsOfFile:[model.icon getImagePath]];
    if (imageData) {
        UIImage* sandboxImage = [UIImage imageWithData:imageData];
        cell.headView.image = sandboxImage;
        return cell;
    }

    //判断操作缓冲池是否存在相应的操作，如果存在，直接返回cell
    if ([self.operationCache objectForKey:model.icon]) {

        return cell;
    }
    /**
     *  创建操作队列执行图片下载的任务
     */
    [self downloadImage:indexPath];
    //判断是否使用占位图片
    if (![self.imageCache objectForKey:model.icon]) {
        cell.headView.image = [UIImage imageNamed:@"user_default"];
    }

    return cell;
}
/**
 *  创建操作队列来执行图片下载任务
 *
 *  @param indexPath
 */
- (void)downloadImage:(NSIndexPath*)indexPath
{
    HMAppModel* model = self.modelArr[indexPath.row];
    //创建blockOperation
    NSBlockOperation* downLoadOperation = [NSBlockOperation blockOperationWithBlock:^{
        /**
         *  网络加载图片
         */
        NSURL* url = [NSURL URLWithString:model.icon];
        NSData* data = [NSData dataWithContentsOfURL:url];
        UIImage* image = [UIImage imageWithData:data];

        //将image存进图片缓存中
        if (image) {
            [self.imageCache setObject:image forKey:model.icon];
            NSString* path = [model.icon getImagePath];
            [data writeToFile:path atomically:YES];
        }

        //创建更新image的operation
        NSBlockOperation* updateOperation = [NSBlockOperation blockOperationWithBlock:^{
            //            cell.headView.image = [self.imageCache objectForKey:model.icon];
            [self.tableView reloadRowsAtIndexPaths:@[ indexPath ] withRowAnimation:UITableViewRowAnimationRight];
        }];
        /**
         *  回到主线程更新UI
         */
        NSOperationQueue* mainQueue = [NSOperationQueue mainQueue];
        [mainQueue addOperation:updateOperation];
        [self.operationCache removeObjectForKey:model.icon];
    }];

    //将下载operation添加到异步线程
    NSOperationQueue* concurrentQueue = [[NSOperationQueue alloc] init];
    self.queue = concurrentQueue;
    [concurrentQueue addOperation:downLoadOperation];
    //将操作任务存入操作缓存
    [self.operationCache setObject:downLoadOperation forKey:model.icon];
}

#pragma mark-----receive memory warning------

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    NSLog(@"----");
    //取消正在下载队列中的下载任务
    [self.queue cancelAllOperations];
    //清空图片缓存
    [self.imageCache removeAllObjects];
    //清空操作缓存
    [self.operationCache removeAllObjects];
}

#pragma mark--------hide status bar--------
- (BOOL)prefersStatusBarHidden
{
    return YES;
}

@end
