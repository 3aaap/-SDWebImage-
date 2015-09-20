//
//  NSString+CachePath.m
//  06-仿SDWebImage（Git）
//
//  Created by 宋得中 on 15/9/20.
//  Copyright © 2015年 宋得中. All rights reserved.
//

#import "NSString+CachePath.h"

@implementation NSString (CachePath)

- (NSString*)getImagePath
{
    NSString* path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    return [path stringByAppendingString:[self lastPathComponent]];
}

@end
