//
//  WordErrorListTableViewCell.m
//  cooplaniOS
//
//  Created by Lee on 2018/8/4.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "WordErrorListTableViewCell.h"

@implementation WordErrorListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.isOpen = NO;
    NSArray<UIImage*> *imageArray=[NSArray arrayWithObjects:
                                   [UIImage imageNamed:@"播放2根线"],
                                   [UIImage imageNamed:@"播放一根线"]
                                   ,nil];
    self.playImageView.image = [UIImage imageNamed:@"播放2根线"];
    //赋值
    self.playImageView.animationImages = imageArray;
    //周期时间
    self.playImageView.animationDuration = 1;
    //重复次数，0为无限制
    self.playImageView.animationRepeatCount = 0;
}
#pragma mark Play播放动画

- (IBAction)playAnimation:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        [self.playImageView startAnimating];
    }else{
        [self.playImageView stopAnimating];
        self.playImageView.image = self.playImageView.animationImages.firstObject;
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setIsOpen:(BOOL)isOpen{
    _isOpen = isOpen;
    
    if (isOpen) {
        self.wordErrorBottomView.hidden = NO;
    }else{
        self.wordErrorBottomView.hidden = YES;
    }
    [UIView animateWithDuration:0.2 animations:^{
        [self layoutIfNeeded];
        [self needsUpdateConstraints];
    }];
}
@end
