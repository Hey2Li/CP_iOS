//
//  HomeCategoryTableViewCell.m
//  cooplaniOS
//
//  Created by Lee on 2018/9/11.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "HomeCategoryTableViewCell.h"
#import "ListenTrainingViewController.h"

@implementation HomeCategoryTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)listenClick:(UIButton *)sender {
    ListenTrainingViewController *vc = [[ListenTrainingViewController alloc]init];
    [self.viewController.navigationController pushViewController:vc animated:YES];
}

@end
