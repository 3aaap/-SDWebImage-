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

@interface ViewController ()

@property (nonatomic, strong) NSArray* modelArr;

@end

@implementation ViewController

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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

    //创建blockOperation
    NSBlockOperation* downLoadOperation = [NSBlockOperation blockOperationWithBlock:^{

        /**
         *  网络加载图片
         */
        NSURL* url = [NSURL URLWithString:model.icon];
        NSData* data = [NSData dataWithContentsOfURL:url];
        UIImage* image = [UIImage imageWithData:data];

        //创建更新image的operation
        NSBlockOperation* updateOperation = [NSBlockOperation blockOperationWithBlock:^{
            cell.headView.image = image;
        }];
        /**
         *  回到主线程更新UI
         */
        NSOperationQueue* mainQueue = [NSOperationQueue mainQueue];
        [mainQueue addOperation:updateOperation];
    }];

    //将下载operation添加到异步线程
    NSOperationQueue* concurrentQueue = [[NSOperationQueue alloc] init];
    [concurrentQueue addOperation:downLoadOperation];

    //判断是否使用占位图片
    if (!cell.headView.image) {
        cell.headView.image = [UIImage imageNamed:@"user_default"];
    }

    return cell;
}

@end
