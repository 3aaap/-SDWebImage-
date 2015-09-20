//
//  HMTableViewCell.h
//  06-仿SDWebImage（Git）
//
//  Created by 宋得中 on 15/9/20.
//  Copyright © 2015年 宋得中. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HMTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView* headView;
@property (weak, nonatomic) IBOutlet UILabel* nameLabel;
@property (weak, nonatomic) IBOutlet UILabel* downloadLabel;

@end
