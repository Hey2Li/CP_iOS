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

- (void)setModel:(QuestionsModel *)model{
    _model = model;
    [self layoutIfNeeded];
    if (model.isSelected) {
        [UIView animateWithDuration:0.2 animations:^{
            [self layoutIfNeeded];
            self.bottomView.hidden = NO;
            self.youAnswerBtnTopHeight.constant = 10;
            self.youAnswertBtnHeight.constant = 40;
            self.answerDetailBottomHeight.constant = 5;
            self.answerDetailTopHeight.constant = 10;
        }];
    }else{
        [UIView animateWithDuration:0.2 animations:^{
            [self layoutIfNeeded];
            self.bottomView.hidden = YES;
            self.youAnswerBtnTopHeight.constant = 0;
            self.youAnswertBtnHeight.constant = 0;
            self.answerDetailBottomHeight.constant = 0;
            self.answerDetailTopHeight.constant = 0;
        }];
    }
    if (model.isCorrect) {
        self.shapeImageView.hidden = NO;
        self.CorrectLb.hidden = YES;
        self.questionView.backgroundColor = UIColorFromRGB(0xFFFFFF);
        self.questionNameLb.textColor = UIColorFromRGB(0x666666);
        self.youAnswerLb.textColor = UIColorFromRGB(0x4DAC7D);
        self.correctAnswerLb.textColor = UIColorFromRGB(0x4DAC7D);
    }else{
        self.shapeImageView.hidden = YES;
        self.CorrectLb.hidden = NO;
        self.questionView.backgroundColor = UIColorFromRGB(0xD76F67);
        self.questionNameLb.textColor = UIColorFromRGB(0xFFFFFF);
        self.youAnswerLb.textColor = UIColorFromRGB(0xD76F67);
        self.correctAnswerLb.textColor = UIColorFromRGB(0x4DAC7D);
    }
//    if (model.cellHeight <= 50) {
//        self.cellHeight.constant = 0;
//    }else{
//        self.cellHeight.constant = model.cellHeight = model.cellHeight;
//    }
    NSString *isHaveNet = [USERDEFAULTS objectForKey:@"isHaveNet"];
    self.questionNameLb.text = [NSString stringWithFormat:@"Q%@",model.QuestionNo];
    if ([isHaveNet isEqualToString:@"1"]) {
        self.CorrectLb.text = [NSString stringWithFormat:@"%@的人答错了",model.correctStr];//答错人
    }else{
        self.CorrectLb.text = @"%0的人答错了";//答错人数
    }
    
    self.correctAnswerLb.text = model.Answer;
    self.youAnswerLb.text = model.youAnswer;
    self.answerDetailLb.text = model.Explanation;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
