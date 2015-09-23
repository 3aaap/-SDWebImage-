//
//  UIImageView+HMExtension.m
//  01-仿SDWebImage（单张图片例子）
//
//  Created by 宋得中 on 15/9/22.
//  Copyright © 2015年 宋得中. All rights reserved.
//

#import "UIImageView+HMExtension.h"
#import <objc/runtime.h>
#import "HMOperationManager.h"

@implementation UIImageView (HMExtension)

- (void)setImageFromDownloadWithUrlStr:(NSString*)urlStr
{
    self.image = [UIImage imageNamed:@"user_default"];
    /**
     *  判断本次加载的图片是否与上一个图片是不同图片
     */
    if (![urlStr isEqualToString:self.preUrl]) {
        
        //取消上一次正在执行还没结束的任务
        [[HMOperationManager sharedOperationManager] cancelOperationWithUrl:self.preUrl];
     }   
        self.preUrl = urlStr;
        
        //加载图片并在回调方法中对ImageView进行设置
        __weak typeof(self) weakSelf = self;
        [[HMOperationManager sharedOperationManager] downloadImageWithUrl:urlStr andFinishBlock:^(UIImage *image) {
            weakSelf.image = image;
        }];
    
}

#pragma mark--------runtime set value--------

#define HMAssociatedKey "ExtensionUrlKey"
- (void)setPreUrl:(NSString*)preUrl
{
    objc_setAssociatedObject(self, HMAssociatedKey, preUrl, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString*)preUrl
{
    return objc_getAssociatedObject(self, HMAssociatedKey);
}

@end
