//
//  FeedbackPhoneTableViewCell.m
//  cooplaniOS
//
//  Created by Lee on 2018/4/27.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "FeedbackPhoneTableViewCell.h"

@interface FeedbackPhoneTableViewCell()<UITextFieldDelegate>

@end

@implementation FeedbackPhoneTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = NO;
    self.QQOrPhoneTF.delegate = self;
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField.text.length > 0) {
        if (self.userContact) {
            self.userContact(textField.text);
        }
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
