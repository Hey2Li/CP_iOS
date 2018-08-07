//
//  ReciteWordTbFooterView.m
//  cooplaniOS
//
//  Created by Lee on 2018/8/1.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "ReciteWordTbFooterView.h"

@implementation ReciteWordTbFooterView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    self = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([ReciteWordTbFooterView class]) owner:self options:nil] lastObject];
    if (self) {
        self.frame = frame;
    }
    return self;
}
@end
