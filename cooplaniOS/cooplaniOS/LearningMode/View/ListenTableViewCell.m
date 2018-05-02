//
//  ListenTableViewCell.m
//  cooplaniOS
//
//  Created by Lee on 2018/4/19.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "ListenTableViewCell.h"

@implementation ListenTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.userInteractionEnabled = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (selected) {
        _listenLb.textColor = DRGBCOLOR;
    }else{
        _listenLb.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1/1.0];
    }
    // Configure the view for the selected state
}

@end
