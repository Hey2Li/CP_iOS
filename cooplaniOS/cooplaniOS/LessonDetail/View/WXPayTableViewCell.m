//
//  WXPayTableViewCell.m
//  cooplaniOS
//
//  Created by Lee on 2018/7/12.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "WXPayTableViewCell.h"

@implementation WXPayTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.greenLb.layer setCornerRadius:15];
    [self.greenLb.layer setMasksToBounds:YES];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
