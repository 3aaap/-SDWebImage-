//
//  NSString+Extension.m
//  DZWebImage
//
//  Created by 宋得中 on 15/9/21.
//  Copyright © 2015年 宋得中. All rights reserved.
//

#import "NSString+Extension.h"

@implementation NSString (Extension)

- (NSString*)getAppendingPath
{
    NSString* lastPath = self.lastPathComponent;
    NSString* homeDir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    return [homeDir stringByAppendingString:lastPath];
}

@end
