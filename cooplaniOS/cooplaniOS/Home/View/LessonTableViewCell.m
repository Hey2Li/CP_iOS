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
- (void)setLessonModel:(LessonModel *)lessonModel{
    _lessonModel = lessonModel;
    self.name.text = lessonModel.name;
    if ([lessonModel.state isEqualToString:@"0"]) {
        self.price.text = [NSString stringWithFormat:@"￥%@",lessonModel.price];
    }else if ([lessonModel.state isEqualToString:@"1"]){
        self.price.text = @"已购买";
    }
    self.detail.text = lessonModel.info;
}
- (void)setMyLessonModel:(LessonModel *)myLessonModel{
    _myLessonModel = myLessonModel;
    self.name.text = [NSString stringWithFormat:@"%@",myLessonModel.name];
    self.detail.text = myLessonModel.info;
    self.price.text = @"已购买";
}
@end
