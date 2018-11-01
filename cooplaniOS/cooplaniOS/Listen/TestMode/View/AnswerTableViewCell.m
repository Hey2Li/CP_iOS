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
    [self setNeedsUpdateConstraints];
    [self updateConstraints];
    if (model.isSelected) {
        self.bottomView.hidden = NO;
        self.youAnswerBtnTopHeight.constant = 10;
        self.youAnswertBtnHeight.constant = 40;
        self.answerDetailBottomHeight.constant = 5;
        self.answerDetailTopHeight.constant = 10;
        [UIView animateWithDuration:0.2 animations:^{
            [self layoutIfNeeded];
        }];
    }else{
        self.bottomView.hidden = YES;
        self.youAnswerBtnTopHeight.constant = 0;
        self.youAnswertBtnHeight.constant = 0;
        self.answerDetailBottomHeight.constant = 0;
        self.answerDetailTopHeight.constant = 0;
        [UIView animateWithDuration:0.2 animations:^{
            [self layoutIfNeeded];
        }];
    }
    if (model.isCorrect) {
//        self.shapeImageView.hidden = NO;
        [self.shapeImageView setImage:[UIImage imageNamed:@"Shape"]];
//        self.CorrectLb.hidden = YES;
        self.questionView.backgroundColor = UIColorFromRGB(0xFFFFFF);
        self.questionNameLb.textColor = UIColorFromRGB(0x666666);
        self.youAnswerLb.textColor = UIColorFromRGB(0x4DAC7D);
        self.correctAnswerLb.textColor = UIColorFromRGB(0x4DAC7D);
    }else{
//        self.shapeImageView.hidden = YES;
        [self.shapeImageView setImage:[UIImage imageNamed:@"回答错误"]];
//        self.CorrectLb.hidden = NO;
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
- (void)setReadSBOptionsModel:(ReadSBOptionsModel *)readSBOptionsModel{
    _readSBOptionsModel = readSBOptionsModel;
    [self setNeedsUpdateConstraints];
    [self updateConstraints];
    if (readSBOptionsModel.isSelected) {
        self.bottomView.hidden = NO;
        self.youAnswerBtnTopHeight.constant = 10;
        self.youAnswertBtnHeight.constant = 40;
        self.answerDetailBottomHeight.constant = 5;
        self.answerDetailTopHeight.constant = 10;
        [UIView animateWithDuration:0.2 animations:^{
            [self layoutIfNeeded];
        }];
    }else{
        self.bottomView.hidden = YES;
        self.youAnswerBtnTopHeight.constant = 0;
        self.youAnswertBtnHeight.constant = 0;
        self.answerDetailBottomHeight.constant = 0;
        self.answerDetailTopHeight.constant = 0;
        [UIView animateWithDuration:0.2 animations:^{
            [self layoutIfNeeded];
        }];
    }
    if (readSBOptionsModel.isCorrect) {
        //        self.shapeImageView.hidden = NO;
        [self.shapeImageView setImage:[UIImage imageNamed:@"Shape"]];
        //        self.CorrectLb.hidden = YES;
        self.questionView.backgroundColor = UIColorFromRGB(0xFFFFFF);
        self.questionNameLb.textColor = UIColorFromRGB(0x666666);
        self.youAnswerLb.textColor = UIColorFromRGB(0x4DAC7D);
        self.correctAnswerLb.textColor = UIColorFromRGB(0x4DAC7D);
    }else{
        //        self.shapeImageView.hidden = YES;
        [self.shapeImageView setImage:[UIImage imageNamed:@"回答错误"]];
        //        self.CorrectLb.hidden = NO;
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
    self.questionNameLb.text = [NSString stringWithFormat:@"Q%@",readSBOptionsModel.No];
   
    self.correctAnswerLb.text = readSBOptionsModel.Answer;
    self.youAnswerLb.text = readSBOptionsModel.yourAnswer;
    self.answerDetailLb.text = readSBOptionsModel.Explain;
}
- (void)setReadSAAnswerModel:(ReadSAAnswerModel *)readSAAnswerModel{
    _readSAAnswerModel = readSAAnswerModel;
    [self setNeedsUpdateConstraints];
    [self updateConstraints];
    if (readSAAnswerModel.isSelected) {
        self.bottomView.hidden = NO;
        self.youAnswerBtnTopHeight.constant = 10;
        self.youAnswertBtnHeight.constant = 40;
        self.answerDetailBottomHeight.constant = 5;
        self.answerDetailTopHeight.constant = 10;
        [UIView animateWithDuration:0.2 animations:^{
            [self layoutIfNeeded];
        }];
    }else{
        self.bottomView.hidden = YES;
        self.youAnswerBtnTopHeight.constant = 0;
        self.youAnswertBtnHeight.constant = 0;
        self.answerDetailBottomHeight.constant = 0;
        self.answerDetailTopHeight.constant = 0;
        [UIView animateWithDuration:0.2 animations:^{
            [self layoutIfNeeded];
        }];
    }
    if (readSAAnswerModel.isCorrect) {
        //        self.shapeImageView.hidden = NO;
        [self.shapeImageView setImage:[UIImage imageNamed:@"Shape"]];
        //        self.CorrectLb.hidden = YES;
        self.questionView.backgroundColor = UIColorFromRGB(0xFFFFFF);
        self.questionNameLb.textColor = UIColorFromRGB(0x666666);
        self.youAnswerLb.textColor = UIColorFromRGB(0x4DAC7D);
        self.correctAnswerLb.textColor = UIColorFromRGB(0x4DAC7D);
    }else{
        //        self.shapeImageView.hidden = YES;
        [self.shapeImageView setImage:[UIImage imageNamed:@"回答错误"]];
        //        self.CorrectLb.hidden = NO;
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
//    self.questionNameLb.text = [NSString stringWithFormat:@"Q%@",readSAAnswerModel.];
    self.correctAnswerLb.text = readSAAnswerModel.Alphabet;
    self.youAnswerLb.text = readSAAnswerModel.yourAnswer;
    self.answerDetailLb.text = readSAAnswerModel.Explain;
}
- (void)setReadSCAnswerModel:(QuestionsItem *)readSCAnswerModel{
    _readSCAnswerModel = readSCAnswerModel;
    [self setNeedsUpdateConstraints];
    [self updateConstraints];
    if (readSCAnswerModel.isSelected) {
        self.bottomView.hidden = NO;
        self.youAnswerBtnTopHeight.constant = 10;
        self.youAnswertBtnHeight.constant = 40;
        self.answerDetailBottomHeight.constant = 5;
        self.answerDetailTopHeight.constant = 10;
        [UIView animateWithDuration:0.2 animations:^{
            [self layoutIfNeeded];
        }];
    }else{
        self.bottomView.hidden = YES;
        self.youAnswerBtnTopHeight.constant = 0;
        self.youAnswertBtnHeight.constant = 0;
        self.answerDetailBottomHeight.constant = 0;
        self.answerDetailTopHeight.constant = 0;
        [UIView animateWithDuration:0.2 animations:^{
            [self layoutIfNeeded];
        }];
    }
    if (readSCAnswerModel.isCorrect) {
        //        self.shapeImageView.hidden = NO;
        [self.shapeImageView setImage:[UIImage imageNamed:@"Shape"]];
        //        self.CorrectLb.hidden = YES;
        self.questionView.backgroundColor = UIColorFromRGB(0xFFFFFF);
        self.questionNameLb.textColor = UIColorFromRGB(0x666666);
        self.youAnswerLb.textColor = UIColorFromRGB(0x4DAC7D);
        self.correctAnswerLb.textColor = UIColorFromRGB(0x4DAC7D);
    }else{
        //        self.shapeImageView.hidden = YES;
        [self.shapeImageView setImage:[UIImage imageNamed:@"回答错误"]];
        //        self.CorrectLb.hidden = NO;
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
    //    self.questionNameLb.text = [NSString stringWithFormat:@"Q%@",readSAoptionsModel.No];
    
    self.correctAnswerLb.text = readSCAnswerModel.Answer;
    self.youAnswerLb.text = readSCAnswerModel.yourAnswer;
    self.questionNameLb.text = [NSString stringWithFormat:@"Q%@",readSCAnswerModel.QuestionNumber];
//    self.answerDetailLb.text = readSCAnswerModel.Explain;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
