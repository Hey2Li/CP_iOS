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
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setLessonModel:(LessonModel *)lessonModel{
    _lessonModel = lessonModel;
    self.name.text = lessonModel.name;
    if ([lessonModel.state isEqualToString:@"0"]) {
        self.price.text = [NSString stringWithFormat:@"%@",lessonModel.price];
    }else if ([lessonModel.state isEqualToString:@"1"]){
        self.price.text = @"已购买";
    }
    lessonModel.type = @(arc4random()%3 + 1);
    if ([lessonModel.type  isEqual: @2]) {//2:方法课,3刷题课
        self.backImageView.image = [UIImage imageNamed:@"方法课"];
    }else if ([lessonModel.type  isEqual: @3]){
        self.backImageView.image = [UIImage imageNamed:@"刷题课"];
    }else{
        self.backImageView.image = [UIImage imageNamed:@"急救包"];
    }
    self.detail.text = lessonModel.info;
}
- (void)setMyLessonModel:(LessonModel *)myLessonModel{
    _myLessonModel = myLessonModel;
    self.name.text = [NSString stringWithFormat:@"%@",myLessonModel.name];
    self.detail.text = myLessonModel.info;
    self.price.text = @"已购买";
    myLessonModel.type = @(arc4random()%3 + 1);
    if ([myLessonModel.type  isEqual: @2]) {//2:方法课,3刷题课
        self.backImageView.image = [UIImage imageNamed:@"方法课"];
    }else if ([myLessonModel.type  isEqual: @3]){
        self.backImageView.image = [UIImage imageNamed:@"刷题课"];
    }else{
        self.backImageView.image = [UIImage imageNamed:@"急救包"];
    }
}
@end
