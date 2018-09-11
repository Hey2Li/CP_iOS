//
//  TopWordBookTableViewCell.m
//  cooplaniOS
//
//  Created by Lee on 2018/8/2.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "TopWordBookTableViewCell.h"
#import "WordBookSettingTableViewController.h"
#import "MyNoteViewController.h"

@implementation TopWordBookTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
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
- (IBAction)noKonwWordBtnClick:(UIButton *)sender {
    MyNoteViewController *vc = [[MyNoteViewController alloc]init];
    [self.viewController.navigationController pushViewController:vc animated:YES];
}



@end
