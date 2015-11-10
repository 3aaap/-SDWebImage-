//
//  DZAppModel.m
//  DZWebImage
//
//  Created by 宋得中 on 15/9/19.
//  Copyright © 2015年 宋得中. All rights reserved.
//

#import "DZAppModel.h"

@implementation DZAppModel

- (instancetype)initWithDict:(NSDictionary*)dict
{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+ (instancetype)modelWithDict:(NSDictionary*)dict
{
    return [[self alloc] initWithDict:dict];
}

+ (NSArray*)models
{
    NSString* path = [[NSBundle mainBundle] pathForResource:@"apps.plist" ofType:nil];
    NSArray* dicArr = [NSArray arrayWithContentsOfFile:path];
    NSMutableArray* tempArr = [NSMutableArray array];
    for (NSDictionary* dict in dicArr) {
        DZAppModel* model = [DZAppModel modelWithDict:dict];
        [tempArr addObject:model];
    }
    return tempArr.copy;
}

@end
