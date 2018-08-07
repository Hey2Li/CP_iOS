//
//  NotKnowView.m
//  cooplaniOS
//
//  Created by Lee on 2018/8/2.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "NotKnowView.h"

@implementation NotKnowView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    self = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([NotKnowView class]) owner:self options:nil] lastObject];
    if (self) {
        self.frame = frame;
        self.backgroundImg.userInteractionEnabled = YES;
    }
    return self;
}
@end
