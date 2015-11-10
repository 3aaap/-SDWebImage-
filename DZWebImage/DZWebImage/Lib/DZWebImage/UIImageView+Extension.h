//
//  UIImageView+Extension.h
//  DZWebImage
//
//  Created by 宋得中 on 15/9/22.
//  Copyright © 2015年 宋得中. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (Extension)

@property (nonatomic, copy) NSString* preUrl;

- (void)setImageFromDownloadWithUrlStr:(NSString*)urlStr;

@end
