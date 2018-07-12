//
//  LessonTableViewCell.m
//  cooplaniOS
//
//  Created by Lee on 2018/7/11.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LessonTableViewCell.h"

@implementation LessonTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backImageView.image = [UIImage imageNamed:@"lessonGroup"];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
