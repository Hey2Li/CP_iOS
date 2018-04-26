//
//  AnswerTableViewCell.m
//  cooplaniOS
//
//  Created by Lee on 2018/4/24.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "AnswerTableViewCell.h"

@implementation AnswerTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.bottomView.hidden = YES;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setModel:(answerModel *)model{
    _model = model;
    [self layoutIfNeeded];
    if (model.isSelected) {
        [UIView animateWithDuration:0.2 animations:^{
            [self layoutIfNeeded];
            self.bottomView.hidden = NO;
        }];
    }else{
        [UIView animateWithDuration:0.2 animations:^{
            [self layoutIfNeeded];
            self.bottomView.hidden = YES;
        }];
    }
    if (model.isCorrect) {
        self.shapeImageView.hidden = NO;
        self.CorrectLb.hidden = YES;
        self.questionView.backgroundColor = UIColorFromRGB(0xFFFFFF);
        self.questionNameLb.textColor = UIColorFromRGB(0x666666);
    }else{
        self.shapeImageView.hidden = YES;
        self.CorrectLb.hidden = NO;
        self.questionView.backgroundColor = UIColorFromRGB(0xD76F67);
        self.questionNameLb.textColor = UIColorFromRGB(0xFFFFFF);
    }
//    if (model.cellHeight <= 50) {
//        self.cellHeight.constant = 0;
//    }else{
//        self.cellHeight.constant = model.cellHeight = model.cellHeight;
//    }
    self.questionNameLb.text = model.questionNum;
    self.CorrectLb.text = model.correct;
    [self.yourAnswerBtn setTitle:model.yourAnswer forState:UIControlStateNormal];
    [self.correctAnswerBtn setTitle:model.correctAnswer forState:UIControlStateNormal];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
