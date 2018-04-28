//
//  FeedbackContentTableViewCell.m
//  cooplaniOS
//
//  Created by Lee on 2018/4/27.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "FeedbackContentTableViewCell.h"

@interface FeedbackContentTableViewCell()<UITextViewDelegate>

@end
@implementation FeedbackContentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.problemContentTV.delegate = self;
    self.selectionStyle = NO;
}
- (void)textViewDidBeginEditing:(UITextView *)textView{
    self.placehodlerLb.hidden = YES;
}
- (void)textViewDidEndEditing:(UITextView *)textView{
    if (textView.text.length == 0) {
        self.placehodlerLb.hidden = NO;
    }else{
        if (self.feedbackContent) {
            self.feedbackContent(textView.text);
        }
    }
}
//正在改变

- (void)textViewDidChange:(UITextView *)textView{
    //实时显示字数
    self.wordNum.text = [NSString stringWithFormat:@"%lu/100", (unsigned long)textView.text.length];
    //字数限制操作
    if (textView.text.length >= 100) {
        textView.text = [textView.text substringToIndex:100];
        self.wordNum.text = @"100/100";
    }
}
- (IBAction)uploadImageClick:(UIButton *)sender {
    if (sender == self.leftImageBtn) {
        if (self.uploadImageClick) {
            self.uploadImageClick(sender,self.rightImageBtn);
        }
    }else{
        if (self.uploadImageClick) {
            self.uploadImageClick(sender,self.leftImageBtn);
        }
    }
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
