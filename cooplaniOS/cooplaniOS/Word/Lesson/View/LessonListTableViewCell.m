//
//  LessonListTableViewCell.m
//  cooplaniOS
//
//  Created by Lee on 2018/7/13.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LessonListTableViewCell.h"

@implementation LessonListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setModel:(VideoLessonModel *)model{
    _model = model;
    self.name.text = model.name;
    self.info.text = model.info;
    self.time.text = model.time;
}

- (void)setLearnedModel:(learnLessonModel *)learnedModel{
    _learnedModel = learnedModel;
    self.name.text = learnedModel.course_name;
    self.info.text = learnedModel.course_info;
    self.time.text = learnedModel.course_time;
}
@end
