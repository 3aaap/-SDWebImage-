//
//  ViewController.m
//  06-仿SDWebImage（Git）
//
//  Created by 宋得中 on 15/9/19.
//  Copyright © 2015年 宋得中. All rights reserved.
//

#import "ViewController.h"
#import "HMAppModel.h"

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
