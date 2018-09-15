//
//  ListenTeacherTableViewCell.m
//  cooplaniOS
//
//  Created by Lee on 2018/9/12.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "ListenTeacherTableViewCell.h"

@implementation ListenTeacherTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.backgroundImg.layer setCornerRadius:8.0f];
    [self.backgroundImg.layer setMasksToBounds:YES];
    [self.startBtn.layer setCornerRadius:13];
    [self.startBtn.layer setMasksToBounds:YES];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
