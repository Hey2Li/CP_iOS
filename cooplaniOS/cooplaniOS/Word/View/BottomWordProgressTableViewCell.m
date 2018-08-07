//
//  BottomWordProgressTableViewCell.m
//  cooplaniOS
//
//  Created by Lee on 2018/8/2.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "BottomWordProgressTableViewCell.h"
#import "WordErrorListTableViewController.h"

@implementation BottomWordProgressTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.layer.cornerRadius = 8.0f;
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOpacity = 0.1f;
    self.layer.shadowRadius = 3.0f;
    self.layer.shadowOffset = CGSizeMake(1, 1);
    self.selectionStyle = NO;
    self.backgroundColor = UIColorFromRGB(0xFFFFFF);
}
- (void)setFrame:(CGRect)frame{
    frame.origin.x = 10;
    frame.size.width -= 2 * frame.origin.x;
    frame.size.height -= 10;
    [super setFrame: frame];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)alwaysWordClick:(UIButton *)sender {
    WordErrorListTableViewController *vc = [[WordErrorListTableViewController alloc]init];
    vc.title = @"常错词";
    [self.viewController.navigationController pushViewController:vc animated:YES];
}
- (IBAction)inMemoryClick:(UIButton *)sender {
    WordErrorListTableViewController *vc = [[WordErrorListTableViewController alloc]init];
    vc.title = @"记忆中";
    [self.viewController.navigationController pushViewController:vc animated:YES];
}
- (IBAction)skilledWordClick:(UIButton *)sender {
    WordErrorListTableViewController *vc = [[WordErrorListTableViewController alloc]init];
    vc.title = @"熟练词";
    [self.viewController.navigationController pushViewController:vc animated:YES];
}

@end
