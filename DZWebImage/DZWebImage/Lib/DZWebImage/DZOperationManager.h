//
//  DZOperationManager.h
//  DZWebImage
//
//  Created by 宋得中 on 15/9/21.
//  Copyright © 2015年 宋得中. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DZWebOperation.h"

@interface DZOperationManager : NSObject

+ (instancetype)sharedOperationManager;

- (void)downloadImageWithUrl:(NSString*)urlStr andFinishBlock:(finishBlock)block;
- (void)cancelOperationWithUrl:(NSString*)urlStr;
@end
