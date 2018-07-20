//
//  VideoBottomView.m
//  cooplaniOS
//
//  Created by Lee on 2018/7/19.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "VideoBottomView.h"

@implementation VideoBottomView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    self = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([VideoBottomView class]) owner:self options:nil] lastObject];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.frame = frame;
        [self.clarityBtn.layer setCornerRadius:2.0f];
        [self.clarityBtn.layer setMasksToBounds:YES];
        [self.clarityBtn.layer setBorderWidth:1];
        [self.clarityBtn.layer setBorderColor:UIColorFromRGB(0x4DAC7D).CGColor];
    }
    return self;
}
- (IBAction)selectionClick:(UIButton *)sender {
}
- (IBAction)shareClick:(UIButton *)sender {
}
- (IBAction)downloadClick:(UIButton *)sender {
}
- (IBAction)clarityClick:(UIButton *)sender {
}
@end
