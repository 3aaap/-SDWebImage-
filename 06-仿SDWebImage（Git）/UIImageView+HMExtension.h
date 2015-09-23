//
//  UIImageView+HMExtension.h
//  01-仿SDWebImage（单张图片例子）
//
//  Created by 宋得中 on 15/9/22.
//  Copyright © 2015年 宋得中. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (HMExtension)

@property (nonatomic, copy) NSString* preUrl;

- (void)setImageFromDownloadWithUrlStr:(NSString*)urlStr;

@end
