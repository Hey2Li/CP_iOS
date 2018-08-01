//
//  LearnWordGroupView.m
//  cooplaniOS
//
//  Created by Lee on 2018/7/31.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LearnWordGroupView.h"

@implementation LearnWordGroupView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    self = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([LearnWordGroupView class]) owner:self options:nil] lastObject];
    if (self) {
        self.frame = frame;
        self.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.4/1.0];
        self.hidden = YES;
    }
    return self;
}
- (void)show{
    [UIView animateWithDuration:0.2 animations:^{
        self.hidden = NO;
    }];
}
- (IBAction)immediatelyToGroup:(UIButton *)sender {
    
}
- (IBAction)close:(UIButton *)sender {
    [self removeFromSuperview];
}
@end
