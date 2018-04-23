//
//  PaperDetailTableViewCell.m
//  cooplaniOS
//
//  Created by Lee on 2018/4/16.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "PaperDetailTableViewCell.h"

@implementation PaperDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.layer.cornerRadius = 5.0f;
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOpacity = 0.1f;
    self.layer.shadowRadius = 6.0f;
    self.layer.shadowOffset = CGSizeMake(1, 1);
    self.selectionStyle = NO;
    self.backgroundColor = UIColorFromRGB(0xF7F7F7);
    self.clipsToBounds = YES;
//    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bottomView.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(6, 6)];
//    
//    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
//    maskLayer.frame = _bottomView.bounds;
//    maskLayer.path = maskPath.CGPath;
//    self.bottomView.layer.mask = maskLayer;
}
- (void)setFrame:(CGRect)frame{
    frame.origin.x = 15;
    frame.size.width -= 2 * frame.origin.x;
    frame.size.height -= 10;
    [super setFrame: frame];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
