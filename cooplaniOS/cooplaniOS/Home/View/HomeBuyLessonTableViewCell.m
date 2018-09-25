//
//  HomeBuyLessonTableViewCell.m
//  cooplaniOS
//
//  Created by Lee on 2018/9/12.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "HomeBuyLessonTableViewCell.h"

@implementation HomeBuyLessonTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setModel:(HomeBuyLessonModel *)model{
    _model = model;
    [self.lessonImg sd_setImageWithURL:[NSURL URLWithString:model.img] placeholderImage:[UIImage imageNamed:@"全程班图"]];
    self.lessonNameLb.text = [NSString stringWithFormat:@"%@", model.course_name];
    self.lessonTimeLb.text = [NSString stringWithFormat:@"%@", model.indate];
    self.lessonDetailLb.text = [NSString stringWithFormat:@"%@", model.info];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
