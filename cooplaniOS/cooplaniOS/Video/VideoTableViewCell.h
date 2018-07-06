//
//  VideoTableViewCell.h
//  cooplaniOS
//
//  Created by Lee on 2018/7/3.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^playStartClick)(UIImageView *imageView);

@interface VideoTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *playBtn;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (nonatomic, copy) playStartClick playStartClickBlock;
@end
