//
//  FeedbackTypeTableViewCell.m
//  cooplaniOS
//
//  Created by Lee on 2018/4/27.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "FeedbackTypeTableViewCell.h"

@implementation FeedbackTypeTableViewCell
{
    UIButton *_tagBtn;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.otherFeedbackBtn.layer setCornerRadius:3];
    [self.productIdeasBtn.layer setCornerRadius:3];
    [self.contentErrorBtn.layer setCornerRadius:3];
    self.selectionStyle = NO;
}
- (IBAction)btnClick:(UIButton *)btn {
    
    if (btn != _tagBtn) {
        btn.backgroundColor = DRGBCOLOR;
        _tagBtn.backgroundColor = UIColorFromRGB(0xF7F7F7);
        _tagBtn.selected = NO;
        btn.selected = YES;
        _tagBtn = btn;
    }else if (btn == _tagBtn && btn.selected){
        btn.selected = NO;
        btn.backgroundColor = UIColorFromRGB(0xF7F7F7);
        _tagBtn = btn;
    }else{
        _tagBtn.selected = YES;
        btn.backgroundColor = UIColorFromRGB(0xF7F7F7);
        _tagBtn.backgroundColor = DRGBCOLOR;
    }
    if (self.feedbackTypeClick) {
        self.feedbackTypeClick(btn);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
