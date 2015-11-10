//
//  DZTableViewCell.h
//  DZWebImage
//
//  Created by 宋得中 on 15/11/3.
//  Copyright © 2015年 song_dzhong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DZTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView* iconImage;
@property (weak, nonatomic) IBOutlet UILabel* nameLabel;
@property (weak, nonatomic) IBOutlet UILabel* downloadLabel;

@end
