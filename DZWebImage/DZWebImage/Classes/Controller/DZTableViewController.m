//
//  DZTableViewController.m
//  DZWebImage
//
//  Created by 宋得中 on 15/11/3.
//  Copyright © 2015年 song_dzhong. All rights reserved.
//

#import "DZTableViewController.h"
#import "DZAppModel.h"
#import "DZTableViewCell.h"
#import "UIImageView+Extension.h"

#define ReuseId @"AppInfo"
@interface DZTableViewController ()

@property (nonatomic, strong) NSArray<DZAppModel*>* modelArr;

@end

@implementation DZTableViewController

/// 懒加载数据模型
- (NSArray<DZAppModel*>*)modelArr
{
    if (!_modelArr) {
        _modelArr = [DZAppModel models];
    }
    return _modelArr;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark-----------dataSource-----------
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"%lu", self.modelArr.count);
    return self.modelArr.count;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    static NSString* ID = @"AppInfo";
    DZTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:ID];

    //    cell.iconImage.image = [UIImage imageNamed:@"user_default"];
    [cell.iconImage setImageFromDownloadWithUrlStr:self.modelArr[indexPath.row].icon];
    cell.nameLabel.text = self.modelArr[indexPath.row].name;
    cell.downloadLabel.text = self.modelArr[indexPath.row].download;

    return cell;
}

#pragma mark-----------memeoryWarning-----------
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

@end
