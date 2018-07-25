//
//  AddressTableViewCell.m
//  cooplaniOS
//
//  Created by Lee on 2018/7/12.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "AddressTableViewCell.h"

@interface AddressTableViewCell()<UITextFieldDelegate>

@end

@implementation AddressTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.addresseeTF.delegate = self;
    self.addressTF.delegate = self;
    self.telephoneTF.delegate = self;
    [self.changeAddressLb.layer setCornerRadius:4.0f];
    [self.changeAddressLb.layer setMasksToBounds:YES];
    // Initialization code
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField == self.addresseeTF) {
        if (textField.text.length > 0) {
            if (self.addresseeClick) {
                self.addresseeClick(textField.text);
            }
        }
    }else if (textField == self.addressTF){
        if (textField.text.length > 0) {
            if (self.addressClick) {
                self.addressClick(textField.text);
            }
        }
    }else if (textField == self.telephoneTF){
        if (textField.text.length > 0) {
            if (self.telephoneClick) {
                self.telephoneClick(textField.text);
            }
        }
    }
}
- (IBAction)changeBtnClick:(UIButton *)sender {
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    if (self.changeAddressClick) {
        self.changeAddressClick(self.changeAddressLb);
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
