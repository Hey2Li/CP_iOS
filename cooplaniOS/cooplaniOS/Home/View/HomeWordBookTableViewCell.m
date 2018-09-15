//
//  HomeWordBookTableViewCell.m
//  cooplaniOS
//
//  Created by Lee on 2018/9/12.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "HomeWordBookTableViewCell.h"
#import "StartLearnWordViewController.h"

@implementation HomeWordBookTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.gotoLearnBtn.layer setCornerRadius:13];
    [self.gotoLearnBtn.layer setMasksToBounds:YES];
    self.backgroundImg.layer.shadowColor = [UIColor blackColor].CGColor;
    self.backgroundImg.layer.shadowOffset = CGSizeMake(3, 3);
    self.backgroundImg.layer.shadowOpacity = 0.15;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)startWordClick:(UIButton *)sender {
    StartLearnWordViewController *vc = [[StartLearnWordViewController alloc]init];
    [self.viewController.navigationController pushViewController:vc animated:YES];
}

@end
